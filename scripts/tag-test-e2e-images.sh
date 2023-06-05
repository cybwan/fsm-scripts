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

docker tag flomesh/httpbin:latest ${LOCAL_REGISTRY}/flomesh/httpbin:latest
docker tag flomesh/httpbin:ken ${LOCAL_REGISTRY}/flomesh/httpbin:ken
docker tag busybox:latest ${LOCAL_REGISTRY}/busybox:latest
docker tag fortio/fortio:latest ${LOCAL_REGISTRY}/fortio/fortio:latest
docker tag curlimages/curl:latest ${LOCAL_REGISTRY}/curlimages/curl:latest
docker tag flomesh/alpine-debug:latest ${LOCAL_REGISTRY}/flomesh/alpine-debug:latest
docker tag nginx:1.19-alpine ${LOCAL_REGISTRY}/nginx:1.19-alpine
docker tag bitnami/zookeeper:3.8.0-debian-10-r11 ${LOCAL_REGISTRY}/bitnami/zookeeper:3.8.0-debian-10-r11
docker tag bitnami/bitnami-shell:10-debian-10-r378 ${LOCAL_REGISTRY}/bitnami/bitnami-shell:10-debian-10-r378
docker tag flomesh/grpcurl:latest ${LOCAL_REGISTRY}/flomesh/grpcurl:latest
docker tag flomesh/grpcbin:latest ${LOCAL_REGISTRY}/flomesh/grpcbin:latest
docker tag quay.io/jetstack/cert-manager-controller:v1.3.1 ${LOCAL_REGISTRY}/jetstack/cert-manager-controller:v1.3.1
docker tag quay.io/jetstack/cert-manager-cainjector:v1.3.1 ${LOCAL_REGISTRY}/jetstack/cert-manager-cainjector:v1.3.1
docker tag quay.io/jetstack/cert-manager-webhook:v1.3.1 ${LOCAL_REGISTRY}/jetstack/cert-manager-webhook:v1.3.1