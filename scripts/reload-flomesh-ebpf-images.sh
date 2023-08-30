#!/bin/bash

set -uo pipefail

source ./scripts/funcs.sh

images=(
"flomesh/ebpf:base20.04"
)

docker_io_images_to_local_registry "${images[@]}"