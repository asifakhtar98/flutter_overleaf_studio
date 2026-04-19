# Writing Custom LaTeX Packages and Classes

Ref: Overleaf — *Writing your own package* · *Writing your own class*

## Table of Contents
1. Why Write Your Own Package or Class?
2. Package vs Class — When to Use Each
3. Writing a `.sty` Package — Full Anatomy
4. Package Options with `\DeclareOption`
5. Package with Key-Value Options (pgfopts / kvoptions)
6. Practical STEM Package Example
7. Writing a `.cls` Class — Full Anatomy
8. Class Options and `\PassOptionsToClass`
9. Overriding or Extending Class Commands
10. Practical STEM Class Example
11. Distribution and Best Practices

---

## 1. Why Write Your Own Package or Class?

- **Consistency**: define theorem styles, colors, and macros once — used across all files
- **Reusability**: share the package across multiple projects
- **Collaboration**: team members use your style without touching the preamble
- **Clean main.tex**: one `\usepackage{mystemnotes}` instead of 80 lines of preamble

---

## 2. Package vs Class — When to Use Each

| | Package (`.sty`) | Class (`.cls`) |
|---|---|---|
| Loaded with | `\usepackage{mypackage}` | `\documentclass{myclass}` |
| Extends | Any document class | A specific base class (book, article…) |
| Controls layout | Partially | Fully (margins, headings, fonts) |
| Best for | Reusable macros, environments, colors | Custom document type (journal, thesis, notes) |
| Loaded by | User in preamble | Replaces `\documentclass` |

---

## 3. Writing a `.sty` Package — Full Anatomy

A `.sty` file has four structural sections: **Identification → Preliminary Declarations → Options → Final Code**.

```latex
%% File: mystemnotes.sty
%% ─────────────────────────────────────────────────────────────────────────────
%% SECTION 1: IDENTIFICATION
%% ─────────────────────────────────────────────────────────────────────────────
\NeedsTeXFormat{LaTeX2e}[2020/01/01]
\ProvidesPackage{mystemnotes}
  [2026/04/01 v1.2 STEM Notes Style Package]
%   ↑ date must be YYYY/MM/DD   ↑ version  ↑ short description

%% ─────────────────────────────────────────────────────────────────────────────
%% SECTION 2: PRELIMINARY DECLARATIONS (load dependencies, init defaults)
%% ─────────────────────────────────────────────────────────────────────────────
\RequirePackage{amsmath, amssymb, amsthm}
\RequirePackage{mathtools}
\RequirePackage{xcolor}
\RequirePackage{tcolorbox}
\tcbuselibrary{theorems, skins, breakable}

% Initialise default values (may be changed by options)
\newcommand{\mystemnotes@themecolor}{blue}
\newcommand{\mystemnotes@fontsize}{12pt}

%% ─────────────────────────────────────────────────────────────────────────────
%% SECTION 3: OPTIONS
%% ─────────────────────────────────────────────────────────────────────────────
% Named theme options
\DeclareOption{bluetheme}{%
  \renewcommand{\mystemnotes@themecolor}{1A3C6E}%
}
\DeclareOption{greentheme}{%
  \renewcommand{\mystemnotes@themecolor}{1B5E20}%
}
\DeclareOption{tealtheme}{%
  \renewcommand{\mystemnotes@themecolor}{00695C}%
}

% Pass unknown options to a dependency
\DeclareOption*{%
  \PackageWarning{mystemnotes}{Unknown option '\CurrentOption'}%
}

% Process all declared options
\ProcessOptions\relax   % \relax prevents issues with following code

%% ─────────────────────────────────────────────────────────────────────────────
%% SECTION 4: FINAL CODE (the actual package content)
%% ─────────────────────────────────────────────────────────────────────────────

% Apply theme color
\definecolor{themeMain}{HTML}{\mystemnotes@themecolor}

% ── Theorem environments ──────────────────────────────────────────────────────
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

% ── Custom math commands ──────────────────────────────────────────────────────
\newcommand{\R}{\mathbb{R}}
\newcommand{\C}{\mathbb{C}}
\newcommand{\N}{\mathbb{N}}
\newcommand{\Z}{\mathbb{Z}}
\DeclareMathOperator{\Tr}{Tr}
\DeclareMathOperator{\rank}{rank}
\DeclareMathOperator*{\argmin}{arg\,min}
\DeclareMathOperator*{\argmax}{arg\,max}

% ── Vector notation ───────────────────────────────────────────────────────────
\newcommand{\vb}[1]{\boldsymbol{#1}}       % bold vector (works for Greek too)
\newcommand{\vu}[1]{\hat{\boldsymbol{#1}}} % unit vector

% ── Tcolorbox theorem wrappers ───────────────────────────────────────────────
\newtcbtheorem[number within=chapter]{stheorem}{Theorem}{
  enhanced, breakable,
  colback=themeMain!5, colframe=themeMain!70,
  fonttitle=\bfseries\color{white},
  attach boxed title to top left={yshift=-2mm, xshift=4mm},
  boxed title style={colback=themeMain!70},
  separator sign={.},
}{thm}

\newtcbtheorem[number within=chapter]{sdefinition}{Definition}{
  enhanced, breakable,
  colback=green!5, colframe=green!50!black,
  fonttitle=\bfseries\color{white},
  attach boxed title to top left={yshift=-2mm, xshift=4mm},
  boxed title style={colback=green!50!black},
  separator sign={.},
}{def}

\endinput   % always end .sty files with \endinput
```

