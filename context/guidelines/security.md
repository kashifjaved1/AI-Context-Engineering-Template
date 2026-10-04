# Security Guidelines & Guardrails

> **Agent Instruction**: Security is a non-negotiable invariant. Pay special attention to OWASP Top 10 vulnerabilities, credential protection, and tenant data isolation.

---

## 1. Secrets & Credentials Policy

1. **Zero Hardcoded Secrets**:
   - Never embed API keys, secrets, private keys, database passwords, or JWT secrets in code or commits.
   - Use environment variables or designated secret management vaults (e.g., AWS Secrets Manager, Azure Key Vault, HashiCorp Vault).
   - In local development, use git-ignored `.env` files matching `.env.example`.

2. **Log Redaction & Data Sanitization**:
   - Sanitize all log payloads.
   - Prohibited in logs: Authorization headers, JWT tokens, credit card numbers (PAN/CVV), plain passwords, session cookies, sensitive PII.

---

## 2. Ingress & Injection Defense

### SQL & NoSQL Injection Prevention
- Always use parameterized queries or ORM query builders.
- Raw string interpolation inside queries is prohibited.

#### ❌ Bad (Vulnerable to SQL Injection):
```typescript
const query = `SELECT * FROM users WHERE email = '${userSuppliedEmail}'`;
```

#### ✅ Good (Parameterized Query):
```typescript
const query = `SELECT * FROM users WHERE email = $1`;
const result = await db.query(query, [userSuppliedEmail]);
```

### Cross-Site Scripting (XSS)
- Sanitize and HTML-encode any user-generated content before rendering.
- Ensure appropriate Content-Security-Policy (CSP) headers are returned by web endpoints.

---

## 3. Authentication & Authorization Boundaries

1. **Verify Token Claims at Every Boundary**:
   - Do not trust unverified client headers (such as `X-User-Id` or `X-Tenant-Id`) sent from public clients.
   - The API Gateway or auth middleware must parse and cryptographically verify the JWT signature, then set trusted downstream headers.

2. **Defense in Depth**:
   - Enforce authorization checks in both controller entrypoints and core domain service methods.
   - Use role-based (RBAC) or attribute-based (ABAC) permission evaluators rather than hardcoded role names.
