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

docker push ${LOCAL_REGISTRY}/alpine:3
docker push ${LOCAL_REGISTRY}/busybox:1.33
docker push ${LOCAL_REGISTRY}/busybox:1.36
docker push ${LOCAL_REGISTRY}/golang:1.19
docker push ${LOCAL_REGISTRY}/flomesh/alpine:3
docker push ${LOCAL_REGISTRY}/prom/prometheus:v2.18.1
docker push ${LOCAL_REGISTRY}/grafana/grafana:8.2.2
docker push ${LOCAL_REGISTRY}/grafana/grafana-image-renderer:3.2.1
docker push ${LOCAL_REGISTRY}/jaegertracing/all-in-one
docker push ${LOCAL_REGISTRY}/fluent/fluent-bit:1.6.4
docker push ${LOCAL_REGISTRY}/distroless/static:latest
docker push ${LOCAL_REGISTRY}/distroless/base:latest
docker push ${LOCAL_REGISTRY}/cybwan/gcr.io.distroless.static:latest
docker push ${LOCAL_REGISTRY}/cybwan/gcr.io.distroless.base:latest
docker push ${LOCAL_REGISTRY}/cybwan/alpine:3-iptables