**Usage in main.tex:**
```latex
\documentclass[12pt]{book}
\usepackage[bluetheme]{mystemnotes}
```

---

## 4. Package Options with `\DeclareOption`

```latex
% Boolean option (flag)
\newif\if@mysty@solutions      % creates \@mysty@solutionstrue / false
\@mysty@solutionsfalse         % default: off

\DeclareOption{solutions}{\@mysty@solutionstrue}
\DeclareOption{nosolutions}{\@mysty@solutionsfalse}
\ProcessOptions\relax

% Later in the package, use conditionally:
\if@mysty@solutions
  \newenvironment{solution}{\begin{tcolorbox}[title=Solution]}{\end{tcolorbox}}
\else
  \newenvironment{solution}{\comment}{\endcomment}   % hide solutions
\fi

%% Usage: \usepackage[solutions]{mystemnotes}
%%        \usepackage[nosolutions]{mystemnotes}
```

---

## 5. Package with Key-Value Options (pgfopts)

Key-value options are more powerful and user-friendly than flag options.

```latex
\RequirePackage{pgfopts}   % or kvoptions

\pgfkeys{
  /mystemnotes/.cd,               % all keys under /mystemnotes namespace
  theme/.store in  = \mystemnotes@theme,
  theme            = blue,        % default value
  fontsize/.store in = \mystemnotes@fontsize,
  fontsize         = 12pt,
  solutions/.is if = mystemnotes@solutions,  % boolean key
  solutions        = false,
}
\ProcessPgfOptions{/mystemnotes}

%% Usage:
%% \usepackage[theme=green, solutions=true]{mystemnotes}
%% \usepackage[fontsize=11pt, theme=teal]{mystemnotes}
```

---

## 6. Practical STEM Package Example

```latex
%% File: stem-macros.sty
%% A lightweight macro package for physics / mathematics notes.
\NeedsTeXFormat{LaTeX2e}
\ProvidesPackage{stem-macros}[2026/04/01 v1.0 STEM macros]

\RequirePackage{physics}      % \dv, \pdv, \bra, \ket, etc.
\RequirePackage{siunitx}
\RequirePackage{bm}

% ── Physical constants (ISO 80000 names) ─────────────────────────────────────
\newcommand{\kB}{k_{\mathrm{B}}}        % Boltzmann constant
\newcommand{\NA}{N_{\mathrm{A}}}        % Avogadro number
\newcommand{\hbar}{\mkern1mu\bar{\mkern-1mu h}}  % ℏ (if physics not loaded)

% ── Common operators ─────────────────────────────────────────────────────────
\DeclareMathOperator{\Tr}{Tr}
\DeclareMathOperator{\tr}{tr}
\DeclareMathOperator{\diag}{diag}
\DeclareMathOperator{\rank}{rank}
\DeclareMathOperator{\sign}{sgn}
\DeclareMathOperator*{\argmin}{arg\,min}
\DeclareMathOperator*{\argmax}{arg\,max}
\DeclareMathOperator{\Real}{Re}
\DeclareMathOperator{\Imag}{Im}

% ── Number sets ──────────────────────────────────────────────────────────────
\newcommand{\RR}{\mathbb{R}}
\newcommand{\CC}{\mathbb{C}}
\newcommand{\NN}{\mathbb{N}}
\newcommand{\ZZ}{\mathbb{Z}}
\newcommand{\QQ}{\mathbb{Q}}
\newcommand{\FF}{\mathbb{F}}

% ── Differential forms / exterior calculus ────────────────────────────────────
\newcommand{\dd}{\mathrm{d}}             % upright differential: \dd x
\newcommand{\Dd}[1]{\,\mathrm{d}#1}     % \Dd{x} = thin space + upright d + x

% ── Notation shortcuts ───────────────────────────────────────────────────────
\newcommand{\vb}[1]{\boldsymbol{#1}}
\newcommand{\vu}[1]{\hat{\boldsymbol{#1}}}
\newcommand{\order}[1]{\mathcal{O}\!\left(#1\right)}

\endinput
```

---

## 7. Writing a `.cls` Class — Full Anatomy

