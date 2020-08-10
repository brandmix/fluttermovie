#!/bin/bash

set -Eeuo pipefail

export PATH="$PATH:$PUB_CACHE/bin"
flutter pub global activate webdev

#Supply ENV vars
sed -i "s/-DTMDB_KEY=.*/-DTMDB_KEY=${TMDB_KEY:-}/" web/build.yaml

# Build application
source _ops/get-deps.sh
(cd web && webdev build)
#Remove Keys
sed -i "s/-DTMDB_KEY=.*/-DTMDB_KEY=/" web/build.yaml
