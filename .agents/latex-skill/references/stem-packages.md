# STEM-Specific Packages Reference

## Table of Contents
1. Physics — `physics` package
2. SI Units — `siunitx`
3. Chemistry — `mhchem` and `chemformula`
4. Circuit Diagrams — `circuitikz`
5. Data Plots — `pgfplots`
6. Feynman Diagrams — `feynmp-auto`
7. Molecular Orbital Diagrams
8. Biology / Genetics
9. Computer Science

---

## 1. Physics Package

```latex
\usepackage{physics}

% Automatic sizing of delimiters
\qty(\frac{a}{b})       % (a/b) auto-sized
\qty[\frac{a}{b}]       % [a/b]
\qty|\psi|              % |ψ|
\qty{\frac{a}{b}}       % {a/b}

% Derivatives
\dv{f}{x}               \dv[n]{f}{x}
\pdv{f}{x}              \pdv{f}{x}{y}

% Vector calculus
\grad{f}   \div{\vb{F}}   \curl{\vb{F}}   \laplacian{f}

% Quantum
\ket{\psi}   \bra{\phi}   \braket{\phi}{\psi}
\comm{A}{B}   \anticomm{A}{B}

% Matrices
\mqty(a & b \\ c & d)        % matrix with parens
\pmqty{a & b \\ c & d}       % same
\det\mqty(a & b \\ c & d)
\tr\mqty(a & 0 \\ 0 & b)     % trace
```

---

## 2. SI Units (siunitx)

```latex
\usepackage{siunitx}
\sisetup{
  per-mode=symbol,
  uncertainty-mode=separate,
}

% Values with units
\SI{9.81}{\metre\per\second\squared}
\SI{1.6e-19}{\coulomb}
\SI{300}{\kelvin}
\SI{1.5 \pm 0.1}{\kilo\gram}

% Units alone
\si{\newton\metre}
\si{\kilo\watt\hour}
\si{\micro\farad}

% Numbers
\num{1.23e-4}         % 1.23 × 10⁻⁴
\numrange{1}{5}       % 1–5

% Tables with aligned numbers
\begin{tabular}{S[table-format=3.2]}
  \toprule
  {Value (\si{\metre})} \\
  \midrule
  1.23 \\
  45.60 \\
  \bottomrule
\end{tabular}

% Common units quick reference
% Length: \metre, \kilo\metre, \centi\metre, \milli\metre, \micro\metre, \nano\metre
% Mass: \gram, \kilo\gram
% Time: \second, \milli\second, \micro\second, \nano\second
% Energy: \joule, \kilo\joule, \electronvolt
% Force: \newton
% Pressure: \pascal, \kilo\pascal, \bar, \atm (use \atmosphere from siunitx v3)
% Frequency: \hertz, \kilo\hertz, \mega\hertz, \giga\hertz
% Charge: \coulomb
% Voltage: \volt, \kilo\volt, \milli\volt
% Current: \ampere, \milli\ampere
% Resistance: \ohm, \kilo\ohm, \mega\ohm
% Temperature: \kelvin, \degreeCelsius
% Angle: \degree, \radian
```

---

## 3. Chemistry

### chemformula (simpler, recommended)
```latex
\usepackage{chemformula}

\ch{H2O}                       % H₂O
\ch{C6H12O6}                   % glucose
\ch{H2SO4}                     % sulfuric acid
\ch{Na+ + Cl- -> NaCl}         % ionic reaction
\ch{2H2 + O2 -> 2H2O}          % combustion
\ch{CH4 + 2O2 -> CO2 + 2H2O}
\ch{^{14}_{6}C}                % isotope notation
```

### mhchem (more powerful)
```latex
\usepackage[version=4]{mhchem}

\ce{H2O}
\ce{2H2 + O2 -> 2H2O}
\ce{Hg^2+ ->[I-] HgI2 ->[I-] [Hg^{II}I4]^2-}   % stepwise with conditions
\ce{^{227}_{90}Th+}               % nuclides
\ce{H2O_{(l)}}                    % state symbols
```

### Structural formulae (chemfig)
```latex
\usepackage{chemfig}
\chemfig{H-C(-[2]H)(-[6]H)-H}    % methane
\chemfig{*6(-=--=-=)}              % benzene ring
```

---

## 4. Circuit Diagrams (circuitikz)

