---
name: latex-skill
description: >
  Expert guide for writing professional STEM notes, lab manuals, lecture notes, theses,
  and academic documents in Latex/LaTeX. Use this skill whenever the user asks to create,
  structure, style, or format any STEM document in LaTeX or Latex — including
  physics, math, chemistry, biology, engineering, and computer science content. Triggers include:
  "write notes", "create STEM notes in Latex", "LaTeX document template", "format my thesis",
  "add equations to my LaTeX notes", "make a lab manual in LaTeX", "section structure in Latex",
  "STEM notes styling", "professional LaTeX document", or any mention of Latex + notes/sections/STEM.
  Also triggers for advanced topics: custom theorem environments, TikZ diagrams, pgfplots, chemistry
  formulae, multi-file projects, bibliography management, or custom LaTeX class/package creation.
  Also triggers for: "Beamer presentation", "LaTeX slides", "STEM poster", "LaTeX fonts",
  "font pairing LaTeX", "paragraph formatting", "margin notes", "multiple columns LaTeX",
  "glossary LaTeX", "nomenclature LaTeX", "latexmk", "latexdiff", "LuaLaTeX scripting",
  "xparse command", "custom .sty", "custom .cls", "LaTeX draft mode", "todo notes LaTeX",
  "STEM writing tips", "equation numbering", "cross-reference best practices", "float placement",
  "multi-file LaTeX", "\\include vs \\input", "subfiles package", "standalone package",
  "large LaTeX project", "file management LaTeX", "\\includeonly", "import package",
  "writing LaTeX package", "writing LaTeX class", "NeedsTeXFormat", "ProvidesPackage",
  "ProvidesClass", "DeclareOption", "babel", "polyglossia", "multilingual LaTeX",
  "hyperref setup", "cleveref", "exam class LaTeX", "tikz-feynman", "makeglossaries",
  "nomencl package", "csquotes", "cross-referencing LaTeX".
---

# LaTeX STEM Notes Writing Skill

A comprehensive guide for producing professional STEM notes and academic documents in LaTeX.
Covers everything from document architecture to advanced styling, mathematics, science-specific
packages, multi-file project management, presentations, and custom build tooling.

---

## 1. Document Architecture

### Choosing the Right Document Class

```latex
% Full textbook / monograph
\documentclass[12pt, twoside, openright]{book}

% Shorter lecture notes or lab manual
\documentclass[12pt, oneside]{report}

% Article-length notes (single chapter feel)
\documentclass[12pt]{article}

% Beamer presentation
\documentclass[12pt, aspectratio=169]{beamer}
```

**Recommended class for STEM notes:** `report` or `article` with `oneside` for digital-friendly output.

### Essential Preamble for STEM Notes

```latex
\documentclass[12pt, twoside, openright]{book}

% --- Core layout ---
\usepackage[a4paper, inner=3cm, outer=2.5cm, top=2.5cm, bottom=3cm]{geometry}
\usepackage{microtype}          % Better text justification
\usepackage{emptypage}          % Blank pages without headers

% --- Mathematics ---
\usepackage{amsmath, amssymb, amsthm}
\usepackage{mathtools}          % extends amsmath
\usepackage{bm}                 % bold math symbols
\usepackage{siunitx}            % SI units: \SI{9.8}{\metre\per\second\squared}

% --- Science-specific ---
\usepackage{chemformula}        % \ch{H2O}, \ch{CO2}
\usepackage{mhchem}             % complex reaction equations
\usepackage{physics}            % \dv, \pdv, \qty, \bra, \ket etc.
\usepackage{circuitikz}         % electrical circuit diagrams

% --- Figures and tables ---
\usepackage{graphicx}
\usepackage{float}
\usepackage{subcaption}         % subfigures
\usepackage{booktabs}           % professional tables (\toprule, \midrule)
\usepackage{multirow}
\usepackage{longtable}          % tables spanning multiple pages
\usepackage{array}

% --- Code listings ---
\usepackage{listings}
\usepackage{minted}             % syntax-highlighted code (requires -shell-escape)

% --- Diagrams ---
\usepackage{tikz}
\usepackage{pgfplots}
\pgfplotsset{compat=1.18}
\usetikzlibrary{arrows.meta, shapes, positioning, calc, patterns}

% --- Color ---
\usepackage{xcolor}

% --- Cross-references and links ---
\usepackage{hyperref}
\usepackage{cleveref}           % \cref{fig:x} → "Figure 1"

% --- Bibliography ---
\usepackage[backend=biber, style=numeric, sorting=none]{biblatex}
\addbibresource{references.bib}

% --- Fonts (XeLaTeX/LuaLaTeX recommended) ---
% \usepackage{fontspec}
% \setmainfont{TeX Gyre Termes}  % Times-like
% \setmathfont{TeX Gyre Termes Math}
```

