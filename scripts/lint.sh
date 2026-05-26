#!/usr/bin/env bash
set -euo pipefail

swift run --package-path BuildTools swiftformat --lint AlertaApp
swift run --package-path BuildTools swiftlint --config .swiftlint.yml AlertaApp
