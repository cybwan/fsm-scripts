#!/bin/bash

set -uo pipefail

source ./scripts/funcs.sh

images=(
"flomesh/pipy:latest"
"flomesh/pipy-nightly:latest"
"flomesh/pipy-repo:latest"
"flomesh/pipy-repo-nightly:latest"
#"flomesh/pipy:0.70.0-24"
#"flomesh/pipy-repo:0.70.0-24"
)

docker_io_images_to_local_registry "${images[@]}"