#!/usr/bin/env bash
set -euo pipefail

# Verify App Store Connect credentials are valid for TestFlight release.
#
# Usage:
#   export APPSTORE_KEY_ID="ABC123XYZ"
#   export APPSTORE_ISSUER_ID="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
#   scripts/verify-credentials.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

PASS=0
FAIL=0

pass() { printf "  ${GREEN}✓${NC} %s\n" "$1"; PASS=$((PASS + 1)); }
fail() { printf "  ${RED}✗${NC} %s\n" "$1"; FAIL=$((FAIL + 1)); }
warn() { printf "  ${YELLOW}⚠${NC} %s\n" "$1"; }

echo "=== App Store Connect Credential Check ==="
echo ""

# ── Environment variables ──────────────────────────────────
if [[ -z "${APPSTORE_KEY_ID:-}" ]]; then
    fail "APPSTORE_KEY_ID: not set"
    echo ""
    echo "  Fix: export APPSTORE_KEY_ID=\"YOUR_KEY_ID\""
else
    pass "APPSTORE_KEY_ID: ${APPSTORE_KEY_ID}"
fi

if [[ -z "${APPSTORE_ISSUER_ID:-}" ]]; then
    fail "APPSTORE_ISSUER_ID: not set"
    echo ""
    echo "  Fix: export APPSTORE_ISSUER_ID=\"XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX\""
else
    pass "APPSTORE_ISSUER_ID: set"
fi

if [[ $FAIL -gt 0 ]]; then
    exit 1
fi

# ── Key file ────────────────────────────────────────────────
KEY_DIR="${HOME}/.appstoreconnect"
KEY_PATH="${KEY_DIR}/AuthKey_${APPSTORE_KEY_ID}.p8"

if [[ ! -f "${KEY_PATH}" ]]; then
    fail "Key file not found: ${KEY_PATH}"
    echo ""
    echo "  Fix: Save your .p8 key file to ${KEY_PATH}"
    echo "       cp ~/Downloads/AuthKey_${APPSTORE_KEY_ID}.p8 ${KEY_PATH}"
    exit 1
fi
pass "Key file exists: ${KEY_PATH}"

KEY_SIZE="$(wc -c < "${KEY_PATH}" | tr -d ' ')"
if [[ "${KEY_SIZE}" -lt 20 ]]; then
    fail "Key file too small: ${KEY_SIZE} bytes (expected ~160+ bytes)"
    echo ""
    echo "  Fix: Re-download the .p8 file from App Store Connect"
    echo "       https://appstoreconnect.apple.com/access/integrations/api"
    exit 1
fi
pass "Key file size: ${KEY_SIZE} bytes"

KEY_PERMS="$(stat -f '%Lp' "${KEY_PATH}" 2>/dev/null || stat -c '%a' "${KEY_PATH}" 2>/dev/null || echo "???")"
if [[ "${KEY_PERMS}" != "600" ]]; then
    warn "Key file permissions: ${KEY_PERMS} (expected 600)"
    chmod 600 "${KEY_PATH}"
    pass "Key file permissions fixed: 600"
else
    pass "Key file permissions: 600"
fi

# ── Content check ───────────────────────────────────────────
if grep -q "BEGIN PRIVATE KEY" "${KEY_PATH}" 2>/dev/null; then
    pass "Key file format: valid private key"
else
    fail "Key file contains 'BEGIN PRIVATE KEY' header"
    echo ""
    echo "  Fix: This does not look like a valid .p8 file."
    echo "       If you base64-decoded it yourself, use 'base64 -d' not 'base64 -D'."
    exit 1
fi

# ── Authentication test ─────────────────────────────────────
echo ""
echo "--- Testing authentication ---"

if xcrun appstoreconnect list-apps \
    --apiKey "${APPSTORE_KEY_ID}" \
    --apiIssuer "${APPSTORE_ISSUER_ID}" \
    > /dev/null 2>&1; then
    pass "list-apps: authenticated successfully"
else
    ERROR_OUT="$(xcrun appstoreconnect list-apps \
        --apiKey "${APPSTORE_KEY_ID}" \
        --apiIssuer "${APPSTORE_ISSUER_ID}" 2>&1 || true)"

    fail "list-apps: authentication failed"

    if echo "${ERROR_OUT}" | grep -qi "401"; then
        echo ""
        echo "  Possible causes:"
        echo "    - Key ID or Issuer ID does not match the .p8 file"
        echo "    - Key has expired (check Status in App Store Connect)"
        echo "    - Key role too low: must be 'Admin' or 'App Manager'"
        echo ""
        echo "  Check at: https://appstoreconnect.apple.com/access/integrations/api"
    elif echo "${ERROR_OUT}" | grep -qi "403"; then
        echo ""
        echo "  Possible causes:"
        echo "    - API key exists but has insufficient permissions"
        echo "    - Apple ID that created the key does not have team access"
        echo ""
        echo "  Fix: Recreate key with 'Admin' role in App Store Connect"
    else
        echo ""
        echo "  Raw error:"
        echo "${ERROR_OUT}" | head -5
    fi
    exit 1
fi

if xcrun appstoreconnect list-teams \
    --apiKey "${APPSTORE_KEY_ID}" \
    --apiIssuer "${APPSTORE_ISSUER_ID}" \
    > /dev/null 2>&1; then
    pass "list-teams: team access confirmed"
else
    warn "list-teams: not available (non-blocking, apps query passed)"
fi

# ── Summary ─────────────────────────────────────────────────
echo ""
echo "=== All checks passed — credentials are valid ==="
