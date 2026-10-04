# Claude Code Guidelines & Configuration

This repository uses a structured Context Engineering architecture.

## Primary Instructions

For all behavioral rules, architectural invariants, and security guidelines, refer to the canonical project instructions:
👉 **[`AGENTS.md`](./AGENTS.md)**

## Essential Project Commands

> *Customized per project during setup:*

- **Build**: Run project build command (e.g., `npm run build`, `dotnet build`, `make`)
- **Test**: Run test suite (e.g., `npm test`, `pytest`, `dotnet test`)
- **Lint / Format**: Run static checks (e.g., `npm run lint`, `flake8`, `golangci-lint`)
- **Context Validation**: `pwsh ./scripts/validate-context.ps1` (or `./scripts/validate-context.sh`)

## Context Discovery Protocol

1. Before starting a task, check [`contextrc.json`](./contextrc.json) to locate relevant domain documentation.
2. Review architecture principles in [`context/architecture/`](./context/architecture/).
3. Review coding conventions in [`context/guidelines/`](./context/guidelines/).
4. Check existing decisions in [`context/decisions/`](./context/decisions/).
5. Keep temporary files and scratch notes in [`.ai/`](./.ai/) (which is git-ignored).

## Operating Rules for Claude Code

- Always verify existing codebase patterns before proposing or writing code.
- Keep diffs small, focused, and directly tied to the user request.
- Run tests and linters to verify your changes before declaring completion.
