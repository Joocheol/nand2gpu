# Continuous Integration

## One workflow per book

Each book repository keeps one caller workflow:

```text
.github/workflows/book-ci.yml
```

That workflow runs for:

- every pull request opened or updated against `main`,
- every push to `main`,
- a manual `workflow_dispatch` run.

A standard caller is:

```yaml
name: Book CI

on:
  pull_request:
    branches:
      - main
    types:
      - opened
      - synchronize
      - reopened
  push:
    branches:
      - main
  workflow_dispatch:

permissions:
  contents: read

concurrency:
  group: book-ci-${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  build:
    uses: Joocheol/latex-book-template/.github/workflows/book-ci.yml@COMMIT_SHA
    with:
      artifact_name: book-pdf
      retention_days: 7
```

There is no separate lightweight pull-request workflow and no `build-pdf`
label. Every manuscript update receives the same validation and complete PDF
build.

## What the reusable workflow does

The shared workflow:

1. checks out the complete caller repository with full Git history,
2. checks whitespace only in the pull request's actual base-to-head changes,
3. runs inside the immutable XeLaTeX CI container,
4. runs the book's `scripts/validate.sh`,
5. builds `main.pdf` through `scripts/build.sh`,
6. confirms that the PDF exists and is nonempty,
7. uploads it as the `book-pdf` workflow artifact.

The pinned image removes repeated TeX installation and guarantees that all
books use the same compiler and package environment.

## Shared checks and manuscript-specific checks

The shared validator under `book-template/scripts/validate.sh` checks repository
and toolchain assumptions such as required files, JSON syntax, executable build
wrappers, and unwanted cache files.

A book may extend its top-level `scripts/validate.sh` with checks that describe
that manuscript, including:

- required chapter includes and labels,
- terminology consistency,
- exercise and outline completion,
- recomputed numerical examples,
- bibliography entries,
- book-specific code and result files.

These checks remain scripts in the book repository. They are called by the one
Book CI workflow rather than being implemented as additional workflow files.

## Local writing workflow

The normal author command is:

```bash
bash scripts/build.sh
```

Use the following only for diagnosis or infrastructure maintenance:

```bash
bash scripts/validate.sh
bash book-template/scripts/doctor.sh
bash book-template/scripts/update-template.sh
```

CI is the authoritative complete check before merge.

## Version pinning

Every book pins the reusable workflow to a reviewed commit SHA:

```yaml
uses: Joocheol/latex-book-template/.github/workflows/book-ci.yml@COMMIT_SHA
```

Do not call `@main` from a book. A platform update should be intentional,
reviewed once, tested against all affected books, and then frozen again.

## Prebuilt XeLaTeX image

The template builds its CI image from:

```text
containers/latex-ci/Dockerfile
```

The publishing workflow is:

```text
.github/workflows/publish-latex-ci-image.yml
```

It publishes `ghcr.io/joocheol/latex-book-ci`. Book builds pin the image to an
immutable digest rather than `:latest`.

The image contains the TeX Live toolchain, Python, and build utilities. It does
not contain KoPubWorld files, manuscript sources, figures, or book PDFs. Each
book supplies its own private manuscript assets at checkout time.

## Release boundary

During writing, the `main` workflow artifact is the canonical generated PDF.
A tagged GitHub Release workflow should be added only when a book reaches a
publication milestone. It is not part of the daily manuscript CI.

## Branch protection

When branch protection is enabled, require the single shared Book CI result and
any human editorial approval that the project needs. Remove required checks
that refer to deleted legacy validation or label-based build workflows.
