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

docker push ${LOCAL_REGISTRY}/flomesh/httpbin:latest
docker push ${LOCAL_REGISTRY}/flomesh/httpbin:ken
docker push ${LOCAL_REGISTRY}/busybox:latest
docker push ${LOCAL_REGISTRY}/fortio/fortio:latest
docker push ${LOCAL_REGISTRY}/curlimages/curl:latest
docker push ${LOCAL_REGISTRY}/flomesh/alpine-debug:latest
docker push ${LOCAL_REGISTRY}/nginx:1.19-alpine
docker push ${LOCAL_REGISTRY}/bitnami/zookeeper:3.8.0-debian-10-r11
docker push ${LOCAL_REGISTRY}/bitnami/bitnami-shell:10-debian-10-r378
docker push ${LOCAL_REGISTRY}/flomesh/grpcurl:latest
docker push ${LOCAL_REGISTRY}/flomesh/grpcbin:latest
docker push ${LOCAL_REGISTRY}/jetstack/cert-manager-controller:v1.3.1
docker push ${LOCAL_REGISTRY}/jetstack/cert-manager-cainjector:v1.3.1
docker push ${LOCAL_REGISTRY}/jetstack/cert-manager-webhook:v1.3.1