#!/bin/bash

set -Eeuo pipefail

which flutter || export PATH=$PATH:~/flutter/flutter/bin/
echo $PUB_CACHE || export PUB_CACHE=~/.pub-cache

# Get all packages for core, mobile and web
(cd core && flutter clean) || :
(cd web && flutter clean) || :
(cd mobile && flutter clean) || :

# Clean fastlane files
(cd mobile/ios && fastlane run clean_cocoapods_cache) || :
(cd mobile/ios && fastlane run xcclean scheme:Runner) || :
(cd mobile/ios && fastlane run clean_build_artifacts) || :

rm -rf $PUB_CACHE/*

git clean -fdx
