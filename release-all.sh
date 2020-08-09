#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

# Activate webdev
flutter pub global activate webdev
(cd web && webdev build)

exit

(cd mobile && flutter build apk)
(cd mobile/android && fastlane internal)

(cd mobile && flutter build ios)
(cd mobile/ios && fastlane beta)
