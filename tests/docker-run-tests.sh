#!/bin/bash

set -uo pipefail

DEBUGX=${DEBUGX:-}
[[ -z $DEBUGX ]] || set -x

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker run --rm --volume ${script_dir}/../:/workspace \
    --env DEBUGX=$DEBUGX \
    --env GITHUB_API_TOKEN=${GITHUB_API_TOKEN:-} \
    --env DOCKER_MODE=true \
    laidbackware/asdf-tools-test:v1 \
    bash -c "/workspace/tests/setup-env.sh && \
    /workspace/tests/run-tests.sh"

docker run --rm --volume ${script_dir}/../:/workspace \
    --env DEBUGX=$DEBUGX \
    --env GITHUB_API_TOKEN=${GITHUB_API_TOKEN:-} \
    --env DOCKER_MODE=true \
    laidbackware/asdf-tools-test:v1 \
    bash -c "export ASDF_LEGACY=true && \
    /workspace/tests/setup-env.sh && \
    /workspace/tests/run-tests.sh"

echo "Latest exit code: $?"