# Pre-Merge Quality & Verification Checklist

> **Agent Instruction**: Complete this checklist before requesting review or declaring a task complete.

---

## 1. Correctness & Requirements
- [ ] Meets all stated acceptance criteria in the specification.
- [ ] No unintended side effects or scope creep outside the task requirements.
- [ ] Existing codebase utilities were reused where applicable (no duplicate helpers).

---

## 2. Testing & Verification
- [ ] Unit tests added for all new business logic and validation rules.
- [ ] Integration tests cover boundary conditions and error status codes.
- [ ] All tests pass cleanly (`npm test`, `dotnet test`, `pytest`, etc.).
- [ ] Test names follow the `should [result] when [condition]` convention.

---

## 3. Security & Safety
- [ ] No hardcoded secrets, API keys, or credentials in code or git diff.
- [ ] Multi-tenancy invariants respected (tenant scoping verified in all queries).
- [ ] User input sanitized and parameterized (zero raw SQL or unescaped HTML).
- [ ] Logs contain correlation IDs and no sensitive PII or bearer tokens.

---

## 4. Code Quality & Standards
- [ ] Code follows project naming and architectural layer conventions.
- [ ] Structured errors conform to standard format (e.g. RFC 7807 Problem Details).
- [ ] Static analysis / linting passes without warnings (`npm run lint`, `dotnet format`).
- [ ] All new files have proper directory placement per [`contextrc.json`](../../contextrc.json).

---

## 5. Documentation
- [ ] New endpoints, CLI commands, or environment variables documented.
- [ ] ADR created in `context/decisions/` if a major architectural choice was made.
- [ ] Context documentation updated if domain concepts or invariants changed.
