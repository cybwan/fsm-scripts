#!/bin/bash

set -uo pipefail

LOCAL_REGISTRY="${LOCAL_REGISTRY:-localhost:5000}"

IMG="flomesh/fsm-edge-demo-tcp-echo-server"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="flomesh/fsm-edge-healthcheck"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="flomesh/fsm-edge-preinstall"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="flomesh/fsm-edge-bootstrap"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="flomesh/fsm-edge-injector"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="flomesh/fsm-edge-controller"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="flomesh/fsm-edge-crds"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="flomesh/fsm-edge-sidecar-init"; docker rmi "${LOCAL_REGISTRY}/${IMG}"

IMG="alpine:3"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="busybox:latest"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="fortio/fortio:latest"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="curlimages/curl:latest"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="curlimages/curl:latest"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="devilbox/mysql:mysql-8.0"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="grafana/grafana:8.2.2"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="grafana/grafana-image-renderer:3.2.1"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="jaegertracing/all-in-one"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="library/busybox:1.33"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="library/golang:1.19"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="nginx:1.19-alpine"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="projectcontour/contour:v1.18.0"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="prom/prometheus:v2.18.1"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="flomesh/pipy:latest"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="flomesh/pipy-nightly:latest"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="flomesh/pipy-repo:latest"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="flomesh/pipy-repo-nightly:latest"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="flomesh/grpcurl:latest"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="flomesh/grpcbin:latest"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="flomesh/httpbin:latest"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="flomesh/httpbin:ken"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="flomesh/alpine:3"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="flomesh/alpine-debug:latest"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="fluent/fluent-bit:1.6.4"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="bitnami/zookeeper:3.8.0-debian-10-r11"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="bitnami/bitnami-shell:10-debian-10-r378"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="cybwan/gcr.io.distroless.static:latest"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="cybwan/gcr.io.distroless.base:latest"; docker rmi "${LOCAL_REGISTRY}/${IMG}"
IMG="jetstack/cert-manager-controller:v1.3.1"; docker rmi "quay.io/${IMG}" "${LOCAL_REGISTRY}/${IMG}"
IMG="jetstack/cert-manager-cainjector:v1.3.1"; docker rmi "quay.io/${IMG}" "${LOCAL_REGISTRY}/${IMG}"
IMG="jetstack/cert-manager-webhook:v1.3.1"; docker rmi "quay.io/${IMG}" "${LOCAL_REGISTRY}/${IMG}"

IMG="distroless/base:latest"; docker rmi "gcr.io/${IMG}" "${LOCAL_REGISTRY}/${IMG}"
IMG="distroless/static:latest"; docker rmi "gcr.io/${IMG}" "${LOCAL_REGISTRY}/${IMG}"

docker container prune -f
docker volume prune -f
docker image prune -f
