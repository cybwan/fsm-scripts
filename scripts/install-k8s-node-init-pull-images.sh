#!/bin/bash

set -uo pipefail

LOCAL_REGISTRY="${LOCAL_REGISTRY:-local.registry}"

docker pull registry.k8s.io/kube-apiserver:v1.24.10
docker pull registry.k8s.io/kube-controller-manager:v1.24.10
docker pull registry.k8s.io/kube-scheduler:v1.24.10
docker pull registry.k8s.io/kube-proxy:v1.24.10
docker pull registry.k8s.io/pause:3.7
docker pull registry.k8s.io/etcd:3.5.6-0
docker pull registry.k8s.io/coredns/coredns:v1.8.6
docker pull docker.io/calico/cni:v3.25.0
docker pull docker.io/calico/node:v3.25.0


docker tag registry.k8s.io/kube-apiserver:v1.24.10          ${LOCAL_REGISTRY}/kube-apiserver:v1.24.10
docker tag registry.k8s.io/kube-controller-manager:v1.24.10 ${LOCAL_REGISTRY}/kube-controller-manager:v1.24.10
docker tag registry.k8s.io/kube-scheduler:v1.24.10          ${LOCAL_REGISTRY}/kube-scheduler:v1.24.10
docker tag registry.k8s.io/kube-proxy:v1.24.10              ${LOCAL_REGISTRY}/kube-proxy:v1.24.10
docker tag registry.k8s.io/pause:3.7                        ${LOCAL_REGISTRY}/pause:3.7
docker tag registry.k8s.io/etcd:3.5.6-0                     ${LOCAL_REGISTRY}/etcd:3.5.6-0
docker tag registry.k8s.io/coredns/coredns:v1.8.6           ${LOCAL_REGISTRY}/coredns:v1.8.6
docker tag docker.io/calico/cni:v3.25.0                     ${LOCAL_REGISTRY}/cni:v3.25.0
docker tag docker.io/calico/node:v3.25.0                    ${LOCAL_REGISTRY}/node:v3.25.0


docker push ${LOCAL_REGISTRY}/kube-apiserver:v1.24.10
docker push ${LOCAL_REGISTRY}/kube-controller-manager:v1.24.10
docker push ${LOCAL_REGISTRY}/kube-scheduler:v1.24.10
docker push ${LOCAL_REGISTRY}/kube-proxy:v1.24.10
docker push ${LOCAL_REGISTRY}/pause:3.7
docker push ${LOCAL_REGISTRY}/etcd:3.5.6-0
docker push ${LOCAL_REGISTRY}/coredns:v1.8.6
docker push ${LOCAL_REGISTRY}/cni:v3.25.0
docker push ${LOCAL_REGISTRY}/node:v3.25.0
