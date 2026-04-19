# Fonts Reference — Sizes, Families, Styles, and STEM Pairings

## Table of Contents
1. Font Size Commands
2. Font Family and Shape Commands
3. Encoding (pdfLaTeX)
4. Curated STEM Font Pairings (5 combos)
5. XeLaTeX / LuaLaTeX with fontspec
6. Math Font Packages (pdfLaTeX)
7. Math Font Packages (XeLaTeX / LuaLaTeX with unicode-math)
8. Monospace Fonts for Code
9. Font Troubleshooting

---

## 1. Font Size Commands

The size commands are relative to the base font size set in `\documentclass[12pt]{}`.

| Command | 10pt class | 11pt class | 12pt class |
|---------|-----------|-----------|-----------|
| `\tiny` | 5pt | 6pt | 6pt |
| `\scriptsize` | 7pt | 8pt | 8pt |
| `\footnotesize` | 8pt | 9pt | 10pt |
| `\small` | 9pt | 10pt | 11pt |
| `\normalsize` | 10pt | 11pt | 12pt |
| `\large` | 12pt | 12pt | 14pt |
| `\Large` | 14pt | 14pt | 17pt |
| `\LARGE` | 17pt | 17pt | 20pt |
| `\huge` | 20pt | 20pt | 25pt |
| `\Huge` | 25pt | 25pt | 25pt |

```latex
{\large This text is large.}
\begin{Large}
  Entire paragraph in Large size.
\end{Large}
```

### Arbitrary Sizes (fontsize)
```latex
\fontsize{16}{20}\selectfont   % 16pt font with 20pt baseline skip
{\fontsize{9}{11}\selectfont   Small precise size.}
```

---

## 2. Font Family and Shape Commands

### Families
```latex
\textrm{Serif / Roman}          \rmfamily
\textsf{Sans-serif}             \sffamily
\texttt{Monospace / typewriter} \ttfamily
```

### Shapes
```latex
\textup{Upright (normal)}       \upshape
\textit{Italic}                 \itshape
\textsl{Slanted}                \slshape
\textsc{Small Capitals}         \scshape
```

### Weight
```latex
\textbf{Bold}                   \bfseries
\textmd{Medium (normal weight)} \mdseries
```

### Emphasis
```latex
\emph{Emphasized (italic in roman context)}
\textbf{\textit{Bold italic}}   % combined
```

### Combined shorthand
```latex
{\sffamily\bfseries\large Heading in bold sans-serif at large size}
```

---

## 3. Encoding (pdfLaTeX only)

```latex
% Required for pdfLaTeX — always include in preamble
\usepackage[T1]{fontenc}      % Output encoding: proper accented chars in PDF
\usepackage[utf8]{inputenc}   % Input encoding: accept UTF-8 source files
```

> With **XeLaTeX** or **LuaLaTeX**, both packages are unnecessary — UTF-8 is native.

---

## 4. Curated STEM Font Pairings

### Pairing 1 — Palatino + Euler Math (elegant mathematics)
```latex
% pdfLaTeX
\usepackage{mathpazo}     % Palatino for text + math
\usepackage{eulervm}      % AMS Euler for math (optional override)
\usepackage[T1]{fontenc}
% Result: elegant, Knuth-approved style (used in "Concrete Mathematics")
```

### Pairing 2 — Times + STIX2 (IEEE/APS journal style)
```latex
% XeLaTeX / LuaLaTeX
\usepackage{fontspec}
\usepackage{unicode-math}
\setmainfont{STIX Two Text}
\setmathfont{STIX Two Math}
% Result: closest to Times New Roman with excellent math glyph coverage
```

### Pairing 3 — Libertinus (open-source publishing quality)
```latex
% XeLaTeX / LuaLaTeX
\usepackage{fontspec}
\usepackage{unicode-math}
\setmainfont{Libertinus Serif}
\setsansfont{Libertinus Sans}
\setmathfont{Libertinus Math}
% Result: clean, open-source, very complete Unicode coverage
```

### Pairing 4 — Source Serif 4 + Source Code (modern digital)
```latex
% XeLaTeX / LuaLaTeX
\usepackage{fontspec}
\usepackage{unicode-math}
\setmainfont{Source Serif 4}
\setsansfont{Source Sans 3}
\setmonofont{Source Code Pro}[Scale=0.88]
\setmathfont{TeX Gyre Termes Math}   % best available match
% Result: Adobe's open-source family, excellent for digital-first notes
```

### Pairing 5 — Latin Modern + lm-math (safe default)
```latex
% pdfLaTeX / XeLaTeX / LuaLaTeX
\usepackage{lmodern}     % Latin Modern (improved Computer Modern)
\usepackage[T1]{fontenc}
% Result: default LaTeX look but better PDF quality than plain CM
```

