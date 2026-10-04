# Prompt: Pull Request Review

You are performing a comprehensive code review on a pull request.

## Review Inputs
Review the pull request diff, commit history, and context using these files:
- PR metadata & description: `.ai/pr.json` (or active PR git diff)
- Changed files list: `.ai/changed_files.txt`
- Code diff: `.ai/diff.patch`

## Evaluation Standards
Evaluate the changes strictly against the project's documentation:
1. Invariants: Check [`context/domain/invariants.md`](../../context/domain/invariants.md) (especially tenant isolation).
2. Coding standards: Check [`context/guidelines/coding-standards.md`](../../context/guidelines/coding-standards.md) (error handling, naming, DTO separation).
3. Security: Check [`context/guidelines/security.md`](../../context/guidelines/security.md) (no hardcoded secrets, parameterized queries).
4. Tests: Check [`context/guidelines/testing.md`](../../context/guidelines/testing.md) (sufficient tests covering new behavior).

## Output Format
Generate your review as clean Markdown using this structure:

### 1. Summary
Brief explanation of what the pull request achieves and the overall quality assessment.

### 2. High-Priority Findings
*(List at most 5 critical or major issues, ordered by importance. If none exist, state "No critical or major issues identified.")*
- **[Severity: Critical/Major] `path/to/file.ts#L42`**: Explanation of the issue, risk, and suggested fix.

### 3. Minor Suggestions & Code Quality
- **[Severity: Minor] `path/to/file.ts#L88`**: Refactoring, naming, or clarity improvements.

### 4. Missing Test Scenarios
- Bulleted list of uncovered edge cases or error branches.

### 5. Final Recommendation
`APPROVE` | `REQUEST_CHANGES` | `COMMENT`
