# Advanced LaTeX Reference — Custom Packages, LuaLaTeX, Build Tools, and More

## Table of Contents
1. Custom Style File (.sty)
2. Custom Class File (.cls)
3. Robust Command Definitions (xparse / LaTeX3)
4. Conditional Compilation (etoolbox)
5. Automated Builds with latexmk
6. latexmkrc Configuration
7. Tracking Changes with latexdiff
8. LuaLaTeX Scripting Basics
9. LaTeX3 / expl3 Intro
10. Useful Debugging Commands
11. Glossaries and Nomenclature
12. Hyperlinks and PDF Metadata (hyperref)
13. Cross-Referencing (cleveref / autoref)
14. Defining Commands and Environments
15. Multilingual Support (babel / polyglossia)
16. Field-Specific Packages
17. Typesetting Exams

---

## 1. Custom Style File (.sty)

A `.sty` file encapsulates your preamble into a reusable package.

```latex
% File: styles/mystemnotes.sty
\NeedsTeXFormat{LaTeX2e}[2020/01/01]
\ProvidesPackage{mystemnotes}[2026/04/01 v1.0 STEM Notes Style]

\RequirePackage{pgfopts}
\pgfkeys{
  /mystemnotes/.cd,
  theme/.store in = \mystemnotes@theme,
  theme           = blue,
}
\ProcessPgfOptions{/mystemnotes}

\RequirePackage{amsmath, amssymb, amsthm}
\RequirePackage{mathtools}
\RequirePackage[backend=biber, style=numeric]{biblatex}
\RequirePackage{tcolorbox}
\tcbuselibrary{theorems, skins, breakable}

\theoremstyle{plain}
\newtheorem{theorem}{Theorem}[chapter]
\newtheorem{lemma}[theorem]{Lemma}

\theoremstyle{definition}
\newtheorem{definition}[theorem]{Definition}

\newcommand{\R}{\mathbb{R}}
\newcommand{\C}{\mathbb{C}}
\DeclareMathOperator{\Tr}{Tr}
\DeclareMathOperator*{\argmin}{arg\,min}

\endinput
```

See `references/custom-packages-classes.md` for the full, annotated guide.

---

## 2. Custom Class File (.cls)

```latex
% File: styles/stembook.cls
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{stembook}[2026/04/01 v1.0 STEM Textbook Class]

\LoadClass[12pt, twoside]{book}

\RequirePackage[a4paper, inner=3cm, outer=2.5cm]{geometry}
\RequirePackage{xcolor, fancyhdr, titlesec}
\RequirePackage{amsmath, amssymb, amsthm}

\definecolor{classblue}{HTML}{1A3C6E}

\titleformat{\chapter}[display]
  {\normalfont\Huge\bfseries\color{classblue}}
  {Chapter \thechapter}{20pt}{}

\pagestyle{fancy}
\fancyhf{}
\fancyhead[LE,RO]{\thepage}
\fancyhead[LO]{\nouppercase\rightmark}
\fancyhead[RE]{\nouppercase\leftmark}

\endinput
```

See `references/custom-packages-classes.md` for the full guide including options, `\PassOptionsToClass`, and a thesis class example.

---

## 3. Robust Command Definitions (xparse)

```latex
% \NewDocumentCommand{name}{arg spec}{definition}
% Argument types: m=mandatory, o=optional [], O{default}=optional w/ default, s=star

\NewDocumentCommand{\deriv}{ O{1} m m }{%
  \IfValueTF{#1}%
    {\frac{d^{#1} #2}{d #3^{#1}}}%
    {\frac{d #2}{d #3}}%
}
% \deriv{f}{x}    → df/dx        \deriv[2]{f}{x} → d²f/dx²

\NewDocumentCommand{\boxedeq}{ s m }{%
  \IfBooleanTF{#1}{\boxed{#2}}{\fbox{\ensuremath{#2}}}%
}
% \boxedeq{E=mc^2}   \boxedeq*{E=mc^2}

\NewDocumentCommand{\note}{ O{Note} O{blue} m }{%
  \textcolor{#2}{\textbf{#1:} #3}%
}
% \note{Text}   \note[Remark]{Text}   \note[Warning][red]{Text}
```

