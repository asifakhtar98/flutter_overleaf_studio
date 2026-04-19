# Multi-file LaTeX Project Management

## Table of Contents
1. \include vs \input vs \subfile
2. Recommended Folder Structure
3. \includeonly for Fast Iteration
4. Shared Preamble with subfiles
5. Version Control Tips for Overleaf

---

## 1. \include vs \input vs \subfile

| Command | Starts new page | Can be selective | Standalone compile |
|---------|----------------|------------------|--------------------|
| `\include{file}` | Yes (chapter-level) | Yes (with \includeonly) | No |
| `\input{file}` | No | No | No |
| `\subfile{file}` | No | No | **Yes** |

**Use `\include`** for chapters (each starts a new page, works with `\includeonly`).  
**Use `\input`** for small fragments: macros, preamble snippets, appendix sections.  
**Use `\subfile`** when you want each chapter to compile independently for fast feedback.

---

## 2. Recommended Folder Structure

```
project/
├── main.tex              ← master file
├── preamble.tex          ← \input'd into main.tex
├── references.bib
├── chapters/
│   ├── ch01_intro.tex
│   ├── ch02_mechanics.tex
│   └── ch03_thermo.tex
├── appendices/
│   └── appendix_A.tex
├── figures/
│   ├── ch01/
│   └── ch02/
├── data/
│   └── experiment1.csv
└── styles/
    └── bookstyle.sty
```

---

## 3. \includeonly for Fast Iteration

When your book is large, compiling everything is slow. Use `\includeonly` in main.tex to compile only the chapters you're editing, while preserving cross-reference numbers:

```latex
% main.tex
\includeonly{chapters/ch02_mechanics}  % Only compile ch02

% ... rest of preamble ...
\begin{document}
\include{chapters/ch01_intro}          % Skipped, but aux file preserved
\include{chapters/ch02_mechanics}      % Compiled
\include{chapters/ch03_thermo}         % Skipped
\end{document}
```

This lets you edit ch02 quickly while `\ref{}` numbers remain correct.

---

## 4. Standalone Chapter Compilation with subfiles

```latex
% preamble.tex
\usepackage{amsmath}
\usepackage{graphicx}
% ... all your packages ...

% main.tex
\documentclass[12pt]{book}
\input{preamble}
\usepackage{subfiles}

\begin{document}
\subfile{chapters/ch01_intro}
\subfile{chapters/ch02_mechanics}
\end{document}
```

```latex
% chapters/ch02_mechanics.tex
\documentclass[../main.tex]{subfiles}
\begin{document}

\chapter{Classical Mechanics}
Content here...

\end{document}
```

Compiling `ch02_mechanics.tex` directly in Overleaf produces a standalone PDF of that chapter.

---

## 5. Graphics Path

When figures are in subdirectories, set a graphics path:

```latex
\graphicspath{{figures/ch01/}{figures/ch02/}{figures/}}
```

Now you can write:
```latex
\includegraphics{diagram.pdf}   % instead of figures/ch01/diagram.pdf
```

---

## 6. Version Control Tips (Overleaf + Git)

- Overleaf Pro supports **Git sync**: `git clone https://git.overleaf.com/<project-id>`
- Commit per chapter/section milestone
- Use Overleaf's **Track Changes** for collaborative review
- Keep a `CHANGES.md` or use the Overleaf history panel

---

## 7. Managing Large Bibliographies

Split `.bib` files by topic:
```latex
\addbibresource{refs/textbooks.bib}
\addbibresource{refs/papers.bib}
\addbibresource{refs/online.bib}
```

Use `\nocite{*}` to include all entries without citing them, for a complete bibliography appendix.
