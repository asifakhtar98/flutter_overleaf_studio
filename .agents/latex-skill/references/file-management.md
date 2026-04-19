# File Management in Large LaTeX Projects

## Table of Contents
1. `\input` vs `\include` vs `\subfile` — Comparison
2. `\input` — Fragment Inclusion
3. `\include` and `\includeonly` — Chapter-level Inclusion
4. The `subfiles` Package — Standalone Chapter Compilation
5. The `standalone` Package — Independent Compilable Fragments
6. The `import` Package — Nested Relative Paths
7. Shared Preamble Strategies
8. Recommended Folder Structures
9. `\graphicspath` and Asset Management
10. Splitting the Bibliography
11. Version Control with Git and Overleaf
12. Compilation Speed Tips

---

## 1. `\input` vs `\include` vs `\subfile` — Comparison

| Feature | `\input` | `\include` | `\subfile` |
|---------|---------|-----------|-----------|
| Starts new page | ❌ No | ✅ Yes (always) | ❌ No |
| Works with `\includeonly` | ❌ No | ✅ Yes | ❌ No |
| Preserves `.aux` when skipped | ❌ No | ✅ Yes | ❌ No |
| Standalone compilation | ❌ No | ❌ No | ✅ Yes |
| Can be nested | ✅ Yes | ❌ No | ✅ Yes |
| Requires preamble in subfile | ❌ No | ❌ No | ✅ Yes (inherits main) |
| Extension in argument | Optional | ❌ Must omit `.tex` | Optional |
| Best for | Macros, preamble snippets, small fragments | Full chapters | Chapters with independent preview |

**Rule of thumb:**
- Use `\input` for macro files, preamble snippets, and appendix subsections.
- Use `\include` for full chapters in a book/report (preserves cross-ref numbers when using `\includeonly`).
- Use `\subfile` when you want to compile individual chapters independently during writing.

---

## 2. `\input` — Fragment Inclusion

```latex
% main.tex
\input{preamble}             % imports preamble.tex (no page break)
\input{sections/macros}      % imports macros.tex
\input{chapters/ch01}        % imports ch01.tex inline

% Also valid with extension (slightly less portable):
\input{chapters/ch01.tex}
```

```latex
% chapters/ch01.tex  (no preamble needed — it is a raw fragment)
\chapter{Introduction}

The study of classical mechanics begins with\ldots

\section{Newton's Laws}
```

> **Important**: Do NOT include `\documentclass`, `\begin{document}`, or `\end{document}` in `\input`-ted files.

### Nested `\input`
```latex
% main.tex
\input{chapters/ch01}

% chapters/ch01.tex — this file can itself contain \input:
\input{chapters/ch01/sec01}
\input{chapters/ch01/sec02}
```

---

## 3. `\include` and `\includeonly` — Chapter-level Inclusion

```latex
% main.tex
\includeonly{chapters/ch02, chapters/ch03}  % compile ONLY these chapters
                                             % cross-ref numbers of skipped chapters are preserved

\begin{document}
\frontmatter
  \tableofcontents

\mainmatter
  \include{chapters/ch01}    % skipped (not in \includeonly) — .aux preserved
  \include{chapters/ch02}    % compiled
  \include{chapters/ch03}    % compiled
  \include{chapters/ch04}    % skipped

\backmatter
  \printbibliography
\end{document}
```

**Key rules for `\include`:**
- Always omit the `.tex` extension: `\include{chapters/ch01}` ✓, NOT `\include{chapters/ch01.tex}` ✗
- Each `\include` file gets its own `.aux` file (`ch01.aux`) which stores labels and TOC entries
- `\include` **cannot be nested** — you cannot put `\include` inside a file that is `\include`d
- `\include` always forces a `\clearpage` before and after — all pending floats are flushed

```latex
% chapters/ch02.tex — no preamble, just content:
\chapter{Classical Mechanics}

\section{Newton's Laws}
The first law states that\ldots

\section{Energy}
```

