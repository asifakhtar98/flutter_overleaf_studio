"""Core LaTeX compilation logic with all performance optimizations.

Performance features:
- tmpfs (/dev/shm) compilation — zero disk I/O
- Smart multi-pass — parse .aux files, skip unnecessary passes
- ProcessPoolExecutor — true parallelism, no GIL
- Draft mode — skip image rendering
- Engine path caching — resolved once at startup
- In-memory LRU cache — hash-based, per-request controllable
"""

import asyncio
import hashlib
import io
import os
import re
import shutil
import subprocess
import tempfile
import time
import zipfile
from concurrent.futures import ProcessPoolExecutor
from dataclasses import dataclass
from pathlib import Path

import structlog

from app.cache import CachedResult, compile_cache
from app.config import settings

logger = structlog.get_logger()

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------
MAX_UNCOMPRESSED_SIZE = 200 * 1024 * 1024  # 200 MB zip bomb limit
MAX_PASSES = 3
BIB_TOOL_TIMEOUT = 60  # seconds for bibtex/biber

_ENGINE_NAMES = ("pdflatex", "xelatex", "lualatex", "latexmk")
_BIB_TOOL_NAMES = ("bibtex", "biber")
_ALL_TOOLS = (*_ENGINE_NAMES, *_BIB_TOOL_NAMES)

_RERUN_PATTERNS = [
    re.compile(r"Rerun to get"),
    re.compile(r"Please rerun LaTeX"),
    re.compile(r"Label\(s\) may have changed"),
    re.compile(r"There were undefined references"),
    re.compile(r"Citation .* undefined"),
]

_WARNING_PATTERN = re.compile(r"LaTeX Warning:")
_BIB_PATTERNS = (re.compile(r"\\bibliography\{"), re.compile(r"\\addbibresource\{"))

# ---------------------------------------------------------------------------
# Engine path cache — resolved once at startup
# ---------------------------------------------------------------------------
ENGINE_PATHS: dict[str, str | None] = {}


def _resolve_engine_paths() -> None:
    """Resolve engine binary paths once at startup. Idempotent."""
    for name in _ALL_TOOLS:
        ENGINE_PATHS[name] = shutil.which(name)
    logger.info("engine_paths_resolved", paths=ENGINE_PATHS)


_resolve_engine_paths()

# ---------------------------------------------------------------------------
# tmpfs detection
# ---------------------------------------------------------------------------
TMPFS_DIR: str | None = "/dev/shm" if (settings.use_tmpfs and os.path.isdir("/dev/shm")) else None

if TMPFS_DIR:
    logger.info("tmpfs_enabled", path=TMPFS_DIR)
else:
    logger.warning("tmpfs_unavailable", fallback="/tmp")

# ---------------------------------------------------------------------------
# Process pool for concurrent compilation
# ---------------------------------------------------------------------------
_executor: ProcessPoolExecutor | None = None


def get_executor() -> ProcessPoolExecutor:
    """Get or create the global ProcessPoolExecutor."""
    global _executor
    if _executor is None:
        _executor = ProcessPoolExecutor(max_workers=settings.max_concurrent_compiles)
        logger.info("process_pool_created", max_workers=settings.max_concurrent_compiles)
    return _executor


def shutdown_executor() -> None:
    """Shutdown the ProcessPoolExecutor gracefully."""
    global _executor
    if _executor is not None:
        _executor.shutdown(wait=False)
        _executor = None


# ---------------------------------------------------------------------------
# Data classes
# ---------------------------------------------------------------------------
@dataclass
class CompileResult:
    """Result of a LaTeX compilation."""

    success: bool
    pdf_bytes: bytes
    log: str
    compilation_time: float
    warnings_count: int
    passes_run: int
    cached: bool = False
    engine: str = "pdflatex"


def _error_result(
    log: str,
    engine: str,
    elapsed: float = 0.0,
    passes: int = 0,
    warnings: int = 0,
) -> CompileResult:
    """Create a failure CompileResult. Reduces boilerplate in _compile_sync."""
    return CompileResult(
        success=False,
        pdf_bytes=b"",
        log=log,
        compilation_time=elapsed,
        warnings_count=warnings,
        passes_run=passes,
        engine=engine,
    )


# ---------------------------------------------------------------------------
# Hashing
# ---------------------------------------------------------------------------
def _compute_hash(content: bytes, engine: str, main_file: str, draft: bool) -> str:
    """Compute SHA-256 hash of compilation inputs for cache keying."""
    h = hashlib.sha256()
    h.update(content)
    h.update(engine.encode())
    h.update(main_file.encode())
    h.update(b"draft" if draft else b"nodraft")
    return h.hexdigest()


