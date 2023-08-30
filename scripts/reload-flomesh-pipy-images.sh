#!/bin/bash

set -uo pipefail

source ./scripts/funcs.sh

images=(
"flomesh/pipy:latest"
"flomesh/pipy-nightly:latest"
"flomesh/pipy-repo:latest"
"flomesh/pipy-repo-nightly:latest"
"flomesh/pipy:0.90.2-33"
"flomesh/pipy:0.90.2-41-nonroot"
"flomesh/pipy-repo:0.90.2-33"
"flomesh/ebpf:base20.04"
)

docker_io_images_to_local_registry "${images[@]}"