---

## 4. Conditional Compilation (etoolbox)

```latex
\usepackage{etoolbox}

\newtoggle{draft}
\toggletrue{draft}

\iftoggle{draft}{%
  \usepackage{todonotes}
  \usepackage[firstpage]{draftwatermark}
}{%
  \usepackage[disable]{todonotes}
}

\newbool{solutions}
\booltrue{solutions}

\ifbool{solutions}{%
  \begin{proof}[Solution] ... \end{proof}
}{}

\pretocmd{\chapter}{\clearpage}{}{}
\apptocmd{\maketitle}{\thispagestyle{empty}}{}{}
```

---

## 5. Automated Builds with latexmk

```bash
latexmk -pdf main.tex               # pdfLaTeX
latexmk -pdfxe main.tex             # XeLaTeX
latexmk -pdflua main.tex            # LuaLaTeX
latexmk -pdf -shell-escape main.tex # with minted
latexmk -pdf -pvc main.tex          # continuous mode (watch + recompile)
latexmk -c                          # clean aux files
latexmk -C                          # also remove PDF
```

---

## 6. latexmkrc Configuration

```perl
# latexmkrc
$pdf_mode = 4;   # 1=pdflatex, 4=lualatex, 5=xelatex

$pdflatex = 'pdflatex -interaction=nonstopmode -shell-escape %O %S';

add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');
sub run_makeglossaries {
    system("makeglossaries '$_[0]'");
}

add_cus_dep('idx', 'ind', 0, 'run_makeindex');
sub run_makeindex { system("makeindex '$_[0]'") }

$clean_ext = "synctex.gz run.xml tex.bak bbl bcf fdb_latexmk run tdo %R-blx.bib";
```

---

## 7. Tracking Changes with latexdiff

```bash
latexdiff old.tex new.tex > diff.tex
pdflatex diff.tex

latexdiff --type=UNDERLINE old.tex new.tex > diff.tex
latexdiff --flatten old.tex new.tex > diff.tex    # for multi-file projects

# With git:
latexdiff-vc --git --flatten -r HEAD main.tex
latexdiff-vc --git --flatten -r HEAD~3 main.tex   # compare 3 commits ago
```

---

## 8. LuaLaTeX Scripting Basics

```latex
\documentclass{article}
\begin{document}

\directlua{tex.print("The answer is " .. 42)}

\directlua{
  function factorial(n)
    if n == 0 then return 1 end
    return n * factorial(n-1)
  end
}
$10! = \directlua{tex.print(factorial(10))}$

\end{document}
```

```latex
\usepackage{luacode}
\begin{luacode*}
  for i = 1, 5 do
    tex.print(i .. " & " .. i*i .. " \\\\")
  end
\end{luacode*}
```

---

## 9. LaTeX3 / expl3 Intro

```latex
\ExplSyntaxOn

\int_new:N \l_my_counter_int
\int_set:Nn \l_my_counter_int { 5 }
\int_incr:N \l_my_counter_int

\tl_new:N  \l_my_text_tl
\tl_set:Nn \l_my_text_tl { Hello~World }

\int_step_inline:nn { 5 } { Iteration~#1 \par }

\int_compare:nTF { \l_my_counter_int > 3 }
  { Greater~than~3 }
  { Not~greater }

\ExplSyntaxOff
```

---

## 10. Useful Debugging Commands

```latex
\showthe\textwidth
\listfiles           % list all loaded packages at end of log
\meaning\somecommand
\overfullrule=5pt    % mark overfull lines with black bar

\usepackage[colorinlistoftodos]{todonotes}
\todo{Fix this}
\todo[inline]{Add figure here}
\missingfigure{Graph}
\listoftodos

\usepackage{showframe}   % visualise page layout boxes
\usepackage{layout}
\layout                  % print page layout diagram
```

---

## 11. Glossaries and Nomenclature

### Glossaries (glossaries-extra)

