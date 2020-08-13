#!/bin/bash

set -Eeuo pipefail

mkdir -p ~/.pub-cache

# Build tools
if type docker; then
	(cd _ops && docker build --rm=true --pull=true -t fmv_tools -f Dockerfile.tools .)
fi

#Build App with tools
if [[ "${1:-}" == "test" ]]; then
	docker run -e TMDB_KEY -v ~/.pub-cache:/pub-cache -e PUB_CACHE=/pub-cache -v `pwd`:/src -w /src --rm fmv_tools bash _ops/run.tests.sh

elif [[ "${1:-}" == "web" ]]; then
	docker run -e TMDB_KEY -v ~/.pub-cache:/pub-cache -e PUB_CACHE=/pub-cache -v `pwd`:/src -w /src --rm fmv_tools bash _ops/build.web.sh

	#Run web
	docker build --rm=true --pull=true -t fluttermovie .
	docker stop fluttermovie || :
	docker run --rm --name fluttermovie -p 8080:8080 -d fluttermovie
	echo "Done! - Check in browser"

elif [[ "${1:-}" == "android" ]]; then
	if type docker; then
		docker run -e TMDB_KEY -v ~/.pub-cache:/pub-cache -e PUB_CACHE=/pub-cache -v `pwd`:/src -w /src --rm fmv_tools bash _ops/build.android.sh
	else
		PUB_CACHE=~/.pub-cache bash _ops/build.android.mac.sh
	fi

elif [[ "${1:-}" == "ios" ]]; then
	bash _ops/build.ios.sh

elif [[ "${1:-}" == "clean" ]]; then
	if type docker; then
		docker run -e TMDB_KEY -v ~/.pub-cache:/pub-cache -e PUB_CACHE=/pub-cache -v `pwd`:/src -w /src --rm fmv_tools bash _ops/clean.sh
	else
		PUB_CACHE=~/.pub-cache bash _ops/clean.sh
	fi

else
	echo "---"
	echo "Usage:- bash build.sh (web|android|ios|test|clean)"
fi