A class differs from a package: it **defines the document layout** and uses `\LoadClass` to
inherit from a base class.

```latex
%% File: stembook.cls
%% ─────────────────────────────────────────────────────────────────────────────
%% SECTION 1: IDENTIFICATION
%% ─────────────────────────────────────────────────────────────────────────────
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{stembook}
  [2026/04/01 v1.0 STEM Textbook Class]

%% ─────────────────────────────────────────────────────────────────────────────
%% SECTION 2: PRELIMINARY DECLARATIONS
%% ─────────────────────────────────────────────────────────────────────────────
\newcommand{\stembook@themecolor}{1A3C6E}  % default: academic blue

%% ─────────────────────────────────────────────────────────────────────────────
%% SECTION 3: OPTIONS
%% ─────────────────────────────────────────────────────────────────────────────
\DeclareOption{blue}{%
  \renewcommand{\stembook@themecolor}{1A3C6E}%
}
\DeclareOption{green}{%
  \renewcommand{\stembook@themecolor}{1B5E20}%
}
\DeclareOption{teal}{%
  \renewcommand{\stembook@themecolor}{00695C}%
}

% Pass unknown options to the base class (book)
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}

\ProcessOptions\relax

%% ─────────────────────────────────────────────────────────────────────────────
%% SECTION 4: LOAD BASE CLASS  ← key difference from .sty
%% ─────────────────────────────────────────────────────────────────────────────
\LoadClass[12pt, twoside, openright]{book}

%% ─────────────────────────────────────────────────────────────────────────────
%% SECTION 5: PACKAGE REQUIREMENTS AND LAYOUT
%% ─────────────────────────────────────────────────────────────────────────────
\RequirePackage[a4paper, inner=3cm, outer=2.5cm, top=2.5cm, bottom=3cm]{geometry}
\RequirePackage{microtype}
\RequirePackage{emptypage}
\RequirePackage{xcolor}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\RequirePackage{amsmath, amssymb, amsthm}
\RequirePackage{tcolorbox}
\tcbuselibrary{theorems, skins, breakable}

% Apply theme
\definecolor{themecolor}{HTML}{\stembook@themecolor}
\colorlet{themelight}{themecolor!10!white}
\colorlet{themeaccent}{themecolor!30!orange}

%% ─────────────────────────────────────────────────────────────────────────────
%% SECTION 6: LAYOUT CUSTOMIZATION
%% ─────────────────────────────────────────────────────────────────────────────

% Chapter title style
\titleformat{\chapter}[display]
  {\normalfont\Huge\bfseries\color{themecolor}}
  {\rule{\textwidth}{1.5pt}\\[4pt]%
   \large\scshape Chapter \thechapter}
  {0pt}{\Huge}
  [\vspace{4pt}\rule{\textwidth}{0.5pt}]
\titlespacing*{\chapter}{0pt}{40pt}{30pt}

% Section style
\titleformat{\section}
  {\normalfont\Large\bfseries\color{themecolor!80!black}}
  {\thesection}{0.8em}{}
  [\color{themecolor!50}\titlerule[0.5pt]]

\titleformat{\subsection}
  {\normalfont\large\bfseries\color{themecolor!70!black}}
  {\thesubsection}{0.8em}{}

% Headers and footers
\pagestyle{fancy}
\fancyhf{}
\fancyhead[LE]{\small\thepage\enspace\textcolor{gray}{\textit{\leftmark}}}
\fancyhead[RO]{\small\textcolor{gray}{\textit{\rightmark}}\enspace\thepage}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\headrule}{%
  \hbox to\headwidth{\color{themecolor}\leaders\hrule height\headrulewidth\hfill}}

\fancypagestyle{plain}{
  \fancyhf{}
  \fancyfoot[C]{\small\thepage}
  \renewcommand{\headrulewidth}{0pt}
}

%% ─────────────────────────────────────────────────────────────────────────────
%% SECTION 7: THEOREM ENVIRONMENTS
%% ─────────────────────────────────────────────────────────────────────────────
\theoremstyle{plain}
\newtheorem{theorem}{Theorem}[chapter]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{corollary}[theorem]{Corollary}

\theoremstyle{definition}
\newtheorem{definition}[theorem]{Definition}
\newtheorem{example}[theorem]{Example}
\newtheorem{exercise}{Exercise}[chapter]

\theoremstyle{remark}
\newtheorem*{remark}{Remark}

\endinput
```

**Usage:**
```latex
\documentclass[blue]{stembook}    % uses stembook.cls

\begin{document}
\frontmatter
\tableofcontents
\mainmatter
\chapter{Classical Mechanics}
...
\end{document}
```

---

## 8. Class Options and `\PassOptionsToClass`

