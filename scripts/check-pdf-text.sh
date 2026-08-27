#!/usr/bin/env bash
set -euo pipefail

PDF_PATH="${1:-main.pdf}"

if ! command -v pdftotext >/dev/null 2>&1; then
  echo "[nand2gpu] pdftotext is required for Korean PDF text validation." >&2
  exit 1
fi

test -s "$PDF_PATH"

EXTRACTED_TEXT="$(mktemp)"
trap 'rm -f "$EXTRACTED_TEXT"' EXIT

pdftotext -enc UTF-8 -layout "$PDF_PATH" "$EXTRACTED_TEXT"

python3 - "$EXTRACTED_TEXT" <<'PY'
from pathlib import Path
import re
import sys

text = Path(sys.argv[1]).read_text(encoding="utf-8")
required = (
    "진리표에서 GPU까지",
    "사람에게는 당연해 보이는 계산 하나",
    "행렬 곱셈 한 줄은",
    "1 × 5 + 2 × 7 = 19",
)

missing = [phrase for phrase in required if phrase not in text]
if missing:
    raise SystemExit(f"missing extracted Korean text: {missing}")
if "�" in text:
    raise SystemExit("Unicode replacement character found in extracted PDF text")

hangul_count = len(re.findall(r"[가-힣]", text))
if hangul_count < 500:
    raise SystemExit(f"too few extracted Hangul syllables: {hangul_count}")

print(f"[nand2gpu] Korean PDF text extraction passed: hangul={hangul_count}")
PY
