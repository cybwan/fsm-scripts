#!/bin/bash

ARCH_MAP_x86_64 := amd64
ARCH_MAP_arm64 := arm64
ARCH_MAP_aarch64 := arm64

BUILDARCH := $(ARCH_MAP_$(shell uname -m))
BUILDOS := $(shell uname -s | tr '[:upper:]' '[:lower:]')

TARGETS := $(BUILDOS)/$(BUILDARCH)
DOCKER_BUILDX_PLATFORM := $(BUILDOS)/$(BUILDARCH)

FSM_HOME ?= $(abspath ../fsm)
ECN_HOME ?= $(abspath ../ErieCanalNet)
LOCAL_REGISTRY ?= localhost:5000

default: build

install-k3s:
	scripts/install-k3s.sh

install-docker:
	scripts/install-docker.sh

install-k8s-tools: install-docker
	scripts/install-k8s-tools.sh ${BUILDARCH} ${BUILDOS}

install-golang:
	make -f scripts/Makefile.golang

kind-k8s-version:
	scripts/kind-node-images.sh ${FSM_HOME} ${BUILDARCH} ${BUILDOS}

install-k8s-local-registry:
	scripts/install-k8s-local-registry.sh

init-k8s-node:
	scripts/install-k8s-node-init.sh ${BUILDARCH} ${BUILDOS}

init-k8s-node-master:
	scripts/install-k8s-node-init-net.sh ${BUILDARCH} ${BUILDOS} master  ens36 192.168.226.50/24 192.168.226.101 8.8.8.8 ens33 192.168.127.50/24
	scripts/install-k8s-node-init-tools.sh ${BUILDARCH} ${BUILDOS}

init-k8s-node-node1:
	scripts/install-k8s-node-init-net.sh ${BUILDARCH} ${BUILDOS} node1 ens36 192.168.226.51/24 192.168.226.101 8.8.8.8 ens33 192.168.127.51/24
	scripts/install-k8s-node-init-tools.sh ${BUILDARCH} ${BUILDOS}

init-k8s-node-node2:
	scripts/install-k8s-node-init-net.sh ${BUILDARCH} ${BUILDOS} node2 ens36 192.168.226.52/24 192.168.226.101 8.8.8.8 ens33 192.168.127.52/24
	scripts/install-k8s-node-init-tools.sh ${BUILDARCH} ${BUILDOS}

init-k8s-node-local-registry:
	scripts/install-k8s-node-init-local-registry.sh 192.168.226.101

init-k8s-node-pull-images:
	scripts/install-k8s-node-init-pull-images.sh

init-k8s-node-start-master:
	scripts/install-k8s-node-master-start.sh 192.168.226.50 flannel

init-k8s-node-start-master-local-registry:
	scripts/install-k8s-node-master-start-local-registry.sh 192.168.226.50 flannel

init-k8s-node-start-master-local-registry-calico:
	scripts/install-k8s-node-master-start-local-registry.sh 192.168.226.50 calico

init-k8s-node-start-master-local-registry-weave:
	scripts/install-k8s-node-master-start-local-registry.sh 192.168.226.50 weave

init-k8s-node-join-worker:
	scripts/install-k8s-node-worker-join.sh 192.168.226.50

init-k8s-node-stop:
	scripts/install-k8s-node-stop.sh

install-local-registry-crt-into-buildx:
	scripts/install-local-registry-crt-into-buildx.sh

ebpf-trace:
	cat /sys/kernel/debug/tracing/trace_pipe|grep bpf_trace_printk

ebpf-deps:
	apt -y update
	apt -y install git cmake make gcc python3 libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf
	cd /tmp;git clone -b v5.4 https://github.com/torvalds/linux.git --depth 1;cd linux/tools/bpf/bpftool; make && make install

fsm-ebpf-up:
	scripts/fsm-up-ebpf.sh

rebuild-fsm-interceptor:
	@#cd ${BPFIMG};git pull;
	@#cd ${BPFIMG};make docker-build-ubuntu
	@#cd ${BPFIMG};make docker-build-compiler
	@#cd ${BPFIMG};make docker-build-base
	@#cd ${BPFIMG};make docker-build-golang
	@cd ${BPFIMG};make -f Makefile.Dockerfiles docker-build-interceptor

