#!/usr/bin/env bash

set -Eeuo pipefail

if [[ "$OSTYPE" != "darwin"* ]]; then
	echo "---"
	echo "Need MacOS"
	exit 1
fi

FLUTTER_VER=1.17.2

if [[ ! -d ~/flutter ]]; then

	mkdir -p ~/flutter && cd ~/flutter
	wget --quiet https://storage.googleapis.com/flutter_infra/releases/stable/macos/flutter_macos_${FLUTTER_VER}-stable.zip
	unzip -q flutter_macos_${FLUTTER_VER}-stable.zip

	export PATH="$PATH:`pwd`/flutter/bin"
	flutter precache
fi

cd ${GITHUB_WORKSPACE:-.}/mobile
flutter doctor
flutter build ios --release --no-codesign || :
exit

cd ${GITHUB_WORKSPACE:-.}/mobile/ios
bundle update
bundle exec fastlane beta
