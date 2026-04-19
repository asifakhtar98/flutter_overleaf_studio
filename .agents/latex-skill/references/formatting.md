# Formatting Reference — Lengths, Paragraphs, Alignment, Columns

## Table of Contents
1. LaTeX Length Units
2. Predefined Lengths
3. Paragraph Formatting
4. Line Spacing
5. Text Alignment
6. Line Breaks and Blank Spaces
7. Page Breaking Control
8. Multiple Columns
9. Footnotes and Endnotes
10. Margin Notes
11. Counters
12. Boxes and Rules

---

## 1. LaTeX Length Units

| Unit | Meaning |
|------|---------|
| `pt` | Point (1/72.27 inch) — TeX's native unit |
| `mm` | Millimetre |
| `cm` | Centimetre |
| `in` | Inch |
| `em` | Approximately width of 'M' in current font |
| `ex` | Approximately height of 'x' in current font |
| `bp` | Big point (1/72 inch — PDF/PostScript unit) |
| `pc` | Pica (12 pt) |
| `sp` | Scaled point (1/65536 pt — smallest TeX unit) |
| `mu` | Math unit (1/18 em, used in math spacing) |

---

## 2. Predefined Lengths

```latex
% Page and text dimensions
\textwidth          % width of the text area
\textheight         % height of the text area
\linewidth          % current line width (inside columns: narrower)
\columnwidth        % width of current column in multicol
\paperwidth         % full paper width
\paperheight        % full paper height
\marginparwidth     % width of margin note area

% Spacing
\parindent          % paragraph indent (default ~1.5em)
\parskip            % extra space between paragraphs (default 0pt)
\baselineskip       % baseline-to-baseline distance
\baselinestretch    % multiplier for \baselineskip (use setspace instead)
\topmargin          % controlled by geometry package
\headheight         % height of running headers
```

### Setting Lengths
```latex
\setlength{\parindent}{1.5em}        % fixed value
\setlength{\parskip}{0.5ex plus 0.2ex minus 0.1ex}  % flexible (rubber length)
\addtolength{\textwidth}{1cm}        % add to existing value
\settowidth{\mylen}{Some text}       % set to width of text
\settoheight{\myht}{Tg}              % set to height of text
```

---

## 3. Paragraph Formatting

```latex
% Paragraph indent and spacing
\setlength{\parindent}{1.5em}   % indent first line of paragraphs
\setlength{\parskip}{0.5ex}     % add space between paragraphs

% No indent for the current paragraph only
\noindent This paragraph has no indent.

% Force indent even when suppressed
\indent This paragraph is indented.

% Widow and orphan control
\widowpenalty=10000    % avoid widow lines (last line alone on next page)
\clubpenalty=10000     % avoid orphan lines (first line alone on prev page)
\raggedbottom          % allow uneven page bottoms (preferred for multi-column notes)
\flushbottom           % force even page bottoms (default in two-side mode)
```

---

## 4. Line Spacing

```latex
\usepackage{setspace}

\singlespacing          % 1× (default)
\onehalfspacing         % 1.5×
\doublespacing          % 2×
\setstretch{1.15}       % custom multiplier

% Local scope
\begin{spacing}{1.3}
  This block uses 1.3× line spacing.
\end{spacing}

% Or use \linespread (TeX primitive, less precise)
\linespread{1.2}   % before \begin{document}
```

---

## 5. Text Alignment

```latex
% Environments
\begin{center}      Content centered \end{center}
\begin{flushleft}   Left aligned     \end{flushleft}
\begin{flushright}  Right aligned    \end{flushright}

% Inline commands (global, use locally in groups)
{\centering Text centered here.}
{\raggedright Left-aligned. No hyphenation.}
{\raggedleft  Right-aligned.}
```

### Better Ragged with `ragged2e`
```latex
\usepackage{ragged2e}
% Provides improved versions:
\RaggedRight   % better than \raggedright (allows some hyphenation)
\RaggedLeft
\Centering
\justifying    % return to justified (default)
```

---

## 6. Line Breaks and Blank Spaces

### Horizontal Space
```latex
\hspace{1cm}          % fixed horizontal space
\hspace*{1cm}         % non-breakable even at line start
\hfill                % fill remaining horizontal space
\quad                 % 1em space
\qquad                % 2em space
\,                    % thin space (3/18 em)
~                     % non-breaking space (tie)
```

### Vertical Space
```latex
\vspace{1cm}          % flexible vertical space
\vspace*{1cm}         % also works at top of page
\vfill                % fill remaining vertical space
\smallskip            % small (3pt plus 1pt minus 1pt)
\medskip              % medium (6pt plus 2pt minus 2pt)
\bigskip              % large (12pt plus 4pt minus 4pt)
```