restart-fsm-interceptor:
	kubectl rollout restart daemonset -n fsm-system fsm-interceptor

logs-fsm-interceptor-node1:
	kubectl logs -n fsm-system $$(kubectl get pod -n fsm-system -l app=fsm-interceptor --field-selector spec.nodeName==node1 -o=jsonpath='{..metadata.name}') -f

logs-fsm-interceptor-node2:
	kubectl logs -n fsm-system $$(kubectl get pod -n fsm-system -l app=fsm-interceptor --field-selector spec.nodeName==node2 -o=jsonpath='{..metadata.name}') -f

shell-fsm-interceptor-node1:
	kubectl logs -n fsm-system $$(kubectl get pod -n fsm-system -l app=fsm-interceptor --field-selector spec.nodeName==node1 -o=jsonpath='{..metadata.name}')

shell-fsm-interceptor-node2:
	kubectl logs -n fsm-system $$(kubectl get pod -n fsm-system -l app=fsm-interceptor --field-selector spec.nodeName==node2 -o=jsonpath='{..metadata.name}')

fsm-ebpf-demo-deploy:
	kubectl create namespace ebpf
	fsm namespace add ebpf
	kubectl apply -n ebpf -f demo/ebpf/sleep.yaml
	kubectl apply -n ebpf -f demo/ebpf/helloworld.yaml
	kubectl apply -n ebpf -f demo/ebpf/helloworld-v1.yaml
	kubectl apply -n ebpf -f demo/ebpf/helloworld-v2.yaml

fsm-ebpf-demo-affinity:
	kubectl patch deployments sleep -n ebpf -p '{"spec":{"template":{"spec":{"nodeName":"node1"}}}}'
	kubectl patch deployments helloworld-v1 -n ebpf -p '{"spec":{"template":{"spec":{"nodeName":"node1"}}}}'
	kubectl patch deployments helloworld-v2 -n ebpf -p '{"spec":{"template":{"spec":{"nodeName":"node2"}}}}'

fsm-ebpf-demo-undeploy:
	kubectl delete -n ebpf -f demo/ebpf/sleep.yaml
	kubectl delete -n ebpf -f demo/ebpf/helloworld-v1.yaml
	kubectl delete -n ebpf -f demo/ebpf/helloworld-v2.yaml
	kubectl delete -n ebpf -f demo/ebpf/helloworld.yaml
	fsm namespace remove ebpf
	kubectl delete namespace ebpf

fsm-ebpf-demo-restart:
	kubectl rollout restart deployment -n ebpf sleep
	kubectl rollout restart deployment -n ebpf helloworld-v1
	kubectl rollout restart deployment -n ebpf helloworld-v2

fsm-ebpf-demo-restart-sleep:
	kubectl rollout restart deployment -n ebpf sleep

fsm-ebpf-demo-restart-helloworld-v1:
	kubectl rollout restart deployment -n ebpf helloworld-v1

fsm-ebpf-demo-restart-helloworld-v2:
	kubectl rollout restart deployment -n ebpf helloworld-v2

fsm-ebpf-demo-curl-helloworld-v1:
	kubectl exec -n ebpf $$(kubectl get po -n ebpf -l app=sleep --field-selector spec.nodeName==node1 -o=jsonpath='{..metadata.name}') -c sleep -- curl -s helloworld-v1:5000/hello

fsm-ebpf-demo-curl-helloworld-v2:
	kubectl exec -n ebpf $$(kubectl get po -n ebpf -l app=sleep --field-selector spec.nodeName==node1 -o=jsonpath='{..metadata.name}') -c sleep -- curl -s helloworld-v2:5000/hello

fsm-ebpf-demo-curl-helloworld:
	kubectl exec -n ebpf $$(kubectl get po -n ebpf -l app=sleep --field-selector spec.nodeName==node1 -o=jsonpath='{..metadata.name}') -c sleep -- curl -s helloworld:5000/hello

fsm-ebpf-demo-deploy-pipy-ok:
	kubectl create namespace ebpf
	fsm namespace add ebpf
	kubectl apply -n ebpf -f demo/ebpf/curl.yaml
	kubectl apply -n ebpf -f demo/ebpf/pipy-ok.yaml

