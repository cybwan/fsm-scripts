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

find "${OSM_HOME}"/dockerfiles -type f -exec sed -i "s# alpine:# ${LOCAL_REGISTRY}/alpine:#g" {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i "s# flomesh/alpine:# ${LOCAL_REGISTRY}/flomesh/alpine:#g" {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i "s# flomesh/ebpf:# ${LOCAL_REGISTRY}/flomesh/ebpf:#g" {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i "s# busybox:# ${LOCAL_REGISTRY}/busybox:#g" {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i "s# golang:# ${LOCAL_REGISTRY}/golang:#g" {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i "s# gcr.io/distroless# ${LOCAL_REGISTRY}/distroless#g" {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i "s# flomesh/proxy-wasm-cpp-sdk:# ${LOCAL_REGISTRY}/flomesh/proxy-wasm-cpp-sdk:#g" {} +

sed -i "s#docker.io#${LOCAL_REGISTRY}#g" "${OSM_HOME}"/charts/osm/values.yaml
sed -i "s#sidecarImage: envoyproxy/envoy#sidecarImage: ${LOCAL_REGISTRY}/envoyproxy/envoy#g" "${OSM_HOME}"/charts/osm/values.yaml
sed -i "s#sidecarImage: flomesh/pipy-nightly#sidecarImage: ${LOCAL_REGISTRY}/flomesh/pipy-nightly#g" "${OSM_HOME}"/charts/osm/values.yaml
sed -i "s#sidecarImage: flomesh/pipy#sidecarImage: ${LOCAL_REGISTRY}/flomesh/pipy#g" "${OSM_HOME}"/charts/osm/values.yaml
sed -i "s#curlImage: curlimages/curl#curlImage: ${LOCAL_REGISTRY}/curlimages/curl#g" "${OSM_HOME}"/charts/osm/values.yaml
sed -i "s#image: prom/prometheus:v2.18.1#image: ${LOCAL_REGISTRY}/prom/prometheus:v2.18.1#g" "${OSM_HOME}"/charts/osm/values.yaml
sed -i "s#image: grafana/grafana:8.2.2#image: ${LOCAL_REGISTRY}/grafana/grafana:8.2.2#g" "${OSM_HOME}"/charts/osm/values.yaml
sed -i "s#rendererImage: grafana/grafana-image-renderer:3.2.1#rendererImage: ${LOCAL_REGISTRY}/grafana/grafana-image-renderer:3.2.1#g" "${OSM_HOME}"/charts/osm/values.yaml
sed -i "s#image: jaegertracing/all-in-one#image: ${LOCAL_REGISTRY}/jaegertracing/all-in-one#g" "${OSM_HOME}"/charts/osm/values.yaml
sed -i "s#image: flomesh/pipy-repo#image: ${LOCAL_REGISTRY}/flomesh/pipy-repo#g" "${OSM_HOME}"/charts/osm/values.yaml
sed -i "s#registry: fluent#registry: ${LOCAL_REGISTRY}/fluent#g" "${OSM_HOME}"/charts/osm/values.yaml

if [ -f "${OSM_HOME}"/dockerfiles/Dockerfile.osm-edge-sidecar-init ]; then
  sed -i 's!flomesh/alpine:3!cybwan/alpine:3-iptables!g' "${OSM_HOME}"/dockerfiles/Dockerfile.osm-edge-sidecar-init
  sed -i 's!^RUN apk add --no-cache iptables!#RUN apk add --no-cache iptables!g' "${OSM_HOME}"/dockerfiles/Dockerfile.osm-edge-sidecar-init
fi