# ---------------------------------------------------------------------------
# Zip safety
# ---------------------------------------------------------------------------
def _safe_extract_zip(zip_bytes: bytes, dest: str) -> None:
    """Extract a zip archive with bomb and path-traversal protection.

    Args:
        zip_bytes: Raw zip file bytes.
        dest: Destination directory path.

    Raises:
        ValueError: On zip bomb or path traversal attempt.
    """
    with zipfile.ZipFile(io.BytesIO(zip_bytes)) as zf:
        total_size = sum(info.file_size for info in zf.infolist())
        if total_size > MAX_UNCOMPRESSED_SIZE:
            raise ValueError(
                f"Zip uncompressed size ({total_size} bytes) exceeds "
                f"limit ({MAX_UNCOMPRESSED_SIZE} bytes)"
            )

        dest_path = Path(dest).resolve()
        for info in zf.infolist():
            target = (dest_path / info.filename).resolve()
            if not str(target).startswith(str(dest_path)):
                raise ValueError(f"Path traversal detected: {info.filename}")

        zf.extractall(dest)


# ---------------------------------------------------------------------------
# Log / source analysis helpers
# ---------------------------------------------------------------------------
def _log_has_rerun_warning(log_content: str) -> bool:
    """Check compilation log for rerun warnings."""
    return any(p.search(log_content) for p in _RERUN_PATTERNS)


def _has_bibliography(tex_content: str) -> bool:
    """Check if TeX source references bibliography files."""
    return any(p.search(tex_content) for p in _BIB_PATTERNS)


def _count_warnings(log_content: str) -> int:
    """Count LaTeX warnings in the compilation log."""
    return len(_WARNING_PATTERN.findall(log_content))


def _get_log_snippet(log_content: str, max_lines: int = 50) -> str:
    """Extract the last N lines of the log for the response."""
    lines = log_content.strip().split("\n")
    return "\n".join(lines[-max_lines:])


# ---------------------------------------------------------------------------
# Subprocess helpers — DRY engine invocations
# ---------------------------------------------------------------------------
def _run_engine(
    cmd: list[str],
    cwd: str,
    timeout: int,
) -> subprocess.CompletedProcess[str]:
    """Run an engine/tool subprocess with standard options.

    Args:
        cmd: Command and arguments.
        cwd: Working directory.
        timeout: Seconds before TimeoutExpired.

    Returns:
        CompletedProcess result.

    Raises:
        subprocess.TimeoutExpired: If the command exceeds timeout.
    """
    return subprocess.run(
        cmd,
        cwd=cwd,
        capture_output=True,
        text=True,
        timeout=timeout,
    )


def _collect_output(result: subprocess.CompletedProcess[str]) -> str:
    """Merge stdout and stderr from a CompletedProcess."""
    return f"{result.stdout}\n{result.stderr}"


# ---------------------------------------------------------------------------
# Synchronous compilation (runs in ProcessPoolExecutor)
# ---------------------------------------------------------------------------
def _compile_sync(
    work_dir: str,
    engine: str,
    main_file: str,
    draft: bool,
    timeout: int,
) -> CompileResult:
    """Synchronous LaTeX compilation — runs in a separate process.

    Handles draft injection, smart multi-pass, and auto BibTeX/Biber.
    """
    start = time.monotonic()
    passes_run = 0
    log_parts: list[str] = []
    main_path = os.path.join(work_dir, main_file)

    # --- Pre-flight checks ---
    if not os.path.exists(main_path):
        return _error_result(f"Main file not found: {main_file}", engine)

    engine_path = ENGINE_PATHS.get(engine)
    if engine_path is None:
        return _error_result(f"Engine not found: {engine}", engine)

    # --- Draft mode injection ---
    if draft:
        with open(main_path, errors="ignore") as f:
            src = f.read()
        with open(main_path, "w") as f:
            f.write("\\PassOptionsToPackage{draft}{graphicx}\n" + src)

    # --- Read source for bibliography detection ---
    with open(main_path, errors="ignore") as f:
        tex_source = f.read()
    has_bib = _has_bibliography(tex_source)

    # --- latexmk mode: single invocation, it handles passes internally ---
    if engine == "latexmk":
        latexmk_path = ENGINE_PATHS.get("latexmk")
        if not latexmk_path:
            return _error_result("latexmk not found", engine)

        cmd = [
            latexmk_path,
            "-pdf",
            "-interaction=nonstopmode",
            "-halt-on-error",
            f"-outdir={work_dir}",
            main_path,
        ]
        try:
            result = _run_engine(cmd, work_dir, timeout)
            log_parts.append(_collect_output(result))
            passes_run = 1
        except subprocess.TimeoutExpired:
            return _error_result(
                f"Compilation timed out after {timeout}s",
                engine,
                elapsed=time.monotonic() - start,
            )
    else:
        # --- Standard engine: smart multi-pass ---
        base_cmd = [
            engine_path,
            "-interaction=nonstopmode",
            "-halt-on-error",
            f"-output-directory={work_dir}",
            main_path,
        ]

        # Pass 1
        try:
            result = _run_engine(base_cmd, work_dir, timeout)
            passes_run = 1
            log_parts.append(_collect_output(result))
        except subprocess.TimeoutExpired:
            return _error_result(
                f"Compilation timed out after {timeout}s",
                engine,
                elapsed=time.monotonic() - start,
            )

        combined_log = "\n".join(log_parts)

        # Hard failure with no rerun indicator → bail early
        if result.returncode != 0 and not _log_has_rerun_warning(combined_log):
            return _error_result(
                combined_log,
                engine,
                elapsed=time.monotonic() - start,
                passes=passes_run,
                warnings=_count_warnings(combined_log),
            )

        # BibTeX / Biber pass
        if has_bib:
            main_stem = os.path.splitext(main_file)[0]
            bcf_path = os.path.join(work_dir, f"{main_stem}.bcf")
            aux_path = os.path.join(work_dir, f"{main_stem}.aux")

            bib_tool = None
            if os.path.exists(bcf_path):
                bib_tool = ENGINE_PATHS.get("biber")
            elif os.path.exists(aux_path):
                bib_tool = ENGINE_PATHS.get("bibtex")

            if bib_tool:
                try:
                    bib_result = _run_engine(
                        [bib_tool, main_stem],
                        work_dir,
                        BIB_TOOL_TIMEOUT,
                    )
                    log_parts.append(_collect_output(bib_result))
                except subprocess.TimeoutExpired:
                    log_parts.append(f"Bibliography tool timed out after {BIB_TOOL_TIMEOUT}s")

        # Additional passes (2 and 3) — only when needed
        for _ in range(MAX_PASSES - 1):
            combined_log = "\n".join(log_parts)
            if not _log_has_rerun_warning(combined_log):
                break
            try:
                result = _run_engine(base_cmd, work_dir, timeout)
                passes_run += 1
                log_parts.append(_collect_output(result))
            except subprocess.TimeoutExpired:
                break

    # --- Read PDF output ---
    main_stem = os.path.splitext(main_file)[0]
    pdf_path = os.path.join(work_dir, f"{main_stem}.pdf")
    elapsed = time.monotonic() - start
    combined_log = "\n".join(log_parts)

    if os.path.exists(pdf_path):
        with open(pdf_path, "rb") as f:
            pdf_bytes = f.read()
        return CompileResult(
            success=True,
            pdf_bytes=pdf_bytes,
            log=combined_log,
            compilation_time=elapsed,
            warnings_count=_count_warnings(combined_log),
            passes_run=passes_run,
            engine=engine,
        )

    return _error_result(
        combined_log,
        engine,
        elapsed=elapsed,
        passes=passes_run,
        warnings=_count_warnings(combined_log),
    )


