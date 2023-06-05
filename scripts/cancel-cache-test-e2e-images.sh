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

find "${FSM_HOME}"/tests -type f -exec sed -i "s#\"${LOCAL_REGISTRY}/flomesh/httpbin:latest\"#\"flomesh/httpbin:latest\"#g" {} +
find "${FSM_HOME}"/tests -type f -exec sed -i "s#\"${LOCAL_REGISTRY}/flomesh/httpbin:ken\"#\"flomesh/httpbin:ken\"#g" {} +
find "${FSM_HOME}"/tests -type f -exec sed -i "s#\"${LOCAL_REGISTRY}/busybox\"#\"busybox\"#g" {} +
find "${FSM_HOME}"/tests -type f -exec sed -i "s#\"${LOCAL_REGISTRY}/fortio/fortio\"#\"fortio/fortio\"#g" {} +
find "${FSM_HOME}"/tests -type f -exec sed -i "s#\"${LOCAL_REGISTRY}/curlimages/curl\"#\"curlimages/curl\"#g" {} +
find "${FSM_HOME}"/tests -type f -exec sed -i "s#\"${LOCAL_REGISTRY}/flomesh/alpine-debug\"#\"flomesh/alpine-debug\"#g" {} +
find "${FSM_HOME}"/tests -type f -exec sed -i "s#\"${LOCAL_REGISTRY}/nginx:1.19-alpine\"#\"nginx:1.19-alpine\"#g" {} +
find "${FSM_HOME}"/tests -type f -exec sed -i "s#\"${LOCAL_REGISTRY}/flomesh/grpcurl\"#\"flomesh/grpcurl\"#g" {} +
find "${FSM_HOME}"/tests -type f -exec sed -i "s#\"${LOCAL_REGISTRY}/flomesh/grpcbin\"#\"flomesh/grpcbin\"#g" {} +
