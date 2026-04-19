# Advanced Styling Reference for STEM Books

## Table of Contents
1. Color Themes
2. Chapter and Section Styling (titlesec)
3. Custom Callout Boxes (tcolorbox)
4. Headers and Footers (fancyhdr)
5. Fonts
6. Page Layout Fine-tuning
7. Custom Environments
8. Caption Styling
9. Hyperref Styling
10. Multiple Columns (multicol)
11. Margin Notes and Sidenotes
12. Drop Caps and Epigraphs
13. mdframed (Lightweight Alternative to tcolorbox)
14. Page Numbering Styles
15. Watermarks and Draft Mode

---

## 1. Color Themes

### Academic Blue (classic textbook)
```latex
\definecolor{chapterblue}{HTML}{1A3C6E}
\definecolor{sectionblue}{HTML}{2E6DA4}
\definecolor{accentorange}{HTML}{E87722}
\definecolor{lightbg}{HTML}{F0F4FA}
\definecolor{noteyellow}{HTML}{FFF9C4}
\definecolor{warningred}{HTML}{FFEBEE}
```

### STEM Green (engineering / biology)
```latex
\definecolor{stemgreen}{HTML}{1B5E20}
\definecolor{lightgreen}{HTML}{E8F5E9}
\definecolor{steelblue}{HTML}{1565C0}
\definecolor{leafgreen}{HTML}{388E3C}
\definecolor{mintbg}{HTML}{F1F8E9}
```

### Deep Slate (digital-first / dark-mode inspired)
```latex
% Ideal for documents primarily read on screen
\definecolor{slateDark}{HTML}{1E2A3A}
\definecolor{slateAccent}{HTML}{4FC3F7}   % sky blue accent
\definecolor{slateGold}{HTML}{FFD54F}     % amber highlight
\definecolor{slateBg}{HTML}{F5F7FA}
\definecolor{slateBorder}{HTML}{90A4AE}
```

### Crimson Academic (humanities × science crossover)
```latex
\definecolor{crimsonMain}{HTML}{7B1C2E}
\definecolor{crimsonLight}{HTML}{FCE8EC}
\definecolor{warmGray}{HTML}{5D5045}
\definecolor{warmPaper}{HTML}{FAF6F0}
\definecolor{goldRule}{HTML}{C9A84C}
```

### Teal CS (Computer Science / ML)
```latex
\definecolor{tealDark}{HTML}{00695C}
\definecolor{tealLight}{HTML}{E0F2F1}
\definecolor{purpleCS}{HTML}{4527A0}
\definecolor{purpleCSLight}{HTML}{EDE7F6}
\definecolor{codeGray}{HTML}{263238}
```

---

## 2. Chapter and Section Styling (titlesec)

### Style A — Large Rule Above
```latex
\usepackage{titlesec}
\titleformat{\chapter}[display]
  {\normalfont\huge\bfseries\color{chapterblue}}
  {\rule{\textwidth}{1.5pt}\\[6pt]\large\textsc{Chapter} \thechapter}
  {0pt}
  {\huge}
  [\vspace{4pt}\rule{\textwidth}{0.5pt}]
```

### Style B — Colored Box Number
```latex
\titleformat{\chapter}[block]
  {\normalfont\Huge\bfseries}
  {\colorbox{chapterblue}{\textcolor{white}{\quad\thechapter\quad}}}
  {12pt}
  {\color{chapterblue}}
```

### Style C — Springer Sidebar Number (right-aligned chapter number)
```latex
\titleformat{\chapter}[hang]
  {\normalfont\huge\bfseries\color{chapterblue}}
  {\makebox[2cm][r]{\textcolor{accentorange}{\thechapter}}\hspace{12pt}}
  {0pt}
  {}
  [\vspace{2pt}\color{chapterblue}\rule{\textwidth}{0.8pt}]
\titlespacing*{\chapter}{0pt}{40pt}{20pt}
```