---

## 2. Multi-File Project Structure

For longer documents with many sections, always split into multiple files.
See `references/file-management.md` for the complete guide covering `\input`, `\include`,
`subfiles`, `standalone`, the `import` package, folder structures, and build speed tips.

**Recommended folder layout:**
```
main.tex
sections/
  sec01_introduction.tex
  sec02_mechanics.tex
  sec03_thermodynamics.tex
figures/
  sec01/
  sec02/
appendices/
  appendix_A.tex
references.bib
styles/
  docstyle.sty    (custom style package)
```

**main.tex skeleton:**
```latex
\documentclass[12pt, twoside]{book}
% ... preamble ...

\begin{document}
\frontmatter
  \include{frontmatter/titlepage}
  \include{frontmatter/preface}
  \tableofcontents
  \listoffigures
  \listoftables

\mainmatter
  \include{sections/sec01_introduction}
  \include{sections/sec02_mechanics}

\appendix
  \include{appendices/appendix_A}

\backmatter
  \printbibliography
  \printindex
\end{document}
```

---

## 3. Mathematics Typesetting

Read `references/mathematics.md` for the full reference. Key patterns:

### Numbered Equations
```latex
\begin{equation}
  E = mc^2 \label{eq:einstein}
\end{equation}
See \cref{eq:einstein}.
```

### Aligned Multi-line Equations
```latex
\begin{align}
  \nabla \cdot \mathbf{E} &= \frac{\rho}{\varepsilon_0} \label{eq:gauss_e} \\
  \nabla \cdot \mathbf{B} &= 0 \label{eq:gauss_b} \\
  \nabla \times \mathbf{E} &= -\frac{\partial \mathbf{B}}{\partial t} \label{eq:faraday}
\end{align}
```

### Cases / Piecewise
```latex
\begin{equation}
  f(x) = \begin{cases} x^2 & x \geq 0 \\ -x & x < 0 \end{cases}
\end{equation}
```

### Matrices
```latex
\begin{equation}
  A = \begin{pmatrix} a_{11} & a_{12} \\ a_{21} & a_{22} \end{pmatrix}
\end{equation}
```

### Derivatives (with `physics` package)
```latex
\dv{f}{x}          % ordinary derivative
\pdv{f}{x}         % partial derivative
\pdv[2]{f}{x}      % second partial
\dv[n]{f}{x}       % nth derivative
```

### SI Units
```latex
\SI{3.0e8}{\metre\per\second}   % speed of light
\SI{6.674e-11}{\newton\metre\squared\per\kilogram\squared}
\si{\kilo\gram\metre\per\second\squared}   % just units
```

---

## 4. Theorem Environments and Proof Structures

```latex
% In preamble:
\usepackage{amsthm}
\usepackage{thmtools}

% Define environments
\theoremstyle{plain}
\newtheorem{theorem}{Theorem}[chapter]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{corollary}[theorem]{Corollary}
\newtheorem{proposition}[theorem]{Proposition}

\theoremstyle{definition}
\newtheorem{definition}[theorem]{Definition}
\newtheorem{example}[theorem]{Example}
\newtheorem{exercise}{Exercise}[chapter]

\theoremstyle{remark}
\newtheorem*{remark}{Remark}
\newtheorem*{note}{Note}
```

**Usage:**
```latex
\begin{theorem}[Fundamental Theorem of Calculus]
  \label{thm:ftc}
  If $f$ is continuous on $[a,b]$ and $F' = f$, then
  \[ \int_a^b f(x)\,dx = F(b) - F(a). \]
\end{theorem}

\begin{proof}
  By definition of the Riemann integral\ldots \qed
\end{proof}
```

