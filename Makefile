#!/bin/bash

ARCH_MAP_x86_64 := amd64
ARCH_MAP_arm64 := arm64
ARCH_MAP_aarch64 := arm64

BUILDARCH := $(ARCH_MAP_$(shell uname -m))
BUILDOS := $(shell uname -s | tr '[:upper:]' '[:lower:]')

TARGETS := $(BUILDOS)/$(BUILDARCH)
DOCKER_BUILDX_PLATFORM := $(BUILDOS)/$(BUILDARCH)

OSM_HOME ?= $(abspath ../osm-edge)

default: build

install-docker:
	scripts/install-docker.sh

install-k8s-tools: install-docker
	scripts/install-k8s-tools.sh ${BUILDARCH} ${BUILDOS}

install-golang:
	make -f scripts/Makefile.golang

kind-k8s-version:
	scripts/kind-node-images.sh ${OSM_HOME} ${BUILDARCH} ${BUILDOS}

.env:
	scripts/env.sh ${OSM_HOME} ${BUILDARCH} ${BUILDOS}

secret:
	scripts/secret.sh ${OSM_HOME}

goproxy:
	@sed -i 's/CH go/CH GO111MODULE=on GOPROXY=https:\/\/goproxy.cn go/g' ${OSM_HOME}/dockerfiles/Dockerfile.demo
	@sed -i 's/CH go/CH GO111MODULE=on GOPROXY=https:\/\/goproxy.cn go/g' ${OSM_HOME}/dockerfiles/Dockerfile.osm-edge-bootstrap
	@sed -i 's/CH go/CH GO111MODULE=on GOPROXY=https:\/\/goproxy.cn go/g' ${OSM_HOME}/dockerfiles/Dockerfile.osm-edge-injector
	@sed -i 's/CH go/CH GO111MODULE=on GOPROXY=https:\/\/goproxy.cn go/g' ${OSM_HOME}/dockerfiles/Dockerfile.osm-edge-controller

goproxy-reset:
	@sed -i 's/CH GO111MODULE=on GOPROXY=https:\/\/goproxy.cn go/CH go/g' ${OSM_HOME}/dockerfiles/Dockerfile.demo
	@sed -i 's/CH GO111MODULE=on GOPROXY=https:\/\/goproxy.cn go/CH go/g' ${OSM_HOME}/dockerfiles/Dockerfile.osm-edge-bootstrap
	@sed -i 's/CH GO111MODULE=on GOPROXY=https:\/\/goproxy.cn go/CH go/g' ${OSM_HOME}/dockerfiles/Dockerfile.osm-edge-injector
	@sed -i 's/CH GO111MODULE=on GOPROXY=https:\/\/goproxy.cn go/CH go/g' ${OSM_HOME}/dockerfiles/Dockerfile.osm-edge-controller

adapter-os-arch:
	scripts/adapter-os-arch.sh ${OSM_HOME} ${BUILDARCH}

disable-wasm-stats:
	scripts/disable-wasm-stats.sh ${OSM_HOME} ${BUILDARCH}

enable-wasm-stats:
	scripts/enable-wasm-stats.sh ${OSM_HOME} ${BUILDARCH}

pull-images:
	scripts/pull-images.sh ${OSM_HOME} ${BUILDARCH}
	#scripts/pull-osm-images.sh ${OSM_HOME} ${BUILDARCH}
	#scripts/pull-demo-images.sh ${OSM_HOME} ${BUILDARCH}
	#scripts/pull-test-e2e-images.sh ${OSM_HOME} ${BUILDARCH}

tag-images:
	scripts/tag-osm-images.sh ${OSM_HOME} ${BUILDARCH}
	scripts/tag-demo-images.sh ${OSM_HOME} ${BUILDARCH}
	scripts/tag-test-e2e-images.sh ${OSM_HOME} ${BUILDARCH}

push-images:
	scripts/push-osm-images.sh ${OSM_HOME} ${BUILDARCH}
	scripts/push-demo-images.sh ${OSM_HOME} ${BUILDARCH}
	scripts/push-test-e2e-images.sh ${OSM_HOME} ${BUILDARCH}

