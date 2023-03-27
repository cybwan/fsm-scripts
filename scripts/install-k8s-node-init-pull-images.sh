#!/bin/bash

set -uo pipefail

LOCAL_REGISTRY="${LOCAL_REGISTRY:-local.registry}"

docker pull busybox:1.36
docker tag busybox:1.36 ${LOCAL_REGISTRY}/busybox:1.36
docker push ${LOCAL_REGISTRY}/busybox:1.36
docker rmi ${LOCAL_REGISTRY}/busybox:1.36
docker rmi busybox:1.36

docker pull golang:1.19
docker tag golang:1.19 ${LOCAL_REGISTRY}/golang:1.19
docker push ${LOCAL_REGISTRY}/golang:1.19
docker rmi ${LOCAL_REGISTRY}/golang:1.19
docker rmi golang:1.19

docker pull gcr.io/distroless/static
docker tag gcr.io/distroless/static ${LOCAL_REGISTRY}/distroless/static
docker push ${LOCAL_REGISTRY}/distroless/static
docker rmi ${LOCAL_REGISTRY}/distroless/static
docker rmi gcr.io/distroless/static

docker pull registry.k8s.io/kube-apiserver:v1.24.10
docker pull registry.k8s.io/kube-controller-manager:v1.24.10
docker pull registry.k8s.io/kube-scheduler:v1.24.10
docker pull registry.k8s.io/kube-proxy:v1.24.10
docker pull registry.k8s.io/pause:3.7
docker pull registry.k8s.io/etcd:3.5.6-0
docker pull registry.k8s.io/coredns/coredns:v1.8.6

docker tag registry.k8s.io/kube-apiserver:v1.24.10 ${LOCAL_REGISTRY}/kube-apiserver:v1.24.10
docker tag registry.k8s.io/kube-controller-manager:v1.24.10 ${LOCAL_REGISTRY}/kube-controller-manager:v1.24.10
docker tag registry.k8s.io/kube-scheduler:v1.24.10 ${LOCAL_REGISTRY}/kube-scheduler:v1.24.10
docker tag registry.k8s.io/kube-proxy:v1.24.10 ${LOCAL_REGISTRY}/kube-proxy:v1.24.10
docker tag registry.k8s.io/pause:3.7 ${LOCAL_REGISTRY}/pause:3.7
docker tag registry.k8s.io/etcd:3.5.6-0 ${LOCAL_REGISTRY}/etcd:3.5.6-0
docker tag registry.k8s.io/coredns/coredns:v1.8.6 ${LOCAL_REGISTRY}/coredns:v1.8.6

docker push ${LOCAL_REGISTRY}/kube-apiserver:v1.24.10
docker push ${LOCAL_REGISTRY}/kube-controller-manager:v1.24.10
docker push ${LOCAL_REGISTRY}/kube-scheduler:v1.24.10
docker push ${LOCAL_REGISTRY}/kube-proxy:v1.24.10
docker push ${LOCAL_REGISTRY}/pause:3.7
docker push ${LOCAL_REGISTRY}/etcd:3.5.6-0
docker push ${LOCAL_REGISTRY}/coredns:v1.8.6

docker rmi ${LOCAL_REGISTRY}/kube-apiserver:v1.24.10
docker rmi ${LOCAL_REGISTRY}/kube-controller-manager:v1.24.10
docker rmi ${LOCAL_REGISTRY}/kube-scheduler:v1.24.10
docker rmi ${LOCAL_REGISTRY}/kube-proxy:v1.24.10
docker rmi ${LOCAL_REGISTRY}/pause:3.7
docker rmi ${LOCAL_REGISTRY}/etcd:3.5.6-0
docker rmi ${LOCAL_REGISTRY}/coredns:v1.8.6
docker rmi registry.k8s.io/kube-apiserver:v1.24.10
docker rmi registry.k8s.io/kube-controller-manager:v1.24.10
docker rmi registry.k8s.io/kube-scheduler:v1.24.10
docker rmi registry.k8s.io/kube-proxy:v1.24.10
docker rmi registry.k8s.io/pause:3.7
docker rmi registry.k8s.io/etcd:3.5.6-0
docker rmi registry.k8s.io/coredns/coredns:v1.8.6

docker pull docker.io/calico/cni:v3.25.0
docker pull docker.io/calico/node:v3.25.0
docker pull docker.io/calico/kube-controllers:v3.25.0
docker tag docker.io/calico/cni:v3.25.0 ${LOCAL_REGISTRY}/calico/cni:v3.25.0
docker tag docker.io/calico/node:v3.25.0 ${LOCAL_REGISTRY}/calico/node:v3.25.0
docker tag docker.io/calico/kube-controllers:v3.25.0 ${LOCAL_REGISTRY}/calico/kube-controllers:v3.25.0
docker push ${LOCAL_REGISTRY}/calico/cni:v3.25.0
docker push ${LOCAL_REGISTRY}/calico/node:v3.25.0
docker push ${LOCAL_REGISTRY}/calico/kube-controllers:v3.25.0
docker rmi ${LOCAL_REGISTRY}/calico/cni:v3.25.0
docker rmi ${LOCAL_REGISTRY}/calico/node:v3.25.0
docker rmi ${LOCAL_REGISTRY}/calico/kube-controllers:v3.25.0
docker rmi docker.io/calico/cni:v3.25.0
docker rmi docker.io/calico/node:v3.25.0
docker rmi docker.io/calico/kube-controllers:v3.25.0

docker pull docker.io/flannel/flannel:v0.21.2
docker pull docker.io/flannel/flannel-cni-plugin:v1.1.2
docker tag docker.io/flannel/flannel:v0.21.2 ${LOCAL_REGISTRY}/flannel/flannel:v0.21.2
docker tag docker.io/flannel/flannel-cni-plugin:v1.1.2 ${LOCAL_REGISTRY}/flannel/flannel-cni-plugin:v1.1.2
docker push ${LOCAL_REGISTRY}/flannel/flannel:v0.21.2
docker push ${LOCAL_REGISTRY}/flannel/flannel-cni-plugin:v1.1.2
docker rmi ${LOCAL_REGISTRY}/flannel/flannel:v0.21.2
docker rmi ${LOCAL_REGISTRY}/flannel/flannel-cni-plugin:v1.1.2
docker rmi docker.io/flannel/flannel:v0.21.2
docker rmi docker.io/flannel/flannel-cni-plugin:v1.1.2

docker pull weaveworks/weave-kube:latest
docker pull weaveworks/weave-npc:latest
docker tag weaveworks/weave-kube:latest ${LOCAL_REGISTRY}/weaveworks/weave-kube:latest
docker tag weaveworks/weave-npc:latest ${LOCAL_REGISTRY}/weaveworks/weave-npc:latest
docker push ${LOCAL_REGISTRY}/weaveworks/weave-kube:latest
docker push ${LOCAL_REGISTRY}/weaveworks/weave-npc:latest
docker rmi ${LOCAL_REGISTRY}/weaveworks/weave-kube:latest
docker rmi ${LOCAL_REGISTRY}/weaveworks/weave-npc:latest
docker rmi weaveworks/weave-kube:latest
docker rmi weaveworks/weave-npc:latest

docker container prune -f
docker volume prune -f
docker image prune -f