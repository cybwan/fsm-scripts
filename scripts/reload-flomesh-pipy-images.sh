#!/bin/bash

set -uo pipefail

IMG="flomesh/pipy:latest"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="flomesh/pipy-nightly:latest"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="flomesh/pipy-repo:latest"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="flomesh/pipy:0.70.0-2"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="flomesh/pipy-repo:0.70.0-2"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="flomesh/pipy-repo-nightly:latest"; docker rmi "${IMG}" "localhost:5000/${IMG}"

docker container prune -f
docker volume prune -f
docker image prune -f

REGPOD="$(docker ps --filter 'name=kind-registry' |tail -n 1| awk 'NR==1{print $1}')"
docker exec $REGPOD  bin/registry garbage-collect /etc/docker/registry/config.yml
docker exec $REGPOD rm -rf /var/lib/registry/docker/registry/v2/repositories/flomesh/pipy
docker exec $REGPOD rm -rf /var/lib/registry/docker/registry/v2/repositories/flomesh/pipy-nightly
docker exec $REGPOD rm -rf /var/lib/registry/docker/registry/v2/repositories/flomesh/pipy-repo:latest
docker exec $REGPOD rm -rf /var/lib/registry/docker/registry/v2/repositories/flomesh/pipy:0.70.0-2
docker exec $REGPOD rm -rf /var/lib/registry/docker/registry/v2/repositories/flomesh/pipy-repo:0.70.0-2
docker exec $REGPOD rm -rf /var/lib/registry/docker/registry/v2/repositories/flomesh/pipy-repo-nightly
docker restart $REGPOD

docker pull docker.io/flomesh/pipy:latest
docker pull docker.io/flomesh/pipy-nightly:latest
docker pull docker.io/flomesh/pipy-repo:latest
docker pull docker.io/flomesh/pipy:0.70.0-2
docker pull docker.io/flomesh/pipy-repo:0.70.0-2
docker pull docker.io/flomesh/pipy-repo-nightly:latest

docker tag docker.io/flomesh/pipy:latest localhost:5000/flomesh/pipy:latest
docker tag docker.io/flomesh/pipy-nightly:latest localhost:5000/flomesh/pipy-nightly:latest
docker tag docker.io/flomesh/pipy-repo:latest localhost:5000/flomesh/pipy-repo:latest
docker tag docker.io/flomesh/pipy-repo:0.70.0-2 localhost:5000/flomesh/pipy-repo:0.70.0-2
docker tag docker.io/flomesh/pipy:0.70.0-2 localhost:5000/flomesh/pipy:0.70.0-2
docker tag docker.io/flomesh/pipy-repo-nightly:latest localhost:5000/flomesh/pipy-repo-nightly:latest

docker push localhost:5000/flomesh/pipy:latest
docker push localhost:5000/flomesh/pipy-nightly:latest
docker push localhost:5000/flomesh/pipy-repo:latest
docker push localhost:5000/flomesh/pipy:0.70.0-2
docker push localhost:5000/flomesh/pipy-repo:0.70.0-2
docker push localhost:5000/flomesh/pipy-repo-nightly:latest

IMG="flomesh/pipy:latest"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="flomesh/pipy-nightly:latest"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="flomesh/pipy-repo:latest"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="flomesh/pipy:0.70.0-2"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="flomesh/pipy-repo:0.70.0-2"; docker rmi "${IMG}" "localhost:5000/${IMG}"
IMG="flomesh/pipy-repo-nightly:latest"; docker rmi "${IMG}" "localhost:5000/${IMG}"

docker container prune -f
docker volume prune -f
docker image prune -f