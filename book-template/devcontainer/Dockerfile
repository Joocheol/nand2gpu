FROM mcr.microsoft.com/devcontainers/base:noble

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       biber \
       file \
       fontconfig \
       latexmk \
       texlive-bibtex-extra \
       texlive-fonts-extra \
       texlive-fonts-recommended \
       texlive-lang-korean \
       texlive-latex-extra \
       texlive-xetex \
    && fc-cache -f \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
