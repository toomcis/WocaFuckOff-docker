#!/bin/bash
set -e

# Helper: remove surrounding quotes if present
strip_quotes() {
    echo "$1" | sed 's/^"\(.*\)"$/\1/'
}

# --- Main Configuration Variables ---
TARGET_URL=$(strip_quotes "${TARGET_URL:-https://wocabee.app}")
DEBUG_PORT=$(strip_quotes "${DEBUG_PORT:-http://localhost:9222}")
WORDLIST_FILE=$(strip_quotes "${WORDLIST_FILE:-wordlist.json}")
PICTURE_FILE=$(strip_quotes "${PICTURE_FILE:-picturelist.json}")

# Placeholder words as TOML array
if [ -z "$PLACEHOLDER_WORDS" ]; then
    PLACEHOLDER_WORDS='["","translate","check"]'
else
    # Split by comma, trim spaces, quote each element
    PLACEHOLDER_WORDS=$(echo "$PLACEHOLDER_WORDS" | tr ',' '\n' | sed 's/^\s*//;s/\s*$//' | awk '{printf "\"%s\",",$0}' | sed 's/,$//')
    PLACEHOLDER_WORDS="[$PLACEHOLDER_WORDS]"
fi

# NTFY settings (can be empty)
NTFY_SERVER=$(strip_quotes "${NTFY_SERVER:-}")
NTFY_TOPIC=$(strip_quotes "${NTFY_TOPIC:-}")
NTFY_TOKEN=$(strip_quotes "${NTFY_TOKEN:-}")

# --- Write config.toml ---
cat > /bot/config.toml << EOF
urlbase = "$TARGET_URL"
debug_port = "$DEBUG_PORT"
wordlist_file = "$WORDLIST_FILE"
picture_file = "$PICTURE_FILE"
placeholder_words = $PLACEHOLDER_WORDS

[ntfy]
server = "$NTFY_SERVER"
topic  = "$NTFY_TOPIC"
token  = "$NTFY_TOKEN"
EOF

echo "--- Generated config.toml ---"
cat /bot/config.toml
echo "----------------------------"

# Forward arguments to CMD
exec "$@"