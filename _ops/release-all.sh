#!/bin/bash

set -Eeuo pipefail

flutter pub global activate webdev
(cd web && webdev build)
(cd mobile && flutter build apk)



