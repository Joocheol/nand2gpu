# 출처 관리대장

현대 GPU와 제품 관련 사실은 기억에 의존해 확정하지 않는다. 원리 설명과 특정 구현 사례를 분리하며, 장기적으로 변할 수 있는 주장에는 확인일을 기록한다.

## 출처 우선순위

주장 종류에 따라 두 계열을 구분한다.

### 수학적 원리와 일반 구조

1. 학술논문과 공개 표준
2. 대학 교재와 대학 강의자료
3. 신뢰할 수 있는 전문서
4. 검증 가능한 2차 자료

### 회사별 구현과 현재 제품

1. 제조사·개발사의 공식 아키텍처 및 프로그래밍 문서
2. 해당 구현을 분석한 학술논문
3. 신뢰할 수 있는 전문서와 대학 자료
4. 검증 가능한 2차 자료

출판시장 판단은 출판사·서점·출판유통망의 공식 도서 정보를 우선한다.

## 기록 양식

| ID | 장 | 검증할 주장 | 출처·링크 | 출처 유형 | 확인일 | 판정·주의점 |
|---|---:|---|---|---|---|---|
| SRC-001 | 1~2 | 진리표는 논리 기능을 완전하게 명세할 수 있고 2입력 NAND와 NOR는 각각 보편 게이트다. | [MIT OCW 6.004, 4.1 Annotated Slides](https://ocw.mit.edu/courses/6-004-computation-structures-spring-2017/pages/c4/c4s1/) | 대학 강의자료 | 2026-08-26 | 확인. 논리적 보편성을 실제 표준 셀 구성이 NAND나 NOR뿐이라는 주장으로 넓히지 않는다. |
| SRC-002 | 2 | NAND를 출발점으로 기본 논리 게이트를 계층적으로 구성할 수 있다. | [Nand2Tetris Project 1: Boolean Logic](https://www.nand2tetris.org/project01) | 공식 교육자료 | 2026-08-26 | 확인. 교육용 추상화이며 실제 칩 구현의 유일한 방식은 아니다. |
| SRC-003 | 6 | 조합논리와 달리 순차논리는 현재 상태를 저장하며 레지스터는 클럭 경계에서 값을 보존한다. | [MIT OCW 6.004, 5.1 Annotated Slides](https://ocw.mit.edu/courses/6-004-computation-structures-spring-2017/pages/c5/c5s1/) | 대학 강의자료 | 2026-08-26 | 확인. 본문에서는 래치 내부 회로보다 상태와 시간의 역할에 집중한다. |
| SRC-004 | 7 | 최소 프로세서는 데이터 경로, 제어, 레지스터, 프로그램 카운터, 메모리의 관계로 설명할 수 있다. | [MIT OCW 6.004, 9.1 Annotated Slides](https://ocw.mit.edu/courses/6-004-computation-structures-spring-2017/pages/c9/c9s1/) | 대학 강의자료 | 2026-08-26 | 확인. 특정 Beta ISA의 세부사항은 일반 CPU 구조로 일반화하지 않는다. |
| SRC-005 | 10 | NVIDIA SIMT에서 warp는 32개 스레드로 구성되며 분기 발산과 독립 스레드 스케줄링을 함께 고려해야 한다. | [NVIDIA CUDA Programming Guide 13.2](https://docs.nvidia.com/cuda/cuda-programming-guide/pdf/cuda-programming-guide.pdf) | 제조사 공식 문서 | 2026-08-26 | 확인. 32는 CUDA/NVIDIA 사례이며 GPU 일반 폭으로 쓰지 않는다. 세대별 하드웨어 실행 세부사항을 프로그래밍 모델과 구분한다. |
| SRC-006 | 10, 12~13 | AMD wavefront 폭과 CU 구성은 아키텍처·제품에 따라 달라지며 CU에는 스케줄러, 벡터·스칼라 파이프라인, 레지스터, LDS 등이 포함된다. | [AMD GPU specifications](https://rocm.docs.amd.com/en/latest/reference/gpu-specs.html), [AMD Compute Unit](https://rocm.docs.amd.com/projects/rocprofiler-compute/en/docs-7.14.0/conceptual/cdna/compute-unit.html) | 제조사 공식 문서 | 2026-08-26 | 확인. RDNA와 CDNA, 세대별 wave32/wave64 및 내부 구성을 분리해 서술한다. |
| SRC-007 | 12~13 | 여러 준비된 실행 흐름을 번갈아 내보내는 멀티스레딩은 의존성·메모리 대기로 생긴 빈 시간을 다른 일로 채우는 일반적인 지연시간 은폐 방법이며, 필요한 동시 흐름 수는 작업과 자원에 따라 달라진다. | [MIT 6.5900, Multithreading Architectures](https://csg.csail.mit.edu/6.5900/Lectures/L11handout.pdf), [Volkov, “Understanding Latency Hiding on GPUs”](https://escholarship.org/uc/item/1wb7f3h4), [NVIDIA CUDA Programming Guide](https://docs.nvidia.com/cuda/archive/12.9.2/cuda-c-programming-guide/index.html) | 대학 강의자료·학술논문·제조사 공식 문서 | 2026-08-26 | 교차 확인. MIT 자료로 멀티스레딩의 일반 원리와 상태 비용을, UC eScholarship의 Berkeley 박사학위논문으로 GPU 지연시간 은폐의 조건과 단순 점유율 모형의 한계를 확인한다. CUDA의 block·warp·SM 자원 제한은 NVIDIA 사례로만 사용한다. 점유율이 높으면 성능이 항상 비례해 증가한다고 쓰지 않는다. |
| SRC-008 | 13 | 작은 빠른 저장공간과 큰 느린 저장공간을 계층으로 두고 시간·공간 지역성을 이용하면 평균 데이터 접근 비용을 낮출 수 있으며, GPU의 레지스터·로컬 저장공간·캐시·외부 메모리는 이 일반 절충의 한 사례다. | [MIT OCW 6.004, Caches and the Memory Hierarchy](https://ocw.mit.edu/courses/6-004-computation-structures-spring-2017/pages/c14/c14s1/), [NVIDIA CUDA Programming Guide: GPU Memory](https://docs.nvidia.com/cuda/cuda-programming-guide/01-introduction/programming-model.html), [AMD Compute Unit](https://rocm.docs.amd.com/projects/rocprofiler-compute/en/docs-7.14.0/conceptual/cdna/compute-unit.html) | 대학 강의자료·제조사 공식 문서 | 2026-08-26 | 교차 확인. 용량·접근시간·지역성의 일반 원리는 MIT 자료를 기준으로 한다. CUDA shared memory와 AMD LDS는 소프트웨어 관리 로컬 저장공간의 서로 다른 사례이며 모든 GPU의 보편 명칭으로 쓰지 않는다. |
| SRC-009 | 15, 17 | 산술 집약도는 정한 메모리 경계를 통과한 바이트당 산술 연산량으로 연산 상한과 메모리 상한을 연결한다. | [Williams, Waterman, Patterson, “Roofline”](https://dl.acm.org/doi/10.1145/1498765.1498785), [Berkeley Lab Roofline 소개](https://amcr.lbl.gov/departments/computer-science-department/ppan/roofline-performance-model/) | 학술논문·연구기관 | 2026-08-26 | 교차 확인. 분자에 포함한 연산, 분모의 메모리 경계, 읽기·쓰기와 바이트 수를 밝혀야 한다. `연산/입력값 읽기`는 같은 크기 값끼리 원리를 비교하는 교육용 중간 단위이며 표준 roofline 단위와 구분한다. |
| SRC-010 | 19 | NVIDIA Tensor Core는 행렬 곱셈·누산을 가속하며 입력 형식과 누산 형식은 구분해야 한다. | [NVIDIA Mixed Precision Guide](https://docs.nvidia.com/deeplearning/performance/mixed-precision-training/index.html), [TensorRT Precision Control](https://docs.nvidia.com/deeplearning/tensorrt/latest/inference-library/precision-control.html) | 제조사 공식 문서 | 2026-08-26 | 확인. Volta 수치와 행렬 크기는 세대 한정 사례다. 낮은 정밀도가 자동으로 같은 정확도를 보장한다고 쓰지 않는다. |
| SRC-011 | 19 | AMD CDNA 계열에는 행렬 연산을 위한 MFMA 장치·명령이 있다. | [AMD HIP Hardware Implementation](https://rocm.docs.amd.com/projects/HIP/en/develop/understand/hardware_implementation.html) | 제조사 공식 문서 | 2026-08-26 | 확인. AMD의 공식 명칭과 지원 형식은 세대별로 확인한다. |
| SRC-012 | 19 | Intel Xe 계열은 범용 벡터 엔진과 구분되는 XMX 행렬 엔진을 제공하는 구현 사례가 있다. | [Intel Xe-HPG Architecture](https://www.intel.com/content/www/us/en/developer/articles/technical/introduction-to-the-xe-hpg-architecture.html) | 제조사 공식 문서 | 2026-08-26 | 제한적. Xe-HPG 사례이며 모든 Intel GPU에 동일하게 적용하지 않는다. |
| SRC-013 | 19~20 | TPU의 MXU는 MAC 배열과 데이터 흐름을 전용화한 사례이며 TPU는 세대별 구성이 다르다. | [Google Cloud TPU Architecture](https://docs.cloud.google.com/tpu/docs/system-architecture-tpu-vm), [Jouppi et al., 2017](https://research.google/pubs/in-datacenter-performance-analysis-of-a-tensor-processing-unit/) | 개발사 공식 문서·학술논문 | 2026-08-26 | 교차 확인. 최신 TPU의 배열 크기·TensorCore 수치를 일반적인 TPU 정의로 고정하지 않는다. |
| SRC-014 | 18 | 부동소수점 형식과 연산의 정확한 정의는 IEEE 754 표준을 기준으로 검증해야 한다. | [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/) | 표준 문서 | 2026-08-26 | 확인. BF16·FP8 등 기계학습용 형식은 IEEE 754 기본 형식과 구분해 제조사·표준화 자료를 추가 확인한다. |
| SRC-015 | 4 | 리플 캐리 덧셈기는 올림이 자리별로 전달되는 경로를 갖고, 올림 미리보기는 생성·전파 정보를 더 많은 논리로 계산해 긴 올림 경로를 줄이는 대표적 절충이다. | [MIT OCW 6.896, Lecture 2: Fast Addition](https://ocw.mit.edu/courses/6-896-theory-of-parallel-hardware-sma-5511-spring-2004/resources/lect2/), [MIT 6.111, Carry Lookahead Adder](https://www.ocw.mit.edu/courses/6-111-introductory-digital-systems-laboratory-spring-2006/a38d2e85a64c02b5f248d3168a10a3c8_lec8_9.pdf) | 대학 강의자료 | 2026-08-26 | 교차 확인. 4장 수치는 선택한 4비트 회로의 게이트 지연 모형을 먼저 정의한 뒤 센다. carry-lookahead를 모든 고속 덧셈기의 유일한 구조로 쓰지 않으며, 병렬 접두형은 별도 근거 없이 본문 핵심에 넣지 않는다. |
| SRC-016 | 5 | 이진 곱셈은 부분곱 생성, 여러 부분곱의 감축, 최종 이진 덧셈으로 조직할 수 있고 순차·배열·트리 구조는 지연·규칙성·회로량 사이에서 서로 다른 선택을 한다. | [Behrooz Parhami, UCSB Computer Arithmetic: Multiplication](https://web.ece.ucsb.edu/~parhami/pres_folder/f31-book-arith-pres-pt3.pdf), [CMU 15-828, Wallace Tree notes](https://www.cs.cmu.edu/afs/cs/academic/class/15828-s98/lectures/0126/scribe.html) | 대학 강의자료 | 2026-08-26 | 교차 확인. UCSB 자료는 full-tree·partial-tree·array와 4×4 Wallace/Dadda 예를 비교하고, CMU 자료는 부분곱 감축의 로그 깊이 원리를 설명한다. 5장에서는 먼저 작은 shift-and-add 곱셈을 완성하고 트리 구조는 `다른 선택` 상자로 제한한다. |
| SRC-017 | 8~9 | 총 연산량(work)과 가장 긴 의존 사슬(span)을 구분하면 일렬 합과 나무형 합의 병렬성 차이를 설명할 수 있다. | [MIT 6.172 Lecture 7: Races and Parallelism](https://ocw.mit.edu/courses/6-172-performance-engineering-of-software-systems-fall-2018/543e419bff1ed05b1a649115c24c44b3_MIT6_172F18_lec7.pdf) | 대학 강의자료 | 2026-08-26 | 확인. span law와 `work/span`의 의미를 근거로 사용한다. 4장의 게이트 경로와 8장의 알고리즘 의존 사슬은 같은 층위의 시간이 아님을 본문에서 구분한다. |
| SRC-018 | 11 | 그래픽 파이프라인은 정점·프래그먼트 등에 프로그램 가능한 연산을 반복 적용하며, 프로그래머블 GPU는 GPGPU로 확장되었다. | [Khronos Vulkan Shaders](https://github.khronos.org/Vulkan-Site/spec/latest/chapters/shaders.html), [Owens et al., “A Survey of General-Purpose Computation on Graphics Hardware,” Computer Graphics Forum 26(1), 80–113, 2007](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1467-8659.2007.01012.x) | 표준 문서·학술논문 | 2026-08-26 | 교차 확인. Owens 논문은 2007년 3월 23일 처음 출판됐다. 현대 Vulkan의 단계 구성을 초기 GPU 역사에 그대로 투사하지 않는다. GPGPU는 딥러닝 대두 이전부터 선형대수·과학 계산 등에 사용됐다. |
| SRC-019 | 9~10 | SIMD와 SIMT는 제어 공유라는 공통점이 있지만 프로그래밍 모델은 독립 스칼라 스레드를 드러내고 하드웨어는 이를 SIMD 실행 묶음으로 조직할 수 있다. | [Fung & Aamodt, “Thread Block Compaction for Efficient SIMT Control Flow”](https://people.ece.ubc.ca/aamodt/papers/wwlfung.hpca2011.pdf), [ElTantawy & Aamodt, “MIMD Synchronization on SIMT Architectures”](https://people.ece.ubc.ca/~aamodt/publications/papers/eltantawy.micro2016.pdf) | 학술논문 | 2026-08-26 | 교차 확인. SIMT를 SIMD와 완전히 다른 물리 회로라고 단정하지 않는다. 논문들의 세대별 lockstep·재수렴 세부사항을 모든 현대 GPU에 일반화하지 않는다. |
| SRC-020 | 14, 17 | 정확 산술에서 계산 순서와 블록화는 같은 수학적 계산을 유지하면서 작은 빠른 메모리와 큰 느린 메모리 사이의 데이터 이동량을 바꿀 수 있다. | [Ballard et al., “Minimizing Communication in Numerical Linear Algebra”](https://epubs.siam.org/doi/10.1137/090769156) | 학술논문 | 2026-08-26 | 확인. SIAM에 출판된 논문은 행렬 곱셈의 통신 하한을 포함한 일반 이론을 제공한다. 17장의 128·64·48은 논문의 수치가 아니라 책이 명시한 작은 교육 모형에서 별도 계산한 값이다. 유한 정밀도 결과는 SRC-021과 분리한다. |
| SRC-021 | 17~18 | 유한 정밀도 부동소수점에서는 반올림 때문에 실수의 결합법칙과 같은 기계 결과가 보장되지 않을 수 있다. | [Goldberg, “What Every Computer Scientist Should Know About Floating-Point Arithmetic”](https://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html), [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/) | 학술논문 재수록·표준 | 2026-08-26 | 교차 확인. 각 기본 연산의 정확한 반올림 규칙과 여러 연산의 재결합 결과가 같다는 주장은 구분한다. 정수 예제와 부동소수점 예제를 섞지 않는다. |
| SRC-022 | 19 | systolic architecture는 데이터를 여러 처리 요소 사이로 규칙적으로 흐르게 해 메모리 접근당 여러 계산을 수행하는 전용화 원리다. | [H. T. Kung, “Why Systolic Architectures?”](https://www.eecs.harvard.edu/~htk/publication/1982-kung-why-systolic-architecture.pdf) | 원전 학술논문 | 2026-08-26 | 확인. 1982년 원전은 행렬 곱셈만을 위한 단일 구조가 아니라 고수준 계산을 규칙적 하드웨어로 사상하는 일반 방법론을 설명한다. 현대 TPU·Tensor Core와 동일한 구조라고 쓰지 않는다. |
| SRC-023 | 8, 12, 20 | 처리량 지향 설계와 응답 지연시간 지향 설계는 이분법이 아니라 작업 요구·제어·메모리·전용화에 따른 설계 선택이다. | [MIT 6.172 Lecture 7](https://ocw.mit.edu/courses/6-172-performance-engineering-of-software-systems-fall-2018/543e419bff1ed05b1a649115c24c44b3_MIT6_172F18_lec7.pdf), [Jouppi et al., TPU](https://research.google/pubs/in-datacenter-performance-analysis-of-a-tensor-processing-unit/) | 대학 강의자료·학술논문 | 2026-08-26 | 교차 확인. TPU 논문의 평균 처리량과 99번째 백분위 응답시간 비교는 특정 데이터센터 추론 사례다. CPU·GPU·TPU 전체를 하나의 숫자로 서열화하지 않는다. |
| SRC-024 | 11 | GPU는 그래픽의 데이터 병렬성을 위해 발전했지만 프로그래머블화와 범용 계산 환경을 거쳐 딥러닝 학습에 재사용되었다. 2012년 AlexNet은 두 GTX 580 GPU에서 학습됐다. | [Owens et al., GPGPU Survey](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1467-8659.2007.01012.x), [NVIDIA CUDA FAQ](https://developer.nvidia.com/cuda/faq), [Krizhevsky et al., AlexNet](https://proceedings.neurips.cc/paper/2012/hash/c399862d3b9d6b76c8436e924a68c45b-Abstract.html) | 학술논문·개발사 공식 문서 | 2026-08-26 | 교차 확인. `인류사적 우연`은 해석적 표현이다. 검증된 사실은 그래픽용 병렬 구조의 프로그래머블화, 딥러닝 이전 GPGPU, 2012년 GPU 기반 CNN 학습이다. 그래픽과 AI가 같은 계산·같은 구조였다고 일반화하지 않는다. |
| SRC-025 | 11 | 대표 PC 그래픽 하드웨어는 1999년 무렵 고정 기능 변환·조명, 2001년 프로그램 가능한 정점 셰이더, 2002년 프로그램 가능한 픽셀 셰이더로 전개된 사례가 있다. | [NVIDIA, “Programming Graphics Hardware” (2005)](https://download.nvidia.com/developer/presentations/2005/I3D/I3D_05_IntroductionToGPU.pdf) | 제조사 공식 교육자료·역사 회고 | 2026-08-26 | 제한적. NVIDIA가 2005년에 정리한 대표 PC GPU 세대 연표다. GPU 전체의 최초 발명 시점이나 모든 회사의 전환 시점으로 일반화하지 않는다. |
| SRC-026 | 11 | 현대 그래픽 파이프라인은 프로그램 가능한 셰이더 단계와 고정 기능 단계를 함께 가진다. | [Khronos Vulkan Pipelines](https://github.khronos.org/Vulkan-Site/spec/latest/chapters/pipelines.html) | 표준 공식 문서 | 2026-08-26 | 확인. API의 논리적 파이프라인 단계 구분이며 특정 GPU의 물리 회로 배치와 일대일 대응한다고 추정하지 않는다. |
| SRC-027 | 3 | 이진 자릿값과 2의 보수는 같은 비트열의 수 해석과 표현 범위를 정한다. | [MIT OCW 6.004, 1.1 Basics of Information](https://ocw.mit.edu/courses/6-004-computation-structures-spring-2017/pages/c1/c1s1/) | 대학 강의자료 | 2026-08-26 | 확인. 4비트 예제의 범위·합·뺄셈과 carry-out·signed overflow의 대비는 본문에서 직접 계산한다. |
| SRC-028 | 4~5 | 리플 캐리의 긴 경로는 비트 폭과 함께 늘며, ALU는 여러 산술·논리 후보 기능을 만들고 멀티플렉서로 하나를 선택하는 구조로 설계할 수 있다. | [MIT OCW 6.004, 8.1 Design Tradeoffs](https://ocw.mit.edu/courses/6-004-computation-structures-spring-2017/pages/c8/c8s1/) | 대학 강의자료 | 2026-08-26 | 확인. 강의의 ALU와 carry-select는 설계 사례다. 4장의 16·9·22·6과 38은 별도로 명시한 2입력 단위 게이트 모형에서 직접 센 c4 또는 carry 회로 수치이며 출처의 제품 수치가 아니다. |
| SRC-029 | 3, 5 | 반가산기·전가산기·다중 비트 덧셈기와 교육용 ALU를 불 함수의 계층으로 구성할 수 있다. | [Nand2Tetris Project 2: Boolean Arithmetic](https://www.nand2tetris.org/project02) | 공식 교육자료 | 2026-08-26 | 확인. 교육용 계층의 근거로 사용한다. Hack ALU의 구체적 기능 구성을 모든 ALU의 정의로 일반화하지 않는다. |

## 우선 조사 묶음

### 오래가는 원리

- NAND의 논리적 보편성과 실제 표준 셀 설계의 차이
- 같은 수학적 함수의 여러 분해와 게이트 수·깊이 절충
- 연산 횟수와 의존 사슬의 깊이, 병렬 reduction
- SIMD와 SIMT의 정의 및 관계
- 계산 첨자를 유한한 실행 자원에 배치하는 방법
- 데이터 위치, 계산 순서, 산술집약도, 루프 타일링
- 블록 행렬 곱셈의 수학적 정당성과 데이터 재사용
- 유한 정밀도, 반올림, 비결합성, 혼합 정밀도
- 행렬 곱셈·누산 전용화와 systolic dataflow

### 회사별 사례

- NVIDIA: warp, SM, Tensor Core, CUDA 실행 모델
- AMD: wavefront, CU, CDNA/RDNA 실행 모델
- Intel: Xe 실행 모델과 행렬 연산 장치
- Google: TPU와 systolic array 계열 설명

회사별 사례는 원리를 설명한 뒤 붙이며, 세대에 따라 바뀌는 수치는 본문 핵심 문장보다 표·주석·보충 상자에 둔다.

미확보 주장은 표 안에서 SRC ID와 `보류` 판정으로 관리한다. 표 밖의 할 일 목록만으로 남기지 않는다.

## 검증 상태 표기

- `확인`: 1차 자료로 직접 확인
- `교차 확인`: 독립적인 두 개 이상의 신뢰할 수 있는 자료가 일치
- `제한적`: 특정 세대나 조건에서만 성립
- `보류`: 적절한 근거를 아직 확보하지 못함
- `수정 필요`: 현재 원고의 표현이 근거보다 넓음
