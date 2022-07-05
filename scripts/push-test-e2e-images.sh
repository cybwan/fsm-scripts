#!/bin/bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument OSM_HOME"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Error: expected one argument OS_ARCH"
  exit 1
fi

OSM_HOME=$1

docker push localhost:5000/flomesh/httpbin:latest
docker push localhost:5000/flomesh/httpbin:ken
docker push localhost:5000/busybox:latest
docker push localhost:5000/curlimages/curl:latest
docker push localhost:5000/flomesh/alpine-debug:latest
docker push localhost:5000/nginx:1.19-alpine
docker push localhost:5000/flomesh/grpcurl:latest
docker push localhost:5000/flomesh/grpcbin:latest