### Style D — Minimal / Monochrome (arXiv submission style)
```latex
\titleformat{\chapter}[display]
  {\normalfont\large\bfseries}
  {\MakeUppercase{Chapter \thechapter}}
  {6pt}
  {\Large\bfseries}
  [\vspace{2pt}\rule{\textwidth}{0.4pt}]
\titlespacing*{\chapter}{0pt}{30pt}{15pt}
```

### Section and Subsection
```latex
\titleformat{\section}
  {\normalfont\Large\bfseries\color{sectionblue}}
  {\thesection}{1em}{}
  [\color{sectionblue}\titlerule[0.8pt]]

\titleformat{\subsection}
  {\normalfont\large\bfseries\color{sectionblue!80}}
  {\thesubsection}{1em}{}

\titleformat{\subsubsection}
  {\normalfont\normalsize\bfseries\itshape}
  {\thesubsubsection}{1em}{}
```

---

## 3. Custom Callout Boxes (tcolorbox)

```latex
\usepackage{tcolorbox}
\tcbuselibrary{skins, breakable, theorems}

% ── Definition box ──────────────────────────────────────────────────────────
\newtcolorbox{definitionbox}[2][]{
  enhanced, breakable,
  title={Definition: #2},
  colback=green!5!white,
  colframe=green!50!black,
  fonttitle=\bfseries,
  attach boxed title to top left={yshift=-2mm, xshift=4mm},
  boxed title style={colback=green!50!black},
  #1
}

% ── Theorem box ─────────────────────────────────────────────────────────────
\newtcolorbox{theorembox}[2][]{
  enhanced, breakable,
  title={Theorem: #2},
  colback=blue!5!white,
  colframe=chapterblue,
  fonttitle=\bfseries\color{white},
  attach boxed title to top left={yshift=-2mm, xshift=4mm},
  boxed title style={colback=chapterblue},
  #1
}

% ── Warning / Caution box ───────────────────────────────────────────────────
\newtcolorbox{warningbox}{
  enhanced,
  colback=warningred,
  colframe=red!70!black,
  title={\faExclamationTriangle\quad Warning},
  fonttitle=\bfseries,
}

% ── Note / Tip box ──────────────────────────────────────────────────────────
\newtcolorbox{notebox}{
  enhanced,
  colback=noteyellow,
  colframe=orange!60!black,
  title={Note},
  fonttitle=\bfseries,
}

% ── Insight box (key insight — purple theme) ─────────────────────────────────
\newtcolorbox{insightbox}[1][]{
  enhanced, breakable,
  title={Key Insight},
  colback=purple!5!white,
  colframe=purple!60!black,
  fonttitle=\bfseries\color{white},
  attach boxed title to top left={yshift=-2mm, xshift=4mm},
  boxed title style={colback=purple!60!black},
  #1
}

% ── Lemma / Proposition box ──────────────────────────────────────────────────
\newtcolorbox{lemmapropbox}[2][]{
  enhanced, breakable,
  title={#2},
  colback=teal!5!white,
  colframe=teal!50!black,
  fonttitle=\bfseries\color{white},
  attach boxed title to top left={yshift=-2mm, xshift=4mm},
  boxed title style={colback=teal!50!black},
  #1
}

% ── Algorithm highlight box ──────────────────────────────────────────────────
\newtcolorbox{algorithmbox}[2][]{
  enhanced, breakable,
  title={Algorithm: #2},
  colback=codeGray!3!white,
  colframe=codeGray!80,
  fonttitle=\bfseries\ttfamily\color{white},
  attach boxed title to top left={yshift=-2mm, xshift=4mm},
  boxed title style={colback=codeGray!80},
  #1
}

% ── Sidebar callout ──────────────────────────────────────────────────────────
\tcbset{
  sidebarbase/.style={
    enhanced, breakable,
    borderline west={4pt}{0pt}{chapterblue},
    colback=lightbg, colframe=white,
    boxrule=0pt, left=8pt,
    fonttitle=\bfseries\small\color{chapterblue},
  }
}
\newtcolorbox{sidebarbox}[1]{
  sidebarbase, title={#1}
}

% ── Numbered example with counter ─────────────────────────────────────────────
\newtcbtheorem[number within=chapter]{example}{Example}{
  enhanced, breakable,
  colback=gray!5,
  colframe=gray!50,
  fonttitle=\bfseries,
  separator sign={.},
}{ex}
```

