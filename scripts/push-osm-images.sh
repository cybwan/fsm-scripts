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

docker push localhost:5000/alpine:3
docker push localhost:5000/library/busybox:1.33
docker push localhost:5000/library/golang:1.17
docker push localhost:5000/envoyproxy/envoy:v1.19.3
docker push localhost:5000/projectcontour/contour:v1.18.0
docker push localhost:5000/flomesh/pipy:latest
docker push localhost:5000/flomesh/pipy-nightly:latest
docker push localhost:5000/flomesh/pipy-repo:latest
docker push localhost:5000/flomesh/pipy-repo-nightly:latest
docker push localhost:5000/flomesh/proxy-wasm-cpp-sdk:v2
docker push localhost:5000/prom/prometheus:v2.18.1
docker push localhost:5000/grafana/grafana:8.2.2
docker push localhost:5000/grafana/grafana-image-renderer:3.2.1
docker push localhost:5000/jaegertracing/all-in-one
docker push localhost:5000/fluent/fluent-bit:1.6.4
docker push localhost:5000/distroless/static:latest
docker push localhost:5000/distroless/base:latest
docker push localhost:5000/cybwan/gcr.io.distroless.static:latest
docker push localhost:5000/cybwan/gcr.io.distroless.base:latest
