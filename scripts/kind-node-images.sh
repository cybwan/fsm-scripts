#!/bin/bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument FSM_HOME"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Error: expected one argument OS_ARCH"
  exit 1
fi

if [ -z "$3" ]; then
  echo "Error: expected one argument OS"
  exit 1
fi

BUILD_ARCH=$2

wget -q https://registry.hub.docker.com/v2/repositories/kindest/node-"${BUILD_ARCH}"/tags?page=1\&ordering=name -O - | jq -r '.results[].name'
wget -q https://registry.hub.docker.com/v2/repositories/kindest/node-"${BUILD_ARCH}"/tags?page=2\&ordering=name -O - | jq -r '.results[].name'
wget -q https://registry.hub.docker.com/v2/repositories/kindest/node-"${BUILD_ARCH}"/tags?page=3\&ordering=name -O - | jq -r '.results[].name'
#wget -q https://registry.hub.docker.com/v2/repositories/kindest/node-"${BUILD_ARCH}"/tags?page=4\&ordering=name -O - | jq -r '.results[].name'
#wget -q https://registry.hub.docker.com/v2/repositories/kindest/node-"${BUILD_ARCH}"/tags?page=5\&ordering=name -O - | jq -r '.results[].name'
#wget -q https://registry.hub.docker.com/v2/repositories/kindest/node-"${BUILD_ARCH}"/tags?page=6\&ordering=name -O - | jq -r '.results[].name'