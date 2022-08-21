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

docker tag flomesh/httpbin:latest localhost:5000/flomesh/httpbin:latest
docker tag flomesh/httpbin:ken localhost:5000/flomesh/httpbin:ken
docker tag busybox:latest localhost:5000/busybox:latest
docker tag fortio/fortio:latest localhost:5000/fortio/fortio:latest
docker tag curlimages/curl:latest localhost:5000/curlimages/curl:latest
docker tag flomesh/alpine-debug:latest localhost:5000/flomesh/alpine-debug:latest
docker tag nginx:1.19-alpine localhost:5000/nginx:1.19-alpine
docker tag bitnami/zookeeper:3.8.0-debian-10-r11 localhost:5000/bitnami/zookeeper:3.8.0-debian-10-r11
docker tag bitnami/bitnami-shell:10-debian-10-r378 localhost:5000/bitnami/bitnami-shell:10-debian-10-r378
docker tag flomesh/grpcurl:latest localhost:5000/flomesh/grpcurl:latest
docker tag flomesh/grpcbin:latest localhost:5000/flomesh/grpcbin:latest
