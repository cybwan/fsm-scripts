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

if [ -f "${FSM_HOME}"/dockerfiles/Dockerfile.fsm-sidecar-init ]; then
  sed -i 's!cybwan/alpine:3-iptables!flomesh/alpine:3!g' "${FSM_HOME}"/dockerfiles/Dockerfile.fsm-sidecar-init
  sed -i 's!^#RUN apk add --no-cache iptables!RUN apk add --no-cache iptables!g' "${FSM_HOME}"/dockerfiles/Dockerfile.fsm-sidecar-init
fi

find "${FSM_HOME}"/dockerfiles -type f -exec sed -i "s# ${LOCAL_REGISTRY}/alpine:# alpine:#g" {} +
find "${FSM_HOME}"/dockerfiles -type f -exec sed -i "s# ${LOCAL_REGISTRY}/flomesh/alpine:# flomesh/alpine:#g" {} +
find "${FSM_HOME}"/dockerfiles -type f -exec sed -i "s# ${LOCAL_REGISTRY}/flomesh/ebpf:# flomesh/ebpf:#g" {} +
find "${FSM_HOME}"/dockerfiles -type f -exec sed -i "s# ${LOCAL_REGISTRY}/flomesh/pipy:# flomesh/pipy:#g" {} +
find "${FSM_HOME}"/dockerfiles -type f -exec sed -i "s# ${LOCAL_REGISTRY}/busybox:# busybox:#g" {} +
find "${FSM_HOME}"/dockerfiles -type f -exec sed -i "s# ${LOCAL_REGISTRY}/golang:# golang:#g" {} +
find "${FSM_HOME}"/dockerfiles -type f -exec sed -i "s# ${LOCAL_REGISTRY}/distroless# gcr.io/distroless#g" {} +

sed -i "s#sidecarImage: ${LOCAL_REGISTRY}/flomesh/pipy-nightly#sidecarImage: flomesh/pipy-nightly#g" "${FSM_HOME}"/charts/fsm/values.yaml
sed -i "s#sidecarImage: ${LOCAL_REGISTRY}/flomesh/pipy#sidecarImage: flomesh/pipy#g" "${FSM_HOME}"/charts/fsm/values.yaml
sed -i "s#curlImage: ${LOCAL_REGISTRY}/curlimages/curl#curlImage: curlimages/curl#g" "${FSM_HOME}"/charts/fsm/values.yaml
sed -i "s#image: ${LOCAL_REGISTRY}/prom/prometheus:v2.18.1#image: prom/prometheus:v2.18.1#g" "${FSM_HOME}"/charts/fsm/values.yaml
sed -i "s#image: ${LOCAL_REGISTRY}/grafana/grafana:8.2.2#image: grafana/grafana:8.2.2#g" "${FSM_HOME}"/charts/fsm/values.yaml
sed -i "s#rendererImage: ${LOCAL_REGISTRY}/grafana/grafana-image-renderer:3.2.1#rendererImage: grafana/grafana-image-renderer:3.2.1#g" "${FSM_HOME}"/charts/fsm/values.yaml
sed -i "s#image: ${LOCAL_REGISTRY}/jaegertracing/all-in-one#image: jaegertracing/all-in-one#g" "${FSM_HOME}"/charts/fsm/values.yaml
sed -i "s#${LOCAL_REGISTRY}\$#docker.io#g" "${FSM_HOME}"/charts/fsm/values.yaml
sed -i "s#image: ${LOCAL_REGISTRY}/flomesh/pipy-repo#image: flomesh/pipy-repo#g" "${FSM_HOME}"/charts/fsm/values.yaml
sed -i "s#registry: ${LOCAL_REGISTRY}/fluent#registry: fluent#g" "${FSM_HOME}"/charts/fsm/values.yaml