```latex
\usepackage{circuitikz}

\begin{circuitikz}[scale=1.0]
  % Simple RC circuit
  \draw (0,0)
    to[battery, l=$V_s$] (0,3)
    to[R, l=$R$] (3,3)
    to[C, l=$C$] (3,0)
    -- (0,0);
  % Labels
  \node at (1.5, -0.3) {RC Circuit};
\end{circuitikz}

% Op-amp example
\begin{circuitikz}
  \draw (0,0) node[op amp] (opamp) {}
    (opamp.+) node[left] {$v_+$}
    (opamp.-) node[left] {$v_-$}
    (opamp.out) node[right] {$v_{out}$};
\end{circuitikz}
```

---

## 5. Data Plots (pgfplots)

### 2D Plot with Data File
```latex
\usepackage{pgfplots}
\pgfplotsset{compat=1.18,
  every axis/.append style={
    font=\small,
    label style={font=\small},
  }
}

\begin{tikzpicture}
\begin{axis}[
  xlabel={Time (\si{\second})},
  ylabel={Position (\si{\metre})},
  title={Projectile Motion},
  grid=both,
  legend pos=north east,
  width=0.85\textwidth,
]
  \addplot[blue, thick] table[x=t, y=x, col sep=comma]{data/motion.csv};
  \addlegendentry{Horizontal}
  \addplot[red, thick, dashed] table[x=t, y=y, col sep=comma]{data/motion.csv};
  \addlegendentry{Vertical}
\end{axis}
\end{tikzpicture}
```

### 3D Surface Plot
```latex
\begin{tikzpicture}
\begin{axis}[
  view={60}{30},
  xlabel=$x$, ylabel=$y$, zlabel=$z$,
  title={$z = \sin(x)\cos(y)$},
]
  \addplot3[surf, colormap/cool, samples=30, domain=-pi:pi]
    {sin(deg(x))*cos(deg(y))};
\end{axis}
\end{tikzpicture}
```

### Bar Chart
```latex
\begin{tikzpicture}
\begin{axis}[
  ybar, bar width=0.6cm,
  xlabel={Sample}, ylabel={Value},
  xtick=data,
  xticklabels={A, B, C, D},
  nodes near coords,
]
  \addplot coordinates {(1,3.4) (2,7.2) (3,5.1) (4,8.9)};
\end{axis}
\end{tikzpicture}
```

---

## 6. Feynman Diagrams (feynmp-auto)

```latex
\usepackage{feynmp-auto}

\begin{fmffile}{feyndiag}
\begin{fmfgraph*}(120,80)
  \fmfleft{i1,i2}
  \fmfright{o1,o2}
  \fmf{fermion}{i1,v1,o1}
  \fmf{fermion}{i2,v2,o2}
  \fmf{photon, label=$\gamma$}{v1,v2}
\end{fmfgraph*}
\end{fmffile}
```
*(Requires running `mpost` — works automatically on Overleaf)*

---

## 7. Biology and Genetics

```latex
% DNA sequences
\usepackage{seqsplit}
\seqsplit{ATGCGATCGATCGATCGTAGCTAGCTAG}

% For alignment diagrams, use tikz manually or import SVG/PDF figures

% Phylogenetic trees (simple, with forest package)
\usepackage{forest}
\begin{forest}
  [Animalia
    [Chordata
      [Mammalia [Primates] [Rodentia]]
      [Aves]
    ]
    [Arthropoda [Insecta] [Arachnida]]
  ]
\end{forest}
```

---

## 8. Computer Science

### Algorithm Pseudocode (algorithmicx)
```latex
\usepackage{algorithm}
\usepackage{algpseudocode}

\begin{algorithm}
\caption{Binary Search}\label{alg:binsearch}
\begin{algorithmic}[1]
  \Require Sorted array $A[1..n]$, target $t$
  \Ensure Index $i$ such that $A[i] = t$, or $-1$
  \State $\ell \gets 1$, $r \gets n$
  \While{$\ell \leq r$}
    \State $m \gets \lfloor(\ell + r)/2\rfloor$
    \If{$A[m] = t$} \Return $m$
    \ElsIf{$A[m] < t$} $\ell \gets m+1$
    \Else\ $r \gets m-1$
    \EndIf
  \EndWhile
  \Return $-1$
\end{algorithmic}
\end{algorithm}
```

### Automata / State Machines (tikz)
```latex
\usetikzlibrary{automata, positioning}
\begin{tikzpicture}[shorten >=1pt, node distance=2.5cm, auto]
  \node[state, initial]   (q0) {$q_0$};
  \node[state]            (q1) [right of=q0] {$q_1$};
  \node[state, accepting] (q2) [right of=q1] {$q_2$};
  \path[->]
    (q0) edge node {0} (q1)
    (q1) edge node {1} (q2)
    (q0) edge [loop above] node {1} ()
    (q1) edge [loop above] node {0} ();
\end{tikzpicture}
```
