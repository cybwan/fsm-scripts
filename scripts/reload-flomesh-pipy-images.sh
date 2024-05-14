#!/bin/bash

set -uo pipefail

source ./scripts/funcs.sh

images=(
"flomesh/pipy:latest"
"flomesh/pipy-nightly:latest"
"flomesh/pipy-repo:latest"
"flomesh/pipy-repo-nightly:latest"
"flomesh/pipy:1.1.0-1
"flomesh/pipy:1.1.0-1-1-nonroot"
"flomesh/pipy-repo:1.1.0-1
)

docker_io_images_to_local_registry "${images[@]}"