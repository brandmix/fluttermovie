#!/usr/bin/env bash

set -Eeuo pipefail

#set -x

if [[ "$OSTYPE" != "darwin"* ]]; then
	echo "---"
	echo "Need MacOS"
	exit 1
fi

if [[ ! -z "${GITHUB_WORKSPACE:-}" ]]; then

	pushd ${GITHUB_WORKSPACE:-.}/mobile/ios

	bundle update
	pod install

        export TEMP_KEYCHAIN_NAME=fastlane_$(LC_ALL=C; dd if=/dev/urandom bs=256 count=1 2> /dev/null | tr -dc 'a-zA-Z0-9' | head -c 16; echo)
	export TEMP_KEYCHAIN_PASSWORD=$(LC_ALL=C; dd if=/dev/urandom bs=256 count=1 2> /dev/null | tr -dc 'a-zA-Z0-9' | head -c 64; echo)

	export DART_DEFINES=TMDB_KEY=$TMDB_KEY
	bundle exec fastlane beta
	git diff

	popd
fi
