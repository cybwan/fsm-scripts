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

FSM_HOME=$1

find "${FSM_HOME}"/tests -type f -exec sed -i "s#\"flomesh/httpbin:latest\"#\"${LOCAL_REGISTRY}/flomesh/httpbin:latest\"#g" {} +
find "${FSM_HOME}"/tests -type f -exec sed -i "s#\"flomesh/httpbin:ken\"#\"${LOCAL_REGISTRY}/flomesh/httpbin:ken\"#g" {} +
find "${FSM_HOME}"/tests -type f -exec sed -i "s#\"busybox\"#\"${LOCAL_REGISTRY}/busybox\"#g" {} +
find "${FSM_HOME}"/tests -type f -exec sed -i "s#\"fortio/fortio\"#\"${LOCAL_REGISTRY}/fortio/fortio\"#g" {} +
find "${FSM_HOME}"/tests -type f -exec sed -i "s#\"curlimages/curl\"#\"${LOCAL_REGISTRY}/curlimages/curl\"#g" {} +
find "${FSM_HOME}"/tests -type f -exec sed -i "s#\"flomesh/alpine-debug\"#\"${LOCAL_REGISTRY}/flomesh/alpine-debug\"#g" {} +
find "${FSM_HOME}"/tests -type f -exec sed -i "s#\"nginx:1.19-alpine\"#\"${LOCAL_REGISTRY}/nginx:1.19-alpine\"#g" {} +
find "${FSM_HOME}"/tests -type f -exec sed -i "s#\"flomesh/grpcurl\"#\"${LOCAL_REGISTRY}/flomesh/grpcurl\"#g" {} +
find "${FSM_HOME}"/tests -type f -exec sed -i "s#\"flomesh/grpcbin\"#\"${LOCAL_REGISTRY}/flomesh/grpcbin\"#g" {} +
