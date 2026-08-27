#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
MAIN_TEX="$ROOT_DIR/main.tex"
FINAL_PDF="$ROOT_DIR/main.pdf"
KEEP_AUX="${BOOK_KEEP_AUX:-0}"

cd "$ROOT_DIR"

clean_aux_files() {
  # 저장소 내부를 재귀적으로 정리하되, Git 객체와 pack 인덱스가 있는
  # .git 내부의 파일은 정리 대상에서 명시적으로 제외한다.
  find "$ROOT_DIR" \
    -type f \
    ! -path "$ROOT_DIR/.git/*" \
    \( -name '*.aux' \
       -o -name '*.bbl' \
       -o -name '*.bcf' \
       -o -name '*.blg' \
       -o -name '*.fdb_latexmk' \
       -o -name '*.fls' \
       -o -name '*.idx' \
       -o -name '*.ilg' \
       -o -name '*.ind' \
       -o -name '*.lof' \
       -o -name '*.log' \
       -o -name '*.lot' \
       -o -name '*.out' \
       -o -name '*.run.xml' \
       -o -name '*.toc' \
       -o -name '*.xdv' \) \
    -delete
}

rm -rf "$ROOT_DIR/.build"
clean_aux_files

PROJECT_NAME="${BOOK_PROJECT_NAME:-$(basename "$ROOT_DIR")}"
echo "[$PROJECT_NAME] Building main.pdf with XeLaTeX..."

if latexmk \
  -xelatex \
  -synctex=1 \
  -interaction=nonstopmode \
  -file-line-error \
  -halt-on-error \
  "$MAIN_TEX"; then

  test -s "$FINAL_PDF"

  if [[ "$KEEP_AUX" == "1" ]]; then
    echo "[$PROJECT_NAME] Created main.pdf and retained auxiliary files for diagnostics."
  else
    clean_aux_files
    echo "[$PROJECT_NAME] Created main.pdf and removed auxiliary files."
  fi
else
  echo "[$PROJECT_NAME] Build failed. Diagnostic files remain in the project folder." >&2
  exit 1
fi
