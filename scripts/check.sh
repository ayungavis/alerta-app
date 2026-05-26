#!/usr/bin/env bash
set -euo pipefail

scripts/lint.sh
xcodebuild build \
  -project AlertaApp.xcodeproj \
  -scheme AlertaApp \
  -configuration Debug \
  -destination generic/platform=iOS \
  CODE_SIGNING_ALLOWED=NO
