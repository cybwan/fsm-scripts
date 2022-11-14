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

docker tag docker.io/alpine:3 localhost:5000/alpine:3
docker tag docker.io/library/busybox:1.33 localhost:5000/library/busybox:1.33
docker tag docker.io/library/golang:1.19 localhost:5000/library/golang:1.19
docker tag docker.io/envoyproxy/envoy:v1.19.3 localhost:5000/envoyproxy/envoy:v1.19.3
docker tag docker.io/projectcontour/contour:v1.18.0 localhost:5000/projectcontour/contour:v1.18.0
docker tag docker.io/flomesh/alpine:3 localhost:5000/flomesh/alpine:3
docker tag docker.io/flomesh/proxy-wasm-cpp-sdk:v2 localhost:5000/flomesh/proxy-wasm-cpp-sdk:v2
docker tag docker.io/prom/prometheus:v2.18.1 localhost:5000/prom/prometheus:v2.18.1
docker tag docker.io/grafana/grafana:8.2.2 localhost:5000/grafana/grafana:8.2.2
docker tag docker.io/grafana/grafana-image-renderer:3.2.1 localhost:5000/grafana/grafana-image-renderer:3.2.1
docker tag docker.io/jaegertracing/all-in-one localhost:5000/jaegertracing/all-in-one
docker tag docker.io/fluent/fluent-bit:1.6.4 localhost:5000/fluent/fluent-bit:1.6.4
docker tag docker.io/cybwan/gcr.io.distroless.base:latest localhost:5000/distroless/base:latest
docker tag docker.io/cybwan/gcr.io.distroless.static:latest localhost:5000/cybwan/gcr.io.distroless.static:latest
docker tag docker.io/cybwan/gcr.io.distroless.base:latest localhost:5000/cybwan/gcr.io.distroless.base:latest
docker tag docker.io/cybwan/gcr.io.distroless.static:latest localhost:5000/distroless/static:latest
docker tag docker.io/cybwan/alpine:3-iptables localhost:5000/cybwan/alpine:3-iptables