### Styled Theorem Boxes (using `tcolorbox`)
```latex
\usepackage{tcolorbox}
\tcbuselibrary{theorems, skins, breakable}

\tcbset{
  STEMbox/.style={
    enhanced, breakable,
    colback=blue!5!white, colframe=blue!60!black,
    fonttitle=\bfseries, separator sign={.},
  }
}
\newtcbtheorem[number within=chapter]{stheorem}{Theorem}{STEMbox}{thm}
\newtcbtheorem[number within=chapter]{sdefinition}{Definition}{
  STEMbox, colback=green!5!white, colframe=green!50!black
}{def}
```

---

## 5. Figures, TikZ Diagrams, and Plots

### Inserting Figures
```latex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.8\textwidth]{figures/sec01/diagram.pdf}
  \caption[Short caption for LoF]{Full descriptive caption for the figure.}
  \label{fig:diagram}
\end{figure}
```

### Side-by-Side Subfigures
```latex
\begin{figure}[htbp]
  \centering
  \begin{subfigure}[b]{0.45\textwidth}
    \includegraphics[width=\textwidth]{fig_a.pdf}
    \caption{Before}\label{fig:before}
  \end{subfigure}\hfill
  \begin{subfigure}[b]{0.45\textwidth}
    \includegraphics[width=\textwidth]{fig_b.pdf}
    \caption{After}\label{fig:after}
  \end{subfigure}
  \caption{Comparison of states.}
\end{figure}
```

### TikZ — Force Diagram Example
```latex
\begin{figure}[h]
\centering
\begin{tikzpicture}[scale=1.2, >=Stealth]
  % Block
  \draw[thick, fill=gray!20] (0,0) rectangle (2,1);
  \node at (1, 0.5) {$m$};
  % Ground
  \draw[thick] (-0.5,0) -- (3,0);
  \fill[pattern=north east lines] (-0.5,-0.2) rectangle (3,0);
  % Forces
  \draw[->, thick, red]   (1,0.5) -- (3,0.5) node[right]{$F$};
  \draw[->, thick, blue]  (1,0.5) -- (1,2)   node[above]{$N$};
  \draw[->, thick, green!60!black] (1,0.5) -- (1,-1) node[below]{$mg$};
  \draw[->, thick, orange](1,0)   -- (-0.5,0) node[left]{$f$};
\end{tikzpicture}
\caption{Free body diagram.}
\end{figure}
```

### pgfplots — Function Plot
```latex
\begin{figure}[h]
\centering
\begin{tikzpicture}
\begin{axis}[
  xlabel={$x$}, ylabel={$y$},
  grid=major, grid style={dashed,gray!30},
  width=0.75\textwidth, height=6cm,
  legend pos=north west,
]
  \addplot[blue, thick, domain=-3:3, samples=100] {x^2};
  \addlegendentry{$y=x^2$}
  \addplot[red, thick, domain=-3:3, samples=100] {sin(deg(x))};
  \addlegendentry{$y=\sin x$}
\end{axis}
\end{tikzpicture}
\caption{Sample plot using pgfplots.}
\end{figure}
```

---

## 6. Tables

```latex
\begin{table}[htbp]
  \centering
  \caption{Physical constants.}
  \label{tab:constants}
  \begin{tabular}{@{}llS[table-format=2.6e2]@{}}
    \toprule
    Constant & Symbol & {Value (\si{\SI})} \\
    \midrule
    Speed of light    & $c$  & 2.997924e8 \\
    Planck constant   & $h$  & 6.626070e-34 \\
    Boltzmann constant & $k_B$ & 1.380649e-23 \\
    \bottomrule
  \end{tabular}
\end{table}
```

---

## 7. Chemistry (mhchem / chemformula)

```latex
% Molecular formula
\ch{H2SO4}   \ch{CO2}   \ch{C6H12O6}

% Reaction equation
\ch{2 H2 + O2 -> 2 H2O}

% Ionic equation with states
\ch{Na+ (aq) + Cl- (aq) -> NaCl (s)}

% With mhchem (alternative):
\ce{H2O}
\ce{2H2 + O2 -> 2H2O}
\ce{^{227}_{90}Th+}     % isotopes/ions
```

---

## 8. Code Listings

### Using `listings`
```latex
\lstset{
  language=Python,
  basicstyle=\ttfamily\small,
  keywordstyle=\color{blue}\bfseries,
  commentstyle=\color{green!50!black},
  stringstyle=\color{red},
  numbers=left, numberstyle=\tiny\color{gray},
  breaklines=true, frame=single,
  backgroundcolor=\color{gray!10},
}

\begin{lstlisting}[caption={Euler's method}, label=lst:euler]
def euler(f, y0, t0, t_end, h):
    t, y = t0, y0
    while t < t_end:
        y += h * f(t, y)
        t += h
    return y
\end{lstlisting}
```

