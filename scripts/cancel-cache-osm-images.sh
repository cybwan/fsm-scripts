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

if [ -f "${OSM_HOME}"/dockerfiles/Dockerfile.osm-edge-sidecar-init ]; then
  sed -i 's!cybwan/alpine:3-iptables!flomesh/alpine:3!g' "${OSM_HOME}"/dockerfiles/Dockerfile.osm-edge-sidecar-init
  sed -i 's!^#RUN apk add --no-cache iptables!RUN apk add --no-cache iptables!g' "${OSM_HOME}"/dockerfiles/Dockerfile.osm-edge-sidecar-init
fi

find "${OSM_HOME}"/dockerfiles -type f -exec sed -i "s# ${LOCAL_REGISTRY}/alpine:# alpine:#g" {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i "s# ${LOCAL_REGISTRY}/flomesh/alpine:# flomesh/alpine:#g" {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i "s# ${LOCAL_REGISTRY}/flomesh/ebpf:# flomesh/ebpf:#g" {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i "s# ${LOCAL_REGISTRY}/busybox:# busybox:#g" {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i "s# ${LOCAL_REGISTRY}/golang:# golang:#g" {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i "s# ${LOCAL_REGISTRY}/distroless# gcr.io/distroless#g" {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i "s# ${LOCAL_REGISTRY}/flomesh/proxy-wasm-cpp-sdk:# flomesh/proxy-wasm-cpp-sdk:#g" {} +

sed -i "s#sidecarImage: ${LOCAL_REGISTRY}/envoyproxy/envoy#sidecarImage: envoyproxy/envoy#g" "${OSM_HOME}"/charts/osm/values.yaml
sed -i "s#sidecarImage: ${LOCAL_REGISTRY}/flomesh/pipy-nightly#sidecarImage: flomesh/pipy-nightly#g" "${OSM_HOME}"/charts/osm/values.yaml
sed -i "s#sidecarImage: ${LOCAL_REGISTRY}/flomesh/pipy#sidecarImage: flomesh/pipy#g" "${OSM_HOME}"/charts/osm/values.yaml
sed -i "s#curlImage: ${LOCAL_REGISTRY}/curlimages/curl#curlImage: curlimages/curl#g" "${OSM_HOME}"/charts/osm/values.yaml
sed -i "s#image: ${LOCAL_REGISTRY}/prom/prometheus:v2.18.1#image: prom/prometheus:v2.18.1#g" "${OSM_HOME}"/charts/osm/values.yaml
sed -i "s#image: ${LOCAL_REGISTRY}/grafana/grafana:8.2.2#image: grafana/grafana:8.2.2#g" "${OSM_HOME}"/charts/osm/values.yaml
sed -i "s#rendererImage: ${LOCAL_REGISTRY}/grafana/grafana-image-renderer:3.2.1#rendererImage: grafana/grafana-image-renderer:3.2.1#g" "${OSM_HOME}"/charts/osm/values.yaml
sed -i "s#image: ${LOCAL_REGISTRY}/jaegertracing/all-in-one#image: jaegertracing/all-in-one#g" "${OSM_HOME}"/charts/osm/values.yaml
sed -i "s#${LOCAL_REGISTRY}\$#docker.io#g" "${OSM_HOME}"/charts/osm/values.yaml
sed -i "s#image: ${LOCAL_REGISTRY}/flomesh/pipy-repo#image: flomesh/pipy-repo#g" "${OSM_HOME}"/charts/osm/values.yaml
sed -i "s#registry: ${LOCAL_REGISTRY}/fluent#registry: fluent#g" "${OSM_HOME}"/charts/osm/values.yaml