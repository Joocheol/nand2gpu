#!/usr/bin/env bash
set -euo pipefail

export BOOK_PROJECT_NAME="nand2gpu"
exec bash book-template/scripts/doctor.sh