# ---------------------------------------------------------------------------
# Async public API
# ---------------------------------------------------------------------------
async def compile_latex(
    content: bytes,
    engine: str = "pdflatex",
    main_file: str = "main.tex",
    draft: bool = False,
    enable_cache: bool = True,
    is_zip: bool = False,
) -> CompileResult:
    """Compile LaTeX source into PDF asynchronously.

    This is the main entry point for compilation. It handles cache
    lookup/store, tmpfs temp directory management, process-pool
    delegation, and cleanup.

    Args:
        content: Raw .tex source bytes or zip archive bytes.
        engine: LaTeX engine name.
        main_file: Main .tex file for zip projects.
        draft: Whether to enable draft mode.
        enable_cache: Whether to check/store in cache.
        is_zip: Whether content is a zip archive.

    Returns:
        CompileResult with PDF bytes and metadata.
    """
    # --- Cache lookup ---
    cache_key: str | None = None
    if enable_cache:
        cache_key = _compute_hash(content, engine, main_file, draft)
        cached = compile_cache.get(cache_key)
        if cached is not None:
            logger.info("cache_hit", engine=engine, main_file=main_file)
            return CompileResult(
                success=True,
                pdf_bytes=cached.pdf_bytes,
                log=cached.log_snippet,
                compilation_time=cached.compilation_time,
                warnings_count=cached.warnings_count,
                passes_run=cached.passes_run,
                cached=True,
                engine=cached.engine,
            )

    # --- Compile in tmpfs ---
    work_dir = tempfile.mkdtemp(dir=TMPFS_DIR, prefix="texlive_")
    logger.info("compilation_start", engine=engine, main_file=main_file, work_dir=work_dir)

    try:
        # Write content to work dir
        if is_zip:
            _safe_extract_zip(content, work_dir)
        else:
            target_path = os.path.join(work_dir, main_file)
            os.makedirs(os.path.dirname(target_path), exist_ok=True)
            with open(target_path, "wb") as f:
                f.write(content)

        # Delegate to process pool
        loop = asyncio.get_running_loop()
        result = await loop.run_in_executor(
            get_executor(),
            _compile_sync,
            work_dir,
            engine,
            main_file,
            draft,
            settings.compilation_timeout,
        )

        # Cache store on success
        if result.success and cache_key is not None:
            compile_cache.put(
                cache_key,
                CachedResult(
                    pdf_bytes=result.pdf_bytes,
                    engine=result.engine,
                    compilation_time=result.compilation_time,
                    warnings_count=result.warnings_count,
                    passes_run=result.passes_run,
                    log_snippet=_get_log_snippet(result.log),
                ),
            )

        logger.info(
            "compilation_done",
            success=result.success,
            engine=engine,
            time=f"{result.compilation_time:.2f}s",
            passes=result.passes_run,
            cached=result.cached,
        )
        return result

    except ValueError as e:
        return _error_result(str(e), engine)
    finally:
        shutil.rmtree(work_dir, ignore_errors=True)
