#!/usr/bin/env bash
set -euo pipefail

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "Not inside a Git repository." >&2
  exit 1
fi

ROOT_DIR="$(git rev-parse --show-toplevel)"
PROJECT_NAME="${BOOK_PROJECT_NAME:-$(basename "$ROOT_DIR")}"
cd "$ROOT_DIR"

score=100
warnings=0

warn() {
  warnings=$((warnings + 1))
  score=$((score - 5))
  printf 'WARN: %s\n' "$1"
}

pass() {
  printf 'PASS: %s\n' "$1"
}

echo "[$PROJECT_NAME] Book doctor"
echo

if bash scripts/validate.sh; then
  pass "shared repository validation"
else
  warn "shared repository validation failed"
fi

echo "[$PROJECT_NAME] Running diagnostic build..."
if BOOK_KEEP_AUX=1 bash scripts/build.sh; then
  pass "diagnostic PDF build"
else
  warn "diagnostic PDF build failed"
fi

if [[ -s main.pdf ]]; then
  pass "main.pdf exists"
else
  warn "main.pdf is missing or empty"
fi

if [[ -f main.log ]]; then
  if grep -Eq 'LaTeX Warning: There were undefined references|undefined citations|Citation .* undefined' main.log; then
    warn "undefined references or citations are present in main.log"
  else
    pass "no undefined reference warning found in main.log"
  fi

  if grep -Eq 'Label .* multiply defined|multiply-defined labels' main.log; then
    warn "multiply defined labels are present"
  else
    pass "no multiply defined label warning found"
  fi

  overfull_count="$(grep -c 'Overfull \\hbox' main.log || true)"
  if [[ "$overfull_count" -gt 0 ]]; then
    warn "$overfull_count overfull hbox warning(s) found"
  else
    pass "no overfull hbox warning found"
  fi

  font_warning_count="$(grep -c 'LaTeX Font Warning' main.log || true)"
  if [[ "$font_warning_count" -gt 0 ]]; then
    warn "$font_warning_count font warning(s) found"
  else
    pass "no LaTeX font warning found"
  fi
else
  warn "main.log is unavailable after diagnostic build"
fi

unfinished_sources=()
for path in main.tex preamble.tex chapters figures; do
  if [[ -e "$path" ]]; then
    unfinished_sources+=("$path")
  fi
done

if [[ "${#unfinished_sources[@]}" -gt 0 ]] && \
  grep -RInE --include='*.tex' 'TODO|FIXME|집필 예정' \
    "${unfinished_sources[@]}" >/tmp/book-doctor-todos.txt 2>/dev/null; then
  warn "unfinished markers found in manuscript sources; see /tmp/book-doctor-todos.txt"
else
  : > /tmp/book-doctor-todos.txt
  pass "no TODO, FIXME, or 집필 예정 marker found in manuscript sources"
fi

duplicate_labels="$(
  find . \
    -path './.git' -prune -o \
    -path './book-template' -prune -o \
    -path './.venv' -prune -o \
    -type f -name '*.tex' -print0 2>/dev/null |
  xargs -0 grep -hoE '\\label\{[^}]+\}' 2>/dev/null |
  grep -v '#' |
  sort |
  uniq -d || true
)"
if [[ -n "$duplicate_labels" ]]; then
  warn "duplicate concrete LaTeX labels found"
  printf '%s\n' "$duplicate_labels"
else
  pass "no duplicate concrete LaTeX labels found"
fi

large_files="$(
  find . \
    -path './.git' -prune -o \
    -path './book-template' -prune -o \
    -path './.venv' -prune -o \
    -type f -size +10M -print 2>/dev/null || true
)"
if [[ -n "$large_files" ]]; then
  warn "files larger than 10 MB found"
  printf '%s\n' "$large_files"
else
  pass "no unreviewed file larger than 10 MB found"
fi

if [[ "$score" -lt 0 ]]; then
  score=0
fi

echo
echo "[$PROJECT_NAME] Doctor score: $score/100"
echo "[$PROJECT_NAME] Warnings: $warnings"
echo "[$PROJECT_NAME] Diagnostic files were retained. Run a normal build to clean them."

if [[ "$warnings" -gt 0 ]]; then
  exit 2
fi
