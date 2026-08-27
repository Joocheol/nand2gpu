# Changelog

All notable changes to the shared book platform are recorded here.

The format follows Keep a Changelog principles. Platform releases should use semantic version tags when books need reproducible infrastructure references.

## Unreleased

### Added

- shared XeLaTeX preamble based on STIX Two and KoPubWorld Pro,
- shared Dev Container Dockerfile,
- common build and validation scripts,
- reusable GitHub Actions PDF build workflow,
- shared VS Code settings and extension recommendations,
- `.editorconfig`,
- `git subtree` distribution model,
- architecture, onboarding, update, CI, and source-style documentation,
- `update-template.sh` helper,
- `doctor.sh` diagnostics helper.

### Changed

- build output messages now derive the book project name automatically,
- project repositories use thin wrappers around shared scripts and preamble files.

## 0.1.0 - 2026-08-04

### Added

- initial shared infrastructure extracted from FEB and EconMath,
- first working subtree integration in both book repositories.