cache-images:
	scripts/cache-osm-images.sh ${OSM_HOME} ${BUILDARCH}
	scripts/cache-demo-images.sh ${OSM_HOME} ${BUILDARCH}
	scripts/cache-test-e2e-images.sh ${OSM_HOME} ${BUILDARCH}
	scripts/cache-zookeeper-chart.sh ${OSM_HOME} ${BUILDARCH}
	scripts/cache-cert-manager-chart.sh ${OSM_HOME} ${BUILDARCH}

load-images-without-clean: pull-images tag-images push-images
	scripts/clean-tag-docker.sh

load-images: clean-tag-docker clean-local-registry load-images-without-clean

reload-flomesh-pipy-images:
	scripts/reload-flomesh-pipy-images.sh
	scripts/list-local-registry.sh

reload-flomesh-fsm-images:
	scripts/reload-flomesh-fsm-images.sh
	scripts/list-local-registry.sh

cancel-cache-images:
	scripts/cancel-cache-osm-images.sh ${OSM_HOME} ${BUILDARCH}
	scripts/cancel-cache-demo-images.sh ${OSM_HOME} ${BUILDARCH}
	scripts/cancel-cache-test-e2e-images.sh ${OSM_HOME} ${BUILDARCH}
	scripts/cancel-cache-zookeeper-chart.sh ${OSM_HOME} ${BUILDARCH}
	scripts/cancel-cache-cert-manager-chart.sh ${OSM_HOME} ${BUILDARCH}

switch-sidecar-to-pipy: disable-wasm-stats
	scripts/switch-sidecar.sh ${OSM_HOME} ${BUILDARCH} pipy

switch-sidecar-to-envoy: enable-wasm-stats
	scripts/switch-sidecar.sh ${OSM_HOME} ${BUILDARCH} envoy

build-osm-images:
	scripts/build-osm-images.sh ${OSM_HOME}

digest-charts-osm-images:
	scripts/digest-charts-osm-images.sh ${OSM_HOME}

build-osm-cli:
	scripts/build-osm-cli.sh ${OSM_HOME}

enable-port-forward-addr:
	scripts/enable-port-forward-addr.sh ${OSM_HOME}

autobuild-disable:
	scripts/disable-test-e2e-build.sh ${OSM_HOME}
	scripts/disable-test-demo-build.sh ${OSM_HOME}

autobuild-reset:
	scripts/enable-test-e2e-build.sh ${OSM_HOME}
	scripts/enable-test-demo-build.sh ${OSM_HOME}

gcr-io:
	scripts/gcr-io-images.sh ${OSM_HOME}

gcr-io-reset:
	scripts/gcr-io-images-reset.sh ${OSM_HOME}

clean-docker:
	scripts/clean-docker.sh

clean-tag-docker:
	scripts/clean-tag-docker.sh

clean-local-registry:
	scripts/clean-local-registry.sh

list-local-registry:
	scripts/list-local-registry.sh

osm-reset:
	scripts/clean-osm.sh

test-e2e:
	scripts/e2e.sh ${OSM_HOME}

once: .env secret
	@echo
	@echo "Please execute \"\033[1;32;40msource ~/.bashrc\033[0m\""
	@echo

.PHONY: go-checks
go-checks:
	cd ${OSM_HOME};make embed-files-test
	cd ${OSM_HOME};make codegen
	cd ${OSM_HOME};go run github.com/norwoodj/helm-docs/cmd/helm-docs -c charts -t charts/osm/README.md.gotmpl
	cd ${OSM_HOME};go run ./mockspec/generate.go
	cd ${OSM_HOME};make helm-lint

.PHONY: go-lint
go-lint: go-checks
	docker run --rm -v ${OSM_HOME}:/app -w /app -e GOPROXY="https://goproxy.cn" -e GOSUMDB="sum.golang.google.cn" golangci/golangci-lint:latest golangci-lint run --timeout 1800s --config .golangci.yml

