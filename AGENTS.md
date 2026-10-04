# Agent Instructions & Project Constitution

> **Status:** Canonical Instruction Set  
> **Target Audience:** All AI Coding Agents (Cursor, Claude Code, GitHub Copilot, Antigravity, Windsurf, CLI agents)  
> **Human Rule:** Humans remain accountable for outcomes, code quality, and system safety.

---

## 1. Primary Directives & Invariants

All AI agents interacting with this repository **MUST** adhere to the following non-negotiable rules:

1. **Security & Data Privacy First**:
   - Never output, log, commit, or infer sensitive values (passwords, tokens, API keys, private keys, certificates, customer personal data / PII).
   - If sensitive values are encountered in context, stop and inform the user immediately.
   - Do not weaken authentication, authorization, TLS configs, or cryptographic operations for convenience.

2. **Reuse Existing Patterns & Avoid Duplication**:
   - Always inspect the existing codebase before implementing new solutions.
   - Search for existing shared modules, helpers, data models, and configurations that can fulfill or simplify the task.
   - Do not reinvent existing utilities or create parallel architectural patterns.

3. **Small, Verifiable, and Reversible Steps**:
   - Make minimal, targeted modifications. Prefer additive, backward-compatible updates over large, speculative refactors.
   - For every change, identify the appropriate verification mechanism (tests, linters, builds, or runtime checks).
   - Never assume changes work without verifying against relevant project test suites or linters.

4. **Strict Requirement Adherence**:
   - Fulfill the exact requirements specified by the user without introducing unauthorized scope creep, extra dependencies, or unrelated changes.
   - When requirements are ambiguous or incomplete, ask clarifying questions rather than guessing.

5. **Safe Shell & Command Execution**:
   - Never execute destructive commands (e.g., recursive deletions outside temp folders, hard git resets, force pushes, or raw drop-table scripts) without explicit user authorization.
   - Do not commit or push to remote Git repositories without explicit user instruction.

---

## 2. Context Discovery & Routing Protocol

Agents should navigate project context systematically rather than reading every file:

```
[User Request]
       │
       ▼
1. Consult Root Instructions (AGENTS.md)
       │
       ▼
2. Check Context Routing Manifest (contextrc.json)
       │
       ▼
3. Read Scoped Architectural Guidance (context/ & docs/)
       │
       ▼
4. Formulate Plan & Validate Against Domain Invariants (context/domain/)
       │
       ▼
5. Execute Changes Step-by-Step with Verification
```

- **Universal Rules**: This file (`AGENTS.md`).
- **Context Routing Manifest**: [`contextrc.json`](./contextrc.json) maps target directories and file paths to their relevant design documents, schemas, and guidelines.
- **Architectural & Design Guidance**: Located in [`context/architecture/`](./context/architecture/) and [`context/guidelines/`](./context/guidelines/).
- **Domain Invariants & Ubiquitous Language**: Located in [`context/domain/`](./context/domain/).
- **Historical Decisions**: Check Architecture Decision Records in [`context/decisions/`](./context/decisions/).
- **Ephemeral Workspaces**: Use [`.ai/`](./.ai/) for transient files (patches, temporary review artifacts, scratchpad notes). Do not commit transient artifacts.

---

## 3. Workflow for Implementing Features & Fixes

When assigned a non-trivial task (bug fix, new endpoint, feature, or refactor), follow this structured lifecycle:

1. **Investigate & Clarify**:
   - Read relevant existing code and tests.
   - Formulate clear understanding of existing behavior and target behavior.
   - Check existing ADRs or domain models.

2. **Plan & Confirm**:
   - Produce a concise summary of the proposed changes.
   - Identify affected modules, interfaces, and test requirements.
   - If user interaction is enabled, verify the plan before applying code modifications.

3. **Implement Incrementally**:
   - Apply edits cleanly to existing files.
   - Follow project style guides, typing discipline, and naming conventions.
   - Add educational/explanatory comments only where non-obvious rationale is required.

4. **Verify**:
   - Run relevant test suites and static analysis tools.
   - Ensure no regressions are introduced.

5. **Explain Completed Changes**:
   - Clearly summarize what was modified, why it was modified, and how it was verified.
   - Highlight any follow-up actions or deployment considerations.

---

## 4. Operation Modes

Depending on user settings and context, agents operate in one of two modes:

### Mode A: Strict Read-Only (Analysis Mode)
- **Permissions**: Inspect files, search code, run read-only queries, analyze dependencies, and formulate plans.
- **Restrictions**: Do not write, edit, delete, or rename files. Do not run commands that alter disk or database state.
- **Goal**: Provide accurate diagnosis, architectural reviews, or proposed plans.

### Mode B: Active Modification (Build Mode)
- **Permissions**: Apply changes authorized by the user.
- **Restrictions**: Modify only files directly relevant to the approved task.
- **Goal**: Deliver precise, tested, production-grade implementations.

---

## 5. Coding & Architecture Invariants

- **Separation of Concerns**: Keep business logic decoupled from presentation layers and transport adapters.
- **Deterministic Error Handling**: Use structured, standard error responses (e.g., Problem Details, domain result types) rather than generic unhandled exceptions.
- **Observability**: Ensure meaningful operations emit structured logs with relevant correlation context, without logging sensitive data.
- **Zero Broken Links**: Keep documentation, file references, and links up to date when moving or refactoring components.