```latex
\usepackage[acronym, symbols, toc, automake]{glossaries-extra}
\makeglossaries

% ── Define terms ──────────────────────────────────────────────────────────────
\newglossaryentry{hamiltonian}{
  name        = {Hamiltonian},
  plural      = {Hamiltonians},
  description = {The total energy operator $\hat{H} = \hat{T} + \hat{V}$,
                 central to quantum and classical mechanics.}
}

\newglossaryentry{entropy}{
  name        = {entropy},
  symbol      = {\ensuremath{S}},
  description = {A measure of disorder or information content of a system.}
}

% ── Abbreviations / Acronyms ──────────────────────────────────────────────────
\newacronym{qm}{QM}{Quantum Mechanics}
\newacronym{ode}{ODE}{Ordinary Differential Equation}
\newacronym{pde}{PDE}{Partial Differential Equation}
\newacronym{snr}{SNR}{Signal-to-Noise Ratio}

% ── Symbol entries ─────────────────────────────────────────────────────────────
\newglossaryentry{sym:hbar}{
  type        = symbols,
  name        = {\ensuremath{\hbar}},
  description = {Reduced Planck constant, $\hbar = h / 2\pi$},
  sort        = hbar,
}
\newglossaryentry{sym:kB}{
  type        = symbols,
  name        = {\ensuremath{k_{\mathrm{B}}}},
  description = {Boltzmann constant},
  sort        = kB,
}
```

```latex
% ── Usage in text ─────────────────────────────────────────────────────────────
The \gls{hamiltonian} is\ldots       % singular
\Gls{hamiltonian}                    % capitalised (start of sentence)
\glspl{hamiltonian}                  % plural
\glssymbol{sym:hbar}                 % print the symbol ℏ

\gls{qm}                             % "Quantum Mechanics (QM)" on first use, "QM" thereafter
\acrlong{qm}                         % always "Quantum Mechanics"
\acrshort{qm}                        % always "QM"
\acrfull{qm}                         % always "Quantum Mechanics (QM)"

% ── Print at end of document ──────────────────────────────────────────────────
\printglossary[type=main,    title={Glossary}]
\printglossary[type=acronym, title={Acronyms}]
\printglossary[type=symbols, title={Notation}, style=long]

% ── Compile steps ─────────────────────────────────────────────────────────────
% pdflatex main.tex → makeglossaries main → pdflatex main.tex
% Or: latexmk with latexmkrc custom dependency (see §6 above)
```

### Glossary Styles

```latex
\setglossarystyle{altlist}          % definition on new line, indented
\setglossarystyle{list}             % term in bold, definition inline
\setglossarystyle{listgroup}        % alphabetically grouped
\setglossarystyle{listhypergroup}   % grouped + hyperlinks at top
\setglossarystyle{long}             % two-column tabular list
\setglossarystyle{longheader}       % with header row
\setglossarystyle{index}            % index-style (tight)
```

### Nomenclature (nomencl)

```latex
\usepackage{nomencl}
\makenomenclature

% ── Define entries ────────────────────────────────────────────────────────────
\nomenclature{$c$}{Speed of light in vacuum, \SI{3e8}{\metre\per\second}}
\nomenclature{$\hbar$}{Reduced Planck constant, \SI{1.055e-34}{\joule\second}}
\nomenclature{$k_{\mathrm{B}}$}{Boltzmann constant}

% ── Grouped nomenclature ──────────────────────────────────────────────────────
% prefix: A = Latin symbols, G = Greek, S = Subscripts
\nomenclature[A, 01]{$c$}{Speed of light}
\nomenclature[G, 01]{$\alpha$}{Fine structure constant}
\nomenclature[S, 01]{$_0$}{Vacuum / free space}

% ── Grouping code ─────────────────────────────────────────────────────────────
\usepackage{etoolbox}
\renewcommand\nomgroup[1]{%
  \item[\bfseries
  \ifstrequal{#1}{A}{Latin Symbols}{%
  \ifstrequal{#1}{G}{Greek Symbols}{%
  \ifstrequal{#1}{S}{Subscripts}{}}}%
]}

% ── Print ─────────────────────────────────────────────────────────────────────
\printnomenclature

% ── Compile ───────────────────────────────────────────────────────────────────
% pdflatex → makeindex main.nlo -s nomencl.ist -o main.nls → pdflatex
```