---

## 4. The `subfiles` Package — Standalone Chapter Compilation

`subfiles` lets each chapter compile as a standalone PDF (inheriting the main preamble) while
also being includable in the main document. This is the most productive workflow for long documents.

### Main File Setup

```latex
% main.tex
\documentclass[12pt, twoside]{book}

% ── Preamble (all packages) ──────────────────────────────────────────────────
\usepackage{amsmath, amssymb, amsthm}
\usepackage{graphicx}
\usepackage[backend=biber]{biblatex}
\addbibresource{references.bib}
% ... rest of preamble ...

\usepackage{subfiles}   % load last in preamble

\begin{document}
\frontmatter
  \tableofcontents

\mainmatter
  \subfile{chapters/ch01_intro}          % use \subfile instead of \include
  \subfile{chapters/ch02_mechanics}
  \subfile{chapters/ch03_thermodynamics}

\backmatter
  \printbibliography
\end{document}
```

### Subfile Structure

```latex
% chapters/ch02_mechanics.tex
\documentclass[../main.tex]{subfiles}   % path to main.tex relative to THIS file

\begin{document}

\chapter{Classical Mechanics}

\section{Newton's Second Law}
Newton's second law states:
\begin{equation}
  \mathbf{F} = m\mathbf{a} \label{eq:newton2}
\end{equation}

\end{document}
```

> **Standalone compile:** Open `ch02_mechanics.tex` directly in your editor or Overleaf — it
> compiles as a complete document using the preamble from `../main.tex`.

### Graphics Path in Subfiles

When compiling a subfile standalone, the working directory changes. Fix this with `\subfix`:

```latex
% In main.tex preamble:
\graphicspath{{figures/}{chapters/ch02/figures/}}

% In chapters/ch02_mechanics.tex:
\documentclass[../main.tex]{subfiles}
\graphicspath{{\subfix{figures/}}}   % \subfix adjusts the path relative to THIS file

\begin{document}
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.7\textwidth]{pendulum.pdf}
  \caption{Simple pendulum.}
\end{figure}
\end{document}
```

---

## 5. The `standalone` Package — Independent Compilable Fragments

`standalone` is more flexible than `subfiles` but more complex. Each subfile has its **own preamble** and can include packages not in the main document. Ideal for reusable TikZ figures.

### Main File

```latex
% main.tex
\documentclass{article}
\usepackage[subpreambles=true]{standalone}   % merge subfile preambles
\usepackage{import}

\begin{document}
\tableofcontents

\section{Introduction}
\subimport{sections/}{introduction}

\section{Results}
\subimport{sections/}{results}
\end{document}
```

### Subfile

```latex
% sections/introduction.tex
\documentclass[class=article, crop=false]{standalone}
\usepackage{amsmath}
\usepackage{tikz}

\begin{document}
\subsection{Background}
Some introductory content with math: $E = mc^2$.

\begin{tikzpicture}
  \draw (0,0) circle (1cm);
\end{tikzpicture}
\end{document}
```

### Standalone TikZ Figure (reusable)

```latex
% figures/force_diagram.tex
\documentclass[tikz, border=4pt]{standalone}
\usepackage{tikz}
\usetikzlibrary{arrows.meta}

\begin{document}
\begin{tikzpicture}[>=Stealth]
  \draw[thick, fill=gray!20] (0,0) rectangle (2,1);
  \draw[->, thick, red] (1, 0.5) -- (3, 0.5) node[right]{$F$};
\end{tikzpicture}
\end{document}
```

Then in main.tex:
```latex
\begin{figure}[htbp]
  \centering
  \includestandalone[width=0.6\textwidth]{figures/force_diagram}
  \caption{Force diagram.}
\end{figure}
```

---

## 6. The `import` Package — Nested Relative Paths

The standard `\input` uses paths relative to the **main file**, which breaks when a subfile
itself `\input`s another file. The `import` package fixes this.

