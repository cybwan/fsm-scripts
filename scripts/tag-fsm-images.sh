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

docker tag docker.io/alpine:3 ${LOCAL_REGISTRY}/alpine:3
docker tag docker.io/library/busybox:1.33 ${LOCAL_REGISTRY}/busybox:1.33
docker tag docker.io/library/busybox:1.36 ${LOCAL_REGISTRY}/busybox:1.36
docker tag docker.io/library/golang:1.19  ${LOCAL_REGISTRY}/golang:1.19
docker tag docker.io/library/golang:1.20  ${LOCAL_REGISTRY}/golang:1.20
docker tag docker.io/projectcontour/contour:v1.18.0 ${LOCAL_REGISTRY}/projectcontour/contour:v1.18.0
docker tag docker.io/flomesh/alpine:3 ${LOCAL_REGISTRY}/flomesh/alpine:3
docker tag docker.io/prom/prometheus:v2.18.1 ${LOCAL_REGISTRY}/prom/prometheus:v2.18.1
docker tag docker.io/grafana/grafana:8.2.2 ${LOCAL_REGISTRY}/grafana/grafana:8.2.2
docker tag docker.io/grafana/grafana-image-renderer:3.2.1 ${LOCAL_REGISTRY}/grafana/grafana-image-renderer:3.2.1
docker tag docker.io/jaegertracing/all-in-one ${LOCAL_REGISTRY}/jaegertracing/all-in-one
docker tag docker.io/fluent/fluent-bit:1.6.4 ${LOCAL_REGISTRY}/fluent/fluent-bit:1.6.4
docker tag docker.io/cybwan/gcr.io.distroless.base:latest ${LOCAL_REGISTRY}/distroless/base:latest
docker tag docker.io/cybwan/gcr.io.distroless.static:latest ${LOCAL_REGISTRY}/cybwan/gcr.io.distroless.static:latest
docker tag docker.io/cybwan/gcr.io.distroless.base:latest ${LOCAL_REGISTRY}/cybwan/gcr.io.distroless.base:latest
docker tag docker.io/cybwan/gcr.io.distroless.static:latest ${LOCAL_REGISTRY}/distroless/static:latest
docker tag docker.io/cybwan/alpine:3-iptables ${LOCAL_REGISTRY}/cybwan/alpine:3-iptables