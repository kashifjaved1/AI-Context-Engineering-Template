#!/usr/bin/env bash
# ==============================================================================
# AI Context Engineering Template - Project Initializer (POSIX Bash)
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "=========================================================="
echo "  AI Context Engineering Template - Project Initializer   "
echo "=========================================================="

PROJECT_NAME="${1:-}"
DESCRIPTION="${2:-}"
STACK="${3:-}"

if [ -z "$PROJECT_NAME" ]; then
  read -r -p "Enter Project Name (e.g., billing-service): " PROJECT_NAME
fi

if [ -z "$DESCRIPTION" ]; then
  read -r -p "Enter Brief Description: " DESCRIPTION
fi

if [ -z "$STACK" ]; then
  read -r -p "Enter Primary Tech Stack: " STACK
fi

PROJECT_NAME="${PROJECT_NAME:-my-project}"
DESCRIPTION="${DESCRIPTION:-Project using AI Context Engineering Template}"
STACK="${STACK:-Generic Polyglot}"

echo ""
echo "Configuring project with:"
echo " - Project Name: ${PROJECT_NAME}"
echo " - Description:  ${DESCRIPTION}"
echo " - Tech Stack:   ${STACK}"
echo ""

# 1. Update contextrc.json if jq is available, else sed fallback
CONTEXT_RC="${ROOT_DIR}/contextrc.json"
if [ -f "${CONTEXT_RC}" ]; then
  if command -v jq >/dev/null 2>&1; then
    tmp_json=$(mktemp)
    jq --arg name "$PROJECT_NAME" --arg desc "$DESCRIPTION" \
       '.projectName = $name | .description = $desc' "${CONTEXT_RC}" > "$tmp_json"
    mv "$tmp_json" "${CONTEXT_RC}"
    echo "[OK] Updated contextrc.json with jq."
  else
    # Simple sed replacement for basic key updates
    sed -i.bak -e "s/\"projectName\": \".*\"/\"projectName\": \"${PROJECT_NAME}\"/" "${CONTEXT_RC}" || true
    sed -i.bak -e "s/\"description\": \".*\"/\"description\": \"${DESCRIPTION}\"/" "${CONTEXT_RC}" || true
    rm -f "${CONTEXT_RC}.bak"
    echo "[OK] Updated contextrc.json with sed."
  fi
fi

# 2. Update CLAUDE.md
CLAUDE_FILE="${ROOT_DIR}/CLAUDE.md"
if [ -f "${CLAUDE_FILE}" ]; then
  sed -i.bak -e "s/generic-project-template/${PROJECT_NAME}/g" "${CLAUDE_FILE}" || true
  rm -f "${CLAUDE_FILE}.bak"
  echo "[OK] Configured CLAUDE.md."
fi

# 3. Ensure directories exist
mkdir -p "${ROOT_DIR}/.ai" "${ROOT_DIR}/src" "${ROOT_DIR}/test"
echo "[OK] Verified base .ai/, src/, and test/ directories."

echo ""
echo "Project initialization complete! Next steps:"
echo " 1. Review context/architecture/overview.md to describe your system architecture."
echo " 2. Fill in domain terms in context/domain/glossary.md."
echo " 3. Run './scripts/validate-context.sh' to verify context integrity."
