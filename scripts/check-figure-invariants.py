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
PREFACE_STANDALONE = ROOT / "tests" / "preface-figures-standalone.tex"
CH03_STANDALONE = ROOT / "tests" / "ch03-figures-standalone.tex"
PREFACE_FIGURES = (
    ROOT / "figures" / "preface-01-equation-and-finite-machine.tex",
    ROOT / "figures" / "preface-02-down-and-up-map.tex",
)
CH02_FIGURES = (
    ROOT / "figures" / "ch02-01-one-function-two-decompositions.tex",
    ROOT / "figures" / "ch02-02-same-output-different-cost.tex",
)
CH03_FIGURES = (
    ROOT / "figures" / "ch03-01-two-faces-of-bits.tex",
    ROOT / "figures" / "ch03-02-four-bit-addition.tex",
)

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
preface_standalone = PREFACE_STANDALONE.read_text(encoding="utf-8")
ch03_standalone = CH03_STANDALONE.read_text(encoding="utf-8")

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

for standalone_source in (standalone, preface_standalone, ch03_standalone):
    if "paperwidth=182mm,paperheight=257mm" not in standalone_source:
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

for figure_path in (FIGURE, *PREFACE_FIGURES, *CH02_FIGURES, *CH03_FIGURES):
    source = figure_path.read_text(encoding="utf-8")
    if "\\resizebox" in source or "\\scalebox" in source:
        fail(f"{figure_path.name}: global scaling would shrink 6.5pt labels")

chapter02 = (ROOT / "chapters" / "chapter02.tex").read_text(encoding="utf-8")
if r"\keyterm{OR}" in chapter02:
    fail("chapter 2 promotes OR beyond the five-term chapter brief")

for required in (
    "0,1,1,0",
    "방법 A는 NAND 6개·가장 긴 경로 4층",
    "방법 B는 NAND 4개·가장 긴 경로 3층",
    "팬아웃",
    "NOR도 혼자서 같은 역할",
):
    if required not in chapter02:
        fail(f"chapter 2 is missing a fixed logic or boundary statement: {required}")

ch02_figure_1 = CH02_FIGURES[0].read_text(encoding="utf-8")
if "2층 없음" not in ch02_figure_1:
    fail("chapter 2 figure 1 no longer marks the N-to-T layer bypass")

chapter03 = (ROOT / "chapters" / "chapter03.tex").read_text(encoding="utf-8")
full_adder_rows = (
    "0 & 0 & 0 & 0 & 0",
    "0 & 0 & 1 & 1 & 0",
    "0 & 1 & 0 & 1 & 0",
    "0 & 1 & 1 & 0 & 1",
    "1 & 0 & 0 & 1 & 0",
    "1 & 0 & 1 & 0 & 1",
    "1 & 1 & 0 & 0 & 1",
    "1 & 1 & 1 & 1 & 1",
)
for row in full_adder_rows:
    if row not in chapter03:
        fail(f"chapter 3 full-adder table is missing row: {row}")

for required in (
    r"0101+0011=1000",
    r"0101+1101=1\,0010",
    r"0\sim15",
    r"-8\sim7",
    "carry-out과 signed overflow가 같은 신호가 아님",
    "각 전가산기의 내부 경로와 가장 왼쪽 결과가 언제 확정되는지는 4장에서",
):
    if required not in chapter03:
        fail(f"chapter 3 is missing a fixed arithmetic or boundary statement: {required}")

if 0b0101 + 0b0011 != 0b1000:
    fail("chapter 3 unsigned addition fixture is wrong")
if ((0b0101 + ((~0b0011 + 1) & 0b1111)) & 0b1111) != 0b0010:
    fail("chapter 3 two's-complement subtraction fixture is wrong")

ch03_figure_1 = CH03_FIGURES[0].read_text(encoding="utf-8")
for required in (r"1000_2=1\times8", r"1000_2=1\times(-8)"):
    if required not in ch03_figure_1:
        fail(f"chapter 3 figure 1 is missing a fixed interpretation: {required}")

ch03_figure_2 = CH03_FIGURES[1].read_text(encoding="utf-8")
if ch03_figure_2.count("% adder:full") != 4:
    fail("chapter 3 figure 2 must contain four full-adder boxes")
for required in (r"c_1=1", r"c_2=1", r"c_3=1", r"c_4=0"):
    if required not in ch03_figure_2:
        fail(f"chapter 3 figure 2 is missing a carry value: {required}")
if "기다림과 내부 경로는 4장에서" not in ch03_figure_2:
    fail("chapter 3 figure 2 no longer postpones path timing to chapter 4")

prologue = (ROOT / "chapters" / "prologue.tex").read_text(encoding="utf-8")
for forbidden in ("행×열", "내적", "\\sum", "타일 계산"):
    if forbidden in prologue:
        fail(f"prologue introduces a forbidden matrix detail too early: {forbidden}")

for required in (
    "수학은 원하는 결과의 규칙을 정하지만",
    "계산이 요구하는 양",
    "기계가 제공하는 자원",
    "진리표 한 장에서 시작",
):
    if required not in prologue:
        fail(f"prologue is missing a fixed narrative element: {required}")

print("[nand2gpu] Book and figure invariants passed.")
