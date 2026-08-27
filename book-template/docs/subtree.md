# Git Subtree Workflow

## Why subtree

Each book stores a complete copy of the shared platform under `book-template/`.
A normal clone therefore contains everything required to build the book.

This avoids the extra initialization step required by Git submodules and works well across local Macs, Codespaces, Dev Containers, archives, and GitHub Actions.

## Initial setup

```bash
git remote add book-template \
  https://github.com/Joocheol/latex-book-template.git

git fetch book-template

git subtree add \
  --prefix=book-template \
  book-template main \
  --squash
```

`--squash` records the imported template history as a compact pair of commits in the book repository.

## Pulling an update

The working tree must be clean.

```bash
git status -sb
git fetch book-template

git subtree pull \
  --prefix=book-template \
  book-template main \
  --squash
```

Then run:

```bash
bash scripts/validate.sh
bash scripts/build.sh
```

Commit and push only after both commands succeed.

## Working tree modifications

If `git subtree pull` reports:

```text
fatal: working tree has modifications. Cannot add.
```

Either commit the work or temporarily store it:

```bash
git stash push -u -m "before template update"
git subtree pull --prefix=book-template book-template main --squash
git stash pop
```

Resolve conflicts before continuing.

## Conflict policy

Shared files inside `book-template/` should normally match the template repository. Book-specific changes belong outside the subtree.

When a conflict occurs:

1. keep the upstream version for shared infrastructure,
2. move necessary book-specific behavior into a wrapper or project file,
3. run validation and a complete build,
4. document any deliberate exception.

## Do not edit the imported copy

Avoid direct changes to:

```text
BOOK/book-template/
```

Make the change in `latex-book-template`, push it, and then pull it into every book.

## Pushing subtree changes upstream

`git subtree push` exists, but it is not the preferred workflow for this platform. Direct work in the template repository keeps review history and ownership clear.

## Checking the imported version

The most recent subtree merge appears in the book history:

```bash
git log --oneline --decorate --grep='book-template' -n 10
```

To compare the imported copy with the template repository:

```bash
git fetch book-template
git diff book-template/main -- book-template/
```

Because paths differ between the two repositories, this comparison is mainly useful for inspection. The reliable update mechanism remains `git subtree pull`.
