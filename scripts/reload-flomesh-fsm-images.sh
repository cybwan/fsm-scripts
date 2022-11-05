#!/bin/bash

set -uo pipefail

IMG="fsm/pipy:0.50.0-146"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="fsm/wait-for-it:1.2.0"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="fsm/toolbox:1.2.0"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="fsm/curl:7.84.0"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="fsm/mirrored-klipper-lb:v0.3.5"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="fsm/fsm-ingress-pipy:0.2.0-alpha.1-dev"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="fsm/fsm-manager:0.2.0-alpha.1-dev"; docker rmi "${IMG}" "localhost:5000/${IMG}"

docker container prune -f
docker volume prune -f
docker image prune -f

REGPOD="$(docker ps --filter 'name=kind-registry' |tail -n 1| awk 'NR==1{print $1}')"
docker exec $REGPOD  bin/registry garbage-collect /etc/docker/registry/config.yml
docker exec $REGPOD rm -rf /var/lib/registry/docker/registry/v2/repositories/fsm
docker restart $REGPOD

docker pull docker.io/flomesh/pipy:0.50.0-146
docker pull docker.io/flomesh/wait-for-it:1.2.0
docker pull docker.io/flomesh/toolbox:1.2.0
docker pull docker.io/flomesh/curl:7.84.0
docker pull docker.io/flomesh/mirrored-klipper-lb:v0.3.5
docker pull docker.io/flomesh/fsm-ingress-pipy:0.2.0-alpha.1-dev
docker pull docker.io/flomesh/fsm-manager:0.2.0-alpha.1-dev

docker tag docker.io/flomesh/pipy:0.50.0-146 localhost:5000/fsm/pipy:0.50.0-146
docker tag docker.io/flomesh/wait-for-it:1.2.0 localhost:5000/fsm/wait-for-it:1.2.0
docker tag docker.io/flomesh/toolbox:1.2.0 localhost:5000/fsm/toolbox:1.2.0
docker tag docker.io/flomesh/curl:7.84.0 localhost:5000/fsm/curl:7.84.0
docker tag docker.io/flomesh/mirrored-klipper-lb:v0.3.5 localhost:5000/fsm/mirrored-klipper-lb:v0.3.5
docker tag docker.io/flomesh/fsm-ingress-pipy:0.2.0-alpha.1-dev localhost:5000/fsm/fsm-ingress-pipy:0.2.0-alpha.1-dev
docker tag docker.io/flomesh/fsm-manager:0.2.0-alpha.1-dev localhost:5000/fsm/fsm-manager:0.2.0-alpha.1-dev

docker push localhost:5000/fsm/pipy:0.50.0-146
docker push localhost:5000/fsm/wait-for-it:1.2.0
docker push localhost:5000/fsm/toolbox:1.2.0
docker push localhost:5000/fsm/curl:7.84.0
docker push localhost:5000/fsm/mirrored-klipper-lb:v0.3.5
docker push localhost:5000/fsm/fsm-ingress-pipy:0.2.0-alpha.1-dev
docker push localhost:5000/fsm/fsm-manager:0.2.0-alpha.1-dev

IMG="fsm/pipy:0.50.0-146"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="fsm/wait-for-it:1.2.0"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="fsm/toolbox:1.2.0"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="fsm/curl:7.84.0"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="fsm/mirrored-klipper-lb:v0.3.5"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="fsm/fsm-ingress-pipy:0.2.0-alpha.1-dev"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="fsm/fsm-manager:0.2.0-alpha.1-dev"; docker rmi "${IMG}" "localhost:5000/${IMG}"

docker container prune -f
docker volume prune -f
docker image prune -f