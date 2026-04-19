#!/usr/bin/env bash
# =============================================================================
# Test Sample Runner — compiles all test_samples/ against the local API
# Outputs PDFs to test_outputs/ with pass/fail summary
# Usage: bash scripts/test_samples.sh
# Requires: running server at http://localhost:8080, curl, zip
# =============================================================================
set -euo pipefail

API_URL="${API_URL:-http://localhost:8080}"
API_KEY="${API_KEY:-dev-key-change-me-in-production}"
OUT_DIR="test_outputs"
SAMPLES_DIR="test_samples"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

mkdir -p "$OUT_DIR"

PASS=0
FAIL=0
TOTAL=0

# ---------------------------------------------------------------------------
# Helper — compile a single .tex file via JSON body
# ---------------------------------------------------------------------------
compile_single() {
    local tex_file="$1"
    local output_name="$2"
    local engine="${3:-pdflatex}"
    local draft="${4:-false}"
    local label="${5:-$output_name}"

    TOTAL=$((TOTAL + 1))
    local source
    source=$(cat "$tex_file")

    printf "${CYAN}[%02d]${NC} %-45s engine=%-10s draft=%-5s " "$TOTAL" "$label" "$engine" "$draft"

    local http_code
    http_code=$(curl -s -o "$OUT_DIR/${output_name}.pdf" -w "%{http_code}" \
        -X POST "${API_URL}/api/v1/compile" \
        -H "X-API-Key: ${API_KEY}" \
        -H "Content-Type: application/json" \
        -d "$(jq -n --arg src "$source" --arg eng "$engine" --argjson draft "$draft" \
            '{source: $src, engine: $eng, draft: $draft}')")

    if [[ "$http_code" == "200" ]]; then
        local size
        size=$(wc -c < "$OUT_DIR/${output_name}.pdf" | tr -d ' ')
        printf "${GREEN}✓ PASS${NC}  (%s bytes)\n" "$size"
        PASS=$((PASS + 1))
    else
        printf "${RED}✗ FAIL${NC}  (HTTP %s)\n" "$http_code"
        # Save error response
        mv "$OUT_DIR/${output_name}.pdf" "$OUT_DIR/${output_name}.error.json" 2>/dev/null || true
        FAIL=$((FAIL + 1))
    fi
}

# ---------------------------------------------------------------------------
# Helper — compile a zip project
# ---------------------------------------------------------------------------
compile_zip() {
    local zip_dir="$1"
    local output_name="$2"
    local engine="${3:-pdflatex}"
    local main_file="${4:-main.tex}"
    local label="${5:-$output_name}"

    TOTAL=$((TOTAL + 1))

    printf "${CYAN}[%02d]${NC} %-45s engine=%-10s zip=true  " "$TOTAL" "$label" "$engine"

    # Create zip from directory
    local tmp_zip
    tmp_zip=$(mktemp /tmp/textest_XXXXXX.zip)
    (cd "$zip_dir" && zip -q -r "$tmp_zip" .)

    local http_code
    http_code=$(curl -s -o "$OUT_DIR/${output_name}.pdf" -w "%{http_code}" \
        -X POST "${API_URL}/api/v1/compile" \
        -H "X-API-Key: ${API_KEY}" \
        -F "file=@${tmp_zip}" \
        -F "engine=${engine}" \
        -F "main_file=${main_file}")

    rm -f "$tmp_zip"

    if [[ "$http_code" == "200" ]]; then
        local size
        size=$(wc -c < "$OUT_DIR/${output_name}.pdf" | tr -d ' ')
        printf "${GREEN}✓ PASS${NC}  (%s bytes)\n" "$size"
        PASS=$((PASS + 1))
    else
        printf "${RED}✗ FAIL${NC}  (HTTP %s)\n" "$http_code"
        mv "$OUT_DIR/${output_name}.pdf" "$OUT_DIR/${output_name}.error.json" 2>/dev/null || true
        FAIL=$((FAIL + 1))
    fi
}