---

## 12. Hyperlinks and PDF Metadata (hyperref)

```latex
\usepackage{hyperref}
\hypersetup{
  colorlinks       = true,
  linkcolor        = blue!70!black,    % internal links (TOC, \ref)
  citecolor        = green!50!black,   % citations
  urlcolor         = cyan!70!black,    % URLs
  filecolor        = magenta,          % links to local files
  % ── PDF metadata ────────────────────────────────────────────────────────────
  pdftitle         = {Introduction to Quantum Mechanics},
  pdfauthor        = {Jane Doe},
  pdfsubject       = {Physics Lecture Notes},
  pdfkeywords      = {quantum, physics, Schrödinger, STEM},
  pdfproducer      = {LuaLaTeX + hyperref},
  % ── PDF viewer options ───────────────────────────────────────────────────────
  bookmarksnumbered = true,
  bookmarksopen    = true,
  pdfpagemode      = UseOutlines,      % open with bookmarks panel
  pdfdisplaydoctitle = true,
}

% ── Linking URLs ──────────────────────────────────────────────────────────────
\url{https://www.overleaf.com}                   % raw URL
\href{https://www.overleaf.com}{Overleaf}        % custom link text
\href{https://arxiv.org/abs/1234.5678}{arXiv:1234.5678}

% ── Local file links ──────────────────────────────────────────────────────────
\href{run:./data/results.csv}{Download data}

% ── Manual anchors ────────────────────────────────────────────────────────────
\hypertarget{myanchor}{Target text}     % define target
\hyperlink{myanchor}{Jump to target}    % link to it

% ── Email links ───────────────────────────────────────────────────────────────
\href{mailto:author@university.edu}{author@university.edu}
```

### Print-Friendly vs Screen Hyperref

```latex
% For print output (remove colored links, use black boxes instead)
\hypersetup{
  colorlinks = false,
  pdfborder  = {0 0 0},   % no border around links either
}

% Or use hidelinks (completely invisible — best for printing)
\usepackage[hidelinks]{hyperref}
```

---

## 13. Cross-Referencing (cleveref and autoref)

```latex
% Load cleveref LAST (after hyperref, amsmath, etc.)
\usepackage{cleveref}

% ── Basic usage ───────────────────────────────────────────────────────────────
\cref{eq:newton}      % → "equation (3.2)"   (auto-detects type)
\cref{fig:pendulum}   % → "figure 2.5"
\cref{tab:constants}  % → "table 1.3"
\cref{thm:ftc}        % → "theorem 4.1"
\cref{sec:intro}      % → "section 1.1"
\cref{ch:mechanics}   % → "chapter 2"

\Cref{eq:newton}      % Capitalised: "Equation (3.2)" — use at sentence start

% ── Multiple references ───────────────────────────────────────────────────────
\cref{eq:1,eq:2,eq:3}          % → "equations (3.1) to (3.3)"
\cref{fig:a,fig:b}             % → "figures 2.1 and 2.2"
\cref{eq:1,fig:2,thm:3}        % → mixed types, still formatted

% ── Range ────────────────────────────────────────────────────────────────────
\crefrange{eq:first}{eq:last}  % → "equations (3.1) to (3.8)"

% ── Custom label names ────────────────────────────────────────────────────────
\crefname{equation}{Eq.}{Eqs.}      % override "equation" → "Eq."
\Crefname{equation}{Equation}{Equations}

% ── Labeling conventions (critical for \cref auto-detection) ─────────────────
\label{eq:xxx}    % equations
\label{fig:xxx}   % figures
\label{tab:xxx}   % tables
\label{thm:xxx}   % theorems
\label{def:xxx}   % definitions
\label{sec:xxx}   % sections
\label{ch:xxx}    % chapters
\label{app:xxx}   % appendices
\label{lst:xxx}   % code listings
\label{alg:xxx}   % algorithms
```

