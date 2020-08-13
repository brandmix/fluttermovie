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
	bundle update
	pod install
	popd
fi
