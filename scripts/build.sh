#!/usr/bin/env bash
set -euo pipefail

export BOOK_PROJECT_NAME="nand2gpu"
bash book-template/scripts/build.sh
bash scripts/check-pdf-text.sh main.pdf
