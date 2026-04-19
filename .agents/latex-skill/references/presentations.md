# Presentations Reference — Beamer and Posters

## Table of Contents
1. Beamer Basics
2. Built-in Themes
3. Frame Structure and Overlays
4. Math-Heavy STEM Slides
5. TikZ Animations in Beamer
6. Custom Beamer Theming
7. Handout / Article Mode
8. Poster Creation (beamerposter / tikzposter)

---

## 1. Beamer Basics

```latex
\documentclass[12pt, aspectratio=169]{beamer}  % 16:9 widescreen
% aspectratio=43 (4:3 default), 169 (16:9), 1610 (16:10), 149 (14:9)

\usetheme{Madrid}
\usecolortheme{default}

\title{Classical Mechanics}
\subtitle{Lagrangian and Hamiltonian Formulations}
\author{Your Name}
\institute{Department of Physics}
\date{\today}

\begin{document}

\begin{frame}
  \titlepage
\end{frame}

\begin{frame}{Outline}
  \tableofcontents
\end{frame}

\end{document}
```

---

## 2. Built-in Themes

### Navigation Style Themes

| Theme | Style | Best For |
|-------|-------|----------|
| `Madrid` | Blue header + footer, navigation dots | General academic |
| `AnnArbor` | Double header bar | University talks |
| `Berlin` | Top navigation bar | Technical talks |
| `Singapore` | Mini frames in header | Math/CS |
| `Warsaw` | Split header + progress bar | Conferences |
| `CambridgeUS` | Clean dark red | Seminars |
| `Boadilla` | Minimal | Clean slides |
| `metropolis` | Modern, flat (external pkg) | Modern STEM |

```latex
% Metropolis (modern, highly recommended for STEM)
% Install: tlmgr install beamertheme-metropolis
\usetheme{metropolis}
\setbeamercolor{background canvas}{bg=white}
```

### Color Themes
```latex
\usecolortheme{orchid}     % purple accents
\usecolortheme{whale}      % dark blue
\usecolortheme{seahorse}   % light
\usecolortheme{crane}      % yellow
\usecolortheme{beaver}     % dark red
```

### Font Themes
```latex
\usefonttheme{serif}            % serif body text
\usefonttheme{professionalfonts}% use document fonts for math
\usefonttheme[onlymath]{serif}  % serif math only
```

---

## 3. Frame Structure and Overlays

### Standard Frame
```latex
\begin{frame}{Frame Title}
  \framesubtitle{Optional subtitle}

  \begin{itemize}
    \item First point
    \item Second point
  \end{itemize}
\end{frame}
```

### Columns Inside a Frame
```latex
\begin{frame}{Two Columns}
  \begin{columns}[T]
    \begin{column}{0.5\textwidth}
      \textbf{Left side}\\
      Some text or figure here.
    \end{column}
    \begin{column}{0.5\textwidth}
      \includegraphics[width=\textwidth]{figure.pdf}
    \end{column}
  \end{columns}
\end{frame}
```

### Overlay Commands

| Command | Effect |
|---------|--------|
| `\pause` | Show content step by step |
| `\only<2>{...}` | Shown only on slide 2 |
| `\uncover<2->{...}` | Revealed from slide 2 (space reserved) |
| `\visible<3>{...}` | Visible on slide 3 (space reserved, no fade) |
| `\alert<2>{text}` | Highlighted on overlay 2 |
| `\onslide<2-4>{...}` | Shown on overlays 2 through 4 |

```latex
\begin{frame}{Step-by-step Proof}
  \begin{align}
    F &= ma              \onslide<2->{ \quad \text{Newton's 2nd law}}\\
    a &= \dv{v}{t}       \onslide<3->{ \quad \text{definition of acceleration}}\\
    F &= m\dv{v}{t}      \onslide<4->{ \quad \text{substituting}}
  \end{align}
\end{frame}
```

### Itemize with Step-by-step Reveal
```latex
\begin{frame}{Key Results}
  \begin{itemize}[<+->]   % each item revealed in turn
    \item Conservation of energy
    \item Conservation of momentum
    \item Noether's theorem connects both
  \end{itemize}
\end{frame}
```

---

## 4. Math-Heavy STEM Slides

### Theorem-Proof Across Frames
```latex
\begin{frame}{Hamilton's Principle}
  \begin{theorem}[Hamilton's Principle]
    The actual trajectory of a system between times $t_1$ and $t_2$
    is the one for which the action
    \[
      S = \int_{t_1}^{t_2} L(q, \dot{q}, t)\,dt
    \]
    is stationary: $\delta S = 0$.
  \end{theorem}
\end{frame}

\begin{frame}{Proof Sketch}
  \begin{proof}
    Varying the path $q(t) \to q(t) + \varepsilon\eta(t)$\ldots
    \pause
    After integration by parts and using $\eta(t_1)=\eta(t_2)=0$:
    \[
      \frac{\partial L}{\partial q} - \frac{d}{dt}\frac{\partial L}{\partial \dot{q}} = 0
    \]
  \end{proof}
\end{frame}
```

