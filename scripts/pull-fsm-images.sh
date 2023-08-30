#!/bin/bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument FSM_HOME"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Error: expected one argument OS_ARCH"
  exit 1
fi

FSM_HOME=$1

docker pull docker.io/alpine:3
docker pull docker.io/library/busybox:1.33
docker pull docker.io/library/busybox:1.36
docker pull docker.io/library/golang:1.19
docker pull docker.io/library/golang:1.20
docker pull docker.io/projectcontour/contour:v1.18.0
docker pull docker.io/flomesh/alpine:3
docker pull docker.io/prom/prometheus:v2.18.1
docker pull docker.io/grafana/grafana:8.2.2
docker pull docker.io/grafana/grafana-image-renderer:3.2.1
docker pull docker.io/jaegertracing/all-in-one
docker pull docker.io/fluent/fluent-bit:1.6.4
#docker pull gcr.io/distroless/base:latest
#docker pull gcr.io/distroless/static:latest
docker pull docker.io/cybwan/gcr.io.distroless.static:latest
docker pull docker.io/cybwan/gcr.io.distroless.base:latest
docker pull docker.io/cybwan/alpine:3-iptables