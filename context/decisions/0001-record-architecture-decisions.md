# ADR 0001: Record Architecture Decisions Using Markdown Records

- **Status**: Accepted
- **Date**: 2026-10-04
- **Author(s)**: Platform Engineering Team
- **Deciders**: Engineering Lead, Platform Architects
- **Consulted**: Development Team, Security Lead

---

## 1. Context and Problem Statement

As software systems evolve, architects and developers make significant technical decisions regarding framework choices, data persistence strategies, API styles, and security controls. Without a structured log of these decisions, the rationale behind them is forgotten over time, leading to:
- Repeated discussions of previously settled topics.
- Inconsistent architectures introduced by new engineers or AI coding agents.
- Accidental regressions of intentional design choices.

We need a lightweight, version-controlled mechanism to document architecture decisions that both human engineers and AI agents can read and respect.

---

## 2. Decision Drivers

- Must live directly alongside the source code in version control.
- Must be easily parsed and understood by both human developers and AI coding agents.
- Low ceremony: minimal friction to create and review.
- Immutable history: once accepted, decisions are not edited in place; subsequent changes create superseding records.

---

## 3. Considered Options

1. **Option 1**: External wiki (Confluence, Notion, SharePoint).
2. **Option 2**: Ad-hoc code comments and README paragraphs.
3. **Option 3**: Architecture Decision Records (ADRs) stored as markdown files in `context/decisions/`.

---

## 4. Decision Outcome

**Chosen Option**: **Option 3 (Markdown ADRs in `context/decisions/`)** because it keeps architectural context co-located with code, enables pull request reviews for technical decisions, and allows AI coding tools to discover the history and constraints of the codebase automatically.

### Positive Consequences
- AI coding agents read these records during the context discovery phase to understand architectural constraints.
- Changes to architecture go through standard code review (PR).
- The historical evolution of the project remains preserved and auditable.

### Negative Consequences / Trade-offs
- Developers must remember to write ADRs for significant architectural changes.
- Outdated decisions must be explicitly marked as superseded rather than deleted.

---

## 5. Pros and Cons of the Options

### Option 1: External Wiki
- Good, because rich formatting and search features are built in.
- Bad, because wikis quickly become out of date, are disconnected from pull requests, and are inaccessible to offline or repository-scoped AI agents.

### Option 2: Ad-hoc Code Comments
- Good, because they are close to the code.
- Bad, because they lack system-wide visibility and are easily lost during refactoring.

### Option 3: Markdown ADRs in Repository
- Good, because version-controlled, PR-reviewed, and immediately discoverable by AI agents.
- Bad, requires disciplined numbering and index maintenance.

---

## 6. Implementation Notes & Follow-up Actions

- [x] Create `context/decisions/adr.template.md` as standard template.
- [x] Integrate ADR discovery instructions into `AGENTS.md` and `contextrc.json`.
- [ ] Add pre-commit or CI check verifying ADR format when new records are added.
