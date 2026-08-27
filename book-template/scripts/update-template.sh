#!/usr/bin/env bash
set -euo pipefail

REMOTE_NAME="${BOOK_TEMPLATE_REMOTE:-book-template}"
REMOTE_BRANCH="${BOOK_TEMPLATE_BRANCH:-main}"
PREFIX="${BOOK_TEMPLATE_PREFIX:-book-template}"

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "Not inside a Git repository." >&2
  exit 1
fi

ROOT_DIR="$(git rev-parse --show-toplevel)"
PROJECT_NAME="${BOOK_PROJECT_NAME:-$(basename "$ROOT_DIR")}"
cd "$ROOT_DIR"

echo "[$PROJECT_NAME] Checking working tree..."
if [[ -n "$(git status --porcelain)" ]]; then
  echo "[$PROJECT_NAME] Working tree is not clean." >&2
  echo "Commit or stash changes before updating the template." >&2
  exit 1
fi

if ! git remote get-url "$REMOTE_NAME" >/dev/null 2>&1; then
  echo "[$PROJECT_NAME] Missing Git remote: $REMOTE_NAME" >&2
  exit 1
fi

if [[ ! -d "$PREFIX" ]]; then
  echo "[$PROJECT_NAME] Missing subtree directory: $PREFIX" >&2
  exit 1
fi

echo "[$PROJECT_NAME] Fetching $REMOTE_NAME/$REMOTE_BRANCH..."
git fetch "$REMOTE_NAME" "$REMOTE_BRANCH"

echo "[$PROJECT_NAME] Pulling shared platform into $PREFIX..."
git subtree pull \
  --prefix="$PREFIX" \
  "$REMOTE_NAME" "$REMOTE_BRANCH" \
  --squash

echo "[$PROJECT_NAME] Running validation..."
bash scripts/validate.sh

echo "[$PROJECT_NAME] Building the complete PDF..."
bash scripts/build.sh

echo "[$PROJECT_NAME] Template update completed successfully."
echo "Review main.pdf, then commit and push the subtree merge."