```latex
\usepackage{import}

% In main.tex:
\import{chapters/}{ch01_intro}     % imports chapters/ch01_intro.tex
\import{chapters/}{ch02_mechanics} % can nest \import inside ch02

% In chapters/ch02_mechanics.tex:
\import{ch02_sections/}{sec01}     % path relative to chapters/ — works correctly!
```

### `\subimport` for Deeper Nesting

```latex
% In chapters/ch02_mechanics.tex:
\subimport{ch02_sections/}{sec01}   % path is relative to the CURRENT file's directory
```

> **When to use `import`**: whenever you have files importing other files in subdirectories.
> `\input` breaks in this case because paths are always relative to the root `main.tex`.

---

## 7. Shared Preamble Strategies

### Strategy A — `\input{preamble}` (simplest)

```latex
% preamble.tex
\usepackage{amsmath, amssymb, amsthm}
\usepackage{graphicx, xcolor}
\usepackage[backend=biber]{biblatex}
\addbibresource{references.bib}
\usepackage{hyperref}
\usepackage{cleveref}
% ... custom commands, theorem environments, etc.

% main.tex
\documentclass[12pt, twoside]{book}
\input{preamble}
\usepackage{subfiles}   % load after preamble
\begin{document}
...
\end{document}
```

### Strategy B — Custom Package (`.sty`)

```latex
% styles/mystemnotes.sty  (see custom-packages-classes.md)
\NeedsTeXFormat{LaTeX2e}
\ProvidesPackage{mystemnotes}[2026/01/01 v1.0 STEM Notes]
\RequirePackage{amsmath, amssymb}
...

% main.tex
\documentclass[12pt]{book}
\usepackage{styles/mystemnotes}
```

### Strategy C — Custom Class (`.cls`)

```latex
% styles/stembook.cls (see custom-packages-classes.md)
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{stembook}[2026/01/01 STEM Textbook Class]
\LoadClass[12pt, twoside]{book}
...

% main.tex — no \documentclass[12pt]{book} needed
\documentclass{styles/stembook}
```

---

## 8. Recommended Folder Structures

### Structure A — Lecture Notes / Short Report
```
notes/
├── main.tex
├── preamble.tex
├── references.bib
├── sections/
│   ├── 01_introduction.tex
│   ├── 02_methods.tex
│   └── 03_results.tex
└── figures/
    ├── sec01/
    └── sec02/
```

### Structure B — Thesis / Long Book (subfiles)
```
thesis/
├── main.tex
├── preamble.tex          ← \input'd by main.tex
├── references.bib
├── refs/
│   ├── textbooks.bib
│   └── papers.bib
├── chapters/
│   ├── ch01_intro/
│   │   ├── ch01_intro.tex     ← \subfile{chapters/ch01_intro/ch01_intro}
│   │   ├── sec01.tex
│   │   └── figures/
│   ├── ch02_mechanics/
│   │   ├── ch02_mechanics.tex
│   │   └── figures/
│   └── ch03_thermo/
├── appendices/
│   └── appendix_A.tex
├── frontmatter/
│   ├── titlepage.tex
│   └── preface.tex
└── styles/
    ├── mystemnotes.sty
    └── stembook.cls
```

### Structure C — Multi-Author / Collaborative
```
project/
├── main.tex
├── config/
│   ├── preamble.tex
│   └── macros.tex        ← shared custom commands
├── parts/
│   ├── part1_alice/
│   │   ├── part1.tex
│   │   └── figures/
│   └── part2_bob/
│       ├── part2.tex
│       └── figures/
└── shared/
    ├── references.bib
    └── logo.pdf
```

---

## 9. `\graphicspath` and Asset Management

