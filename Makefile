DOCKER_EXE := docker

NAME    := gilbertmike/isl-image
TAG     := $$(git log -1 --pretty=%h)
IMG     := ${NAME}:${TAG}

ALTTAG  := latest
ALTIMG  := ${NAME}:${ALTTAG}


build-amd64:
	"${DOCKER_EXE}" build ${BUILD_FLAGS} --platform linux/amd64 \
          --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
          --build-arg VCS_REF=${TAG} \
          --build-arg BUILD_VERSION=${VERSION} \
          -t ${IMG}-amd64 .
	"${DOCKER_EXE}" tag ${IMG}-amd64 ${ALTIMG}-amd64

push-amd64:
	@echo "Pushing ${NAME}:${ALTTAG}-amd64"
	#Push Amd64 version
	"${DOCKER_EXE}" push ${NAME}:${ALTTAG}-amd64
	"${DOCKER_EXE}" manifest create \
		${NAME}:${ALTTAG} \
		--amend ${NAME}:${ALTTAG}-amd64
	"${DOCKER_EXE}" manifest push ${NAME}:${ALTTAG}