fsm-ebpf-demo-undeploy-pipy-ok:
	kubectl delete -n ebpf -f demo/ebpf/curl.yaml
	kubectl delete -n ebpf -f demo/ebpf/pipy-ok.yaml
	fsm namespace remove ebpf
	kubectl delete namespace ebpf

fsm-ebpf-demo-curl-pipy-ok:
	kubectl exec -n ebpf $$(kubectl get po -n ebpf -l app=curl --field-selector spec.nodeName==node1 -o=jsonpath='{..metadata.name}') -c curl -- curl -s pipy-ok:8080

.env:
	scripts/env.sh ${FSM_HOME} ${BUILDARCH} ${BUILDOS}

secret:
	scripts/secret.sh ${FSM_HOME}

goproxy:
	@sed -i 's/go bui/GO111MODULE=on GOPROXY=https:\/\/goproxy.cn go bui/g' ${FSM_HOME}/dockerfiles/Dockerfile.*
	@sed -i 's/go mod/GO111MODULE=on GOPROXY=https:\/\/goproxy.cn go mod/g' ${FSM_HOME}/dockerfiles/Dockerfile.*

goproxy-reset:
	@sed -i 's/GO111MODULE=on GOPROXY=https:\/\/goproxy.cn go bui/go bui/g' ${FSM_HOME}/dockerfiles/Dockerfile.*
	@sed -i 's/GO111MODULE=on GOPROXY=https:\/\/goproxy.cn go mod/go mod/g' ${FSM_HOME}/dockerfiles/Dockerfile.*

adapter-os-arch:
	scripts/adapter-os-arch.sh ${FSM_HOME} ${BUILDARCH}

pull-images:
	scripts/pull-images.sh ${FSM_HOME} ${BUILDARCH}
	#scripts/pull-fsm-images.sh ${FSM_HOME} ${BUILDARCH}
	#scripts/pull-demo-images.sh ${FSM_HOME} ${BUILDARCH}
	#scripts/pull-test-e2e-images.sh ${FSM_HOME} ${BUILDARCH}

tag-images:
	scripts/tag-fsm-images.sh ${FSM_HOME} ${BUILDARCH}
	scripts/tag-demo-images.sh ${FSM_HOME} ${BUILDARCH}
	scripts/tag-test-e2e-images.sh ${FSM_HOME} ${BUILDARCH}

push-images:
	scripts/push-fsm-images.sh ${FSM_HOME} ${BUILDARCH}
	scripts/push-demo-images.sh ${FSM_HOME} ${BUILDARCH}
	scripts/push-test-e2e-images.sh ${FSM_HOME} ${BUILDARCH}

cache-images:
	scripts/cache-fsm-images.sh ${FSM_HOME} ${BUILDARCH}
	scripts/cache-demo-images.sh ${FSM_HOME} ${BUILDARCH}
	scripts/cache-test-e2e-images.sh ${FSM_HOME} ${BUILDARCH}
	scripts/cache-zookeeper-chart.sh ${FSM_HOME} ${BUILDARCH}
	scripts/cache-cert-manager-chart.sh ${FSM_HOME} ${BUILDARCH}

load-images-without-clean: pull-images tag-images push-images
	scripts/clean-tag-docker.sh

load-images: clean-tag-docker clean-local-registry load-images-without-clean reload-flomesh-fsm-images reload-flomesh-pipy-images reload-flomesh-ebpf-images list-local-registry

reload-flomesh-pipy-images:
	scripts/reload-flomesh-pipy-images.sh
	scripts/list-local-registry.sh

reload-flomesh-fsm-images:
	scripts/reload-flomesh-fsm-images.sh
	scripts/list-local-registry.sh

reload-flomesh-fsm-connector-images:
	scripts/reload-flomesh-fsm-connector-images.sh
	scripts/list-local-registry.sh

reload-flomesh-ebpf-images:
	scripts/reload-flomesh-ebpf-images.sh
	scripts/list-local-registry.sh