**Usage:**
```latex
\begin{definitionbox}{Vector Space}
  A \emph{vector space} over a field $\mathbb{F}$ is a set $V$\ldots
\end{definitionbox}

\begin{insightbox}
  The key insight is that energy eigenstates are stationary: their
  probability densities $|\psi|^2$ do not evolve in time.
\end{insightbox}

\begin{lemmapropbox}{Cauchy–Schwarz Inequality}
  For all vectors $\mathbf{u}, \mathbf{v}$:
  $|\langle \mathbf{u}, \mathbf{v} \rangle| \leq \|\mathbf{u}\|\,\|\mathbf{v}\|$.
\end{lemmapropbox}

\begin{sidebarbox}{Historical Note}
  Maxwell unified electricity and magnetism in 1865\ldots
\end{sidebarbox}
```

### Wiring tcolorbox Counters to amsthm
```latex
% Share the theorem counter between \newtcbtheorem and amsthm
\newtcbtheorem[use counter=theorem, number within=chapter]{stheorem}{Theorem}{
  STEMbox
}{thm}
% Now \begin{stheorem}{Title}{label} increments the same counter as \begin{theorem}
```

---

## 4. Headers and Footers (fancyhdr)

### Standard Textbook Style
```latex
\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}

% Two-sided (book)
\fancyhead[LE]{\small\thepage \quad \textcolor{gray}{\textit{\leftmark}}}
\fancyhead[RO]{\small\textcolor{gray}{\textit{\rightmark}} \quad \thepage}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\headrule}{\hbox to\headwidth{\color{chapterblue}\leaders\hrule height \headrulewidth\hfill}}

% Chapter opening pages (plain style)
\fancypagestyle{plain}{
  \fancyhf{}
  \fancyfoot[C]{\small\thepage}
  \renewcommand{\headrulewidth}{0pt}
}
```

### Digital Notes Style (center page number, colored rule)
```latex
\fancyhf{}
\fancyhead[L]{\small\color{sectionblue}\textit{\leftmark}}
\fancyhead[R]{\small\color{sectionblue}\textit{\rightmark}}
\fancyfoot[C]{\small\thepage}
\renewcommand{\headrulewidth}{0.5pt}
\renewcommand{\headrule}{{\color{accentorange}\hrule width\headwidth height\headrulewidth}}
```

---

## 5. Fonts

### XeLaTeX / LuaLaTeX (recommended for STEM)
```latex
\usepackage{fontspec}
\usepackage{unicode-math}

% Option A — Times-based
\setmainfont{TeX Gyre Termes}
\setmathfont{TeX Gyre Termes Math}

% Option B — Libertine (open-source, elegant)
\setmainfont{Linux Libertine O}
\setmathfont{Libertinus Math}

% Option C — Palatino
\setmainfont{TeX Gyre Pagella}
\setmathfont{TeX Gyre Pagella Math}

% Monospace for code
\setmonofont{JetBrains Mono}[Scale=0.85]
```

### pdfLaTeX (traditional)
```latex
\usepackage{lmodern}         % default modern
\usepackage{palatino}        % Palatino serif
\usepackage{newpxmath}       % Palatino math
\usepackage[T1]{fontenc}
\usepackage[utf8]{inputenc}
```

See `references/fonts.md` for 5 curated STEM font pairings and full math font options.

---

## 6. Page Layout Fine-tuning

```latex
% Geometry
\usepackage[
  a4paper,
  inner=3cm, outer=2.5cm,
  top=2.5cm,  bottom=3cm,
  headheight=14pt,
  includehead,
]{geometry}

% Paragraph spacing
\setlength{\parskip}{0.4ex plus 0.2ex minus 0.1ex}
\setlength{\parindent}{1.5em}

% Line spacing
\usepackage{setspace}
\setstretch{1.15}  % slight increase for readability

% Widow/orphan control
\widowpenalty=10000
\clubpenalty=10000
```

