#!/bin/bash

set -uo pipefail

IMG="flomesh/osm-edge-demo-tcp-echo-server"; docker rmi "localhost:5000/${IMG}"
IMG="flomesh/osm-edge-healthcheck"; docker rmi "localhost:5000/${IMG}"
IMG="flomesh/osm-edge-preinstall"; docker rmi "localhost:5000/${IMG}"
IMG="flomesh/osm-edge-bootstrap"; docker rmi "localhost:5000/${IMG}"
IMG="flomesh/osm-edge-injector"; docker rmi "localhost:5000/${IMG}"
IMG="flomesh/osm-edge-controller"; docker rmi "localhost:5000/${IMG}"
IMG="flomesh/osm-edge-crds"; docker rmi "localhost:5000/${IMG}"
IMG="flomesh/osm-edge-sidecar-init"; docker rmi "localhost:5000/${IMG}"

IMG="alpine:3"; docker rmi "localhost:5000/${IMG}"
IMG="busybox:latest"; docker rmi "localhost:5000/${IMG}"
IMG="fortio/fortio:latest"; docker rmi "localhost:5000/${IMG}"
IMG="curlimages/curl:latest"; docker rmi "localhost:5000/${IMG}"
IMG="curlimages/curl:latest"; docker rmi "localhost:5000/${IMG}"
IMG="devilbox/mysql:mysql-8.0"; docker rmi "localhost:5000/${IMG}"
IMG="envoyproxy/envoy:v1.19.3"; docker rmi "localhost:5000/${IMG}"
IMG="grafana/grafana:8.2.2"; docker rmi "localhost:5000/${IMG}"
IMG="grafana/grafana-image-renderer:3.2.1"; docker rmi "localhost:5000/${IMG}"
IMG="jaegertracing/all-in-one"; docker rmi "localhost:5000/${IMG}"
IMG="library/busybox:1.33"; docker rmi "localhost:5000/${IMG}"
IMG="library/golang:1.17"; docker rmi "localhost:5000/${IMG}"
IMG="nginx:1.19-alpine"; docker rmi "localhost:5000/${IMG}"
IMG="projectcontour/contour:v1.18.0"; docker rmi "localhost:5000/${IMG}"
IMG="prom/prometheus:v2.18.1"; docker rmi "localhost:5000/${IMG}"
IMG="flomesh/pipy:latest"; docker rmi "localhost:5000/${IMG}"
IMG="flomesh/pipy-nightly:latest"; docker rmi "localhost:5000/${IMG}"
IMG="flomesh/pipy-repo:latest"; docker rmi "localhost:5000/${IMG}"
IMG="flomesh/pipy-repo-nightly:latest"; docker rmi "localhost:5000/${IMG}"
IMG="flomesh/grpcurl:latest"; docker rmi "localhost:5000/${IMG}"
IMG="flomesh/grpcbin:latest"; docker rmi "localhost:5000/${IMG}"
IMG="flomesh/httpbin:latest"; docker rmi "localhost:5000/${IMG}"
IMG="flomesh/httpbin:ken"; docker rmi "localhost:5000/${IMG}"
IMG="flomesh/alpine:3"; docker rmi "localhost:5000/${IMG}"
IMG="flomesh/alpine-debug:latest"; docker rmi "localhost:5000/${IMG}"
IMG="flomesh/proxy-wasm-cpp-sdk:v2"; docker rmi "localhost:5000/${IMG}"
IMG="fluent/fluent-bit:1.6.4"; docker rmi "localhost:5000/${IMG}"
IMG="bitnami/zookeeper:3.8.0-debian-10-r11"; docker rmi "localhost:5000/${IMG}"
IMG="bitnami/bitnami-shell:10-debian-10-r378"; docker rmi "localhost:5000/${IMG}"
IMG="cybwan/gcr.io.distroless.static:latest"; docker rmi "localhost:5000/${IMG}"
IMG="cybwan/gcr.io.distroless.base:latest"; docker rmi "localhost:5000/${IMG}"
IMG="jetstack/cert-manager-controller:v1.3.1"; docker rmi "quay.io/${IMG}" "localhost:5000/${IMG}"
IMG="jetstack/cert-manager-cainjector:v1.3.1"; docker rmi "quay.io/${IMG}" "localhost:5000/${IMG}"
IMG="jetstack/cert-manager-webhook:v1.3.1"; docker rmi "quay.io/${IMG}" "localhost:5000/${IMG}"

IMG="distroless/base:latest"; docker rmi "gcr.io/${IMG}" "localhost:5000/${IMG}"
IMG="distroless/static:latest"; docker rmi "gcr.io/${IMG}" "localhost:5000/${IMG}"

docker container prune -f
docker volume prune -f
docker image prune -f
