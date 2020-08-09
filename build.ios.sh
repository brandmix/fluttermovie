#!/usr/bin/env bash

set -xe

FLUTTER_VER=1.20.1

mkdir -p ~/flutter && cd ~/flutter
wget --quiet https://storage.googleapis.com/flutter_infra/releases/stable/macos/flutter_macos_${FLUTTER_VER}-stable.zip
unzip -q flutter_macos_${FLUTTER_VER}-stable.zip

export PATH="$PATH:`pwd`/flutter/bin"
flutter precache

cd ${GITHUB_WORKSPACE}/mobile
flutter doctor
flutter build ios || :

exit

cd ios
bundle update
bundle exec fastlane beta
