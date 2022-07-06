#!/bin/bash

set -uo pipefail

docker rmi localhost:5000/flomesh/pipy:latest
docker rmi localhost:5000/flomesh/pipy-nightly:latest
docker rmi localhost:5000/flomesh/pipy-repo:latest

docker rmi flomesh/pipy:latest
docker rmi flomesh/pipy-nightly:latest
docker rmi flomesh/pipy-repo:latest

docker container prune -f
docker volume prune -f
docker image prune -f
