# Hydrates secrets from 1Password
# Usage: source secrets.env.op.sh

# Clear values this script owns before attempting hydration. This prevents a
# stale inherited token from poisoning tools like gh when 1Password is locked.
unset GITHUB_PERSONAL_ACCESS_TOKEN
unset GITHUB_TOKEN

if ! command -v op >/dev/null; then
    echo "⚠️  'op' command not found." >&2
    return 0
fi

# Check sign-in status
if ! op whoami >/dev/null 2>&1; then
    echo "⚠️  1Password is not signed in. Leaving GitHub token variables unset." >&2
    echo "👉 Run 'eval \$(op signin)' manually, then 'direnv reload'." >&2
    return 0
fi

# Dynamic Search Logic
ITEM_ID=""
VAULT_NAME=""
token=""

validate_github_token() {
    if [ -z "$1" ]; then
        return 1
    fi

    if command -v gh >/dev/null; then
        GITHUB_TOKEN="$1" GH_TOKEN= gh api user >/dev/null 2>&1
        return $?
    fi

    return 0
}

read_item_token() {
    op item get "$1" --vault "$2" --field label=credential --reveal 2>/dev/null || \
        op item get "$1" --vault "$2" --field label=password --reveal 2>/dev/null || \
        op item get "$1" --vault "$2" --field credential --reveal 2>/dev/null
}

if command -v jq >/dev/null; then
    # Search for items with "github" and "token" in title across all vaults.
    # Validate each candidate so one stale token record cannot poison gh.
    MATCHES=$(op item list --format json 2>/dev/null | jq -r '.[] | select(.title | test("github"; "i")) | select(.title | test("token"; "i")) | "\(.id)|\(.vault.name)"')
    while IFS='|' read -r CANDIDATE_ID CANDIDATE_VAULT; do
        if [ -z "$CANDIDATE_ID" ] || [ -z "$CANDIDATE_VAULT" ]; then
            continue
        fi

        candidate_token=$(read_item_token "$CANDIDATE_ID" "$CANDIDATE_VAULT")
        clean_candidate=$(echo "$candidate_token" | tr -d '\r\n')
        if validate_github_token "$clean_candidate"; then
            token="$clean_candidate"
            ITEM_ID="$CANDIDATE_ID"
            VAULT_NAME="$CANDIDATE_VAULT"
            break
        fi

        echo "⚠️  Skipping invalid GitHub token candidate (Vault: $CANDIDATE_VAULT, ID: $CANDIDATE_ID)" >&2
    done <<EOF
$MATCHES
EOF
fi

# Fallback to title-based search if ID search failed or jq missing
if [ -z "$token" ]; then
    ITEM_NAME="GitHub Personal Access Token"
    for CANDIDATE_VAULT in GitHub-Tokens Private Personal; do
        candidate_token=$(op read "op://$CANDIDATE_VAULT/$ITEM_NAME/credential" 2>/dev/null)
        clean_candidate=$(echo "$candidate_token" | tr -d '\r\n')
        if validate_github_token "$clean_candidate"; then
            token="$clean_candidate"
            ITEM_ID="$ITEM_NAME"
            VAULT_NAME="$CANDIDATE_VAULT"
            break
        fi
    done
fi

if [ -n "$token" ]; then
    export GITHUB_PERSONAL_ACCESS_TOKEN="$token"
    export GITHUB_TOKEN="$token"
    echo "✅ Loaded GITHUB_PERSONAL_ACCESS_TOKEN from 1Password (Vault: $VAULT_NAME, ID: $ITEM_ID)"
else
    echo "❌ Failed to load token. Could not find valid GitHub token in 1Password." >&2
    return 0
fi
