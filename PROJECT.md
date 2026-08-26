# 『진리표에서 GPU까지』 프로젝트 허브

## 현재 상태

- 단계: 서장·제1부 상세 설계 집중 리뷰 A~P 반영 완료, 도해 시안 착수 가능
- 확정 본제: 『진리표에서 GPU까지』
- 부제 상태: 미확정. 목차와 샘플 원고 검증 뒤 결정한다.
- 부제 검토안 A: 같은 답, 다른 비용 — 계산을 나누고 옮기고 다시 쓰는 법
- 부제 검토안 B: 무엇을 동시에 하고 무엇을 옮길 것인가 — 병렬 계산과 AI 가속기의 원리
- 보류한 참고안: `행렬 곱셈으로 이해하는 병렬 계산과 AI 가속기의 원리`는 행렬이 16장에 처음 나오는 구조보다 행렬을 지나치게 앞세울 수 있고, `작은 논리 회로가 복제와 전용화를 거쳐 GPU와 AI 가속기가 되는 원리`는 본제와 중복되며 공유·데이터 재사용이 빠진다.
- 기준일: 2026-08-26
- 원격 저장소: https://github.com/Joocheol/nand2gpu

## 책의 약속

이 책은 프로그래밍이나 전공 지식을 요구하지 않고, 수학적으로 같은 계산도 표현·분해·순서·병렬성·데이터 이동에 따라 하드웨어에서 전혀 다른 비용을 갖는 이유를 설명한다. 여기서 `같은 답`은 우선 정확한 산술의 결과를 뜻한다. 유한한 비트로 수를 근사하면 계산 순서와 정밀도에 따라 반올림 결과가 달라질 수 있다. 대개 낮은 자리에서 갈리지만 값의 크기 차이와 상쇄에 따라 더 큰 차이가 날 수도 있으며, 그 경계 자체를 후반부의 주제로 다룬다.

책을 끝까지 끌고 가는 대표적인 종합 계산은 **행렬 곱셈**이다. 그러나 초반부터 행렬 예제를 반복하지 않는다. 1~15장에서는 진리표, 이진수, 덧셈, 합, 벡터, 픽셀, 격자처럼 각 개념에 가장 자연스러운 작은 예제로 계산의 명세·분해·의존성·병렬성·데이터 이동을 익힌다. 16장에서 행렬 곱셈을 처음 완결하며 앞의 개념을 한꺼번에 회수하고, 타일링·유한 정밀도·행렬 연산 전용화로 올라간다. GPU는 이 계산 구조가 물리적 제약을 만났을 때 나온 여러 설계 답 가운데 대표 사례다.

수학적 설명 흐름은 다음과 같다.

> 명세 → 분해 → 의존성 → 재배열 → 재사용 → 근사

이에 대응하는 하드웨어 구현 흐름은 기존 다섯 동사로 유지한다.

> 조합 → 복제 → 공유 → 데이터 재사용 → 전용화

역사적 발명 순서와 독자를 위한 논리적 설명 순서는 반드시 구분한다. 이 흐름을 유일한 필연적 발전 경로로 서술하지 않으며, 현대 GPU를 단순히 “CPU보다 코어가 많은 장치” 또는 “모든 일을 행렬로 계산하는 장치”로 설명하지 않는다.

## 작업 공간 원칙

- `sources/`: 사용자가 제공하거나 동기화한 원본 자료. 읽기 전용이며 수정·이동·삭제하지 않는다.
- `planning/`: 책의 범위, 목차, 일정과 단계별 완료 조건.
- `editorial/`: 집필 및 독립 검토 기준.
- `research/`: 출처 목록과 검증이 필요한 주장.
- `decisions/`: 제목·범위·용어 등에 관한 결정과 근거.
- 실제 원고 폴더는 첫 장 원고 집필을 시작할 때 만든다.

## 현재 문서

- [진행 로드맵](planning/roadmap.md)
- [4부 20장 목차 지도](planning/chapter-map.md)
- [서장·제1부 상세 설계표](planning/preface-part1-detailed-briefs.md)
- [편집·기술 검토 기준](editorial/review-checklist.md)
- [출처 관리대장](research/source-register.md)
- [결정 기록](decisions/decision-log.md)
- [독립 리뷰·반영 기록 색인](reviews/README.md)
- [장별 샘플 원고 색인](samples/README.md)
- [Claude 제목 리뷰 기록](reviews/claude-title-review-2026-08-26.md)
- [세 샘플 구조 검토 기록](reviews/sample-structure-review-2026-08-26.md)
- [Claude 목차·샘플 독립 리뷰](reviews/claude-structure-review-2026-08-26.md)
- [Claude 수학 중심 개편안 독립 리뷰](reviews/claude-math-centered-review-2026-08-26.md)
- [Claude 수정 방향 독립 재검토](reviews/claude-revised-direction-review-2026-08-26.md)
- [Claude 8·11·16·17장 연결 샘플 독립 리뷰](reviews/claude-connection-samples-review-2026-08-26.md)
- [Claude 연결 샘플 리뷰 반영 기록](reviews/claude-connection-samples-review-resolution-2026-08-26.md)
- [Claude 서장·1~5장 상세 설계 독립 리뷰](reviews/claude-preface-part1-brief-review-2026-08-26.md)
- [Claude 서장·제1부 상세 설계 리뷰 반영 기록](reviews/claude-preface-part1-brief-review-resolution-2026-08-26.md)
- [1장 진리표·NAND 샘플](samples/ch01-truth-table-nand.md)
- [8장 합·의존 사슬·시그마 샘플](samples/ch08-sum-work-span-sigma.md)
- [10장 조각별 함수·SIMT 샘플](samples/ch10-simt-execution-groups.md)
- [11장 그래픽 GPU에서 AI로 이어지는 전환 샘플](samples/ch11-graphics-to-ai.md)
- [16장 행렬 곱셈 종합 샘플](samples/ch16-matrix-multiplication.md)
- [17장 블록 행렬·타일링 샘플](samples/ch17-matrix-tiling.md)

## 다음 작업

1. 서장 도해 2종과 1~5장 핵심 도해의 흑백 시안을 만들고, 2장 게이트 수와 4장 16·22게이트 및 9·6층 경로를 그림에서 다시 센다.
2. 서장·1~5장의 상세 설계표에 따라 제1부 원고를 순서대로 집필한다.
3. 1장·3장·5장 초고를 비전공 독자에게 시험해 기호 밀도와 반복 계산 부담을 확인한다.
4. 도해와 독자 시험 결과를 반영해 서장·제1부를 통합 편집하고 독립 기술 검토를 다시 실시한다.
5. 부제는 미확정 상태를 유지하고, 실제 원고 분량과 독자 시험 결과가 나온 뒤 결정한다. 본제는 다시 선정하지 않는다.