### Using `minted` (preferred for syntax highlighting)
```latex
% Compile with: pdflatex -shell-escape main.tex
\begin{minted}[linenos, bgcolor=gray!10, fontsize=\small]{python}
import numpy as np
x = np.linspace(0, 2*np.pi, 100)
y = np.sin(x)
\end{minted}
```

---

## 9. Advanced Styling

Read `references/styling.md` for full details. Key patterns:

### Custom Section Headers (with `titlesec`)
```latex
\usepackage{titlesec}
\titleformat{\chapter}[display]
  {\normalfont\huge\bfseries\color{blue!70!black}}
  {Chapter \thechapter}{20pt}{\Huge}
\titlespacing*{\chapter}{0pt}{50pt}{40pt}
```

### Custom Headers and Footers (with `fancyhdr`)
```latex
\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\fancyhead[LE,RO]{\thepage}
\fancyhead[LO]{\nouppercase{\rightmark}}
\fancyhead[RE]{\nouppercase{\leftmark}}
\renewcommand{\headrulewidth}{0.4pt}
```

### Custom Colors for STEM Notes Branding
```latex
\definecolor{STEMblue}{HTML}{1A3C6E}
\definecolor{STEMorange}{HTML}{E87722}
\definecolor{STEMgray}{HTML}{555555}
```

---

## 10. Bibliography

```latex
% In preamble:
\usepackage[backend=biber, style=numeric-comp, sorting=none]{biblatex}
\addbibresource{references.bib}

% Citing:
\cite{einstein1905}
\parencite{newton1687}
\textcite{maxwell1865} showed that...

% At end of document:
\printbibliography[heading=bibintoc, title={References}]
```

**For physics/science notes:** use `style=phys` or `style=nature`.
**For math notes:** use `style=alphabetic`.

---

## 11. Indices and Glossaries

```latex
% In preamble:
\usepackage{imakeidx}
\makeindex[columns=2, title=Index, intoc]

% In text:
\index{Maxwell equations}
\index{thermodynamics!first law}

% At end:
\printindex
```

### Glossaries and Nomenclature
```latex
\usepackage[acronym, symbols, toc]{glossaries-extra}
\makeglossaries

% Define terms
\newglossaryentry{hamiltonian}{
  name={Hamiltonian},
  description={The total energy operator $\hat{H} = \hat{T} + \hat{V}$}
}
\newacronym{qm}{QM}{Quantum Mechanics}
\newglossaryentry{sym:hbar}{
  type=symbols,
  name={\ensuremath{\hbar}},
  description={Reduced Planck constant, $\hbar = h / 2\pi$}
}

% Usage in text
\gls{hamiltonian} \glspl{hamiltonian}  % singular / plural
\gls{qm}                               % QM (first use: Quantum Mechanics (QM))
\glssymbol{sym:hbar}

% Print at end
\printglossary[type=main]
\printglossary[type=acronym, title={Acronyms}]
\printglossary[type=symbols, title={Notation}]
```

---

## 12. Title Page, Front Matter, and Back Matter

```latex
\frontmatter
\begin{titlepage}
  \centering
  {\Huge\bfseries\color{STEMblue} Introduction to Classical Mechanics}\\[1cm]
  {\large\color{STEMgray} Professional STEM Notes}\\[2cm]
  {\large Author Name}\\[0.5cm]
  {\normalsize Department of Physics, University Name}\\[3cm]
  {\large \today}
  \vfill
  \includegraphics[width=0.3\textwidth]{figures/cover_logo.pdf}
\end{titlepage}

\chapter*{Preface}
\addcontentsline{toc}{chapter}{Preface}
% ...

\mainmatter
```

---

## 13. STEM Writing Best Practices

These are discipline-specific conventions that produce professional, consistent documents.

### Equation Discipline

