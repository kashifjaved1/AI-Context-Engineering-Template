---
applyTo: "**"
description: "Repository-wide instructions for GitHub Copilot. Connects Copilot to the canonical AGENTS.md instructions and contextual routing rules."
---

# GitHub Copilot Instructions

> **Primary Source of Truth**: This file delegates to and enforces the rules in [`AGENTS.md`](../AGENTS.md).

## Non-Negotiable Rules

1. **Security & Privacy**:
   - Never generate, output, or store credentials, API keys, tokens, or personal customer data.
   - Never weaken security, authentication, TLS, or CORS protections.

2. **Reuse & Codebase Consistency**:
   - Inspect existing helper functions, data types, and libraries before writing new code.
   - Adhere to existing project architecture, styling, and framework conventions.

3. **Step-by-Step Discipline**:
   - Implement changes in small, logical increments.
   - Add unit or integration tests for all newly added behaviors.
   - Verify changes with existing project build and test commands.

## Navigating Context

- To find documentation relevant to the current file or folder, check [`contextrc.json`](../contextrc.json).
- Review high-level design in [`context/architecture/`](../context/architecture/).
- Review coding and testing rules in [`context/guidelines/`](../context/guidelines/).
- Review recorded architectural decisions in [`context/decisions/`](../context/decisions/).
- Use [`.ai/`](../.ai/) for ephemeral runtime output (diffs, temporary review logs).
