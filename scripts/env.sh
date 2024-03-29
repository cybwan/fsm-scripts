#!/bin/bash

set -euo pipefail

LOCAL_REGISTRY="${LOCAL_REGISTRY:-localhost:5000}"

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

FSM_HOME=$1
BUILD_ARCH=$2
BUILD_OS=$3
TARGETS=${BUILD_OS}/${BUILD_ARCH}
DOCKER_BUILDX_PLATFORM=${BUILD_OS}/${BUILD_ARCH}

cd "${FSM_HOME}"
make .env
sed -i "s/localhost:5000$/${LOCAL_REGISTRY}\/flomesh/g" .env
sed -i 's/^# export CTR_TAG=.*/export CTR_TAG=latest/g' .env
sed -i 's/^#export USE_PRIVATE_REGISTRY=.*/export USE_PRIVATE_REGISTRY=true/g' .env

if [ -f ~/.bashrc ]; then
  sed -i '/^export TARGETS=/d' ~/.bashrc
  sed -i '/^export DOCKER_BUILDX_PLATFORM=/d' ~/.bashrc
  sed -i '/^export CTR_REGISTRY=/d' ~/.bashrc
  sed -i '/^export CTR_TAG=/d' ~/.bashrc

  cat >> ~/.bashrc <<EOF
export TARGETS=${TARGETS}
export DOCKER_BUILDX_PLATFORM=${DOCKER_BUILDX_PLATFORM}
export CTR_REGISTRY=localhost:5000/flomesh
export CTR_TAG=latest
EOF
fi