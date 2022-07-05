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

docker pull flomesh/httpbin:latest
docker pull flomesh/httpbin:ken
docker pull busybox:latest
docker pull curlimages/curl:latest
docker pull flomesh/alpine-debug:latest
docker pull nginx:1.19-alpine
docker pull flomesh/grpcurl:latest
docker pull flomesh/grpcbin:latest
