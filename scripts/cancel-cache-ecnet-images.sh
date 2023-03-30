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

find "${ECN_HOME}"/dockerfiles -type f -exec sed -i "s# ${LOCAL_REGISTRY}/alpine:# alpine:#g" {} +
find "${ECN_HOME}"/dockerfiles -type f -exec sed -i "s# ${LOCAL_REGISTRY}/busybox:# busybox:#g" {} +
find "${ECN_HOME}"/dockerfiles -type f -exec sed -i "s# ${LOCAL_REGISTRY}/golang:# golang:#g" {} +
find "${ECN_HOME}"/dockerfiles -type f -exec sed -i "s# ${LOCAL_REGISTRY}/flomesh/ebpf:# flomesh/ebpf:#g" {} +
find "${ECN_HOME}"/dockerfiles -type f -exec sed -i "s# ${LOCAL_REGISTRY}/distroless/static# gcr.io/distroless/static#g" {} +

sed -i "s# ${LOCAL_REGISTRY}/flomesh/pipy:# flomesh/pipy:#g" "${ECN_HOME}"/charts/ecnet/values.yaml
sed -i "s# ${LOCAL_REGISTRY}/flomesh/pipy-nightly:# flomesh/pipy-nightly:#g" "${ECN_HOME}"/charts/ecnet/values.yaml
sed -i "s# ${LOCAL_REGISTRY}/flomesh/pipy-repo:# flomesh/pipy-repo:#g" "${ECN_HOME}"/charts/ecnet/values.yaml
sed -i "s# ${LOCAL_REGISTRY}/flomesh/pipy-repo-nightly:# flomesh/pipy-repo-nightly:#g" "${ECN_HOME}"/charts/ecnet/values.yaml
sed -i "s#curlImage: ${LOCAL_REGISTRY}/curlimages/curl#curlImage: curlimages/curl#g" "${ECN_HOME}"/charts/ecnet/values.yaml