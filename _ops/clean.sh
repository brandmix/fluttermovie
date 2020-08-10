#!/bin/bash

set -Eeuo pipefail

# Get all packages for core, mobile and web
(cd core && flutter clean)
(cd web && flutter clean)
(cd mobile && flutter clean)

rm -rf $PUB_CACHE/*
