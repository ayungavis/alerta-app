#!/usr/bin/env bash
set -euo pipefail

# Pre-flight: verify the project is ready to release to TestFlight.
# Run this locally before creating a GitHub Release.
# The actual archive + upload happens in CI via .github/workflows/release.yml.

echo "=== Pre-flight: TestFlight Release Ready Check ==="

# ── Git clean check ────────────────────────────────────────
if [[ -n "$(git status --porcelain)" ]]; then
    echo "ERROR: Working tree is dirty. Commit or stash changes first."
    git status --short
    exit 1
fi
echo "  ✓ working tree clean"

# ── On main branch ─────────────────────────────────────────
BRANCH="$(git branch --show-current)"
if [[ "$BRANCH" != "main" ]]; then
    echo "ERROR: Not on 'main' branch (current: $BRANCH). Merge to main before releasing."
    exit 1
fi
echo "  ✓ on main branch"

# ── Synced with remote ─────────────────────────────────────
git fetch origin main
LOCAL="$(git rev-parse HEAD)"
REMOTE="$(git rev-parse origin/main)"
if [[ "$LOCAL" != "$REMOTE" ]]; then
    echo "ERROR: Local main is not in sync with origin/main. Push or pull first."
    exit 1
fi
echo "  ✓ synced with origin/main"

# ── Lint + build ───────────────────────────────────────────
echo ""
echo "--- Running lint + build check ---"
./scripts/check.sh
echo "  ✓ lint and build pass"

# ── Summary ────────────────────────────────────────────────
echo ""
echo "=== All checks passed — ready to release! ==="
echo ""
echo "Next steps:"
echo "  1. Create a GitHub Release:"
echo "     https://github.com/$(git config --get remote.origin.url | sed 's|.*github.com[:/]\(.*\)\.git|\1|')/releases/new"
echo "  2. Tag: v$(xcrun agvtool what-marketing-version -terse1 2>/dev/null || echo 'X.Y.Z')"
echo "  3. Write release notes"
echo "  4. Click 'Publish release'"
echo ""
echo "  After publishing, CI will build and upload to TestFlight automatically."
