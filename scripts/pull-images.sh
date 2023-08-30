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

docker pull alpine:3
docker pull busybox:latest
docker pull fortio/fortio:latest
docker pull curlimages/curl:latest
docker pull devilbox/mysql:mysql-8.0
docker pull grafana/grafana:8.2.2
docker pull grafana/grafana-image-renderer:3.2.1
docker pull jaegertracing/all-in-one
docker pull busybox:1.33
docker pull busybox:1.36
docker pull golang:1.19
docker pull golang:1.20
docker pull nginx:1.19-alpine
docker pull projectcontour/contour:v1.18.0
docker pull prom/prometheus:v2.18.1
docker pull fluent/fluent-bit:1.6.4

docker pull flomesh/grpcurl:latest
docker pull flomesh/grpcbin:latest
docker pull flomesh/httpbin:latest
docker pull flomesh/httpbin:ken
docker pull flomesh/alpine-debug:latest
docker pull flomesh/alpine:3
docker pull bitnami/zookeeper:3.8.0-debian-10-r11
docker pull bitnami/bitnami-shell:10-debian-10-r378

docker pull quay.io/jetstack/cert-manager-controller:v1.3.1
docker pull quay.io/jetstack/cert-manager-cainjector:v1.3.1
docker pull quay.io/jetstack/cert-manager-webhook:v1.3.1

docker pull cybwan/gcr.io.distroless.static:latest
docker pull cybwan/gcr.io.distroless.base:latest
docker pull cybwan/alpine:3-iptables