---

## 5. XeLaTeX / LuaLaTeX with fontspec

```latex
\usepackage{fontspec}

% Set main (serif) font
\setmainfont{TeX Gyre Termes}[
  Ligatures=TeX,           % traditional TeX ligatures (fi, fl, etc.)
  Numbers=OldStyle,        % old-style numerals (optional)
  Scale=1.0,
]

% Set sans-serif font
\setsansfont{TeX Gyre Heros}[Scale=MatchLowercase]

% Set monospace font
\setmonofont{JetBrains Mono}[
  Scale=0.85,
  BoldFont=JetBrains Mono Bold,
]

% Use system or Google Fonts (if installed)
\setmainfont{Georgia}
\setmainfont{Lato}[Scale=MatchLowercase]
```

### Loading Font Features
```latex
\setmainfont{Linux Libertine O}[
  Ligatures={TeX, Common},
  Numbers={Proportional, OldStyle},
  SmallCapsFont={* Caps},         % dedicated small caps font
  BoldFont={Linux Libertine O Bold},
]
```

---

## 6. Math Font Packages (pdfLaTeX)

| Package | Text Font | Math Style | Notes |
|---------|-----------|-----------|-------|
| `lmodern` | Latin Modern | CM-style | Safe default |
| `mathpazo` + `eulervm` | Palatino | Euler | Elegant, Knuth-style |
| `newtxtext` + `newtxmath` | Times | TX Math | IEEE-style |
| `newpxtext` + `newpxmath` | Palatino | PX Math | Cleaner Palatino |
| `libertinus` | Libertinus | LibMath | Open-source |
| `fourier` | Utopia | Fourier | Distinctive |
| `kpfonts` | KP Serif | KP Math | All-in-one |

```latex
% Example: newtx (Times-based) for IEEE/APS notes
\usepackage{newtxtext}
\usepackage{newtxmath}
\usepackage[T1]{fontenc}
```

---

## 7. Math Font Packages (XeLaTeX / LuaLaTeX)

```latex
\usepackage{unicode-math}

% Set math font (must be OpenType Math font)
\setmathfont{Latin Modern Math}        % default, safe
\setmathfont{STIX Two Math}            % Times-compatible
\setmathfont{Libertinus Math}          % Libertinus family
\setmathfont{TeX Gyre Termes Math}     % Times-compatible
\setmathfont{TeX Gyre Pagella Math}    % Palatino-compatible
\setmathfont{Asana Math}               % Palatino-inspired
\setmathfont{Garamond-Math}            % Garamond-compatible

% Using a specific font for calligraphic letters only
\setmathfont{XITS Math}[
  StylisticSet=2,   % curly cal letters
  range=\mathcal,
]
```

---

## 8. Monospace Fonts for Code

```latex
% pdfLaTeX options (via package)
\usepackage{inconsolata}      % clean, popular
\usepackage{courier}          % Adobe Courier
\usepackage{DejaVuSansMono}[scale=0.9]

% XeLaTeX / LuaLaTeX (via fontspec)
\setmonofont{JetBrains Mono}[Scale=0.85]
\setmonofont{Fira Code}[Scale=0.85]           % programming ligatures
\setmonofont{Cascadia Code}[Scale=0.85]        % Microsoft, ligatures
\setmonofont{Source Code Pro}[Scale=0.88]
\setmonofont{Iosevka}[Scale=0.85]
```

---

## 9. Font Troubleshooting

| Problem | Fix |
|---------|-----|
| Missing glyphs (boxes) appearing | Switch to `T1` encoding or use XeLaTeX |
| Math symbols look wrong | Ensure math font matches text font family |
| PDF copy-paste extracts gibberish | Use `T1` encoding + `lmodern` in pdfLaTeX |
| `fontspec` error in pdfLaTeX | Add `\usepackage{ifxetex}` guard or switch engine |
| Ligatures `fi ff fl` broken | Ensure `Ligatures=TeX` in fontspec or use `microtype` |
| Font not found by fontspec | Run `fc-list | grep "Font Name"` to check system fonts |
| Chapter titles in wrong font | Use `\titleformat` with explicit font command |

```latex
% Guard preamble for both pdfLaTeX and XeLaTeX/LuaLaTeX
\usepackage{ifxetex, ifluatex}
\ifxetex
  \usepackage{fontspec}
  \setmainfont{Linux Libertine O}
\else\ifluatex
  \usepackage{fontspec}
  \setmainfont{Linux Libertine O}
\else
  \usepackage[T1]{fontenc}
  \usepackage[utf8]{inputenc}
  \usepackage{libertinus}
\fi\fi
```
