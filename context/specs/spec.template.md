# Feature Specification: {FEATURE TITLE}

- **Feature ID**: `feat-{kebab-case-name}` (e.g., `feat-tenant-api-rate-limiting`)
- **Status**: Draft | Under Review | Approved | Implemented
- **Author**: {Name / Role}
- **Date**: YYYY-MM-DD

---

## 1. Problem Statement & User Story

### Problem
{Describe what problem this feature solves. What are the symptoms of not having it?}

### User Story
> **As a** {type of user, e.g., platform administrator}  
> **I want** {capability, e.g., to configure per-tenant rate limits}  
> **So that** {benefit, e.g., noisy-neighbor tenants cannot exhaust API Gateway resources}

---

## 2. Scope & Boundaries

### In Scope
- [ ] {Item 1: e.g., Redis-backed sliding window rate limiter middleware}
- [ ] {Item 2: e.g., Configuration endpoint to update tenant limit tiers}
- [ ] {Item 3: e.g., Standard HTTP 429 response with Retry-After header}

### Out of Scope
- [ ] {Explicit non-goal 1: e.g., Custom per-IP rate limiting (tenant-level only)}
- [ ] {Explicit non-goal 2: e.g., Billing tier integration (handled in phase 2)}

---

## 3. Acceptance Criteria & Test Scenarios

### Scenario 1: Request within allowed limit
- **Given**: Tenant `ten_acme` has a limit of 100 requests per minute and has sent 50 requests.
- **When**: A new authenticated request arrives.
- **Then**: The request is allowed through, and `X-RateLimit-Remaining: 49` is returned.

### Scenario 2: Request exceeding allowed limit
- **Given**: Tenant `ten_acme` has exceeded their limit of 100 requests in the current window.
- **When**: A new authenticated request arrives.
- **Then**: The system immediately returns `HTTP 429 Too Many Requests`.
- **And**: Response body conforms to Problem Details RFC 7807 with code `TENANT_RATE_LIMIT_EXCEEDED`.
- **And**: Includes header `Retry-After: {seconds}`.

---

## 4. API & Schema Impact

### New / Modified Endpoints
`GET /api/v1/admin/tenants/{tenantId}/rate-limit`

#### Sample Response Payload:
```json
{
  "tenantId": "ten_acme",
  "tier": "standard",
  "requestsPerMinute": 100,
  "currentUsage": 51,
  "windowResetAt": "2026-10-04T17:05:00Z"
}
```

---

## 5. Security & Invariant Checklist

- [ ] Does this feature preserve tenant isolation? (Yes/No)
- [ ] Does it introduce any unauthenticated endpoints? (Yes/No)
- [ ] Are all inputs validated at the boundary? (Yes/No)
- [ ] Are sensitive tokens or customer details excluded from logs? (Yes/No)
