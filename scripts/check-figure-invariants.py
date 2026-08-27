#!/usr/bin/env python3
"""Check the inherited book layout and the first TikZ migration."""

from pathlib import Path
import re
import sys


ROOT = Path(__file__).resolve().parents[1]
FIGURE = ROOT / "figures" / "ch04-02-chain-vs-expanded.tex"
STYLES = ROOT / "styles" / "tikz-diagrams.tex"
COMMON_PREAMBLE = ROOT / "book-template" / "latex" / "common-preamble.tex"
STANDALONE = ROOT / "tests" / "ch04-02-standalone.tex"

EXPECTED = {
    "ripple-pg": 8,
    "ripple-carry": 8,
    "expanded-pg": 8,
    "expanded-and": 10,
    "expanded-or": 4,
}


def fail(message: str) -> None:
    print(f"[nand2gpu] {message}", file=sys.stderr)
    raise SystemExit(1)


figure = FIGURE.read_text(encoding="utf-8")
styles = STYLES.read_text(encoding="utf-8")
common_preamble = COMMON_PREAMBLE.read_text(encoding="utf-8")
standalone = STANDALONE.read_text(encoding="utf-8")

for required in (
    "paperwidth=182mm,paperheight=257mm",
    "top=22mm,bottom=25mm,inner=22mm,outer=18mm",
    r"\setmainhangulfont{KoPubWorld Batang_Pro}",
    r"\setsanshangulfont{KoPubWorld Dotum_Pro}",
    r"\setmathfont{STIXTwoMath-Regular.otf}",
    r"\definecolor{BookBlue}{gray}{0.00}",
):
    if required not in common_preamble:
        fail(f"inherited FEB layout setting changed or missing: {required}")

if "paperwidth=182mm,paperheight=257mm" not in standalone:
    fail("standalone figure test no longer uses the inherited B5 page size")

for group, expected in EXPECTED.items():
    actual = len(re.findall(rf"% gate:{re.escape(group)}\b", figure))
    if actual != expected:
        fail(f"{group}: expected {expected} gate markers, found {actual}")

for required in ("16게이트", "최장 9층", "22게이트", "최장 6층"):
    if required not in figure:
        fail(f"missing fixed figure label: {required}")

font_match = re.search(r"\\newcommand\{\\DiagramMinFontSize\}\{([0-9.]+)\}", styles)
if not font_match:
    fail("DiagramMinFontSize is not defined")
if float(font_match.group(1)) < 6.5:
    fail("diagram minimum font size is below 6.5pt")

if "\\resizebox" in figure or "\\scalebox" in figure:
    fail("the TikZ source must not be globally scaled; that would shrink 6.5pt labels")

print("[nand2gpu] Book and figure invariants passed.")