### Line Breaks
```latex
\\                    % line break (in text/tables/equations)
\\[6pt]               % line break with extra vertical space
\newline              % same as \\ in text mode
\linebreak[2]         % suggest (not force) a line break at this point
\nolinebreak          % prevent a line break here
```

### Phrase Breaks and Hyphenation
```latex
\- % discretionary hyphen — only hyphenates here if needed
\mbox{un-breakable}   % prevent line break inside
\allowbreak           % allow a line break at this point
```

---

## 7. Page Breaking Control

```latex
\newpage              % start a new page (column in multicol)
\clearpage            % flush all pending floats, then new page
\cleardoublepage      % same but ensures next right-hand page (two-side)
\pagebreak            % suggest a page break
\pagebreak[4]         % force a page break (0=suggestion, 4=force)
\nopagebreak          % prevent a page break here
\samepage             % discourage breaks within this scope

% From needspace package — ensure N lines fit before breaking
\usepackage{needspace}
\needspace{4\baselineskip}   % if <4 lines remain, break page
```

---

## 8. Multiple Columns

```latex
\usepackage{multicol}

% Document-wide two columns
\documentclass[twocolumn]{article}

% Local multi-column block
\begin{multicols}{2}
  Text flows across two balanced columns automatically.
  Equations and figures can be placed normally within columns.
\end{multicols}

% Three columns with a rule between them
\begin{multicols}{3}[\section*{Quick Reference}]  % optional spanning header
  \columnsep=20pt
  \columnseprule=0.4pt   % visible divider rule
  Content\ldots
\end{multicols}

% Forcing a column break
\columnbreak
```

> **Note**: Floats (`figure`, `table`) cannot span columns in `multicols`. Use `figure*` and
> `table*` in `twocolumn` mode for spanning floats.

---

## 9. Footnotes and Endnotes

```latex
% Simple footnote
This is a claim.\footnote{Supporting evidence for the claim.}

% Custom symbol
\footnote[\dag]{Special note with dagger symbol.}

% Footnote in a table or environment where \footnote fails
Text\footnotemark[1]
...
\footnotetext[1]{The actual footnote text goes here.}

% Disabling footnote indent
\setlength{\footnotesep}{8pt}         % space between footnotes
\renewcommand{\footnoterule}{\hrule width 2in \kern 2pt}  % custom rule

% Endnotes (deferred to end of document)
\usepackage{endnotes}
\endnote{This will appear at the end.}
\theendnotes   % print all endnotes here
```

---

## 10. Margin Notes

```latex
% Standard LaTeX margin note (auto left/right by page side)
\marginpar{Note in the margin}
\marginpar[\textit{Left page note}]{Right page note}

% marginnote package (more control, works in floats/minipage)
\usepackage{marginnote}
\marginnote{This note is at this exact vertical position.}
\marginnote[-2cm]{Offset upwards by 2cm.}

% sidenotes package (Tufte-style side content)
\usepackage{sidenotes}
\sidenote{A Tufte-style sidenote with automatic numbering.}
\marginfigure{%
  \includegraphics[width=\marginparwidth]{small_fig.pdf}
  \caption{A margin figure.}
}
```

---

## 11. Counters

```latex
% Define a new counter
\newcounter{problem}[chapter]     % reset at each chapter
\newcounter{subproblem}[problem]  % reset at each problem

% Manipulate
\setcounter{problem}{5}           % jump to 5
\stepcounter{problem}             % increment by 1
\addtocounter{problem}{3}         % add 3
\refstepcounter{problem}          % increment + allow \label/\ref

% Display the counter value
\theproblem         % default representation  (1, 2, 3...)
\arabic{problem}    % arabic numerals
\roman{problem}     % i, ii, iii...
\Roman{problem}     % I, II, III...
\alph{problem}      % a, b, c...
\Alph{problem}      % A, B, C...

% Redefine representation (e.g. chapter.problem style)
\renewcommand{\theproblem}{\thechapter.\arabic{problem}}
```

---

## 12. Boxes and Rules

```latex
% Inline box (width = content)
\mbox{text}                           % no line break inside
\makebox[3cm]{centred text}           % fixed-width box
\makebox[3cm][l]{left-aligned}        % [l], [c], [r], [s]

% Framed boxes
\fbox{Framed content}
\framebox[4cm][c]{Centred in frame}

% Rules (lines)
\rule{\textwidth}{0.4pt}              % full-width horizontal rule
\rule[0.5ex]{2cm}{0.8pt}             % raised rule

% Raised/lowered boxes
\raisebox{2pt}{Raised text}
\raisebox{-3pt}[0pt][0pt]{Lowered}  % [height above][depth below]

% Fixed-height strut (invisible spacer)
\strut         % height + depth of normal line
\rule{0pt}{16pt}    % invisible 16pt tall strut
```
