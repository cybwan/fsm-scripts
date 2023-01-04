#!/bin/bash

set -euo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument OS_ARCH"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Error: expected one argument OS"
  exit 1
fi

BUILD_ARCH=$1
BUILD_OS=$2

sudo apt -y update
sudo apt -y install ca-certificates curl
sudo apt -y install apt-transport-https
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt -y update
sudo apt -y install kubectl kubeadm kubelet

sudo curl -Lo /usr/local/sbin/kind https://kind.sigs.k8s.io/dl/latest/kind-"${BUILD_OS}"-"${BUILD_ARCH}"
sudo chmod a+x /usr/local/sbin/kind

sudo curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
sudo chmod +x get_helm.sh
sudo ./get_helm.sh
sudo rm -rf ./get_helm.sh