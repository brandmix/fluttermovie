#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

# Get all packages for core, mobile and web
(cd core && flutter pub get)
(cd web && flutter pub get)
(cd mobile && flutter pub get)
