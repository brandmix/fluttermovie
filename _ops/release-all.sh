#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

flutter pub global activate webdev
(cd web && webdev build)
(cd mobile && flutter build apk)