```latex
% ALWAYS label every important equation — even if you don't cite it yet
\begin{equation}
  \nabla^2 \phi = -\frac{\rho}{\varepsilon_0} \label{eq:poisson}
\end{equation}

% ALWAYS use \cref (cleveref), NEVER plain \ref
See \cref{eq:poisson}.       % → "Equation (3.5)"  ✓
See equation (\ref{eq:poisson}) % → "equation (3.5)"  ✗ (redundant, fragile)

% Suppress number for intermediate algebra steps
\begin{align*}
  \mathbf{F} &= m\mathbf{a} \\
  \int \mathbf{F}\,dt &= m\Delta\mathbf{v}   % no label needed
\end{align*}

% Use subequations for grouped equations under one number
\begin{subequations}\label{eq:maxwell}
  \begin{align}
    \nabla \cdot \mathbf{E}  &= \rho/\varepsilon_0 \label{eq:gauss_e}\\
    \nabla \cdot \mathbf{B}  &= 0                  \label{eq:gauss_b}
  \end{align}
\end{subequations}
% \cref{eq:maxwell} → "(3.1)", \cref{eq:gauss_e} → "(3.1a)"
```

### Notation Consistency

```latex
% Define ALL custom operators in the preamble — never inline \mathrm{...}
\DeclareMathOperator{\Tr}{Tr}
\DeclareMathOperator{\rank}{rank}
\DeclareMathOperator{\diag}{diag}
\DeclareMathOperator*{\argmin}{arg\,min}   % * = subscript below in display
\DeclareMathOperator*{\argmax}{arg\,max}

% Bold vectors: pick ONE style and stick to it
\newcommand{\vb}[1]{\boldsymbol{#1}}     % Greek + Latin bold
\newcommand{\vu}[1]{\hat{\boldsymbol{#1}}} % unit vector

% Common constants: define once
\newcommand{\hbar}{\mathchar'26\mkern-9mu h}  % if physics pkg not loaded
\newcommand{\kB}{k_{\mathrm{B}}}
\newcommand{\NA}{N_{\mathrm{A}}}
```

### Typography Rules

```latex
% Dashes
-        % hyphen: well-known, mother-in-law
--       % en-dash: pages 15--20, physics--chemistry interface
---      % em-dash: an unexpected result---energy is conserved

% Ellipsis
\ldots   % lower: "a, b, c, \ldots" (text)
\cdots   % centered: "a_1 + a_2 + \cdots + a_n" (math sums)
\vdots   % vertical (matrices, columns)
\ddots   % diagonal (matrices)

% Quotes
``This is a LaTeX quotation.''   % double: `` and ''
`Single quote.'                  % single: ` and '
% Never use "straight quotes" in LaTeX source

% Non-breaking spaces (prevent line break before reference)
Figure~\ref{fig:x}      % ✓
Equation~\eqref{eq:y}   % ✓
Table~\ref{tab:z}       % ✓
Dr.~Smith               % ✓  (after abbreviation)
e.g.,~something         % ✓

% Spacing after periods (LaTeX adds extra space — suppress for abbreviations)
e.g.\ something      % \  = normal inter-word space
Fig.\ \ref{fig:x}
```

### Float (Figure / Table) Placement

```latex
% Preferred specifier order: [htbp] not [h] alone
\begin{figure}[htbp]   % here, top, bottom, page-of-floats

% If a figure truly must be "here": add [!h] but use sparingly
\begin{figure}[!h]

% Prevent floats from crossing a section boundary
\usepackage{placeins}
\FloatBarrier   % place at end of each section if needed

% Spanning floats in two-column mode
\begin{figure*}[t]   % star = span both columns (top or bottom only)

% Caption before content (for tables)
\begin{table}[htbp]
  \caption{Results.}\label{tab:results}  % caption on TOP for tables
  \begin{tabular}{...}
  ...
  \end{tabular}
\end{table}
% Caption BELOW for figures (standard)
```

### Avoiding Common LaTeX Mistakes

| ❌ Anti-pattern | ✓ Correct Practice |
|---|---|
| `$$...$$` for display math | `\[ ... \]` or `equation` environment |
| `eqnarray` | `align` from amsmath |
| `\over` (TeX primitive) | `\frac{}{}` |
| `\bf`, `\it`, `\rm` (deprecated) | `\bfseries`, `\itshape`, `\rmfamily` |
| `center` environment in figures | `\centering` inside figure |
| Hard-coded values like `\vspace{2cm}` | Semantic spacing (`\medskip`, `\bigskip`) or relative lengths |
| `\ref` without package | `\cref` (cleveref) or `\autoref` |
| Missing `~` before `\ref` | Always `Figure~\ref{...}` |

### Draft Mode and TODO Workflow

```latex
% Add to preamble during active writing
\usepackage[colorinlistoftodos, textwidth=2.5cm]{todonotes}