.PHONY: mcs-up
mcs-up:
	KIND_CLUSTER_NAME=control-plane MAPPING_HOST_PORT=8090 API_SERVER_PORT=6445 scripts/mcs-kind-with-registry.sh
	KIND_CLUSTER_NAME=cluster1 MAPPING_HOST_PORT=8091 API_SERVER_PORT=6446 scripts/mcs-kind-with-registry.sh
	KIND_CLUSTER_NAME=cluster2 MAPPING_HOST_PORT=8092 API_SERVER_PORT=6447 scripts/mcs-kind-with-registry.sh
	FSM_NAMESPACE=flomesh FSM_VERSION=0.2.0-alpha.3-dev FSM_CHART=${FSM}/charts/fsm KIND_CLUSTER_NAME=control-plane scripts/mcs-deploy-fsm-control-plane.sh
	FSM_NAMESPACE=flomesh FSM_VERSION=0.2.0-alpha.3-dev FSM_CHART=${FSM}/charts/fsm KIND_CLUSTER_NAME=cluster1 scripts/mcs-deploy-fsm-control-plane.sh
	FSM_NAMESPACE=flomesh FSM_VERSION=0.2.0-alpha.3-dev FSM_CHART=${FSM}/charts/fsm KIND_CLUSTER_NAME=cluster2 scripts/mcs-deploy-fsm-control-plane.sh
	CONTROL_PLANE_CLUSTER=control-plane BIZNESS_PLANE_CLUSTER=cluster1 scripts/mcs-join-fsm-control-plane.sh
	CONTROL_PLANE_CLUSTER=control-plane BIZNESS_PLANE_CLUSTER=cluster2 scripts/mcs-join-fsm-control-plane.sh
	BIZNESS_PLANE_CLUSTER=cluster1 scripts/mcs-deploy-osm-control-plane.sh
	BIZNESS_PLANE_CLUSTER=cluster2 scripts/mcs-deploy-osm-control-plane.sh
	echo "DONE"

.PHONY: mcs-reset
mcs-reset:
	kind delete cluster --name control-plane
	kind delete cluster --name cluster1
	kind delete cluster --name cluster2

.PHONY: kind-up
kind-up:
	cd ${OSM_HOME};make kind-up

.PHONY: kind-ingress-up
kind-ingress-up:
	export KIND_INGRESS_ENABLE=true;cd ${OSM_HOME};make kind-up

.PHONY: kind-reset
kind-reset:
	cd ${OSM_HOME};make kind-reset

.PHONY: demo-up
demo-up:
	cd ${OSM_HOME};./demo/run-osm-demo.sh

.PHONY: demo-reset
demo-reset:
	cd ${OSM_HOME};./demo/clean-kubernetes.sh

cache: cache-images

cache-reset: cancel-cache-images

pipy: switch-sidecar-to-pipy

envoy: switch-sidecar-to-envoy

speed: goproxy autobuild-disable gcr-io

dev: cache speed

dev-reset: cache-reset goproxy-reset autobuild-reset gcr-io-reset

build: build-osm-cli build-osm-images

restart-osm-bootstrap:
	@kubectl rollout restart deployment -n osm-system osm-bootstrap

restart-osm-controller:
	@kubectl rollout restart deployment -n osm-system osm-controller

restart-osm-injector:
	@kubectl rollout restart deployment -n osm-system osm-injector

rebuild-osm-controller:
	scripts/build-osm-image.sh ${OSM_HOME} controller

rebuild-osm-injector:
	scripts/build-osm-image.sh ${OSM_HOME} injector

rebuild-osm-bootstrap:
	scripts/build-osm-image.sh ${OSM_HOME} bootstrap

port-forward-osm-repo:
	cd ${OSM_HOME};./scripts/port-forward-osm-repo.sh

tail-osm-controller-logs:
	cd ${OSM_HOME};./demo/tail-osm-controller-logs.sh

tail-osm-injector-logs:
	cd ${OSM_HOME};./demo/tail-osm-injector-logs.sh

retag:
	docker rmi "${IMAGE}" "localhost:5000/${IMAGE}" | true
	docker pull ${IMAGE}
	docker tag ${IMAGE} localhost:5000/${IMAGE}
	docker push localhost:5000/${IMAGE}
	docker rmi "${IMAGE}" "localhost:5000/${IMAGE}" | true