---

## 7. Custom Environments

```latex
% Chapter summary box
\newenvironment{chapsummary}{%
  \begin{tcolorbox}[
    enhanced, breakable,
    title={Chapter Summary},
    colback=chapterblue!5,
    colframe=chapterblue,
    fonttitle=\bfseries\large,
  ]
}{%
  \end{tcolorbox}
}

% Exercise set
\newcounter{exercise}[chapter]
\newenvironment{exercises}{%
  \section*{Exercises}
  \addcontentsline{toc}{section}{Exercises}
  \setcounter{exercise}{0}
}{%
  \par
}
\newcommand{\exercise}[1][]{%
  \refstepcounter{exercise}%
  \medskip\noindent\textbf{Exercise \thechapter.\theexercise.}%
  \ifthenelse{\equal{#1}{}}{}{\ \textbf{[#1]}}\ %
}

% Solutions environment (toggle with etoolbox)
\newenvironment{solution}{%
  \begin{tcolorbox}[colback=gray!5, colframe=gray!40, title={Solution}, fonttitle=\bfseries]
}{%
  \end{tcolorbox}
}
```

---

## 8. Caption Styling

```latex
\usepackage[
  font=small,
  labelfont={bf, color=chapterblue},
  labelsep=period,
  justification=centering,
]{caption}

\usepackage{subcaption}
```

---

## 9. Hyperref and PDF Metadata

```latex
\usepackage{hyperref}
\hypersetup{
  colorlinks=true,
  linkcolor=chapterblue,
  citecolor=sectionblue,
  urlcolor=accentorange,
  pdftitle={Introduction to Classical Mechanics},
  pdfauthor={Your Name},
  pdfsubject={Physics Textbook},
  pdfkeywords={mechanics, physics, STEM},
  bookmarksnumbered=true,
  pdfpagemode=UseOutlines,
}
```

---

## 10. Multiple Columns (multicol)

```latex
\usepackage{multicol}

% Balanced two-column text block
\begin{multicols}{2}
  \setlength{\columnseprule}{0.4pt}   % rule between columns
  \setlength{\columnsep}{1.5em}       % gap between columns
  Text flows automatically across both columns and is balanced at the end.
\end{multicols}

% Three-column quick reference section
\begin{multicols}{3}[\subsection*{Quick Reference}]
  \small
  $\sin^2\theta + \cos^2\theta = 1$\par
  $e^{i\pi} + 1 = 0$\par
  $\int_0^\infty e^{-x^2}dx = \frac{\sqrt{\pi}}{2}$\par
\end{multicols}

% Force column break
\columnbreak

% Two-column article class (spans full width with starred environments)
\documentclass[twocolumn]{article}
\begin{figure*}[t]   % spans both columns
  ...
\end{figure*}
```

> **Tip**: Use `twocolumn` class option for the whole document (e.g., journal submissions),
> and `multicols` for local two-column regions within a one-column document.

---

## 11. Margin Notes and Sidenotes

```latex
% Standard \marginpar (auto left/right on two-sided docs)
\marginpar{\small\textit{Note in margin.}}
\marginpar[\textit{Left note}]{\textit{Right note}}   % explicit sides

% marginnote package (works inside floats, minipage, etc.)
\usepackage{marginnote}
\marginnote{\small Definition used here.}
\marginnote[-1.5cm]{\small Offset 1.5cm upward.}   % vertical offset

% sidenotes package (Tufte-style numbered sidenotes)
\usepackage{sidenotes}
\sidenote{Tufte-style auto-numbered sidenote text.}

% Margin figure
\begin{marginfigure}
  \includegraphics[width=\marginparwidth]{small_fig.pdf}
  \caption{A margin figure.}
\end{marginfigure}

% Tufte document classes (built-in sidenote support)
% \documentclass{tufte-handout}  or  \documentclass{tufte-book}
```

---

## 12. Drop Caps and Epigraphs

