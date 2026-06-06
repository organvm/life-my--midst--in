# Hydrates secrets from 1Password
# Usage: source secrets.env.op.sh

if ! command -v op >/dev/null; then
    echo "⚠️  'op' command not found." >&2
    return 1
fi

# Check sign-in status
if ! op whoami >/dev/null 2>&1; then
    # If running inside direnv, we can't be interactive
    if [ -n "$DIRENV_DIR" ]; then
        echo "⚠️  1Password is locked. Direnv cannot unlock it interactively." >&2
        echo "👉 Run 'eval $(op signin)' manually, then 'direnv reload'." >&2
        return 1
    else
        echo "🔒 1Password is locked. Attempting to sign in..." >&2
        eval $(op signin)
    fi
fi

# Dynamic Search Logic
ITEM_ID=""
VAULT_NAME=""
if command -v jq >/dev/null; then
    # Search for item with "github" and "token" in title across all vaults
    # We get both the ID and the Vault to be precise
    MATCH=$(op item list --format json | jq -r '.[] | select(.title | test("github"; "i")) | select(.title | test("token"; "i")) | "\(.id)|\(.vault.name)"' | head -n 1)
    if [ -n "$MATCH" ]; then
        ITEM_ID=$(echo "$MATCH" | cut -d'|' -f1)
        VAULT_NAME=$(echo "$MATCH" | cut -d'|' -f2)
    fi
fi

# Fallback to Title-based search if ID search failed or jq missing
if [ -z "$ITEM_ID" ]; then
    ITEM_NAME="GitHub Personal Access Token"
    echo "reading via title: $ITEM_NAME"
    token=$(op read "op://GitHub-Tokens/$ITEM_NAME/credential" 2>/dev/null || \
            op read "op://Private/$ITEM_NAME/credential" 2>/dev/null || \
            op read "op://Personal/$ITEM_NAME/credential" 2>/dev/null)
else
    # Read via ID (avoids colon issues in titles)
    token=$(op item get "$ITEM_ID" --vault "$VAULT_NAME" --field label=credential --reveal 2>/dev/null || \
            op item get "$ITEM_ID" --vault "$VAULT_NAME" --field label=password --reveal 2>/dev/null || \
            op item get "$ITEM_ID" --vault "$VAULT_NAME" --field credential --reveal 2>/dev/null)
fi

if [ -n "$token" ]; then
    # Sanitize (Trim Newlines)
    clean_token=$(echo "$token" | tr -d '\n')
    export GITHUB_PERSONAL_ACCESS_TOKEN="$clean_token"
    export GITHUB_TOKEN="$clean_token"
    echo "✅ Loaded GITHUB_PERSONAL_ACCESS_TOKEN from 1Password (Vault: $VAULT_NAME, ID: $ITEM_ID)"
else
    echo "❌ Failed to load token. Could not find valid GitHub token in 1Password." >&2
    return 1
fi