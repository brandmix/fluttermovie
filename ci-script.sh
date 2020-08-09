#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

# Get all packages for core, mobile and web
(cd core && flutter pub get)
(cd web && flutter pub get)
(cd mobile && flutter pub get)

# Analyze core, mobile and web
(cd core && dartanalyzer ./ --fatal-infos --fatal-warnings)
(cd mobile && dartanalyzer ./ --fatal-infos --fatal-warnings)
(cd web && dartanalyzer ./ --fatal-infos --fatal-warnings)

# Run tests for core, mobile and web
echo "--- Running tests in core... ---"
(cd core && flutter pub run test)

echo "--- Running tests in mobile... ---"
(cd mobile && flutter test)

echo "--- Running tests in web... ---"
(cd web && pub run build_runner test --fail-on-severe -- -p chrome)
