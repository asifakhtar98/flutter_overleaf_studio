# Mathematics Typesetting Reference

## Table of Contents
1. Inline vs Display Math
2. Operators and Special Functions
3. Calculus and Analysis
4. Linear Algebra
5. Probability and Statistics
6. Quantum Mechanics (Dirac Notation)
7. Tensors
8. Number Sets
9. Commonly Needed Symbols
10. Spacing in Math Mode
11. Display Style vs Text Style
12. Advanced amsmath Environments
13. Mathematical Fonts
14. Accents and Decorations
15. Complex Numbers and Fields
16. Bracket Sizing

---

## 1. Inline vs Display Math

```latex
% Inline: use $ ... $
The energy is $E = mc^2$ where $m$ is mass.

% Display (unnumbered): use \[ ... \]
\[ \int_0^\infty e^{-x^2}\,dx = \frac{\sqrt{\pi}}{2} \]

% Display (numbered): use equation
\begin{equation}
  F = ma \label{eq:newton2}
\end{equation}

% Suppress number: \nonumber or equation*
\begin{equation*}
  e^{i\pi} + 1 = 0
\end{equation*}
```

---

## 2. Operators and Special Functions

```latex
% Trig
\sin, \cos, \tan, \csc, \sec, \cot
\arcsin, \arccos, \arctan
\sinh, \cosh, \tanh

% Log/exp
\ln x,  \log_{10} x,  \exp(x)

% Limits
\lim_{x \to 0} \frac{\sin x}{x} = 1

% Min/max
\min_{x \in S} f(x), \quad \max_{1 \le k \le n} a_k

% Sup/inf
\sup_{n} a_n, \quad \inf_{x > 0} f(x)

% Sum and product
\sum_{k=1}^{n} k^2, \quad \prod_{i=1}^{n} x_i

% Custom operator
\DeclareMathOperator{\Tr}{Tr}       % trace
\DeclareMathOperator{\rank}{rank}
\DeclareMathOperator*{\argmin}{arg\,min}  % with subscript below
\DeclareMathOperator*{\argmax}{arg\,max}
\DeclareMathOperator{\diag}{diag}
```

---

## 3. Calculus and Analysis

```latex
% With physics package:
\dv{f}{x}               % df/dx
\dv[2]{f}{x}            % d^2f/dx^2
\pdv{f}{x}              % ∂f/∂x
\pdv{f}{x}{y}           % ∂²f/∂x∂y
\pdv[2]{f}{x}           % ∂²f/∂x²

% Without physics package:
\frac{df}{dx}, \quad \frac{d^2 f}{dx^2}
\frac{\partial f}{\partial x}

% Integrals
\int_a^b f(x)\,dx
\iint_D f(x,y)\,dA
\iiint_V f\,dV
\oint_C \mathbf{F}\cdot d\mathbf{r}   % line integral

% Gradient, divergence, curl (physics package)
\grad f         % ∇f
\div \mathbf{F} % ∇·F
\curl \mathbf{F}% ∇×F
\laplacian f    % ∇²f

% Functional derivative
\frac{\delta F}{\delta \phi(x)}   % functional derivative

% Exterior calculus
d\omega, \quad \omega \wedge \eta, \quad \iota_X \omega
% (use regular math; no standard package required)

% Lie derivative
\mathcal{L}_X \omega   % Lie derivative along X
```

---

## 4. Linear Algebra

```latex
% Matrices
\begin{pmatrix} a & b \\ c & d \end{pmatrix}   % parentheses
\begin{bmatrix} a & b \\ c & d \end{bmatrix}   % brackets
\begin{vmatrix} a & b \\ c & d \end{vmatrix}   % determinant bars
\begin{Vmatrix} a & b \\ c & d \end{Vmatrix}   % double bars

% Augmented matrix
\left[\begin{array}{cc|c}
  1 & 2 & 3 \\
  4 & 5 & 6
\end{array}\right]

% Vectors (bold)
\mathbf{v}, \quad \vec{v}, \quad \bm{v}   % bm package

% Transpose, inverse
A^T, \quad A^{-1}, \quad A^\dagger  % Hermitian conjugate

% Inner products (physics package)
\braket{u}{v}       % ⟨u|v⟩
\mel{u}{A}{v}       % ⟨u|A|v⟩
\ev{A}{\psi}        % ⟨ψ|A|ψ⟩
\norm{\mathbf{v}}   % ‖v‖
```

---

## 5. Probability and Statistics

