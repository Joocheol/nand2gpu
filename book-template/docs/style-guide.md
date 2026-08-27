# Book Source Style Guide

## File organization

Use predictable paths:

```text
chapters/chapter01.tex
chapters/chapter02.tex
figures/ch01-*.tex
figures/ch02-*.tex
```

Keep one primary chapter per file. Put reusable project-specific layout code under `styles/`.

## Labels

Use a stable prefix and chapter number.

```text
chap:ch08-gbm
sec:ch08-risk-neutral
fig:ch08-sample-paths
tab:ch08-parameters
eq:ch08-gbm-solution
```

Do not encode page numbers or temporary section numbers in labels.

## Equations

Label equations that are referenced later or form part of the book's conceptual structure.

```latex
\begin{equation}
  ...
  \label{eq:ch08-gbm-solution}
\end{equation}
```

Avoid labels on disposable intermediate algebra.

## Figures

A figure should have:

- one clear teaching purpose,
- readable labels at final print size,
- a caption that states what the reader should notice,
- a stable label,
- no overlaps or content outside the text width.

Prefer source-controlled TikZ figures when practical. Keep generated source data when a figure is based on computation.

## Tables

Use `booktabs` conventions. Avoid vertical rules unless the table communicates a matrix-like structure where they are essential.

Align decimals and units consistently. State units in the heading rather than repeating them in every cell.

## Terminology

Choose one term and use it consistently across:

- prose,
- equations,
- figures,
- tables,
- exercises,
- solutions,
- outline and index.

Record deliberate terminology choices in a project writing guide when they are not obvious.

## Citations

Use explicit citations near the claim they support. Avoid `\nocite{*}` in finished manuscripts.

Every bibliography entry should be used or deliberately retained for a documented reason.

## Index

Index concepts at the point where they are explained, not at every occurrence.

Use consistent forms for Korean and English terminology.

## Code

Code shown in the book should be:

- executable or clearly marked as pseudocode,
- tested against the stated software version,
- short enough to support the explanation,
- linked to a complete companion file when abbreviated.

Fix random seeds and document parameters for numerical results.

## Warnings and diagnostics

A successful build may still contain layout or reference warnings.

Before release, inspect:

- undefined references,
- undefined citations,
- multiply defined labels,
- significant overfull boxes,
- font substitutions,
- broken PDF bookmarks,
- missing glyphs.

Not every underfull box is an error, but recurring warnings should be reviewed.

## Shared versus book-specific code

Put a feature in the shared template only when it is useful across multiple books and does not depend on manuscript content.

Keep book-specific typography exceptions, validation rules, data, figures, and terminology in the book repository.
