#!/usr/bin/env bash
# SessionStart hook for xSpec workflow
# Injects using-xspec skill into conversation context alongside superpowers

set -euo pipefail

# Determine plugin root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Read using-xspec content
using_xspec_content=$(cat "${PLUGIN_ROOT}/skills/using-xspec/SKILL.md" 2>&1 || echo "Error reading using-xspec skill")

# Escape string for JSON embedding
escape_for_json() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\r'/\\r}"
    s="${s//$'\t'/\\t}"
    printf '%s' "$s"
}

using_xspec_escaped=$(escape_for_json "$using_xspec_content")

# Output context injection as JSON
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "<EXTREMELY_IMPORTANT>\nYou have xSpec capabilities for PRD-driven product-engineering workflow.\n\n**Below is the full content of your 'using-xspec' skill - your guide to the xSpec workflow:**\n\n${using_xspec_escaped}\n</EXTREMELY_IMPORTANT>"
  }
}
EOF

exit 0