```latex
\Pr(X = k)
\mathbb{E}[X]           % expectation
\mathrm{Var}(X)
\mathrm{Cov}(X, Y)

% Distributions
X \sim \mathcal{N}(\mu, \sigma^2)
X \sim \mathrm{Bin}(n, p)
X \sim \mathrm{Poisson}(\lambda)
X \sim \mathrm{Uniform}(a, b)

% Combinatorics
\binom{n}{k} = \frac{n!}{k!(n-k)!}

% Conditional probability
P(A \mid B) = \frac{P(A \cap B)}{P(B)}
```

---

## 6. Quantum Mechanics (Dirac Notation) — `physics` package

```latex
\ket{\psi}              % |ψ⟩
\bra{\phi}              % ⟨φ|
\braket{\phi}{\psi}     % ⟨φ|ψ⟩
\mel{\phi}{H}{\psi}     % ⟨φ|H|ψ⟩
\ketbra{\psi}{\phi}     % |ψ⟩⟨φ| (outer product)
\comm{A}{B}             % [A,B] commutator
\anticomm{A}{B}         % {A,B} anticommutator
\expval{H}{\psi}        % ⟨ψ|H|ψ⟩
```

---

## 7. Tensors

```latex
% Einstein summation convention
T^{\mu\nu} = g^{\mu\alpha} g^{\nu\beta} T_{\alpha\beta}

% Covariant derivative
\nabla_\mu A^\nu = \partial_\mu A^\nu + \Gamma^\nu_{\mu\lambda} A^\lambda

% Use tensor package for cleaner notation
\usepackage{tensor}
\tensor{T}{^\mu_\nu}    % mixed tensor

% Christoffel symbols
\Gamma^\lambda_{\mu\nu}

% Riemann tensor
R^\rho{}_{\sigma\mu\nu}
```

---

## 8. Number Sets

```latex
\mathbb{N}   % natural numbers
\mathbb{Z}   % integers
\mathbb{Q}   % rationals
\mathbb{R}   % reals
\mathbb{C}   % complex
\mathbb{F}   % field
\mathbb{R}^n % n-dimensional reals
\mathbb{H}   % quaternions
\mathbb{P}   % projective space / probability space
```

---

## 9. Commonly Needed Symbols

```latex
% Greek uppercase
\Gamma \Delta \Theta \Lambda \Xi \Pi \Sigma \Upsilon \Phi \Psi \Omega

% Greek lowercase
\alpha \beta \gamma \delta \epsilon \varepsilon \zeta \eta \theta \vartheta
\iota \kappa \lambda \mu \nu \xi \pi \varpi \rho \varrho \sigma \varsigma
\tau \upsilon \phi \varphi \chi \psi \omega

% Arrows
\to, \leftarrow, \leftrightarrow, \Rightarrow, \Leftrightarrow, \implies, \iff
\xrightarrow{\text{label}}   % arrow with label above

% Relations
\approx, \sim, \simeq, \equiv, \propto, \ll, \gg, \leq, \geq, \neq

% Ellipses
\ldots  % lower: a, b, c,...
\cdots  % centered: a + b + \cdots + n
\vdots  % vertical
\ddots  % diagonal (matrices)

% Set notation
\in, \notin, \subset, \subseteq, \supset, \supseteq
\cup, \cap, \setminus, \emptyset, \varnothing
\forall, \exists, \nexists

% Logic
\land, \lor, \lnot, \oplus   % and, or, not, xor
\vdash, \models               % syntactic/semantic consequence

% Miscellaneous
\infty, \partial, \nabla, \hbar, \ell
\dagger, \ddagger, \star, \bullet, \circ
```

---

## 10. Spacing in Math Mode

Fine-grained spacing is critical for readable mathematics.

```latex
% Positive spacing (increasingly wide)
a\,b          % thin space    (3/18 em)
a\:b          % medium space  (4/18 em)  — use \medspace for clarity
a\;b          % thick space   (5/18 em)  — use \thickspace for clarity
a\quad b      % 1 em
a\qquad b     % 2 em

% Negative spacing (pull closer)
a\!b          % negative thin space (-3/18 em)

% Phantom to align (takes space but is invisible)
\phantom{x}   % same width and height as "x", but invisible
\hphantom{x}  % same width only
\vphantom{x}  % same height only (useful for consistent bracket sizes)

% Common uses
dx            % ← wrong: looks crowded
\,dx          % ← correct: thin space before differential
f(x)\,dx
\int_0^1 f(x)\,dx   % thin space before dx

% Spacing after operators (amsmath handles most automatically)
% Manual override in align: use \quad or \qquad between equation and condition
\begin{align}
  f(x) &= x^2,       & x &\geq 0 \\
  f(x) &= -x,        & x &< 0
\end{align}

% Correct spacing for "such that" in set notation
\{ x \in \mathbb{R} \mid x > 0 \}    % \mid gives correct spacing
\{ x \in \mathbb{R} : x > 0 \}       % : also common
```