---

## 14. Defining Commands and Environments

### New Commands

```latex
% Simple command (no arguments)
\newcommand{\Lagrangian}{\mathcal{L}}
\newcommand{\Hamiltonian}{\mathcal{H}}

% Command with mandatory argument
\newcommand{\br}[1]{\left\langle #1 \right\rangle}   % \br{x} → ⟨x⟩

% Command with optional argument (default value in [])
\newcommand{\energy}[1][E]{#1 = mc^2}
% \energy       → E = mc^2
% \energy[K]    → K = mc^2

% Command with starred variant (xparse)
\NewDocumentCommand{\emph}{ s m }{%
  \IfBooleanTF{#1}{\textbf{#2}}{\textit{#2}}%
}
% \emph{text}   → italic     \emph*{text} → bold

% Overwrite existing command (use with care)
\renewcommand{\vec}[1]{\boldsymbol{#1}}   % replace \vec{} with bold

% Check if command exists before defining (safe definition)
\providecommand{\R}{\mathbb{R}}    % define only if not already defined
```

### New Environments

```latex
% Simple environment
\newenvironment{highlight}{%
  \begin{tcolorbox}[colback=yellow!20, colframe=orange]%
}{%
  \end{tcolorbox}%
}
\begin{highlight}
  Important result!
\end{highlight}

% Environment with arguments
\newenvironment{proofof}[1]{%
  \begin{proof}[Proof of #1]%
}{%
  \end{proof}%
}
\begin{proofof}{Theorem 3.1}
  ...
\end{proofof}

% List-based environment
\newenvironment{keypoints}{%
  \begin{itemize}[label=\textcolor{blue}{$\bullet$}, leftmargin=*]%
    \setlength\itemsep{0.3em}%
}{%
  \end{itemize}%
}

% Counter-based exercise environment
\newcounter{exercisenum}[chapter]
\renewcommand{\theexercisenum}{\thechapter.\arabic{exercisenum}}
\newenvironment{excercise}[1][]{%
  \refstepcounter{exercisenum}%
  \medskip\noindent\textbf{Exercise~\theexercisenum%
    \ifblank{#1}{}{ (#1)}%
  }\quad%
}{%
  \medskip%
}
```

---

## 15. Multilingual Support (babel / polyglossia)

### babel (pdfLaTeX — widely compatible)

```latex
% Single language
\usepackage[ngerman]{babel}    % German (new spelling)
\usepackage[french]{babel}
\usepackage[spanish]{babel}
\usepackage[greek, english]{babel}   % multiple: last = main language

% Language-specific hyphenation and typography are automatic.

% Switching language in text
\selectlanguage{french}
Bonjour le monde.
\selectlanguage{english}
Hello world.

% Inline switch
\textfrench{Bonjour}   ou  \foreignlanguage{french}{Bonjour}

% French typography (babel handles automatically):
% ":" → "~:" (thin space + colon)
% «guillemets» instead of "quotation marks"
```

### polyglossia (XeLaTeX / LuaLaTeX — recommended for non-Latin scripts)

```latex
\usepackage{polyglossia}
\usepackage{fontspec}

\setmainlanguage{english}
\setotherlanguage{arabic}
\setotherlanguage{greek}

% Arabic requires a special font
\newfontfamily\arabicfont[Script=Arabic]{Scheherazade New}

% Switch inline
\textarabic{مرحبا}
\textgreek{Καλημέρα}

% Greek math (ancient vs modern)
\setotherlanguage[variant=ancient]{greek}
```

### Quotation Marks

```latex
\usepackage{csquotes}   % smart quotes, works with babel/polyglossia

\enquote{Automatically correct typographic quotes}
% English: "..." (or '' ... '')
% French:  «...»
% German:  „..."

\enquote*{Single-quoted text}   % inner quotation marks

% Manual fine control:
``traditional LaTeX double''
`single'
\textquote{text}   % csquotes
```

---

## 16. Field-Specific Packages

### Typesetting Feynman Diagrams

```latex
% Method 1: feynmp-auto (MetaPost, works on Overleaf)
\usepackage{feynmp-auto}
\begin{fmffile}{feynman}
\begin{fmfgraph*}(100, 80)
  \fmfleft{i1,i2}     \fmfright{o1,o2}
  \fmf{fermion}{i1,v1,o1}
  \fmf{fermion}{i2,v2,o2}
  \fmf{photon, label=$\gamma$}{v1,v2}