cancel-cache-images:
	scripts/cancel-cache-fsm-images.sh ${FSM_HOME} ${BUILDARCH}
	scripts/cancel-cache-demo-images.sh ${FSM_HOME} ${BUILDARCH}
	scripts/cancel-cache-test-e2e-images.sh ${FSM_HOME} ${BUILDARCH}
	scripts/cancel-cache-zookeeper-chart.sh ${FSM_HOME} ${BUILDARCH}
	scripts/cancel-cache-cert-manager-chart.sh ${FSM_HOME} ${BUILDARCH}

build-fsm-images:
	scripts/build-fsm-images.sh ${FSM_HOME}

digest-charts-fsm-images:
	scripts/digest-charts-fsm-images.sh ${FSM_HOME}

build-fsm-cli:
	scripts/build-fsm-cli.sh ${FSM_HOME}

enable-port-forward-addr:
	scripts/enable-port-forward-addr.sh ${FSM_HOME}

autobuild-disable:
	scripts/disable-test-e2e-build.sh ${FSM_HOME}
	scripts/disable-test-demo-build.sh ${FSM_HOME}

autobuild-reset:
	scripts/enable-test-e2e-build.sh ${FSM_HOME}
	scripts/enable-test-demo-build.sh ${FSM_HOME}

gcr-io:
	scripts/gcr-io-images.sh ${FSM_HOME}

gcr-io-reset:
	scripts/gcr-io-images-reset.sh ${FSM_HOME}

clean-docker:
	scripts/clean-docker.sh

clean-tag-docker:
	scripts/clean-tag-docker.sh

clean-local-registry:
	scripts/clean-local-registry.sh

list-local-registry:
	scripts/list-local-registry.sh

pipy-up:
	scripts/pipy-up.sh

pipy-reset:
	scripts/pipy-reset.sh

fsm-up:
	scripts/fsm-up.sh

fsm-up-fsm:
	scripts/fsm-up-fsm.sh

fsm-k8s-up:
	scripts/fsm-up-k8s.sh

fsm-pods:
	scripts/fsm-pod.curl.curl.sh
	scripts/fsm-pod.pipy-ok.pipy.sh

fsm-pods-test:
	scripts/fsm-pod.test.sh

fsm-err-pods:
	scripts/fsm-pod.err.sh

fsm-demo-plugin:
	scripts/fsm-demo-plugin.sh

fsm-reset:
	scripts/clean-fsm.sh

ecnet-build:
	cd ${ECN_HOME};make build-ecnet docker-build

ecnet-up:
	scripts/ecnet-up.sh

ecnet-reset:
	scripts/clean-ecnet.sh

ecnet-pods:
	scripts/ecnet-pods.sh

ecnet-test:
	scripts/ecnet-test.sh

ecnet-restart:
	kubectl rollout restart daemonset -n ecnet-system ecnet-bridge

port-forward-ecnet-repo:
	cd ${ECN_HOME};./scripts/port-forward-ecnet-repo.sh

ecnet-dev:
	scripts/cache-ecnet-images.sh ${ECN_HOME} ${BUILDARCH}

ecnet-dev-reset:
	scripts/cancel-cache-ecnet-images.sh ${ECN_HOME} ${BUILDARCH}

rebuild-ecnet-controller:
	@cd ${ECN};make docker-build-ecnet-controller

rebuild-ecnet-bridge:
	@cd ${ECN};make docker-build-ecnet-bridge

restart-ecnet-controller:
	@kubectl rollout restart deployment -n ecnet-system ecnet-controller

restart-ecnet-bridge:
	@kubectl rollout restart daemonset -n ecnet-system ecnet-bridge

logs-ecnet-bridge-node2:
	kubectl logs -n ecnet-system $$(kubectl get pod -n ecnet-system -l app=ecnet-bridge --field-selector spec.nodeName==node2 -o=jsonpath='{..metadata.name}') -c bridge -f

shell-ecnet-bridge-node2:
	@kubectl exec -it -n ecnet-system $$(kubectl get pod -n ecnet-system -l app=ecnet-bridge --field-selector spec.nodeName==node2 -o=jsonpath='{..metadata.name}') -c bridge -- /usr/bin/bash

test-e2e:
	scripts/e2e.sh ${FSM_HOME}

once: .env secret
	@echo
	@echo "Please execute \"\033[1;32;40msource ~/.bashrc\033[0m\""
	@echo

