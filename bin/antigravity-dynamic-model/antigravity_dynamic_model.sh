#!/usr/bin/env bash
set -euo pipefail

# Paths
CONFIG_DIR="$HOME/.gemini/antigravity-cli"
BRAIN_DIR="$CONFIG_DIR/brain/6ea201fe-7f72-479d-9ea7-c7ba2f2fb846"
QUOTA_FILE="$BRAIN_DIR/model_quota.json"
SETTINGS_FILE="$CONFIG_DIR/settings.json"

# Ensure jq is available
if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required but not installed. Please install jq (e.g., brew install jq)." >&2
  exit 1
fi

# Select the highest‑priority model that still has quota remaining
selected=$(jq -r '.models[] | select(.used < .quota) | .name' "$QUOTA_FILE" | head -n 1)
if [[ -z "$selected" ]]; then
  echo "No model with remaining quota found. Exiting." >&2
  exit 1
fi

# Update the Antigravity settings to use the selected model
tmp=$(mktemp)
jq --arg m "$selected" '.model = $m' "$SETTINGS_FILE" > "$tmp" && mv "$tmp" "$SETTINGS_FILE"

# Run the original Antigravity CLI with the original arguments
exec antigravity "$@"
