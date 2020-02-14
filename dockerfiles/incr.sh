#!/bin/bash

# Use this script to build local images for testing, while leveraging the work already done in the most recent tag
# on the branch that your local branch was based on
#
# Pass in a get commit (that you previously built using this script) if you want to override the default calculation
# of the base build

HEAD=$(git rev-parse --short HEAD)
PREV=$1
[[ -z ${PREV} ]] && PREV=$(git describe --abbrev=0 --tags)

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIR 2>&1 > /dev/null

#more - only do this if head does not match BUILD_VER
echo Building local incremental images based in ${PREV}

docker image build -t hpccsystems/platform-build:${HEAD} --build-arg BUILD_VER=${PREV} --build-arg COMMIT=${HEAD} platform-build-incremental/
docker image build -t hpccsystems/platform-core:${HEAD} --build-arg BUILD_VER=${HEAD} platform-core/  

docker image build -t hpccsystems/roxie:${HEAD} --build-arg BUILD_VER=${HEAD} roxie/
docker image build -t hpccsystems/dali:${HEAD} --build-arg BUILD_VER=${HEAD} dali/
docker image build -t hpccsystems/esp:${HEAD} --build-arg BUILD_VER=${HEAD} esp/
docker image build -t hpccsystems/eclccserver:${HEAD} --build-arg BUILD_VER=${HEAD} eclccserver/
docker image build -t hpccsystems/eclagent:${HEAD} --build-arg BUILD_VER=${HEAD} eclagent/

echo Built hpccsystems/*:${HEAD}