.PHONY: go-checks
go-checks:
	cd ${FSM_HOME};make embed-files-test
	cd ${FSM_HOME};make codegen
	cd ${FSM_HOME};go run github.com/norwoodj/helm-docs/cmd/helm-docs -c charts -t charts/fsm/README.md.gotmpl
	cd ${FSM_HOME};go run ./mockspec/generate.go
	cd ${FSM_HOME};make helm-lint

.PHONY: go-lint
go-lint: go-checks
	docker run --rm -v ${FSM_HOME}:/app -w /app -e GOPROXY="https://goproxy.cn" -e GOSUMDB="sum.golang.google.cn" golangci/golangci-lint:latest golangci-lint run --timeout 1800s --config .golangci.yml

.PHONY: mcs-up
mcs-up:
	helm repo add fsm https://charts.flomesh.io
	helm repo update
	KIND_CLUSTER_NAME=control-plane MAPPING_HOST_PORT=8090 API_SERVER_PORT=6445 scripts/mcs-kind-with-registry.sh
	KIND_CLUSTER_NAME=cluster1 MAPPING_HOST_PORT=8091 API_SERVER_PORT=6446 scripts/mcs-kind-with-registry.sh
	KIND_CLUSTER_NAME=cluster2 MAPPING_HOST_PORT=8092 API_SERVER_PORT=6447 scripts/mcs-kind-with-registry.sh
	KIND_CLUSTER_NAME=cluster3 MAPPING_HOST_PORT=8093 API_SERVER_PORT=6448 scripts/mcs-kind-with-registry.sh
	FSM_NAMESPACE=flomesh FSM_VERSION=0.2.0-alpha.16 FSM_CHART=fsm/fsm KIND_CLUSTER_NAME=control-plane scripts/mcs-deploy-fsm-control-plane.sh
	FSM_NAMESPACE=flomesh FSM_VERSION=0.2.0-alpha.16 FSM_CHART=fsm/fsm KIND_CLUSTER_NAME=cluster1 scripts/mcs-deploy-fsm-control-plane.sh
	FSM_NAMESPACE=flomesh FSM_VERSION=0.2.0-alpha.16 FSM_CHART=fsm/fsm KIND_CLUSTER_NAME=cluster2 scripts/mcs-deploy-fsm-control-plane.sh
	FSM_NAMESPACE=flomesh FSM_VERSION=0.2.0-alpha.16 FSM_CHART=fsm/fsm KIND_CLUSTER_NAME=cluster3 scripts/mcs-deploy-fsm-control-plane.sh
	BIZNESS_PLANE_CLUSTER=cluster1 scripts/mcs-deploy-fsm-control-plane.sh
	BIZNESS_PLANE_CLUSTER=cluster2 scripts/mcs-deploy-fsm-control-plane.sh
	BIZNESS_PLANE_CLUSTER=cluster3 scripts/mcs-deploy-fsm-control-plane.sh
	CONTROL_PLANE_CLUSTER=control-plane BIZNESS_PLANE_CLUSTER=cluster1 PORT=8091 scripts/mcs-join-fsm-control-plane.sh
	CONTROL_PLANE_CLUSTER=control-plane BIZNESS_PLANE_CLUSTER=cluster2 PORT=8092 scripts/mcs-join-fsm-control-plane.sh
	CONTROL_PLANE_CLUSTER=control-plane BIZNESS_PLANE_CLUSTER=cluster3 PORT=8093 scripts/mcs-join-fsm-control-plane.sh
	echo "DONE"

.PHONY: mcs-pods
mcs-pods:
	scripts/mcs-deploy-fsm-biz-pods.sh

.PHONY: mcs-reset
mcs-reset:
	kind delete cluster --name control-plane
	kind delete cluster --name cluster1
	kind delete cluster --name cluster2
	kind delete cluster --name cluster3

.PHONY: k3d-setup
k3d-setup:
	cd ${FSM_HOME};./scripts/k3d-with-registry.sh

.PHONY: k3d-start
k3d-start:
	k3d cluster start fsm

.PHONY: k3d-stop
k3d-stop:
	k3d cluster stop fsm

.PHONY: k3d-up
k3d-up:
	./scripts/k3d-with-registry-multicluster.sh
	kubecm list

