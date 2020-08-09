#!/bin/bash

set -Eeuo pipefail

# Get all packages for core, mobile and web
(cd core && flutter pub get)
(cd web && flutter pub get)
(cd mobile && flutter pub get)

flutter doctor
