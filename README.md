# algorithmlite Package

**LaTeX: A lightweight algorithm float without the float package**

The algorithm package defines the `algorithm` float with `\newfloat` of the float package, and the float package redefines `\caption` as a whole, for every float of the document.

The algorithmlite package defines the environments `algorithm` and `algorithm*` in the same way as the standard classes define `figure` and `table`, with `\@float` and `\@dblfloat` of the LaTeX kernel: the captions of algorithms are set by the `\@makecaption` of the class, as those of figures and tables. The float package is not loaded. If no other package gives the placement `[H]`, algorithmlite gives a minimal one.

The content of an algorithm is up to you: load algorithmic, algpseudocode (algorithmicx) or any other package for it.

* **Supported formats/engines:** pdfLaTeX, XeLaTeX, LuaLaTeX (with or without LuaTeX-ja), pLaTeX, upLaTeX (+ dvipdfmx)

## Files

| File | Description |
|---|---|
| `algorithmlite.sty` | The package |
| `algorithmlite.tex` / `.pdf` | Documentation |
| `test-*.tex` | Test suite (see below) |

## Requirements

* LaTeX2e 2020-10-01 or later (package hooks)
* Tested with TeX Live 2026 (LaTeX2e 2026-06-01)

## Installation

Copy `algorithmlite.sty` to your local TeX tree:
`$TEXMF/tex/latex/algorithmlite/`

## Usage

```latex
\usepackage{algorithmlite}
\usepackage{algorithmic}   % or algpseudocode, ...

\begin{algorithm}[tbp]     % or [H]
\caption{Euclid's algorithm}\label{alg:euclid}
\begin{algorithmic}[1]
  \WHILE{$b \neq 0$}
    \STATE $(a, b) \leftarrow (b, a \bmod b)$
  \ENDWHILE
  \RETURN $a$
\end{algorithmic}
\end{algorithm}

\listofalgorithms
```

The package has no options.

## What is defined

* `algorithm`, `algorithm*`: the float and its two-column variant, as `figure` and `figure*`. The default placement is `tbp`; the list file is `.loa`.
* The counter `algorithm`: with `\chapter`, it is reset at every chapter and `\thealgorithm` is `<chapter>.<n>` (`<n>` before the first chapter), as `\thefigure` of the book classes; otherwise `<n>`.
* `\algorithmname`: `Algorithm`; `アルゴリズム` with pTeX/upTeX and LuaTeX-ja (also when LuaTeX-ja is loaded after algorithmlite), unless the class option `english` of jsclasses or the LuaTeX-ja classes is given.
* `\listalgorithmname`: `List of Algorithms`; `アルゴリズム目次` in Japanese.
* `\fnum@algorithm`: `\algorithmname<sep>\thealgorithm`, where `<sep>` is taken from `\fnum@figure` of the class (`\nobreakspace` in the standard classes, `\nobreak` in jsclasses and the LuaTeX-ja classes, `~` in jarticle/ujarticle, nothing in jlreq).
* `\listofalgorithms`: `\listoffigures` of the class with `\listalgorithmname` and the `.loa` file, so that it looks like the list of figures. The entries are set with `\l@algorithm` = `\l@figure` of the class.
* The float type `\ftype@algorithm`: a bit, as `\ftype@figure` = 1 and `\ftype@table` = 2. It is the next free bit, 4 in most documents. The counter of the float package (also used by floatrow and newfloat) and that of memoir are shared, so that the float types stay distinct: if the float package is loaded later (e.g. by minted), its counter is moved past 4.
* `[H]`: at `\begin{document}`, if neither the float package nor the floatrow package is loaded, a minimal `[H]` is defined (the float is put in a box "here", with `\intextsep` above and below it). As with the float package, it works for every float type. If the float package is loaded, its `[H]` is used.

## Errors and limitations

* The algorithm and algorithm2e packages cannot be used with algorithmlite, before or after it (error).
* algorithmlite does not redefine an existing `algorithm` environment or counter (error).
* `algorithm*[H]` in two-column mode is not supported (as with the float package).
* Vertical writing (tate) is outside the scope of this version.

## Testing

`make test` compiles every test twice with pdfLaTeX, XeLaTeX, LuaLaTeX, pLaTeX and upLaTeX (+ dvipdfmx), and checks the log:

* `ALGL-RESULT OK`: the numbers, names, `\fnum@algorithm`, float types and `\ref` are as expected, an `[H]` float stays in the text flow, a `[p]` float goes to a later page, and `\listofalgorithms` has every entry (see `test-common.tex`).
* No LaTeX or package warning other than "Label(s) may have changed".
* `test-hyperref`: no warning on a duplicate or missing destination in the log or in the output of the engine and (x)dvipdfmx.
* `test-errors`: the expected error message.

| Test | Engines | What it covers |
|---|---|---|
| `test-basic.tex` | pdflatex, xelatex, lualatex (article, book, article + luatexja, ltjsarticle, ltjsbook, ltjsarticle[english], jlreq[book]), platex (jarticle, jsbook, jsbook[english]), uplatex (ujarticle, ujbook, jlreq) | numbering with and without chapters, names, `\fnum@algorithm`, `[H]`, `[p]`, `figure[H]`, `algorithm*`, `\ref`, `\listofalgorithms` |
| `test-hyperref.tex` | pdflatex, xelatex (book), lualatex (ltjsbook), platex (jsbook), uplatex (ujbook) | `test-basic.tex` with hyperref |
| `test-twocolumn.tex` | pdflatex (article), uplatex (ujarticle) | `algorithm*` and `[H]` in two-column mode |
| `test-compat.tex` | pdflatex | float before/after, newfloat, caption, memoir |
| `test-errors.tex` | pdflatex | the error messages |

`test-common.tex` holds the helpers shared by the tests.

## Repository

* <https://github.com/munepi/algorithmlite>
* Bug reports: <https://github.com/munepi/algorithmlite/issues>

## License

This package is licensed under the conditions of the [LaTeX Project Public License](https://www.latex-project.org/lppl.txt), either version 1.3c of this license or any later version.

Copyright (c) 2026 Munehiro Yamamoto
