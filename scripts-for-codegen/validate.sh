#!/usr/bin/env bash
set -euo pipefail

<<<<<<< HEAD
if [ $# -lt 2 ]; then
  echo "Usage: $0 <route-url> <language> [guidelines] [file]"
  exit 1
fi

ROUTE_URL="$1"             # e.g. https://react-agent-<ns>.<domain>
LANGUAGE="$2"              # python | go | typescript | ...
GUIDELINES="${3:-PEP8}"
FILE="${4:-${PWD}/__CURRENT_FILE__}"

CODE_JSON=$(jq -Rs . < "$FILE")

PAYLOAD=$(jq -n \
  --arg language "$LANGUAGE" \
  --arg guidelines "$GUIDELINES" \
  --argjson code "$CODE_JSON" \
  '{language:$language, guidelines:$guidelines, code:$code}')

echo "→ Validating $FILE as $LANGUAGE …"
curl -sS -X POST "$ROUTE_URL/agent/validate" \
  -H 'Content-Type: application/json' \
  -d "$PAYLOAD" | tee /tmp/validation.json

echo -e "\n✓ Saved to /tmp/validation.json"

=======
ROUTE="${1:-${AGENT_ROUTE:-${ROUTE:-}}}"
LANG="${2:-${VALIDATE_LANG:-python}}"
CODE="${3:-}"

# If no 3rd arg, read from stdin (selectedText piped from task)
if [[ -z "${CODE}" ]]; then
  if [ ! -t 0 ]; then
    CODE="$(cat)"
  fi
fi

if [[ -z "${ROUTE}" || -z "${LANG}" || -z "${CODE}" ]]; then
  echo "Usage: $0 <ROUTE> <LANG> [CODE]" >&2
  echo "Example: $0 https://react-agent.apps.example.com python \"print('hi')\"" >&2
  exit 1
fi

# Build payload expected by your Flask /agent/validate
payload=$(jq -n --arg code "$CODE" --arg lang "$LANG" \
  '{ language: $lang, code: $code }')

# Call the validation endpoint
curl -fsSL -X POST "${ROUTE%/}/agent/validate" \
  -H "Content-Type: application/json" \
  -d "$payload" \
  | jq -r '.report // .answer // .message // .error // .'
>>>>>>> f735f63 (code and workig devspaces stuff)