### Equation Box Callout
```latex
% Highlight an important equation with a colored box
\setbeamercolor{myequation}{bg=blue!10, fg=blue!80!black}

\begin{frame}{Schrödinger Equation}
  \begin{beamercolorbox}[rounded=true, sep=8pt, center]{myequation}
    \[
      i\hbar\frac{\partial}{\partial t}\Psi(\mathbf{r},t)
      = \hat{H}\Psi(\mathbf{r},t)
    \]
  \end{beamercolorbox}
\end{frame}
```

### Blocks
```latex
\begin{block}{Key Definition}
  A \emph{Hamiltonian} is defined as...
\end{block}

\begin{alertblock}{Warning}
  This result only holds for conservative systems.
\end{alertblock}

\begin{exampleblock}{Example}
  For the harmonic oscillator, $H = \frac{p^2}{2m} + \frac{1}{2}m\omega^2 x^2$.
\end{exampleblock}
```

---

## 5. TikZ Animations in Beamer

```latex
\begin{frame}{Phase Space Trajectory}
  \centering
  \begin{tikzpicture}[scale=1.5]
    % Background axes
    \draw[->] (-2,0) -- (2,0) node[right] {$q$};
    \draw[->] (0,-2) -- (0,2) node[above] {$p$};
    % Reveal orbit step by step
    \onslide<2->{\draw[blue, thick] (0,0) circle (1);}
    \onslide<3->{\draw[->, red, thick] (1,0) arc (0:90:1);}
    \onslide<4->{\node at (0.7, 0.7) {$E = E_0$};}
  \end{tikzpicture}
\end{frame}
```

---

## 6. Custom Beamer Theming

```latex
% Override theme colors globally
\setbeamercolor{title}{fg=white, bg=blue!60!black}
\setbeamercolor{frametitle}{fg=white, bg=blue!50!black}
\setbeamercolor{block title}{fg=white, bg=blue!40!black}
\setbeamercolor{block body}{fg=black, bg=blue!5}
\setbeamercolor{item}{fg=blue!70!black}

% Custom fonts
\setbeamerfont{title}{size=\Large, series=\bfseries}
\setbeamerfont{frametitle}{size=\large, series=\bfseries}

% Remove navigation symbols (cleaner look)
\setbeamertemplate{navigation symbols}{}

% Custom footer with progress
\setbeamertemplate{footline}{%
  \leavevmode%
  \hbox{%
    \begin{beamercolorbox}[wd=0.5\paperwidth, ht=2.5ex, dp=1ex, left]{author in head/foot}
      \hspace{1em}\insertshortauthor
    \end{beamercolorbox}%
    \begin{beamercolorbox}[wd=0.5\paperwidth, ht=2.5ex, dp=1ex, right]{date in head/foot}
      \insertframenumber{}/\inserttotalframenumber\hspace{1em}
    \end{beamercolorbox}%
  }%
}
```

---

## 7. Handout and Article Mode

```latex
% Compile for handout (all overlays collapsed to one slide)
\documentclass[handout]{beamer}

% 2 slides per page for handout
\usepackage{pgfpages}
\pgfpagesuselayout{2 on 1}[a4paper, border shrink=5mm]

% Article mode: typeset as flowing document
\documentclass{article}
\usepackage{beamerarticle}
```

---

## 8. Poster Creation

### beamerposter
```latex
\documentclass{beamer}
\usepackage[orientation=portrait, size=a0, scale=1.5]{beamerposter}
\usetheme{confposter}  % or any compatible theme

\begin{document}
\begin{frame}[t]{}
  \begin{columns}[T]
    \begin{column}{0.32\textwidth}
      \begin{block}{Introduction}
        ...
      \end{block}
      \begin{block}{Methods}
        ...
      \end{block}
    \end{column}
    \begin{column}{0.32\textwidth}
      \begin{block}{Results}
        \includegraphics[width=\textwidth]{fig_results.pdf}
      \end{block}
    \end{column}
    \begin{column}{0.32\textwidth}
      \begin{block}{Conclusion}
        ...
      \end{block}
    \end{column}
  \end{columns}
\end{frame}
\end{document}
```

### tikzposter (simpler alternative)
```latex
\documentclass[25pt, a0paper, portrait]{tikzposter}
\usetheme{Autumn}  % Wave, Board, Desert, Autumn, Forest

\title{Quantum Entanglement in Many-Body Systems}
\author{Jane Doe}
\institute{Physics Department}

\begin{document}
\maketitle

\begin{columns}
  \column{0.5}
  \block{Introduction}{
    Text here...
  }
  \block{Methods}{
    \[  \hat{H} = -J\sum_{\langle i,j \rangle} \sigma_i\sigma_j \]
  }
  \column{0.5}
  \block{Results}{
    \includegraphics[width=\linewidth]{results.pdf}
  }
\end{columns}

\end{document}
```