.PHONY: k3d-proxy-up
k3d-proxy-up:
	./scripts/k3d-with-registry-multicluster-with-proxy.sh
	kubecm list

.PHONY: k3d-reset
k3d-reset:
	./scripts/k3d-multicluster-cleanup.sh

.PHONY: kind-up
kind-up:
	cd ${FSM_HOME};make kind-up

.PHONY: kind-ingress-up
kind-ingress-up:
	export KIND_INGRESS_ENABLE=true;cd ${FSM_HOME};make kind-up

.PHONY: kind-api-up
kind-api-up:
	scripts/kind-with-registry.sh

.PHONY: kind-reset
kind-reset:
	cd ${FSM_HOME};make kind-reset

.PHONY: metallb-up
metallb-up:
	scripts/metallb-up.sh

.PHONY: demo-up
demo-up:
	cd ${FSM_HOME};./demo/run-fsm-demo.sh

.PHONY: demo-reset
demo-reset:
	cd ${FSM_HOME};./demo/clean-kubernetes.sh

.PHONY: consul-demo
consul-demo:
	scripts/consul-demo.sh

.PHONY: consul-test-http
consul-test-http:
	@scripts/consul-test-http.sh

.PHONY: consul-test-grpc
consul-test-grpc:
	@scripts/consul-test-grpc.sh

cache: cache-images

cache-reset: cancel-cache-images

speed: autobuild-disable gcr-io

dev: cache speed

dev-reset: cache-reset autobuild-reset gcr-io-reset

build: build-fsm-cli build-fsm-images

restart-fsm-bootstrap:
	@kubectl rollout restart deployment -n fsm-system fsm-bootstrap

restart-fsm-controller:
	@kubectl rollout restart deployment -n fsm-system fsm-controller

restart-fsm-injector:
	@kubectl rollout restart deployment -n fsm-system fsm-injector

restart-fsm-consul-connector:
	@kubectl rollout restart deployment -n fsm-system $$(kubectl get deployments -n fsm-system --selector flomesh.io/fsm-connector=consul --no-headers | awk '{print $$1}' | head -n1)

restart-fsm-eureka-connector:
	@kubectl rollout restart deployment -n fsm-system $$(kubectl get deployments -n fsm-system --selector flomesh.io/fsm-connector=eureka --no-headers | awk '{print $$1}' | head -n1)

restart-fsm-nacos-connector:
	@kubectl rollout restart deployment -n fsm-system $$(kubectl get deployments -n fsm-system --selector flomesh.io/fsm-connector=nacos --no-headers | awk '{print $$1}' | head -n1)

restart-fsm-gateway-connector:
	@kubectl rollout restart deployment -n fsm-system $$(kubectl get deployments -n fsm-system --selector flomesh.io/fsm-connector=gateway --no-headers | awk '{print $$1}' | head -n1)

restart-fsm-machine-connector:
	@kubectl rollout restart deployment -n fsm-system $$(kubectl get deployments -n fsm-system --selector flomesh.io/fsm-connector=machine --no-headers | awk '{print $$1}' | head -n1)

restart-fsm-ztm-agent:
	@kubectl rollout restart deployment -n fsm-system $$(kubectl get deployments -n fsm-system --selector flomesh.io/ztm=agent --no-headers | awk '{print $$1}' | head -n1)

rebuild-fsm-controller:
	scripts/build-fsm-image.sh ${FSM_HOME} controller

rebuild-fsm-injector:
	scripts/build-fsm-image.sh ${FSM_HOME} injector

rebuild-fsm-connector:
	scripts/build-fsm-image.sh ${FSM_HOME} connector

rebuild-fsm-ztm-agent:
	scripts/build-fsm-image.sh ${FSM_HOME} ztm-agent

rebuild-fsm-bootstrap:
	scripts/build-fsm-image.sh ${FSM_HOME} bootstrap

port-forward-fsm-repo:
	cd ${FSM_HOME};./scripts/port-forward-fsm-repo.sh

tail-fsm-controller-logs:
	cd ${FSM_HOME};./demo/tail-fsm-controller-logs.sh

tail-fsm-injector-logs:
	cd ${FSM_HOME};./demo/tail-fsm-injector-logs.sh

