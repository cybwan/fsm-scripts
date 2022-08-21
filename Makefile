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

load-images: clean-tag-docker clean-local-registry pull-images tag-images push-images
	scripts/clean-tag-docker.sh

reload-flomesh-images:
	scripts/reload-flomesh-images.sh
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

.PHONY: kind-up
kind-up:
	cd ${OSM_HOME};make kind-up

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