```latex
% In class: forward unknown options to base class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax
\LoadClass{book}

% This means:
% \documentclass[12pt, twoside]{stembook}
% → sends '12pt' and 'twoside' to book class automatically

% Pass a fixed option to base class (always two-column, e.g.):
\LoadClass[twocolumn]{article}
```

---

## 9. Overriding or Extending Class Commands

```latex
% Override \maketitle for a custom title page
\renewcommand{\maketitle}{%
  \begin{titlepage}
    \centering
    \vspace*{2cm}
    {\Huge\bfseries\color{themecolor}\@title}\\[1.5cm]
    {\large\@author}\\[0.5cm]
    {\normalsize\@date}
    \vfill
    \includegraphics[width=0.25\textwidth]{logo.pdf}
  \end{titlepage}%
  \thispagestyle{empty}%
}

% Override \normalsize (change base font size)
\renewcommand{\normalsize}{\fontsize{11}{13.5}\selectfont}

% Override \section using titlesec (in .cls after \LoadClass)
\titleformat{\section}{\Large\bfseries\sffamily}{\thesection}{1em}{}

% Add a custom toc entry style
\renewcommand{\cftchapterfont}{\bfseries\color{themecolor}}   % tocloft package
```

---

## 10. Practical STEM Class Example — Minimal Thesis Class

```latex
%% File: stemthesis.cls
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{stemthesis}[2026/04/01 v1.0 STEM Thesis]

% Options
\newif\if@stemthesis@print
\DeclareOption{print}{\@stemthesis@printtrue}     % print-friendly (no colors)
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax
\LoadClass[12pt, twoside, openright]{book}

% Core packages
\RequirePackage[a4paper, inner=3.5cm, outer=2.5cm, top=3cm, bottom=3cm]{geometry}
\RequirePackage{microtype, emptypage}
\RequirePackage{xcolor}
\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern}

% Color scheme (suppress in print mode)
\if@stemthesis@print
  \definecolor{themecolor}{gray}{0.3}
\else
  \definecolor{themecolor}{HTML}{1A3C6E}
\fi

% Front matter commands
\newcommand{\university}[1]{\gdef\@university{#1}}
\newcommand{\degree}[1]{\gdef\@degree{#1}}
\newcommand{\department}[1]{\gdef\@department{#1}}

\renewcommand{\maketitle}{%
  \begin{titlepage}
    \centering
    \vspace*{1.5cm}
    {\huge\bfseries\color{themecolor}\@title}\\[2cm]
    {\large Thesis submitted for the degree of}\\[0.4cm]
    {\Large\bfseries\@degree}\\[1cm]
    by\\[0.5cm]
    {\large\@author}\\[1.5cm]
    {\normalsize\@department}\\
    {\normalsize\@university}\\[2cm]
    {\normalsize\@date}
    \vfill
  \end{titlepage}%
}

\endinput
```

**Usage:**
```latex
\documentclass[print]{stemthesis}

\university{University of Cambridge}
\degree{Doctor of Philosophy}
\department{Department of Physics}
\title{Quantum Transport in Topological Materials}
\author{Jane Doe}
\date{April 2026}

\begin{document}
\maketitle
\frontmatter
\tableofcontents
\mainmatter
\chapter{Introduction}
...
\end{document}
```

---

## 11. Distribution and Best Practices

```latex
% File header comment block (good practice)
%% Package:    mypackage.sty
%% Author:     Your Name <you@example.com>
%% License:    LaTeX Project Public License (LPPL) v1.3c
%% Repository: https://github.com/yourname/mypackage
%% Version:    1.2 (2026-04-01)
%% Requires:   LaTeX2e + amsmath, xcolor, tcolorbox

% Versioning in \ProvidesPackage:
\ProvidesPackage{mypackage}[2026/04/01 v1.2 My STEM Package]
%                           ↑ date format YYYY/MM/DD is mandatory for LaTeX

% Require minimum version of a dependency:
\RequirePackage{amsmath}[2020/01/01]   % need amsmath released after Jan 2020

% Error/warning/info messages:
\PackageError  {mypackage}{Error message}{Help text for user}
\PackageWarning{mypackage}{Warning — something unusual happened}
\PackageInfo   {mypackage}{Informational message (in log only)}

% Useful debugging:
\typeout{mypackage: loading with theme=\mystemnotes@theme}  % log output
```

### Local Installation (without Overleaf)

```
Place .sty or .cls in either:
  1. Same directory as your .tex file (easiest for a single project)
  2. ~/texmf/tex/latex/my-packages/mypackage.sty  (user-wide, auto-found)
     → then run: texhash ~/texmf   (or mktexlsr)
  3. TEXMFLOCAL/tex/latex/  (system-wide)
     → then run: sudo texhash
```

### On Overleaf

Just place `.sty` and `.cls` files in the same directory as `main.tex`, or in a `styles/`
subdirectory and reference with `\usepackage{styles/mypackage}`.
