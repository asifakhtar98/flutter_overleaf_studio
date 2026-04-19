# Bibliography Management Reference

## Table of Contents
1. BibLaTeX (recommended)
2. BibTeX (traditional)
3. .bib File Formats
4. Citation Commands
5. Bibliography Styles by Discipline

---

## 1. BibLaTeX (Recommended)

```latex
% Preamble
\usepackage[
  backend=biber,
  style=numeric-comp,   % or: alphabetic, authoryear, phys, nature, ieee
  sorting=none,          % or: nyt (name-year-title), ynt
  giveninits=true,
  maxbibnames=5,
]{biblatex}
\addbibresource{references.bib}

% At end of document
\printbibliography[heading=bibintoc, title={References}]

% Filtered bibliographies (e.g., separate books and articles)
\printbibliography[type=article, title={Journal Articles}]
\printbibliography[type=book, title={Books}]
```

---

## 2. Citation Commands

```latex
\cite{key}             % [1]  or  Author (2020)
\parencite{key}        % (Author, 2020) — for authoryear styles
\textcite{key}         % Author (2020) showed...
\footcite{key}         % footnote citation
\citeauthor{key}       % Author
\citeyear{key}         % 2020
\citetitle{key}        % Title of work
\citeurl{key}          % URL field

% Multiple citations
\cite{key1, key2, key3}

% Prenote/postnote
\cite[see][p.~45]{key}    % [see 1, p. 45]
\parencite[p.~12]{key}    % (Author, 2020, p. 12)
```

---

## 3. .bib Entry Types

### Journal Article
```bibtex
@article{einstein1905,
  author  = {Einstein, Albert},
  title   = {Zur Elektrodynamik bewegter K{\"o}rper},
  journal = {Annalen der Physik},
  year    = {1905},
  volume  = {322},
  number  = {10},
  pages   = {891--921},
  doi     = {10.1002/andp.19053221004},
}
```

### Book
```bibtex
@book{griffiths2017,
  author    = {Griffiths, David J.},
  title     = {Introduction to Electrodynamics},
  edition   = {4},
  publisher = {Cambridge University Press},
  year      = {2017},
  isbn      = {978-1-108-42041-9},
}
```

### Book Chapter
```bibtex
@incollection{author2020,
  author    = {Smith, John},
  title     = {Chapter Title},
  booktitle = {Handbook of Physics},
  editor    = {Jones, Mary},
  publisher = {Springer},
  year      = {2020},
  pages     = {123--145},
}
```

### Conference Paper
```bibtex
@inproceedings{author2021,
  author    = {Doe, Jane and Roe, Richard},
  title     = {A New Method for X},
  booktitle = {Proceedings of the International Conference on Y},
  year      = {2021},
  pages     = {55--62},
  doi       = {10.1234/example},
}
```

### Online / Website
```bibtex
@online{overleaf2024,
  author  = {{Overleaf}},
  title   = {Learn LaTeX in 30 minutes},
  year    = {2024},
  url     = {https://www.overleaf.com/learn/latex/Learn_LaTeX_in_30_minutes},
  urldate = {2024-11-01},
}
```

### Thesis
```bibtex
@thesis{student2023,
  author      = {Student, Alice},
  title       = {Novel Approaches to Quantum Computing},
  institution = {MIT},
  year        = {2023},
  type        = {PhD thesis},
}
```

---

## 4. Bibliography Styles by Discipline

| Discipline | Recommended Style | Package Option |
|-----------|------------------|----------------|
| Physics | APS / AIP | `style=phys` |
| Mathematics | AMS | `style=alphabetic` |
| Chemistry | ACS | `style=chem-acs` |
| Biology / Medicine | Nature, Vancouver | `style=nature` |
| Engineering / IEEE | IEEE | `style=ieee` |
| General STEM | Numeric compact | `style=numeric-comp` |
| Social Sciences | APA, Chicago | `style=apa` or `style=chicago-authordate` |

---

## 5. Cross-referencing with cleveref

```latex
\usepackage{cleveref}  % load after hyperref

\cref{eq:maxwell}      % Equation 3.1
\cref{fig:diagram}     % Figure 2.5
\cref{tab:constants}   % Table 1.3
\cref{thm:ftc}         % Theorem 4.2
\cref{sec:intro}       % Section 1.1

% Range
\cref{eq:1,eq:2,eq:3}  % Equations 3.1 to 3.3

% Capitalized (start of sentence)
\Cref{fig:diagram}     % Figure 2.5
```