tail-fsm-consul-connector-logs:
	cd ${FSM_HOME};./demo/tail-fsm-consul-connector-logs.sh

tail-fsm-eureka-connector-logs:
	cd ${FSM_HOME};./demo/tail-fsm-eureka-connector-logs.sh

tail-fsm-nacos-connector-logs:
	cd ${FSM_HOME};./demo/tail-fsm-nacos-connector-logs.sh

tail-fsm-gateway-connector-logs:
	cd ${FSM_HOME};./demo/tail-fsm-gateway-connector-logs.sh

tail-fsm-machine-connector-logs:
	cd ${FSM_HOME};./demo/tail-fsm-machine-connector-logs.sh

CONSUL_VERSION      ?= 1.5.3

.PHONY: consul-deploy
consul-deploy:
	kubectl apply -n default -f ./manifests/consul.$(CONSUL_VERSION).yaml
	kubectl wait --all --for=condition=ready pod -n default -l app=consul --timeout=180s

.PHONY: consul-reboot
consul-reboot:
	kubectl rollout restart deployment -n default consul

.PHONY: eureka-deploy
eureka-deploy:
	kubectl apply -n default -f ./manifests/eureka.yaml
	kubectl wait --all --for=condition=ready pod -n default -l app=eureka --timeout=180s

.PHONY: eureka-reboot
eureka-reboot:
	kubectl rollout restart deployment -n default eureka

.PHONY: nacos-deploy
nacos-deploy:
	kubectl apply -n default -f ./manifests/nacos.yaml
	kubectl wait --all --for=condition=ready pod -n default -l app=nacos --timeout=180s

.PHONY: nacos-reboot
nacos-reboot:
	kubectl rollout restart deployment -n default nacos

.PHONY: consul-port-forward
consul-port-forward:
	export POD=$$(kubectl get pods --selector app=consul -n default --no-headers | grep 'Running' | awk 'NR==1{print $$1}');\
	kubectl port-forward "$$POD" -n default 8500:8500 --address 0.0.0.0 &

.PHONY: eureka-port-forward
eureka-port-forward:
	export POD=$$(kubectl get pods --selector app=eureka -n default --no-headers | grep 'Running' | awk 'NR==1{print $$1}');\
	kubectl port-forward "$$POD" -n default 8761:8761 --address 0.0.0.0 &

.PHONY: nacos-port-forward
nacos-port-forward:
	export POD=$$(kubectl get pods --selector app=nacos -n default --no-headers | grep 'Running' | awk 'NR==1{print $$1}');\
	kubectl port-forward "$$POD" -n default 8848:8848 --address 0.0.0.0 &

.PHONY: deploy-consul-bookwarehouse
deploy-consul-bookwarehouse:
	#fsm namespace add bookwarehouse
	kubectl delete namespace bookwarehouse --ignore-not-found
	kubectl create namespace bookwarehouse
	kubectl apply -n bookwarehouse -f ./manifests/consul/bookwarehouse.yaml
	sleep 2
	kubectl wait --all --for=condition=ready pod -n bookwarehouse -l app=bookwarehouse --timeout=180s

.PHONY: deploy-consul-bookstore
deploy-consul-bookstore:
	#fsm namespace add bookstore
	kubectl delete namespace bookstore --ignore-not-found
	kubectl create namespace bookstore
	kubectl apply -n bookstore -f ./manifests/consul/bookstore.yaml
	sleep 2
	kubectl wait --all --for=condition=ready pod -n bookstore -l app=bookstore --timeout=180s

.PHONY: deploy-consul-bookbuyer
deploy-consul-bookbuyer:
	#fsm namespace add bookbuyer
	kubectl delete namespace bookbuyer --ignore-not-found
	kubectl create namespace bookbuyer
	kubectl apply -n bookbuyer -f ./manifests/consul/bookbuyer.yaml
	sleep 2
	kubectl wait --all --for=condition=ready pod -n bookbuyer -l app=bookbuyer --timeout=180s

.PHONY: deploy-fsm.consul
deploy-fsm.consul:
	scripts/deploy-fsm.consul.sh

