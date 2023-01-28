#!/bin/bash

set -uo pipefail

cat >> /etc/hosts <<EOF
192.168.127.101 local.registry
EOF

sudo sed -i '/\[plugins."io.containerd.grpc.v1.cri".registry.mirrors\]/a\ \ \ \ \ \ \ \ \ \ endpoint = ["https://local.registry"]' /etc/containerd/config.toml
sudo sed -i '/\[plugins."io.containerd.grpc.v1.cri".registry.mirrors\]/a\ \ \ \ \ \ \ \ [plugins."io.containerd.grpc.v1.cri".registry.mirrors."local.registry"]' /etc/containerd/config.toml


sudo sed -i '/\[plugins."io.containerd.grpc.v1.cri".registry.configs\]/a\ \ \ \ \ \ \ \ \ \ insecure_skip_verify = true' /etc/containerd/config.toml
sudo sed -i '/\[plugins."io.containerd.grpc.v1.cri".registry.configs\]/a\ \ \ \ \ \ \ \ [plugins."io.containerd.grpc.v1.cri".registry.configs."local.registry".tls]' /etc/containerd/config.toml

sudo systemctl restart containerd.service
