# Task Breakdown: {FEATURE TITLE}

- **Spec Link**: [`spec.md`](./spec.template.md)
- **Plan Link**: [`plan.md`](./plan.template.md)

---

## Task List

### Phase 1: Setup & Contracts
- [ ] **Task 1.1**: Define API request/response DTOs and schema validators.
  - *Files*: `src/contracts/...`
  - *Verification*: `npm run test -- contracts`
- [ ] **Task 1.2**: Define domain entity and invariant assertions.
  - *Files*: `src/domain/...`
  - *Verification*: Unit tests in `test/domain/...`

### Phase 2: Core Implementation
- [ ] **Task 2.1**: Implement domain service logic.
  - *Files*: `src/services/...`
  - *Verification*: `npm run test -- services`
- [ ] **Task 2.2**: Integrate persistence repository methods.
  - *Files*: `src/repositories/...`
  - *Verification*: Integration tests with test database

### Phase 3: Integration & Ingress
- [ ] **Task 3.1**: Implement controller routes and authorization guards.
  - *Files*: `src/controllers/...`
  - *Verification*: Integration tests in `test/api/...`
- [ ] **Task 3.2**: Add structured error handling and RFC 7807 problem details.
  - *Files*: `src/middleware/...`
  - *Verification*: Assert 4xx/5xx responses match schema

### Phase 4: Verification & Final Polish
- [ ] **Task 4.1**: Execute full test suite (`npm test` / `dotnet test`).
- [ ] **Task 4.2**: Run linter and formatting checks.
- [ ] **Task 4.3**: Update documentation and context files if necessary.