---

## 11. Display Style vs Text Style

```latex
% Force display-style fractions/limits in inline math
$\displaystyle\frac{a}{b}$           % large fraction inline
$\displaystyle\sum_{k=1}^{n} k$      % limits below/above inline

% Force text-style (compact) in display math
\[ \textstyle\sum_{k=1}^{n} k \]     % limits beside sum

% Scriptstyle and scriptscriptstyle (for sub-superscripts within math)
$A_{\scriptscriptstyle ij}$          % smaller index
$f(x) = \scriptstyle\sum k$          % extremely rare

% Common pattern: full-size fraction in a subsuperscript
e^{\displaystyle -\frac{x^2}{2}}    % display fraction in exponent (rare, usually \exp)

% Display style in equation number aligned blocks
% — amsmath handles this automatically; \displaystyle usually not needed in align
```

---

## 12. Advanced amsmath Environments

```latex
% gather: multiple centered equations, each numbered
\begin{gather}
  a^2 + b^2 = c^2 \label{eq:pyth} \\
  e = mc^2         \label{eq:einstein}
\end{gather}

% multline: one long equation split across lines
\begin{multline}
  \int_0^\infty \int_0^\infty f(x, y)\,dx\,dy \\
    = \lim_{n\to\infty} \sum_{i=1}^{n}\sum_{j=1}^{n}
      f(x_i, y_j)\,\Delta x\,\Delta y
\end{multline}

% flalign: like align but flush to margins
\begin{flalign}
  f(x) &= x^2 + 1  & g(x) &= \sin x
\end{flalign}

% split: splits a single equation inside equation (one number total)
\begin{equation}
\begin{split}
  (a+b)^3 &= (a+b)(a+b)^2 \\
           &= (a+b)(a^2 + 2ab + b^2) \\
           &= a^3 + 3a^2b + 3ab^2 + b^3
\end{split}
\end{equation}

% subequations: group with one parent label + sub-labels
\begin{subequations}\label{eq:maxwell}
  \begin{align}
    \nabla \cdot \mathbf{E}  &= \rho/\varepsilon_0 \label{eq:gauss_e}\\
    \nabla \cdot \mathbf{B}  &= 0                  \label{eq:gauss_b}\\
    \nabla \times \mathbf{E} &= -\partial_t\mathbf{B} \label{eq:faraday}\\
    \nabla \times \mathbf{B} &= \mu_0\mathbf{J} + \mu_0\varepsilon_0\partial_t\mathbf{E}
                                                   \label{eq:ampere}
  \end{align}
\end{subequations}
% \cref{eq:maxwell} → "(3.1)",   \cref{eq:gauss_e} → "(3.1a)"

% intertext: insert text between aligned lines without breaking alignment
\begin{align}
  \nabla^2 \phi &= -\frac{\rho}{\varepsilon_0} \\
  \intertext{Applying Green's theorem to the volume $V$:}
  \oint_{\partial V} \nabla\phi \cdot d\mathbf{A}
    &= -\frac{Q_\text{enc}}{\varepsilon_0}
\end{align}

% alignat: manual column spacing for very wide alignment
\begin{alignat}{3}
  f(x) &= x^2    &\quad& \text{for } x \geq 0 \\
  f(x) &= -x     &\quad& \text{for } x < 0
\end{alignat}
```

---

## 13. Mathematical Fonts

```latex
% Calligraphic (uppercase only)
\mathcal{A B C D E F G H I J K L M N O P Q R S T U V W X Y Z}
% → 𝒜 ℬ 𝒞 𝒟 ℰ ℱ 𝒢 ℋ ℐ 𝒥 𝒦 ℒ ℳ 𝒩 𝒪 𝒫 𝒬 ℛ 𝒮 𝒯 𝒰 𝒱 𝒲 𝒳 𝒴 𝒵

% Blackboard bold (for number sets)
\mathbb{N Z Q R C F H P}

% Fraktur (Lie algebras, ideals)
\mathfrak{g h k l su sp so}
% → 𝔤 𝔥 𝔨 𝔩 𝔰𝔲 𝔰𝔭 𝔰𝔬

% Bold (for vectors, matrices)
\mathbf{v F A}              % upright bold
\boldsymbol{\alpha \beta}   % bold Greek (requires amsmath or bm pkg)
\bm{\alpha \beta v}         % bold anything (bm package, preferred)

% Roman (upright, for operators and physical quantities)
\mathrm{d}x        % upright d in differential
\mathrm{e}         % Euler's number (optional style)
\mathrm{i}         % imaginary unit (alternative to i)
T_{\mathrm{eff}}   % subscript labels always \mathrm

% Italic (default math mode — for variables)
x, y, f, g   % automatically italic in math

% Sans-serif (rare, occasionally for categories/matrices)
\mathsf{A B C}

% Typewriter (for code identifiers in math)
\mathtt{myFunction}

% Script (calligraphic alternative with mathrsfs or eucal)
\usepackage{mathrsfs}
\mathscr{L H F}    % Lagrangian, Hamiltonian, free energy (script style)

% Double-struck for operators (unicode-math / XeLaTeX)
\mathbb{1}          % identity operator (double-struck 1)
```

