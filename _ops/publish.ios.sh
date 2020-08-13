#!/usr/bin/env bash

set -Eeuo pipefail

set -x

if [[ "$OSTYPE" != "darwin"* ]]; then
	echo "---"
	echo "Need MacOS"
	exit 1
fi

if [[ ! -z "${GITHUB_WORKSPACE:-}" ]]; then
	pushd ${GITHUB_WORKSPACE:-.}/mobile/ios
        export TEMP_KEYCHAIN_NAME=fastlane_$(cat /dev/urandom | env LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w ${1:-16} | head -n 1)
	export TEMP_KEYCHAIN_PASSWORD=$(cat /dev/urandom | env LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w ${1:-64} | head -n 1)
	echo "here" && sleep 10
	bundle exec fastlane beta
	popd
fi