.PHONY: deploy-eureka-bookwarehouse
deploy-eureka-bookwarehouse:
	#fsm namespace add bookwarehouse
	kubectl delete namespace bookwarehouse --ignore-not-found
	kubectl create namespace bookwarehouse
	kubectl apply -n bookwarehouse -f ./manifests/eureka/bookwarehouse.yaml
	sleep 2
	kubectl wait --all --for=condition=ready pod -n bookwarehouse -l app=bookwarehouse --timeout=180s

.PHONY: deploy-eureka-bookstore
deploy-eureka-bookstore:
	#fsm namespace add bookstore
	kubectl delete namespace bookstore --ignore-not-found
	kubectl create namespace bookstore
	kubectl apply -n bookstore -f ./manifests/eureka/bookstore.yaml
	sleep 2
	kubectl wait --all --for=condition=ready pod -n bookstore -l app=bookstore --timeout=180s

.PHONY: deploy-eureka-bookbuyer
deploy-eureka-bookbuyer:
	#fsm namespace add bookbuyer
	kubectl delete namespace bookbuyer --ignore-not-found
	kubectl create namespace bookbuyer
	kubectl apply -n bookbuyer -f ./manifests/eureka/bookbuyer.yaml
	sleep 2
	kubectl wait --all --for=condition=ready pod -n bookbuyer -l app=bookbuyer --timeout=180s

.PHONY: deploy-fsm.eureka
deploy-fsm.eureka:
	scripts/deploy-fsm.eureka.sh

.PHONY: deploy-nacos-bookwarehouse
deploy-nacos-bookwarehouse:
	#fsm namespace add bookwarehouse
	kubectl delete namespace bookwarehouse --ignore-not-found
	kubectl create namespace bookwarehouse
	kubectl apply -n bookwarehouse -f ./manifests/nacos/bookwarehouse.yaml
	sleep 2
	kubectl wait --all --for=condition=ready pod -n bookwarehouse -l app=bookwarehouse --timeout=180s

.PHONY: deploy-nacos-bookstore
deploy-nacos-bookstore:
	#fsm namespace add bookstore
	kubectl delete namespace bookstore --ignore-not-found
	kubectl create namespace bookstore
	kubectl apply -n bookstore -f ./manifests/nacos/bookstore.yaml
	sleep 2
	kubectl wait --all --for=condition=ready pod -n bookstore -l app=bookstore --timeout=180s

.PHONY: deploy-nacos-bookbuyer
deploy-nacos-bookbuyer:
	#fsm namespace add bookbuyer
	kubectl delete namespace bookbuyer --ignore-not-found
	kubectl create namespace bookbuyer
	kubectl apply -n bookbuyer -f ./manifests/nacos/bookbuyer.yaml
	sleep 2
	kubectl wait --all --for=condition=ready pod -n bookbuyer -l app=bookbuyer --timeout=180s

.PHONY: deploy-fsm.nacos
deploy-fsm.nacos:
	scripts/deploy-fsm.nacos.sh

demo-sleep-pod:
	scripts/demo-sleep-pod.sh

exec-node2-bridge:
	scripts/exec-node2-bridge.sh

retag:
	docker rmi "${IMAGE}" "${LOCAL_REGISTRY}/${IMAGE}" | true
	docker pull ${IMAGE}
	docker tag ${IMAGE} ${LOCAL_REGISTRY}/${IMAGE}
	docker push ${LOCAL_REGISTRY}/${IMAGE}
	docker rmi "${IMAGE}" "${LOCAL_REGISTRY}/${IMAGE}" | true

bpf_trace_printk:
	scripts/bpf_trace_printk.sh

os-init:
	scripts/os-init.sh ${BUILDARCH} ${BUILDOS}

github-ssh-key-generate:
	@ssh-keygen -t ed25519 -C "baili@flomesh.io"

github-ssh-key-test:
	@ifconfig ens33 mtu 1436
	@ssh -T git@github.com || true

github-gpg-key-generate:
	@gpg --full-generate-key

github-gpg-key-list:
	@gpg --list-secret-keys --keyid-format=long

github-gpg-key-export:
	@gpg --armor --export $(gpg --list-secret-keys --keyid-format=long | grep sec | cut -d'/'  -f2 | cut -d' ' -f1)