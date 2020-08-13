#!/usr/bin/env bash

set -Eeuo pipefail

#set -x

if [[ "$OSTYPE" != "darwin"* ]]; then
	echo "---"
	echo "Need MacOS"
	exit 1
fi

if ! type pod; then
  echo "CocoaPods not installed. Installer requires sudo permissions"
  sudo gem install cocoapods
fi

FLUTTER_VER=1.17.2

if [[ ! -d ~/flutter ]]; then

	mkdir -p ~/flutter && pushd ~/flutter
	wget --quiet https://storage.googleapis.com/flutter_infra/releases/stable/macos/flutter_macos_${FLUTTER_VER}-stable.zip
	unzip -q flutter_macos_${FLUTTER_VER}-stable.zip
	rm -rf flutter_macos_${FLUTTER_VER}-stable.zip

	export PATH="$PATH:~/flutter/flutter/bin"
	flutter precache
	popd
fi

export PATH="$PATH:~/flutter/flutter/bin"
pushd ${GITHUB_WORKSPACE:-.}/mobile
flutter doctor
flutter build ios --release --no-codesign
popd

if [[ ! -z "${GITHUB_WORKSPACE:-}" ]]; then
	pushd ${GITHUB_WORKSPACE:-.}/mobile/ios
	bundle update
	pod install
        export TEMP_KEYCHAIN_NAME=fastlane_$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w ${1:-16} | head -n 1)
	export TEMP_KEYCHAIN_PASSWORD=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w ${1:-64} | head -n 1)
	bundle exec fastlane beta
	popd
fi
