#!/bin/bash

set -uo pipefail

source ./scripts/funcs.sh

images=(
"consul:1.5.3"
"consul:1.15.4"
"flomesh/samples-discovery-server:latest"
"nacos/nacos-server:v2.3.0-slim"
"cybwan/springboot-demo:latest"
)

docker_io_images_to_local_registry "${images[@]}"