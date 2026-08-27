# Getting Started

This guide creates a new LaTeX book repository that uses the shared platform.

## Prerequisites

Install:

- Git,
- Git LFS,
- VS Code,
- LaTeX Workshop,
- XeLaTeX and `latexmk` for local builds.

The Dev Container can provide the TeX toolchain when local installation is not desired.

## Create the book repository

Create an empty GitHub repository, then clone it:

```bash
git clone https://github.com/OWNER/BOOK.git
cd BOOK
```

Create the first commit if the repository is empty:

```bash
printf '# BOOK\n' > README.md
git add README.md
git commit -m "Initialize book repository"
git push -u origin main
```

## Add the shared platform

Register the template repository:

```bash
git remote add book-template \
  https://github.com/Joocheol/latex-book-template.git

git fetch book-template
```

Add it as a subtree:

```bash
git subtree add \
  --prefix=book-template \
  book-template main \
  --squash
```

## Create the project wrappers

`preamble.tex`:

```latex
\input{book-template/latex/common-preamble.tex}
```

`scripts/build.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail
exec bash book-template/scripts/build.sh
```

`scripts/validate.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail
exec bash book-template/scripts/validate.sh
```

Make the wrapper scripts executable:

```bash
chmod +x scripts/build.sh scripts/validate.sh
```

## Connect editor and container settings

Use the shared VS Code settings:

```bash
mkdir -p .vscode
ln -s ../book-template/vscode/settings.json .vscode/settings.json
ln -s ../book-template/vscode/extensions.json .vscode/extensions.json
```

Create `.devcontainer/devcontainer.json` with a book-specific name and the shared Dockerfile:

```json
{
  "name": "BOOK LaTeX",
  "build": {
    "dockerfile": "../book-template/devcontainer/Dockerfile",
    "context": ".."
  },
  "remoteUser": "vscode",
  "customizations": {
    "vscode": {
      "extensions": [
        "james-yu.latex-workshop",
        "streetsidesoftware.code-spell-checker"
      ]
    }
  },
  "postCreateCommand": "bash scripts/build.sh",
  "waitFor": "postCreateCommand"
}
```

## Add the minimum manuscript files

A book repository should contain at least:

```text
main.tex
preamble.tex
references.bib
chapters/
figures/
fonts/
scripts/build.sh
scripts/validate.sh
```

The six KoPubWorld Pro OTF files belong in `fonts/` when the common preamble requires them.

## Validate and build

```bash
bash scripts/validate.sh
bash scripts/build.sh
open main.pdf        # macOS
```

## First commit

```bash
git add .
git commit -m "Adopt shared LaTeX book platform"
git push
```

After this point, edit shared infrastructure only in `latex-book-template`. Edit book content only in the book repository.
