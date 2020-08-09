set -xe


docker login ${REGISTRY_ENDPOINT} --username ${REGISTRY_USERNAME} --password ${REGISTRY_PASSWORD} 2>/dev/null
docker build --rm=true --pull=true -t ${REGISTRY_ENDPOINT}/${REGISTRY_REPO} -f Dockerfile .

COMMIT=$GITHUB_SHA
if [[ "${GITHUB_PR_SHA:-}" != "" ]]; then
	COMMIT=$GITHUB_PR_SHA
fi

TAG=$(echo $COMMIT | cut -c1-7) && docker tag ${REGISTRY_ENDPOINT}/${REGISTRY_REPO} ${REGISTRY_ENDPOINT}/${REGISTRY_REPO}:${TAG} && docker push ${REGISTRY_ENDPOINT}/${REGISTRY_REPO}:${TAG}
TAG=$COMMIT && docker tag ${REGISTRY_ENDPOINT}/${REGISTRY_REPO} ${REGISTRY_ENDPOINT}/${REGISTRY_REPO}:${TAG} && docker push ${REGISTRY_ENDPOINT}/${REGISTRY_REPO}:${TAG}
TAG=actions && docker tag ${REGISTRY_ENDPOINT}/${REGISTRY_REPO} ${REGISTRY_ENDPOINT}/${REGISTRY_REPO}:${TAG} && docker push ${REGISTRY_ENDPOINT}/${REGISTRY_REPO}:${TAG}
