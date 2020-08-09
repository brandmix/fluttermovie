#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

# Activate webdev
flutter pub global activate webdev
(cd web && webdev build)

(cd mobile && flutter build apk)
(cd mobile/android && bundle update && bundle exec fastlane internal || :)
