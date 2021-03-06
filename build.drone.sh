set -xe

docker login ${REGISTRY_ENDPOINT} --username ${REGISTRY_USERNAME} --password ${REGISTRY_PASSWORD} 2>/dev/null
docker build --build-arg TMDB_KEY=${TMDB_KEY:-} --rm=true --pull=true -t ${REGISTRY_ENDPOINT}/${REGISTRY_REPO} -f _ops/Dockerfile.web .

TAG=${DRONE_COMMIT:0:7} && docker tag ${REGISTRY_ENDPOINT}/${REGISTRY_REPO} ${REGISTRY_ENDPOINT}/${REGISTRY_REPO}:${TAG} && docker push ${REGISTRY_ENDPOINT}/${REGISTRY_REPO}:${TAG}
TAG=drone && docker tag ${REGISTRY_ENDPOINT}/${REGISTRY_REPO} ${REGISTRY_ENDPOINT}/${REGISTRY_REPO}:${TAG} && docker push ${REGISTRY_ENDPOINT}/${REGISTRY_REPO}:${TAG}
