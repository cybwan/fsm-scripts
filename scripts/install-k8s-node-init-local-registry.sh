#!/bin/bash

set -uo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument local.registry.Address"
  exit 1
fi

LOCAL_REGISTRY_ADDRESS=$1

echo ${LOCAL_REGISTRY_ADDRESS} local.registry >> /etc/hosts

sudo sed -i '/\[plugins."io.containerd.grpc.v1.cri".registry.mirrors\]/a\ \ \ \ \ \ \ \ \ \ endpoint = ["https://local.registry"]' /etc/containerd/config.toml
sudo sed -i '/\[plugins."io.containerd.grpc.v1.cri".registry.mirrors\]/a\ \ \ \ \ \ \ \ [plugins."io.containerd.grpc.v1.cri".registry.mirrors."local.registry"]' /etc/containerd/config.toml


sudo sed -i '/\[plugins."io.containerd.grpc.v1.cri".registry.configs\]/a\ \ \ \ \ \ \ \ \ \ insecure_skip_verify = true' /etc/containerd/config.toml
sudo sed -i '/\[plugins."io.containerd.grpc.v1.cri".registry.configs\]/a\ \ \ \ \ \ \ \ [plugins."io.containerd.grpc.v1.cri".registry.configs."local.registry".tls]' /etc/containerd/config.toml

sudo systemctl restart containerd.service
