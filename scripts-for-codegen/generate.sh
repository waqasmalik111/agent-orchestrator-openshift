#!/usr/bin/env bash
set -euo pipefail
<<<<<<< HEAD

if [ $# -lt 3 ]; then
  echo "Usage: $0 <route-url> <language> <output-dir> [prompt...]"
  exit 1
fi

ROUTE_URL="$1"
LANGUAGE="$2"
OUTDIR="$3"
shift 3
PROMPT="${*:-}"

mkdir -p "$OUTDIR"

case "$LANGUAGE" in
  python|py) EXT="py" ;;
  typescript|ts) EXT="ts" ;;
  javascript|js) EXT="js" ;;
  go) EXT="go" ;;
  *) EXT="txt" ;;
esac

TS="$(date +%Y%m%d-%H%M%S)"
OUTFILE="$OUTDIR/code_${TS}.${EXT}"

PAYLOAD=$(jq -n --arg q "$PROMPT" '{query:$q}')

echo "→ Generating from prompt: $PROMPT"
curl -sS -X POST "$ROUTE_URL/agent/execute" \
  -H 'Content-Type: application/json' \
  -d "$PAYLOAD" \
  | jq -r '.answer // "// (no answer returned)"' > "$OUTFILE"

echo "✓ Saved: $OUTFILE"
sed -n '1,80p' "$OUTFILE" || true

=======
ENV_FILE="${ENV_FILE:-.devspaces.env}"
# shellcheck disable=SC1090
if [ -f "$ENV_FILE" ]; then
  set -a
  . "$ENV_FILE"
  set +a
fi


# Accept ROUTE/LANG from args, or fall back to env (.devspaces.env)
ROUTE="${1:-${AGENT_ROUTE:-${ROUTE:-}}}"
LANG="${2:-${GEN_LANG:-}}"
PROMPT="${3:-}"

if [[ -z "${PROMPT}" ]]; then
  # If no 3rd arg, try to read prompt from STDIN (piped input)
  if [ ! -t 0 ]; then
    PROMPT="$(cat)"
  fi
fi

if [[ -z "${ROUTE}" || -z "${LANG}" || -z "${PROMPT}" ]]; then
  echo "Usage: $0 <ROUTE> <LANG> [PROMPT]" >&2
  echo "Example: $0 https://react-agent.apps.example.com python \"Write a function...\"" >&2
  exit 1
fi

# Debug (optional)
echo "Using ROUTE=${ROUTE} LANG=${LANG}" >&2

# Call your service
curl -fsSL -X POST "${ROUTE}/agent/execute" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg q "$PROMPT" '{query:$q}')" \
  | jq -r '.answer // empty'
>>>>>>> f735f63 (code and workig devspaces stuff)
