#!/usr/bin/env bash
set -euo pipefail

xelatex --version
latexmk -v
biber --version
python3 --version
git lfs version

smoke_dir="$(mktemp -d)"
trap 'rm -rf "$smoke_dir"' EXIT
cd "$smoke_dir"

cat > smoke.bib <<'BIB'
@book{smoke2026,
  author    = {Test, CI},
  title     = {Reproducible Book Build},
  year      = {2026},
  publisher = {OpenAI Press}
}
BIB

cat > smoke.tex <<'TEX'
\documentclass{book}
\usepackage{fontspec}
\usepackage{unicode-math}
\usepackage{kotex}
\setmainfont{STIXTwoText-Regular.otf}[
  BoldFont=STIXTwoText-Bold.otf,
  ItalicFont=STIXTwoText-Italic.otf,
  BoldItalicFont=STIXTwoText-BoldItalic.otf
]
\setmathfont{STIXTwoMath-Regular.otf}
\usepackage{amsmath}
\usepackage{booktabs}
\usepackage{tabularx}
\usepackage{tikz}
\usepackage[most]{tcolorbox}
\usepackage[backend=biber,style=authoryear]{biblatex}
\usepackage{imakeidx}
\addbibresource{smoke.bib}
\makeindex

\begin{document}
\chapter{한국어 조판 검사}
한국어 본문과 수식 $E[X]=\int x\,dF(x)$를 함께 조판한다
\parencite{smoke2026}.\index{한국어}

\begin{tcolorbox}[title={상자 검사}]
TikZ, 표, 상자와 참고문헌·찾아보기를 한 번에 검사한다.
\end{tcolorbox}

\begin{center}
\begin{tabularx}{0.7\textwidth}{lX}
\toprule
항목 & 결과 \\
\midrule
Biber & 인용과 참고문헌 \\
MakeIndex & 찾아보기 \\
\bottomrule
\end{tabularx}
\end{center}

\begin{center}
\begin{tikzpicture}
  \draw[->] (0,0) -- (2,0) node[right] {시간};
  \draw[->] (0,0) -- (0,1.5) node[above] {값};
  \draw[thick] (0,0.2) -- (1,0.8) -- (2,1.2);
\end{tikzpicture}
\end{center}

\printbibliography
\printindex
\end{document}
TEX

latexmk -xelatex -interaction=nonstopmode -halt-on-error smoke.tex

test -s smoke.pdf
test -s smoke.bbl
test -s smoke.ind
grep -Fq 'smoke2026' smoke.bbl
grep -Fq '한국어' smoke.ind
