#!/bin/bash

export INSTALL_K3S_VERSION=v1.23.8+k3s2
curl -sfL https://get.k3s.io | sh -s - --disable traefik --write-kubeconfig-mode 644 --write-kubeconfig ~/.kube/config
