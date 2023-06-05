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

docker pull flomesh/httpbin:latest
docker pull flomesh/httpbin:ken
docker pull busybox:latest
docker pull fortio/fortio:latest
docker pull curlimages/curl:latest
docker pull flomesh/alpine-debug:latest
docker pull nginx:1.19-alpine
docker pull flomesh/grpcurl:latest
docker pull flomesh/grpcbin:latest
docker pull bitnami/zookeeper:3.8.0-debian-10-r11
docker pull bitnami/bitnami-shell:10-debian-10-r378
docker pull quay.io/jetstack/cert-manager-controller:v1.3.1
docker pull quay.io/jetstack/cert-manager-cainjector:v1.3.1
docker pull quay.io/jetstack/cert-manager-webhook:v1.3.1