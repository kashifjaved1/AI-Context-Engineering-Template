#!/usr/bin/env bash
# ==============================================================================
# Generate Repository Map for AI Context (POSIX Bash)
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

OUTPUT_FILE="${1:-}"

generate_tree() {
  echo "# Repository Map for AI Context"
  echo "# Generated: $(date -u +"%Y-%m-%d %H:%M:%SZ")"
  echo "# Root: $(basename "${ROOT_DIR}")"
  echo ""

  if command -v tree >/dev/null 2>&1; then
    tree -a -I '.git|node_modules|dist|build|bin|obj|out|.venv|venv|.idea|.vscode|.ai' --dirsfirst "${ROOT_DIR}"
  else
    find "${ROOT_DIR}" -maxdepth 4 \
      -not -path '*/.*' \
      -not -path '*/node_modules*' \
      -not -path '*/dist*' \
      -not -path '*/build*' \
      -not -path '*/bin*' \
      -not -path '*/obj*' \
      | sort
  fi
}

if [ -n "${OUTPUT_FILE}" ]; then
  mkdir -p "$(dirname "${OUTPUT_FILE}")"
  generate_tree > "${OUTPUT_FILE}"
  echo "[OK] Repository map written to ${OUTPUT_FILE}"
else
  generate_tree
fi
