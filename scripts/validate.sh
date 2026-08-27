#!/usr/bin/env bash
set -euo pipefail

export BOOK_PROJECT_NAME="nand2gpu"
bash book-template/scripts/validate.sh
python3 scripts/check-figure-invariants.py