---

## 14. Accents and Decorations

```latex
% Single-character accents (work in both text and math with care)
\hat{x}       % x̂   — hat (Fourier transform, unit vector, operator)
\tilde{x}     % x̃   — tilde (Fourier pair, approx values)
\bar{x}       % x̄   — bar (mean, complex conjugate)
\vec{x}       % x⃗   — arrow (Euclidean vector, native LaTeX style)
\dot{x}       % ẋ   — dot (time derivative)
\ddot{x}      % ẍ   — double dot
\check{x}     % x̌   — inverted hat (inverse Fourier)
\acute{x}     % x́
\grave{x}     % x̀
\breve{x}     % x̆
\mathring{x}  % x̊   — ring accent

% Wide accents (for expressions wider than one character)
\widehat{fg}        % wide hat
\widetilde{abc}     % wide tilde
\overline{x + y}    % overline / complex conjugate
\underline{x + y}   % underline

% Horizontal braces (for annotations)
\overbrace{a + b + c}^{n \text{ terms}}
\underbrace{a + b + c}_{= S}

% Arrows over expressions
\overrightarrow{AB}     % vector from A to B
\overleftarrow{AB}
\overleftrightarrow{AB}
\xrightarrow{f}         % arrow with label above (amsmath)
\xrightarrow[below]{above}

% Cancellation (cancel package)
\usepackage{cancel}
\cancel{x}             % diagonal strikethrough
\bcancel{x}            % reverse diagonal
\xcancel{x}            % X strikeout
\cancelto{0}{x}        % arrow to value
```

---

## 15. Complex Numbers and Fields

```latex
% Real and imaginary parts
\Re(z), \quad \Im(z)    % built-in (but look like roman R and I)

% Better with physics package or custom operators:
\DeclareMathOperator{\Real}{Re}
\DeclareMathOperator{\Imag}{Im}
\Real(z), \quad \Imag(z)

% Complex conjugate (several conventions)
z^*                     % star (physics convention)
\bar{z}                 % overline (pure math convention)
\overline{z}            % overline (longer expressions)
\overline{a + bi}

% Modulus and argument
|z|, \quad \arg(z), \quad \text{Arg}(z)   % principal argument

% Polar form
z = r e^{i\theta} = r(\cos\theta + i\sin\theta)

% Common identities
e^{i\pi} + 1 = 0        % Euler's identity
e^{i\theta} = \cos\theta + i\sin\theta   % Euler's formula

% Complex conjugate transpose (Hermitian adjoint)
A^\dagger = \overline{A}^T = \bar{A}^T
```

---

## 16. Bracket Sizing

```latex
% Automatic sizing with \left and \right (match any delimiter pair)
\left( \frac{a}{b} \right)      % auto-sized parentheses
\left[ \frac{a}{b} \right]      % auto-sized brackets
\left\{ \frac{a}{b} \right\}    % auto-sized braces
\left| x \right|                 % auto-sized absolute value
\left\| \mathbf{v} \right\|     % auto-sized norm

% Invisible delimiter (open on one side)
\left. \frac{df}{dx} \right|_{x=0}   % right bar only

% Manual sizing (4 sizes, smallest to largest)
\bigl( \quad \Bigl( \quad \biggl( \quad \Biggl(
\bigr) \quad \Bigr) \quad \biggr) \quad \Biggr)

% Use manual sizing when \left/\right adds too much space:
\bigl( f(x) \bigr)^2     % correct: no extra space before ^
\left( f(x) \right)^2    % risky: can add unwanted space

% mleftright package: fixes spacing issues with \left\right
\usepackage{mleftright}
\mleft( \frac{a}{b} \mright)   % same as \left\right but better spacing

% Common bracket pairs
\langle x, y \rangle         % angle brackets (inner product)
\lfloor x \rfloor            % floor
\lceil  x \rceil             % ceiling
\llbracket x \rrbracket      % double square (stmaryrd package, for denotations)

% Sized angle brackets
\langle \psi | H | \psi \rangle
\bigl\langle \psi \bigl| H \bigr| \psi \bigr\rangle   % manual sizing
```