% In-document annotations
\todo{Derive this properly}
\todo[inline]{Add a diagram of the potential well here}
\todo[color=green!30]{Check this value against Griffiths p.~143}
\missingfigure{Phase portrait of the pendulum}

% Print a list of all todos at end of document (or standalone page)
\listoftodos

% Remove ALL todos for final version: pass [disable] to todonotes
\usepackage[disable]{todonotes}

% Draft watermark
\usepackage[firstpage]{draftwatermark}
\SetWatermarkText{DRAFT}
\SetWatermarkScale{1.2}
\SetWatermarkColor[gray]{0.85}
```

### Paragraph and Prose Guidelines

- **One idea per paragraph.** In STEM writing, paragraphs should be 3–6 sentences maximum.
- **Follow equations with text.** Every displayed equation should have a sentence before and after explaining the symbols.
- **Avoid relying on floats as sentences.** Never write "see above" — always use `\cref{fig:x}`.
- **Use `\medskip` / `\bigskip` sparingly.** Prefer structural commands like `\section`,
  `\paragraph`, or tcolorbox environments to create visual breaks.
- **Cross-reference aggressively.** Every figure, table, equation, and theorem should be
  referenced from the text at least once.

---

## 14. Presentations (Beamer)

Read `references/presentations.md` for the full guide. Key patterns:

```latex
\documentclass[aspectratio=169]{beamer}
\usetheme{metropolis}          % or Madrid, Berlin, Singapore, Warsaw

\begin{frame}{Key Results}
  \begin{itemize}[<+->]        % step-by-step reveal
    \item Conservation of energy
    \item Noether's theorem
  \end{itemize}
\end{frame}
```

**Blocks for STEM slides:**
```latex
\begin{block}{Definition}    Content  \end{block}
\begin{alertblock}{Warning}  Content  \end{alertblock}
\begin{exampleblock}{Example} Content \end{exampleblock}
```

---

## 15. Formatting and Layout Control

Read `references/formatting.md` for the complete guide. Key patterns:

```latex
% Multiple columns
\usepackage{multicol}
\begin{multicols}{2}
  Text in two balanced columns.
\end{multicols}

% Margin notes
\usepackage{marginnote}
\marginnote{Side annotation.}

% Paragraph spacing
\setlength{\parskip}{0.5ex plus 0.2ex}
\setlength{\parindent}{1.5em}

% Page breaking
\clearpage          % flush all floats, start new page
\FloatBarrier       % flush floats without page break
```

---

## Reference Files

- **`references/mathematics.md`** — Full math typesetting (operators, calculus, tensors, Dirac notation, spacing, math fonts, accents, bracket sizing, amsmath)
- **`references/file-management.md`** — Multi-file projects: `\input`, `\include`, `\includeonly`, `subfiles`, `standalone`, `import`, folder structures, git, build speed
- **`references/styling.md`** — Full styling: tcolorbox boxes, titlesec, color themes, columns, margin notes, drop caps, epigraphs, mdframed, watermarks
- **`references/stem-packages.md`** — Science packages: circuitikz, pgfplots, chemformula, feynmp, siunitx, forest, algorithmicx
- **`references/bibliography.md`** — BibTeX/BibLaTeX reference, .bib entry types, bibliography styles by discipline
- **`references/presentations.md`** — Beamer themes, overlays, STEM slides, TikZ animations, posters (beamerposter / tikzposter)
- **`references/formatting.md`** — Lengths, paragraph formatting, alignment, columns, footnotes, margin notes, counters, boxes
- **`references/fonts.md`** — Font sizes, families, 5 curated STEM pairings, XeLaTeX fontspec, unicode-math, math fonts
- **`references/custom-packages-classes.md`** — Writing `.sty` packages and `.cls` classes: options, key-value, practical STEM examples
- **`references/advanced-latex.md`** — Glossaries, nomenclature, hyperref, cleveref, babel/polyglossia, field-specific packages, exams, latexmk, LuaLaTeX, expl3
- **`references/multifile.md`** — Legacy reference (superseded by `file-management.md`)
