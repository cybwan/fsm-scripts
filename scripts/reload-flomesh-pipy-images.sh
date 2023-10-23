#!/bin/bash

set -uo pipefail

source ./scripts/funcs.sh

images=(
"flomesh/pipy:latest"
"flomesh/pipy-nightly:latest"
"flomesh/pipy-repo:latest"
"flomesh/pipy-repo-nightly:latest"
"flomesh/pipy:0.90.3-38"
"flomesh/pipy:0.90.3-38-nonroot"
"flomesh/pipy-repo:0.90.3-38"
)

docker_io_images_to_local_registry "${images[@]}"