```latex
% Set multiple search paths — LaTeX tries each in order
\graphicspath{
  {figures/}
  {figures/ch01/}
  {figures/ch02/}
  {figures/common/}
}

% Now \includegraphics{diagram.pdf} searches all listed paths
\includegraphics[width=0.8\textwidth]{pendulum.pdf}   % found in figures/ch01/

% Absolute path (avoid — not portable):
\includegraphics{/Users/me/thesis/figures/fig1.pdf}   % DON'T do this

% Extensions: LaTeX tries .pdf, .png, .jpg, .eps automatically (pdflatex order):
% 1st: .pdf  2nd: .png  3rd: .jpg  4th: .eps
% Override with explicit extension:
\includegraphics{diagram.pdf}   % explicit: skip search
```

### Keeping Figures Organised
- Name figures semantically: `ch02_free_body.pdf` not `fig3.pdf`
- Store TikZ source as `.tex` and compiled output as `.pdf` in `figures/`
- Use `\includestandalone` for TikZ figures to keep them editable

---

## 10. Splitting the Bibliography

For large projects, split `.bib` by topic for maintainability:

```latex
% In preamble:
\usepackage[backend=biber, style=numeric]{biblatex}
\addbibresource{refs/textbooks.bib}
\addbibresource{refs/papers.bib}
\addbibresource{refs/online.bib}
\addbibresource{refs/software.bib}

% In some chapter only (chapter-local bib):
\addbibresource{chapters/ch03_thermo/ch03_refs.bib}

% At end of document:
\printbibliography[heading=bibintoc]

% Or split bibliography by type:
\printbibliography[type=book,    title={Books}]
\printbibliography[type=article, title={Journal Articles}]
\printbibliography[type=online,  title={Online Resources}]
```

---

## 11. Version Control with Git and Overleaf

```bash
# Clone your Overleaf project via Git (Overleaf Pro)
git clone https://git.overleaf.com/<project-id> my-thesis
cd my-thesis

# Standard workflow
git add .
git commit -m "Add Chapter 3: Thermodynamics derivation"
git push   # pushes to Overleaf

git pull   # get collaborator changes

# Branching for major experiments
git checkout -b chapter4-draft
# ... work on chapter 4 draft ...
git checkout main
git merge chapter4-draft

# Compare two versions
latexdiff-vc --git -r HEAD~1 main.tex   # diff against last commit
```

### `.gitignore` for LaTeX Projects
```gitignore
# Compiled output (keep .pdf in repo only if sharing)
*.aux
*.bbl
*.bcf
*.blg
*.fdb_latexmk
*.fls
*.log
*.out
*.run.xml
*.synctex.gz
*.toc
*.lot
*.lof
*.idx
*.ind
*.ilg
*.glo
*.gls
*.glg
*.acn
*.acr
*.alg
*.xdy
_minted-*/
```

---

## 12. Compilation Speed Tips

```latex
% 1. Use \includeonly to compile only the chapter you're editing
\includeonly{chapters/ch03_thermo}

% 2. Use draft mode (skip images, mark overflows)
\documentclass[draft]{book}

% 3. Cache TikZ pictures (requires -shell-escape)
\usetikzlibrary{external}
\tikzexternalize[prefix=tikz-cache/]   % saves each TikZ as a PDF
% Then: pdflatex -shell-escape main.tex

% 4. Use latexmk (detects required passes automatically)
% latexmk -pdf -pvc main.tex

% 5. Use \subfile so you can compile single chapters instantly
% (No need to wait for the whole 400-page book)

% 6. Preamble caching (mylatexformat — advanced)
% Creates a precompiled format file for instant preamble loading
% Only worth it for very large preambles (>100 packages)
```

### latexmkrc for Speed

```perl
# latexmkrc
$pdf_mode = 1;   # pdflatex
$pdflatex = 'pdflatex -interaction=nonstopmode -synctex=1 %O %S';
$clean_ext = 'synctex.gz synctex.gz(busy) run.xml tex.bak bbl bcf fdb_latexmk run tdo %R-blx.bib';
# Keep .pdf in aux cleaning:
$clean_full_ext = '';
```
