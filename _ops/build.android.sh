#!/bin/bash

set -Eeuo pipefail

# Build application
source _ops/get-deps.sh
(cd mobile && flutter build apk)

exit
(cd mobile/android && bundle update && bundle exec fastlane internal || :)
