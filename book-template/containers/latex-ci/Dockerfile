FROM ubuntu:24.04

LABEL org.opencontainers.image.source="https://github.com/Joocheol/latex-book-template"
LABEL org.opencontainers.image.description="Reproducible XeLaTeX toolchain for the LaTeX book platform"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       biber \
       ca-certificates \
       file \
       fontconfig \
       git \
       git-lfs \
       latexmk \
       python3 \
       texlive-bibtex-extra \
       texlive-fonts-extra \
       texlive-fonts-recommended \
       texlive-lang-korean \
       texlive-latex-extra \
       texlive-xetex \
    && git lfs install --system \
    && fc-cache -f \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY containers/latex-ci/smoke-test.sh /usr/local/bin/latex-ci-smoke-test
RUN chmod +x /usr/local/bin/latex-ci-smoke-test

WORKDIR /github/workspace

# KoPubWorld and all manuscript assets intentionally remain outside this image.
# Book repositories provide their own fonts/ directory at build time.
