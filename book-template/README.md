# LaTeX Book Platform

Shared publishing infrastructure for long-form LaTeX book projects.

Currently used by:

- FEB — 『금융공학의 이해』
- EconMath — 『경제학을 만든 수학』
- RiskNumber — 『위험은 어떻게 숫자가 되는가』

## What this repository provides

- cross-platform XeLaTeX typography and fonts,
- shared page, theorem, box, code, bibliography, and index styles,
- a reproducible build script,
- repository validation and book diagnostics,
- a common Dev Container toolchain,
- shared VS Code settings and recommended extensions,
- one reusable GitHub Actions workflow for validation and PDF builds,
- documented `git subtree` distribution.

## Architecture

Each book imports this repository under:

```text
book-template/
```

The book keeps its manuscript and project-specific QA outside that directory.
Small wrappers delegate to the shared implementation:

```text
preamble.tex          -> book-template/latex/common-preamble.tex
scripts/build.sh      -> book-template/scripts/build.sh
scripts/validate.sh   -> book-template/scripts/validate.sh
.vscode/settings.json -> book-template/vscode/settings.json
```

See [Architecture](docs/architecture.md) for the responsibility boundaries.

## Daily writing command

The normal local workflow has one command:

```bash
bash scripts/build.sh
```

GitHub CI performs validation and a complete PDF build automatically for every
pull request update and every push to `main`. Authors do not need to choose a
special build label or run a separate CI workflow.

The following commands are diagnostic or maintenance tools, not normal writing
steps:

```bash
bash scripts/validate.sh
bash book-template/scripts/doctor.sh
bash book-template/scripts/update-template.sh
```

Platform updates are exceptional maintenance. They require a clean working
tree, a complete build, and visual inspection in all affected books.

## Documentation

- [Architecture](docs/architecture.md)
- [Getting started](docs/getting-started.md)
- [Git subtree workflow](docs/subtree.md)
- [Updating the platform](docs/update.md)
- [Continuous integration](docs/ci.md)
- [Source style guide](docs/style-guide.md)

## Development rules

1. Edit shared infrastructure only in this repository.
2. Do not directly edit a book's imported `book-template/` copy.
3. Keep manuscript content and book-specific QA in each book repository.
4. Keep each book's CI caller minimal and identical.
5. Run a complete build and inspect PDFs after an intentional platform change.
6. Do not update the platform merely to obtain minor speed or convenience gains.

## Reusable CI

Every book uses one caller workflow for pull requests, `main`, and manual runs:

```yaml
jobs:
  build:
    uses: Joocheol/latex-book-template/.github/workflows/book-ci.yml@COMMIT_SHA
    with:
      artifact_name: book-pdf
      retention_days: 7
```

Pin the workflow to a reviewed commit SHA. The reusable workflow runs the
book's own `scripts/validate.sh`, so manuscript-specific semantic and numerical
checks stay in the book repository without requiring another workflow.

### Prebuilt CI image

The template publishes a XeLaTeX toolchain that excludes KoPubWorld and other
manuscript-specific fonts from `containers/latex-ci/Dockerfile` to:

```text
ghcr.io/joocheol/latex-book-ci
```

The package is public and can be pulled without authentication, including from
private book repositories. KoPubWorld files and manuscript assets remain in
each book repository. Publication builds pin the image to an immutable digest.

## Stability policy

The current platform is the frozen writing environment for the three books.
Further changes should be limited to demonstrated build failures, required
GitHub platform migrations, or publication-critical defects.

## License

This project is available under the [MIT License](LICENSE).
