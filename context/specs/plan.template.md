# Implementation Plan: {FEATURE OR TASK TITLE}

- **Spec Reference**: [`context/specs/{feat-name}/spec.md`](./spec.template.md)
- **Status**: Draft | Approved | In Progress | Completed
- **Target Release**: {e.g., v1.2.0 / Sprint 42}

---

## 1. Technical Approach & Design

### Summary
{Summarize the implementation strategy in 2-3 sentences. How will the components interact?}

### Affected Components
- [ ] Ingress / Gateway: `{file or module path}`
- [ ] Core Services: `{file or module path}`
- [ ] Persistence / Migrations: `{file or module path}`
- [ ] Tests: `{test file path}`

---

## 2. Phased Execution Steps

### Phase 1: Data Model & Contracts
1. Create or update domain models and data transfer objects (DTOs).
2. Write unit tests verifying model validation and invariants.
3. Review against [`context/domain/invariants.md`](../domain/invariants.md).

### Phase 2: Core Domain Logic
1. Implement business logic and service handlers.
2. Ensure cancellation tokens and timeouts are properly wired.
3. Verify with domain unit tests (mock external boundaries only).

### Phase 3: External Endpoints & Middleware
1. Wire HTTP/gRPC controllers and validation pipes.
2. Return standard `ProblemDetails` error responses for failure cases.
3. Add integration tests verifying end-to-end endpoint behavior.

### Phase 4: Observability & Documentation
1. Add structured telemetry (metrics, traces, and sanitized logs).
2. Update relevant `context/` or `docs/` records.
3. Add ADR to `context/decisions/` if a significant architecture decision was made.

---

## 3. Risk Assessment & Rollback Strategy

| Risk | Severity | Mitigation Strategy |
| :--- | :--- | :--- |
| **High latency from external dependency** | Medium | Implement circuit breaker and fallback cache. |
| **Breaking API contract change** | High | Version endpoint (`/v2/`) or keep additive changes. |
| **Data migration failure on deploy** | High | Write backward-compatible, additive database migrations. |

### Rollback Plan
- **Application Code**: Standard container/binary rollback to previous release tag.
- **Database**: Ensure migrations are non-destructive (do not drop columns in the same release as code deployment).
