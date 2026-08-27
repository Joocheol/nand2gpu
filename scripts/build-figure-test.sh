#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT_DIR"

mkdir -p .build
xelatex \
  -interaction=nonstopmode \
  -file-line-error \
  -halt-on-error \
  -output-directory=.build \
  tests/ch04-02-standalone.tex

xelatex \
  -interaction=nonstopmode \
  -file-line-error \
  -halt-on-error \
  -output-directory=.build \
  tests/preface-figures-standalone.tex

xelatex \
  -interaction=nonstopmode \
  -file-line-error \
  -halt-on-error \
  -output-directory=.build \
  tests/ch03-figures-standalone.tex

test -s .build/ch04-02-standalone.pdf
test -s .build/preface-figures-standalone.pdf
test -s .build/ch03-figures-standalone.pdf
echo "[nand2gpu] Created .build/ch04-02-standalone.pdf"
echo "[nand2gpu] Created .build/preface-figures-standalone.pdf"
echo "[nand2gpu] Created .build/ch03-figures-standalone.pdf"
