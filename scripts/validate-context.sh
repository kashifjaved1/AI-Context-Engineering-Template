#!/usr/bin/env bash
# ==============================================================================
# AI Context Health & Integrity Validator (POSIX Bash)
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "=========================================================="
echo "         AI Context Health & Integrity Validator          "
echo "=========================================================="

TOTAL_ERRORS=0
TOTAL_WARNINGS=0

# Check 1: validate contextrc.json
echo ""
echo "[Check 1/4] Validating contextrc.json..."
CONTEXT_RC="${ROOT_DIR}/contextrc.json"

if [ ! -f "${CONTEXT_RC}" ]; then
  echo " [FAIL] contextrc.json not found at repository root!"
  TOTAL_ERRORS=$((TOTAL_ERRORS + 1))
else
  if command -v jq >/dev/null 2>&1; then
    if jq . "${CONTEXT_RC}" >/dev/null 2>&1; then
      echo " [PASS] contextrc.json is valid JSON."
    else
      echo " [FAIL] Invalid JSON syntax in contextrc.json"
      TOTAL_ERRORS=$((TOTAL_ERRORS + 1))
    fi
  else
    echo " [PASS] contextrc.json exists (install jq for deeper validation)."
  fi
fi

# Check 2: Check canonical instruction files
echo ""
echo "[Check 2/4] Verifying canonical instruction anchors..."
for f in "AGENTS.md" "CLAUDE.md" ".cursorrules" ".github/copilot-instructions.md"; do
  if [ ! -f "${ROOT_DIR}/${f}" ]; then
    echo " [FAIL] Missing core agent connector: ${f}"
    TOTAL_ERRORS=$((TOTAL_ERRORS + 1))
  fi
done
if [ "$TOTAL_ERRORS" -eq 0 ]; then
  echo " [PASS] All canonical agent connectors present."
fi

# Check 3: Check context directory structure
echo ""
echo "[Check 3/4] Verifying context structure..."
for d in "context/architecture" "context/decisions" "context/domain" "context/guidelines" "context/specs"; do
  if [ ! -d "${ROOT_DIR}/${d}" ]; then
    echo " [FAIL] Missing expected directory: ${d}"
    TOTAL_ERRORS=$((TOTAL_ERRORS + 1))
  fi
done
if [ "$TOTAL_ERRORS" -eq 0 ]; then
  echo " [PASS] Core context directory structure verified."
fi

# Summary
echo ""
echo "=========================================================="
if [ "$TOTAL_ERRORS" -eq 0 ]; then
  echo " Health Check Result: PASSED"
  echo "=========================================================="
  exit 0
else
  echo " Health Check Result: FAILED (${TOTAL_ERRORS} Errors)"
  echo "=========================================================="
  exit 1
fi
