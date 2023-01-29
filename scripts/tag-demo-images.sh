#!/bin/bash

set -euo pipefail

LOCAL_REGISTRY="${LOCAL_REGISTRY:-localhost:5000}"

if [ -z "$1" ]; then
  echo "Error: expected one argument OSM_HOME"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Error: expected one argument OS_ARCH"
  exit 1
fi

OSM_HOME=$1

docker tag docker.io/devilbox/mysql:mysql-8.0 ${LOCAL_REGISTRY}/devilbox/mysql:mysql-8.0
docker tag docker.io/curlimages/curl:latest ${LOCAL_REGISTRY}/curlimages/curl:latest
