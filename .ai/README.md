# Ephemeral AI Workspace (`.ai/`)

This directory is an **ephemeral working area** for AI coding agents and automated workflows.

## Purpose
- Intermediate file patches (`diff.patch`, `pr.json`, `changed_files.txt`)
- Scratchpad notes, draft outlines, or temporary reasoning files
- Generated review outputs before they are shared or posted

## Rule
- Files in this directory (except this `README.md` and `.gitignore`) are **git-ignored** and should never be committed to source control.
- If an agent generates persistent documentation (such as an Architecture Decision Record or a permanent specification), write it to [`context/decisions/`](../context/decisions/) or [`context/specs/`](../context/specs/) instead.
