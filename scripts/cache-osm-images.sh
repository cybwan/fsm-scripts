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

find "${OSM_HOME}"/dockerfiles -type f -exec sed -i 's# alpine:3$# localhost:5000/alpine:3#g' {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i 's# flomesh/alpine:3$# localhost:5000/flomesh/alpine:3#g' {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i 's# busybox:1.33# localhost:5000/library/busybox:1.33#g' {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i "s# golang:\$GO_VERSION # localhost:5000/library/golang:\$GO_VERSION #g" {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i 's# gcr.io/distroless/base# localhost:5000/distroless/base#g' {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i 's# gcr.io/distroless/static# localhost:5000/distroless/static#g' {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i 's# cybwan/gcr.io.distroless.base# localhost:5000/cybwan/gcr.io.distroless.base#g' {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i 's# cybwan/gcr.io.distroless.static# localhost:5000/cybwan/gcr.io.distroless.static#g' {} +
find "${OSM_HOME}"/dockerfiles -type f -exec sed -i 's# flomesh/proxy-wasm-cpp-sdk:v2 AS# localhost:5000/flomesh/proxy-wasm-cpp-sdk:v2 AS#g' {} +

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

sed -i 's!flomesh/alpine:3!cybwan/alpine:3-iptables!g' "${OSM_HOME}"/dockerfiles/Dockerfile.osm-edge-sidecar-init
sed -i 's!^RUN apk add --no-cache iptables!#RUN apk add --no-cache iptables!g' "${OSM_HOME}"/dockerfiles/Dockerfile.osm-edge-sidecar-init