# =============================================================================
# Health check first
# =============================================================================
printf "\n${BOLD}═══════════════════════════════════════════════════════════════${NC}\n"
printf "${BOLD} TeX Live API — Sample Compilation Test Suite${NC}\n"
printf "${BOLD}═══════════════════════════════════════════════════════════════${NC}\n"
printf "API:    %s\n" "$API_URL"
printf "Output: %s/\n\n" "$OUT_DIR"

printf "Checking API health... "
HEALTH=$(curl -s -o /dev/null -w "%{http_code}" "${API_URL}/api/v1/health")
if [[ "$HEALTH" != "200" ]]; then
    printf "${RED}FAILED${NC} (HTTP %s)\n" "$HEALTH"
    printf "${RED}Start the server first: docker compose up --build${NC}\n"
    exit 1
fi
printf "${GREEN}OK${NC}\n\n"

printf "${BOLD}--- Single-file tests (JSON body) ---${NC}\n\n"

# 01 — Hello world (pdflatex)
compile_single "$SAMPLES_DIR/01_hello_world.tex" \
    "01_hello_pdflatex" "pdflatex" "false" "Hello World (pdflatex)"

# 02 — Multi-page with TOC (pdflatex)
compile_single "$SAMPLES_DIR/02_multipage_toc.tex" \
    "02_multipage_toc" "pdflatex" "false" "Multi-page + TOC (pdflatex)"

# 03 — Math heavy (pdflatex)
compile_single "$SAMPLES_DIR/03_math_heavy.tex" \
    "03_math_pdflatex" "pdflatex" "false" "Math Heavy (pdflatex)"

# 03 — Math heavy (lualatex)
compile_single "$SAMPLES_DIR/03_math_heavy.tex" \
    "03_math_lualatex" "lualatex" "false" "Math Heavy (lualatex)"

# 05 — TikZ/pgfplots (pdflatex, normal)
compile_single "$SAMPLES_DIR/05_images_tikz.tex" \
    "05_tikz_normal" "pdflatex" "false" "TikZ + pgfplots (normal)"

# 05 — TikZ/pgfplots (pdflatex, draft mode)
compile_single "$SAMPLES_DIR/05_images_tikz.tex" \
    "05_tikz_draft" "pdflatex" "true" "TikZ + pgfplots (draft)"

# 06 — Unicode (xelatex)
compile_single "$SAMPLES_DIR/06_unicode_xelatex.tex" \
    "06_unicode_xelatex" "xelatex" "false" "Unicode (xelatex)"

# 01 — Hello world (latexmk)
compile_single "$SAMPLES_DIR/01_hello_world.tex" \
    "01_hello_latexmk" "latexmk" "false" "Hello World (latexmk)"

printf "\n${BOLD}--- Multi-file tests (zip upload) ---${NC}\n\n"

# 04 — Bibliography (pdflatex, zip)
compile_zip "$SAMPLES_DIR/04_bibliography" \
    "04_bibliography" "pdflatex" "main.tex" "Bibliography + BibTeX (zip)"

# =============================================================================
# Summary
# =============================================================================
printf "\n${BOLD}═══════════════════════════════════════════════════════════════${NC}\n"
printf "${BOLD} Results: ${NC}"
if [[ "$FAIL" -eq 0 ]]; then
    printf "${GREEN}ALL %d PASSED${NC}\n" "$TOTAL"
else
    printf "${GREEN}%d passed${NC}, ${RED}%d failed${NC} out of %d\n" "$PASS" "$FAIL" "$TOTAL"
fi
printf "${BOLD}═══════════════════════════════════════════════════════════════${NC}\n"
printf "PDFs saved to: ${CYAN}%s/${NC}\n\n" "$OUT_DIR"

# List outputs
ls -lh "$OUT_DIR"/*.pdf 2>/dev/null || true
ls -lh "$OUT_DIR"/*.error.json 2>/dev/null || true
printf "\n"

exit "$FAIL"
