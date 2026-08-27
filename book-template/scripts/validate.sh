#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$(basename "$(dirname "$SCRIPT_DIR")")" == "book-template" ]]; then
  ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
else
  ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
fi

PROJECT_NAME="${BOOK_PROJECT_NAME:-$(basename "$ROOT_DIR")}"

cd "$ROOT_DIR"

echo "[$PROJECT_NAME] Validating repository..."

required_files=(
  "main.tex"
  "preamble.tex"
  "references.bib"
  "scripts/build.sh"
  "book-template/latex/common-preamble.tex"
)

for file in "${required_files[@]}"; do
  if [[ ! -e "$file" ]]; then
    echo "[$PROJECT_NAME] Missing required file: $file" >&2
    exit 1
  fi
done

if [[ ! -x scripts/build.sh ]]; then
  echo "[$PROJECT_NAME] scripts/build.sh is not executable." >&2
  exit 1
fi

if ! git diff --check; then
  echo "[$PROJECT_NAME] Whitespace errors detected." >&2
  exit 1
fi

if find . \
  -path './.git' -prune -o \
  -path './book-template/.git' -prune -o \
  -path './.venv' -prune -o \
  -path './.build' -prune -o \
  -type f \( -name '*.pyc' -o -name '*.pyo' \) -print |
  grep -q .; then
  echo "[$PROJECT_NAME] Python bytecode files are tracked or present." >&2
  exit 1
fi

if find . \
  -path './.git' -prune -o \
  -path './book-template/.git' -prune -o \
  -path './.venv' -prune -o \
  -path './.build' -prune -o \
  -type d -name '__pycache__' -print |
  grep -q .; then
  echo "[$PROJECT_NAME] __pycache__ directories are present." >&2
  exit 1
fi

if [[ -L .vscode/settings.json ]]; then
  if [[ ! -e .vscode/settings.json ]]; then
    echo "[$PROJECT_NAME] Broken VS Code settings symlink." >&2
    exit 1
  fi
fi

python3 -m json.tool .devcontainer/devcontainer.json >/dev/null

if [[ -e .vscode/settings.json ]]; then
  python3 -m json.tool .vscode/settings.json >/dev/null
fi

if [[ -e .vscode/extensions.json ]]; then
  python3 -m json.tool .vscode/extensions.json >/dev/null
fi

echo "[$PROJECT_NAME] Validation passed."
