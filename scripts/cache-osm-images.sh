#!/bin/bash

set -euo pipefail

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

sed -i 's#docker.io#localhost:5000#g' "${OSM_HOME}"/charts/osm/values.yaml
sed -i 's#sidecarImage: envoyproxy/envoy#sidecarImage: localhost:5000/envoyproxy/envoy#g' "${OSM_HOME}"/charts/osm/values.yaml
sed -i 's#sidecarImage: flomesh/pipy-nightly#sidecarImage: localhost:5000/flomesh/pipy-nightly#g' "${OSM_HOME}"/charts/osm/values.yaml
sed -i 's#sidecarImage: flomesh/pipy#sidecarImage: localhost:5000/flomesh/pipy#g' "${OSM_HOME}"/charts/osm/values.yaml
sed -i 's#curlImage: curlimages/curl#curlImage: localhost:5000/curlimages/curl#g' "${OSM_HOME}"/charts/osm/values.yaml
sed -i 's#image: prom/prometheus:v2.18.1#image: localhost:5000/prom/prometheus:v2.18.1#g' "${OSM_HOME}"/charts/osm/values.yaml
sed -i 's#image: grafana/grafana:8.2.2#image: localhost:5000/grafana/grafana:8.2.2#g' "${OSM_HOME}"/charts/osm/values.yaml
sed -i 's#rendererImage: grafana/grafana-image-renderer:3.2.1#rendererImage: localhost:5000/grafana/grafana-image-renderer:3.2.1#g' "${OSM_HOME}"/charts/osm/values.yaml
sed -i 's#image: jaegertracing/all-in-one#image: localhost:5000/jaegertracing/all-in-one#g' "${OSM_HOME}"/charts/osm/values.yaml
sed -i 's#pipyRepoImage: flomesh/pipy-repo#pipyRepoImage: localhost:5000/flomesh/pipy-repo#g' "${OSM_HOME}"/charts/osm/values.yaml
sed -i 's#registry: fluent#registry: localhost:5000/fluent#g' "${OSM_HOME}"/charts/osm/values.yaml

sed -i 's!^RUN /build_wasm.sh!#RUN /build_wasm.sh!g' "${OSM_HOME}"/dockerfiles/Dockerfile.osm-edge-controller
sed -i 's!flomesh/alpine:3!cybwan/alpine:3-iptables!g' "${OSM_HOME}"/dockerfiles/Dockerfile.osm-edge-sidecar-init
sed -i 's!^RUN apk add --no-cache iptables!#RUN apk add --no-cache iptables!g' "${OSM_HOME}"/dockerfiles/Dockerfile.osm-edge-sidecar-init