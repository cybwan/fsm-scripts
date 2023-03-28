#!/bin/bash

set -euo pipefail

LOCAL_REGISTRY="${LOCAL_REGISTRY:-localhost:5000}"

if [ -z "$1" ]; then
  echo "Error: expected one argument ECN_HOME"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Error: expected one argument OS_ARCH"
  exit 1
fi

ECN_HOME=$1

find "${ECN_HOME}"/dockerfiles -type f -exec sed -i "s# busybox:# ${LOCAL_REGISTRY}/busybox:#g" {} +
find "${ECN_HOME}"/dockerfiles -type f -exec sed -i "s# golang:# ${LOCAL_REGISTRY}/golang:#g" {} +
find "${ECN_HOME}"/dockerfiles -type f -exec sed -i "s# flomesh/osm-edge-interceptor:# ${LOCAL_REGISTRY}/flomesh/osm-edge-interceptor:#g" {} +
find "${ECN_HOME}"/dockerfiles -type f -exec sed -i "s# gcr.io/distroless/static# ${LOCAL_REGISTRY}/distroless/static#g" {} +

sed -i "s# flomesh/pipy:# ${LOCAL_REGISTRY}/flomesh/pipy:#g" "${ECN_HOME}"/charts/ecnet/values.yaml
sed -i "s# flomesh/pipy-nightly:# ${LOCAL_REGISTRY}/flomesh/pipy-nightly:#g" "${ECN_HOME}"/charts/ecnet/values.yaml
sed -i "s# flomesh/pipy-repo:# ${LOCAL_REGISTRY}/flomesh/pipy-repo:#g" "${ECN_HOME}"/charts/ecnet/values.yaml
sed -i "s# flomesh/pipy-repo-nightly:# ${LOCAL_REGISTRY}/flomesh/pipy-repo-nightly:#g" "${ECN_HOME}"/charts/ecnet/values.yaml
sed -i "s#curlImage: curlimages/curl#curlImage: ${LOCAL_REGISTRY}/curlimages/curl#g" "${ECN_HOME}"/charts/ecnet/values.yaml