\end{fmfgraph*}
\end{fmffile}

% Method 2: tikz-feynman (pure TikZ, modern)
\usepackage[compat=1.1.0]{tikz-feynman}
\feynmandiagram[horizontal=a to b]{
  i1 -- [fermion] a -- [fermion] i2,
  a -- [photon, edge label=\(\gamma\)] b,
  f1 -- [fermion] b -- [fermion] f2,
};
```

### Molecular Orbital Diagrams

```latex
% MOdiagram package
\usepackage{MOdiagram}
\begin{MOdiagram}
  \atom{left}{1s, 2s, 2p}
  \atom{right}{1s, 2s, 2p}
  \molecule{1sMO, 2sMO, 1s2sMO, 2pMO}
\end{MOdiagram}
```

### Chess Notation

```latex
\usepackage{chessboard}
\usepackage{skak}

\newgame
\mainline{1. e4 e5 2. Nf3 Nc6 3. Bb5 a6}
\showboard
```

### Knitting Patterns

```latex
\usepackage{knitting}
% Produces a grid-based knitting chart
\begin{pattern}
  k4 p2 k4   % knit 4, purl 2, knit 4
\end{pattern}
```

### Electrical Engineering (circuitikz)

```latex
\usepackage{circuitikz}
\begin{circuitikz}[scale=1.0]
  \draw (0,0)
    to[battery, l=$V_s$, invert] (0,3)
    to[R, l=$R_1$] (2,3)
    to[C, l=$C$] (4,3)
    to[R, l=$R_2$] (4,0)
    -- (0,0);
  % Op-amp
  \draw (6,1.5) node[op amp] (oa) {};
  \draw (oa.+) -- ++(-1,0) node[left]{$v_+$};
  \draw (oa.-) -- ++(-1,0) node[left]{$v_-$};
  \draw (oa.out) -- ++(1,0) node[right]{$v_\text{out}$};
\end{circuitikz}
```

---

## 17. Typesetting Exams

```latex
\usepackage{exam}   % the exam class (replaces documentclass)
% OR:
\documentclass{exam}

\begin{document}

\header{PHY 301}{Midterm Exam}{\today}
\footer{}{Page \thepage\ of \numpages}{}

\begin{questions}

\question[10]   % 10 marks
  State Newton's three laws of motion.
  \begin{solution}[3cm]   % blank space in exam, filled in solutions mode
    First law: \ldots
  \end{solution}

\question[20]
  \begin{parts}
    \part[5]   Derive the Lagrangian for a simple pendulum.
    \begin{solution}
      $L = \frac{1}{2}ml^2\dot{\theta}^2 + mgl\cos\theta$
    \end{solution}

    \part[15]  Solve for the period of small oscillations.
    \fillwithlines{4cm}   % lined space for student work
  \end{parts}

\question[10]
  Multiple choice: Which equation represents Faraday's law?
  \begin{choices}
    \choice $\nabla \cdot \mathbf{E} = \rho/\varepsilon_0$
    \CorrectChoice $\nabla \times \mathbf{E} = -\partial\mathbf{B}/\partial t$
    \choice $\nabla \cdot \mathbf{B} = 0$
    \choice $\mathbf{F} = q\mathbf{E}$
  \end{choices}

\end{questions}

% Print with solutions: compile with \printanswers in preamble
% \printanswers  % uncomment for answer key version

\end{document}
```

```latex
% Point totals and grading table
\gradetable[h][questions]   % horizontal table of points per question
\bonuspointsinmargin         % show bonus points in margin

% Blank answer boxes
\makeemptybox{3cm}          % empty box of specified height
\answerline                 % a single blank line for short answers
```
