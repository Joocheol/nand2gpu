# Updating the Shared Platform

## Principle

Shared infrastructure is changed once in `latex-book-template` and then imported into each book repository.

Do not make the same infrastructure edit independently in FEB, EconMath, or another book.

## Update the template

```bash
cd ~/Documents/GitHub/latex-book-template
git switch main
git pull --ff-only
git status -sb
```

Edit the shared files, then run appropriate checks:

```bash
bash -n scripts/build.sh
bash -n scripts/validate.sh
git diff --check
```

Commit and push:

```bash
git add .
git commit -m "Describe the platform change"
git push
```

## Update a book

From a clean book repository:

```bash
git fetch book-template

git subtree pull \
  --prefix=book-template \
  book-template main \
  --squash
```

Then test the book:

```bash
bash scripts/validate.sh
bash scripts/build.sh
```

Review the generated PDF before committing a typography or layout change.

```bash
git status -sb
git diff --check
git push
```

## Recommended rollout order

For changes that can affect output:

1. update `latex-book-template`,
2. import into the smaller or faster-building book,
3. validate and inspect its PDF,
4. import into the larger book,
5. run its project-specific QA and complete build,
6. push both books.

This reduces the cost of finding a template regression.

## Changes that require visual inspection

Always inspect PDFs after changes to:

- fonts,
- page geometry,
- headings,
- headers and footers,
- theorem or box environments,
- TikZ defaults,
- bibliography layout,
- index layout,
- line spacing or paragraph spacing.

A successful compilation does not prove that the page layout is acceptable.

## Changes that require Dev Container rebuild

Rebuild the container after changes to:

- `devcontainer/Dockerfile`,
- TeX Live package installation,
- system fonts,
- Git LFS setup,
- OS-level command dependencies.

In VS Code use:

```text
Dev Containers: Rebuild and Reopen in Container
```

## Rollback

If a template update breaks a book, do not edit the imported subtree as a permanent fix.

Either:

1. fix the template and pull the new correction, or
2. revert the subtree merge commit in the book.

Before rollback, record the failing command and error so the root cause can be repaired centrally.
