# Architecture

## Purpose

This repository provides shared infrastructure for LaTeX book projects.

Its purpose is to separate:

1. shared publishing infrastructure,
2. book-specific content,
3. book-specific quality assurance.

The shared infrastructure is maintained once and distributed to each book
repository through `git subtree`.

## Repository model

Each book repository contains the shared template under:

```text
book-template/
```

A book repository follows this general structure:

```text
BookRepository/
├── book-template/
│   ├── latex/
│   ├── scripts/
│   ├── devcontainer/
│   ├── vscode/
│   └── .github/
├── chapters/
├── figures/
├── fonts/
├── references.bib
├── main.tex
├── preamble.tex
├── scripts/
├── .devcontainer/
├── .vscode/
└── .github/workflows/
```

## Responsibility boundaries

### Shared template

The shared template owns:

- common LaTeX packages,
- typography and font configuration,
- page layout,
- theorem and box environments,
- shared build scripts,
- shared validation scripts,
- Docker and Dev Container dependencies,
- common VS Code settings,
- reusable GitHub Actions workflows,
- starter files,
- platform documentation.

Shared files must be changed in the `latex-book-template` repository.

They should not be edited directly inside:

```text
FEB/book-template/
EconMath/book-template/
```

### Book repository

Each book repository owns:

- title, subtitle, and author metadata,
- chapter content,
- figures,
- bibliography data,
- book outline,
- book-specific commands,
- book-specific quality-assurance checks,
- project-specific release names,
- writing plans and editorial rules.

## Wrapper pattern

Book repositories use small wrapper files that delegate to the shared
infrastructure.

Example `preamble.tex`:

```latex
\input{book-template/latex/common-preamble.tex}
```

Example `scripts/build.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

exec bash book-template/scripts/build.sh
```

Example `scripts/validate.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

exec bash book-template/scripts/validate.sh
```

This pattern keeps each book repository understandable while allowing the
shared implementation to evolve independently.

## CI architecture

Continuous integration is divided into three layers.

### Layer 1: shared validation

The shared validation script checks repository structure, JSON syntax,
symbolic links, executable permissions, whitespace errors, and generated
artifacts that must not be committed.

### Layer 2: shared build workflow

The reusable GitHub Actions workflow:

1. checks out the book repository,
2. installs the XeLaTeX toolchain,
3. runs shared validation,
4. builds the complete PDF,
5. uploads the PDF as a workflow artifact.

### Layer 3: book-specific quality assurance

Each book may define additional checks.

Examples include:

- required chapters,
- expected equation labels,
- outline consistency,
- terminology consistency,
- numerical examples,
- bibliography entries,
- completion markers.

These checks belong in the book repository, not in the shared template.

## Release architecture

Normal pushes and pull requests run validation and build checks.

Version tags such as:

```text
v0.9.0
v1.0.0
```

may trigger a release workflow that:

1. builds the PDF,
2. creates or updates a GitHub Release,
3. attaches the generated PDF,
4. preserves the tagged source state.

## Update flow

Shared infrastructure changes follow this sequence:

```text
latex-book-template
        ↓
commit and push
        ↓
git subtree pull in each book
        ↓
validate
        ↓
build
        ↓
commit and push
```

## Design principles

1. Shared infrastructure is maintained in one place.
2. Book content remains independent.
3. Every change must be reproducible.
4. Local builds and CI builds must use the same commands.
5. Generated files must not be committed unless explicitly required.
6. Book-specific quality checks must not leak into the shared template.
7. A new book should be usable without editing infrastructure files.
8. The platform should remain understandable years after its creation.
