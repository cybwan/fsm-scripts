#!/bin/bash

set -uo pipefail

source ./scripts/funcs.sh

images=(
"flomesh/pipy:0.50.0-146"
"flomesh/wait-for-it:1.2.0"
"flomesh/toolbox:1.2.0"
"flomesh/curl:7.84.0"
"flomesh/mirrored-klipper-lb:v0.3.5"
"flomesh/fsm-ingress-pipy:0.2.0-alpha.9"
"flomesh/fsm-manager:0.2.0-alpha.9"
)

docker_io_images_to_local_registry "${images[@]}"