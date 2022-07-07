#!/bin/bash

set -uo pipefail

REGPOD="$(docker ps --filter 'name=kind-registry' |tail -n 1| awk 'NR==1{print $1}')"
docker exec $REGPOD  bin/registry garbage-collect /etc/docker/registry/config.yml
docker exec $REGPOD rm -rf /var/lib/registry/docker/registry/v2/repositories
docker restart $REGPOD
sleep 2
curl http://localhost:5000/v2/_catalog | jq
