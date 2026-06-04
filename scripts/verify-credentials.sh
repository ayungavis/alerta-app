#!/usr/bin/env bash
set -euo pipefail

# Verify App Store Connect credentials are valid for TestFlight release.
# Uses JWT + curl (no xcrun dependency, works on any Mac).
#
# Usage:
#   export APPSTORE_KEY_ID="ABC123XYZ"
#   export APPSTORE_ISSUER_ID="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
#   scripts/verify-credentials.sh

msg()   { printf "  %s\n" "$1"; }
pass()  { printf "  \033[0;32m✓\033[0m %s\n" "$1"; }
fail()  { printf "  \033[0;31m✗\033[0m %s\n" "$1"; EXIT=1; }

EXIT=0
cleanup() { rm -f "${TMP_DIR:-/tmp/notset}"/* 2>/dev/null; rmdir "${TMP_DIR:-/tmp/notset}" 2>/dev/null || true; }
trap cleanup EXIT

echo "=== App Store Connect Credential Check ==="
echo ""

# ── Prerequisite tools ─────────────────────────────────────
for cmd in openssl curl base64; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        fail "${cmd}: not found (required)"
    fi
done
if [[ $EXIT -ne 0 ]]; then exit 1; fi

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
if [[ $EXIT -ne 0 ]]; then exit 1; fi

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
    exit 1
fi
pass "Key file: ${KEY_SIZE} bytes"

KEY_PERMS="$(stat -f '%Lp' "${KEY_PATH}" 2>/dev/null || stat -c '%a' "${KEY_PATH}" 2>/dev/null || echo "???")"
if [[ "${KEY_PERMS}" != "600" ]]; then
    chmod 600 "${KEY_PATH}"
    pass "Key file permissions fixed: 600"
else
    pass "Key file permissions: 600"
fi

if ! grep -q "BEGIN PRIVATE KEY" "${KEY_PATH}" 2>/dev/null; then
    fail "Key file does not contain 'BEGIN PRIVATE KEY' header"
    exit 1
fi

# ── Generate JWT ────────────────────────────────────────────
echo ""
echo "--- JWT + API authentication ---"

TMP_DIR="$(mktemp -d)"

base64url() {
    base64 | tr '+/' '-_' | tr -d '=' | tr -d '\n'
}

HEADER="$(printf '{"alg":"ES256","kid":"%s","typ":"JWT"}' "${APPSTORE_KEY_ID}" | base64url)"
NOW="$(date +%s)"
EXP="$((NOW + 600))"
PAYLOAD="$(printf '{"iss":"%s","iat":%d,"exp":%d,"aud":"appstoreconnect-v1"}' \
    "${APPSTORE_ISSUER_ID}" "${NOW}" "${EXP}" | base64url)"

SIGNING_INPUT="${HEADER}.${PAYLOAD}"

printf '%s' "${SIGNING_INPUT}" | openssl dgst -sha256 -binary -sign "${KEY_PATH}" > "${TMP_DIR}/sig.der"

# DER-encoded ECDSA P-256: 30 <totalLen> 02 <rLen> <r> 02 <sLen> <s>
# Extract R and S raw bytes, each padded to 32 bytes.
SIG_FILE="${TMP_DIR}/sig.der"
offset=2  # skip 0x30
remlen=$(dd if="${SIG_FILE}" bs=1 skip=1 count=1 2>/dev/null | od -A n -t u1 | tr -d ' \n')
# remlen is the byte value, not relevant for fixed parsing

# R: skip 0x02
r_seq="$(dd if="${SIG_FILE}" bs=1 skip=2 count=1 2>/dev/null | od -A n -t x1 | tr -d ' \n')"
if [[ "$r_seq" != "02" ]]; then
    fail "Invalid DER signature: expected 0x02 at byte 2, got 0x${r_seq}"
    exit 1
fi
r_len=$(dd if="${SIG_FILE}" bs=1 skip=3 count=1 2>/dev/null | od -A n -t u1 | tr -d ' \n')
r_start=4
if [[ "$r_len" -eq 33 ]]; then
    r_start=5
    r_len=32
fi
dd if="${SIG_FILE}" bs=1 skip="${r_start}" count="${r_len}" of="${TMP_DIR}/r.bin" 2>/dev/null
R_RAW="${TMP_DIR}/r.bin"
R_PAD="${TMP_DIR}/r_pad.bin"
# Ensure exactly 32 bytes (pad left with zeros if short)
R_SIZE=$(wc -c < "${R_RAW}" | tr -d ' ')
if [ "$R_SIZE" -lt 32 ]; then
    dd if=/dev/zero bs=1 count=$((32 - R_SIZE)) 2>/dev/null > "${R_PAD}"
    cat "${R_RAW}" >> "${R_PAD}"
else
    cp "${R_RAW}" "${R_PAD}"
fi

# S: skip past R
r_total=$((3 + r_len))  # 02 + len_byte + r_bytes
if [[ "${r_len}" -ne "$R_SIZE" && $((R_SIZE)) -eq 32 ]]; then
    r_total=4  # r had a 33-byte representation
fi
# Actually recalculate more carefully
s_offset=$((2 + r_total))

s_seq="$(dd if="${SIG_FILE}" bs=1 skip="${s_offset}" count=1 2>/dev/null | od -A n -t x1 | tr -d ' \n')"
if [[ "$s_seq" != "02" ]]; then
    fail "Invalid DER signature: expected 0x02 for S, got 0x${s_seq}"
    exit 1
fi
s_len=$(dd if="${SIG_FILE}" bs=1 skip=$((s_offset + 1)) count=1 2>/dev/null | od -A n -t u1 | tr -d ' \n')
s_start=$((s_offset + 2))
if [[ "$s_len" -eq 33 ]]; then
    s_start=$((s_start + 1))
    s_len=32
fi
dd if="${SIG_FILE}" bs=1 skip="${s_start}" count="${s_len}" of="${TMP_DIR}/s.bin" 2>/dev/null
S_RAW="${TMP_DIR}/s.bin"
S_PAD="${TMP_DIR}/s_pad.bin"
S_SIZE=$(wc -c < "${S_RAW}" | tr -d ' ')
if [ "$S_SIZE" -lt 32 ]; then
    dd if=/dev/zero bs=1 count=$((32 - S_SIZE)) 2>/dev/null > "${S_PAD}"
    cat "${S_RAW}" >> "${S_PAD}"
else
    cp "${S_RAW}" "${S_PAD}"
fi

SIGNATURE=$(cat "${R_PAD}" "${S_PAD}" | base64url)
JWT="${HEADER}.${PAYLOAD}.${SIGNATURE}"

pass "JWT generated"

# ── Test authentication via App Store Connect API ───────────
HTTP_CODE=$(curl -s -o "${TMP_DIR}/response.json" -w '%{http_code}' \
    -H "Authorization: Bearer ${JWT}" \
    "https://api.appstoreconnect.apple.com/v1/apps?limit=1" 2>/dev/null || echo "000")

case "${HTTP_CODE}" in
    200)
        pass "App Store Connect API: authenticated (200)"
        APP_COUNT=$(python3 -c "
import json, sys
d = json.load(open('${TMP_DIR}/response.json'))
print(len(d.get('data', [])))
" 2>/dev/null || echo "?")
        msg "  Found ${APP_COUNT} apps for this team"
        ;;
    401)
        fail "App Store Connect API: 401 Unauthorized"
        echo ""
        echo "  Possible causes:"
        echo "    - Key ID or Issuer ID does not match the .p8 file"
        echo "    - Key has expired (check Status in App Store Connect)"
        echo "    - Key role must be 'Admin' or 'App Manager'"
        echo ""
        echo "  Check at: https://appstoreconnect.apple.com/access/integrations/api"
        exit 1
        ;;
    403)
        fail "App Store Connect API: 403 Forbidden"
        echo ""
        echo "  Possible causes:"
        echo "    - API key exists but has insufficient permissions"
        echo "    - The Apple ID that created the key does not have team access"
        echo ""
        echo "  Fix: Recreate key with 'Admin' role in App Store Connect"
        exit 1
        ;;
    *)
        fail "App Store Connect API: HTTP ${HTTP_CODE}"
        if [[ -s "${TMP_DIR}/response.json" ]]; then
            echo ""
            echo "  Response:"
            head -c 500 "${TMP_DIR}/response.json"
        fi
        exit 1
        ;;
esac

echo ""
echo "=== All checks passed — credentials are valid ==="
