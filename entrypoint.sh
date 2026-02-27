#!/bin/bash

# Create/update config.toml from environment variables
cat > /bot/config.toml << EOF
urlbase = "${TARGET_URL:-https://wocabee.app/}"
debug_port = "${DEBUG_PORT:-http://localhost:9222}"
wordlist_file = "${WORDLIST_FILE:-wordlist.json}"
picture_file = "${PICTURE_FILE:-picturelist.json}"
placeholder_words = ${PLACEHOLDER_WORDS:-["translate", "check"]}

[ntfy]
server = "${NTFY_SERVER}"
topic = "${NTFY_TOPIC}"
token = "${NTFY_TOKEN}"
EOF