#!/bin/bash

set -Eeuo pipefail

# Build application
source _ops/get-deps.sh
(cd mobile && flutter build --dart-define=TMDB_KEY=$TMDB_KEY apk)

exit
(cd mobile/android && bundle update && bundle exec fastlane internal || :)