### Drop Caps (lettrine)
```latex
\usepackage{lettrine}

% Basic drop cap
\lettrine{T}{he} foundations of classical mechanics were laid by Newton\ldots

% Customized drop cap
\lettrine[lines=3, lraise=0.1, nindent=0em]{%
  \textcolor{chapterblue}{T}%
}{he} study of thermodynamics begins with\ldots

% Options:
% lines=3        — drop 3 lines
% lraise=0.1     — raise the cap by 10%
% lhang=0.4      — hang 40% of cap into margin
% nindent=0pt    — no indent for subsequent lines
```

### Epigraphs
```latex
\usepackage{epigraph}
\setlength{\epigraphwidth}{0.6\textwidth}
\setlength{\epigraphrule}{0.4pt}

% At start of chapter
\epigraph{%
  ``God does not play dice with the universe.''%
}{--- Albert Einstein}

% Custom styling
\renewcommand{\epigraphflush}{center}
\renewcommand{\sourceflush}{center}
```

---

## 13. mdframed (Lightweight Alternative to tcolorbox)

`mdframed` is simpler than `tcolorbox` and works well for breakable framed environments.

```latex
\usepackage[framemethod=TikZ]{mdframed}

% Simple framed box
\begin{mdframed}
  A simply framed paragraph.
\end{mdframed}

% Styled theorem frame
\newmdtheoremenv[
  backgroundcolor=blue!5,
  linecolor=blue!60!black,
  linewidth=1.5pt,
  topline=false,
  rightline=false,
  bottomline=false,
  frametitlefont=\bfseries,
]{mdtheorem}{Theorem}[chapter]

\newmdtheoremenv[
  backgroundcolor=green!5,
  linecolor=green!50!black,
  linewidth=1.5pt,
  topline=false, rightline=false, bottomline=false,
]{mddefinition}{Definition}[chapter]

% Custom framed environment with title
\newmdenv[
  topline=true, bottomline=true, rightline=false, leftline=false,
  linewidth=1pt, linecolor=accentorange,
  backgroundcolor=noteyellow,
  frametitle={Note},
  frametitlefont=\bfseries,
  frametitlerule=true,
]{mdnote}

% Usage
\begin{mdtheorem}[Pythagorean Theorem]
  In a right triangle, $a^2 + b^2 = c^2$.
\end{mdtheorem}
```

---

## 14. Page Numbering Styles

```latex
% Front matter: Roman numerals
\frontmatter           % in book/report: sets \pagenumbering{roman}
\pagenumbering{roman}  % i, ii, iii, ...

% Main matter: Arabic
\mainmatter            % resets to \pagenumbering{arabic} starting at 1
\pagenumbering{arabic} % 1, 2, 3, ...

% Reset page number to a specific value
\setcounter{page}{1}

% Suppress page number on a specific page
\thispagestyle{empty}

% Suppress on all chapter opening pages
\fancypagestyle{plain}{
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
  % footer with page number:
  \fancyfoot[C]{\small\thepage}
}

% Page numbering with chapter prefix: "3-12"  (page 12 of chapter 3)
\renewcommand{\thepage}{\thechapter-\arabic{page}}
\setcounter{page}{1}   % reset at each chapter using \include
```

---

## 15. Watermarks and Draft Mode

```latex
% Watemark on every page
\usepackage{draftwatermark}
\SetWatermarkText{DRAFT}
\SetWatermarkScale{1.5}
\SetWatermarkColor[gray]{0.88}
\SetWatermarkAngle{45}

% Watermark on first page only
\usepackage[firstpage]{draftwatermark}

% Background package (more control, supports images)
\usepackage{background}
\backgroundsetup{
  scale=1,
  color=black,
  opacity=0.08,
  angle=45,
  contents={\fontsize{60pt}{60pt}\sffamily\bfseries DRAFT}
}

% Conditional draft mode with etoolbox
\usepackage{etoolbox}
\newtoggle{draft}
\toggletrue{draft}    % change to \togglefalse for final

\iftoggle{draft}{%
  \usepackage[firstpage]{draftwatermark}
  \usepackage[colorinlistoftodos]{todonotes}
}{%
  \usepackage[disable]{todonotes}   % silently disables all \todo{}
}
```
