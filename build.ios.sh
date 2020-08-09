#!/usr/bin/env bash

set -xe

FLUTTER_VER=1.20.1

mkdir -p ~/flutter && cd ~/flutter
wget https://storage.googleapis.com/flutter_infra/releases/stable/macos/flutter_macos_${FLUTTER_VER}-stable.zip
unzip flutter_macos_${FLUTTER_VER}-stable.zip

export PATH="$PATH:`pwd`/flutter/bin"
flutter precache

cd ${GITHUB_WORKSPACE}/mobile
flutter doctor
flutter build ios

cd ios
bundle update
bundle exec fastlane beta
