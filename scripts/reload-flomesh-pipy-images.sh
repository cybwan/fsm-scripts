#!/bin/bash

set -uo pipefail

source ./scripts/funcs.sh

PIPY_TAG="1.4.1"

images=(
"flomesh/pipy:latest"
"flomesh/pipy-nightly:latest"
"flomesh/pipy-repo:latest"
"flomesh/pipy-repo-nightly:latest"
"flomesh/pipy:${PIPY_TAG}"
"flomesh/pipy:${PIPY_TAG}-nonroot"
"flomesh/pipy-repo:${PIPY_TAG}"
)

docker_io_images_to_local_registry "${images[@]}"