# 서장·제1부 흑백 도해 시안

서장과 1~5장의 상세 설계표에 맞춰 만든 편집 가능한 SVG 시안이다. 특정 제품의 물리 구조를 묘사하지 않으며, 흑백 인쇄에서도 실선·점선·명암으로 구분되도록 설계한다.

## 파일 목록

| 구간 | 도해 1 | 도해 2 |
|---|---|---|
| 서장 | `preface-01-equation-and-finite-machine.svg` | `preface-02-down-and-up-map.svg` |
| 1장 | `ch01-01-rule-to-truth-table.svg` | `ch01-02-specification-vs-implementation.svg` |
| 2장 | `ch02-01-one-table-two-circuits.svg` | `ch02-02-same-and-different.svg` |
| 3장 | `ch03-01-two-faces-of-bits.svg` | `ch03-02-four-bit-addition.svg` |
| 4장 | `ch04-01-carry-propagation.svg` | `ch04-02-chain-vs-expanded.svg` |
| 5장 | `ch05-01-partial-products.svg` | `ch05-02-functions-and-selection.svg` |

## 검산 기준

- 1장 NAND 구현: 게이트 2개, 최장 2층.
- 2장 XOR 방법 A: NAND 6개, 최장 4층.
- 2장 XOR 방법 B: NAND 4개, 최장 3층.
- 4장 리플 c4 회로: p·g 8개와 carry 게이트 8개, 합계 16개, 최장 9층.
- 4장 펼친 c4 회로: p·g 8개, 추가 AND 10개, OR 4개, 합계 22개, 최장 6층.
- 5장 4×4 곱셈: 한 비트 부분곱 16개, 부분곱 행 4개, 행 덧셈 3번, 최대 출력 폭 8비트.

## 조판 기준

- 최종 인쇄 글자는 6.5pt 이상으로 한다.
- `ch02-01`, `ch04-02`, `ch05-01`은 가로 전면 도판으로 예약하고 실제 배치 폭에서 축소 가독성을 다시 검사한다.
- 진한 회색은 지금 따라갈 경로, 옅은 회색은 배경·명세, 흰색은 일반 요소에 쓴다.
- 방향이 핵심인 선은 `marker-end`와 일반 polygon 화살촉을 함께 둬 렌더러가 SVG marker를 생략해도 뜻이 남게 한다. 두 표현 모두 `10×10` 화살촉으로 통일한다.

## TeX·TikZ 이행

이 SVG 12종은 내용과 배치를 빠르게 검토하기 위한 참고본으로 유지한다. 책의 TeX 골격이 정해지면 최종 제작 원본은 `standalone` TikZ 그림으로 옮기고, TeX 본문과 같은 글꼴·수식·선 굵기·회색 정의를 공유한다.

- 먼저 공통 TikZ 스타일에서 상자, 강조 상자, 점선 안내선, 일반선, 강조선, `Stealth` 화살촉을 정의한다.
- 한 그림을 SVG와 TikZ 양쪽에서 계속 수정하지 않는다. 이식이 끝난 그림은 TikZ를 단일 원본으로 삼고 PDF를 조판에 사용한다.
- SVG는 Claude 리뷰 당시의 배치와 수치를 대조하는 참고 자료로 남긴다.
- `ch04-02`처럼 밀도가 높은 도해부터 시험 이식해 글자 크기와 가로 전면 도판 폭을 먼저 확정한다.

최종 조판 전에는 판형에 맞춰 글자 크기와 줄바꿈을 다시 조정하고, 본문 용어가 바뀌면 도해의 표기도 함께 갱신한다.
