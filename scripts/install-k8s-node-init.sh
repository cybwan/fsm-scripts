#!/bin/bash

set -uo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument OS_ARCH"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Error: expected one argument OS"
  exit 1
fi

NODE_ARCH=$1
NODE_OS=$2

sudo systemctl disable --now swap.img.swap
sudo systemctl mask swap.target

sudo tee /etc/modprobe.d/nf_conntrack.conf <<-'EOF'
#hashsize=nf_conntrack_max/8
options nf_conntrack hashsize=16384
EOF

sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
fs.file-max=655360
fs.inotify.max_user_watches = 655350
fs.inotify.max_user_instances = 1024
EOF

sudo sysctl --system

sudo apt -y update
sudo apt -y upgrade

sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt -y update
sudo apt install -y docker-ce docker-ce-cli containerd.io

sudo groupadd docker
sudo gpasswd -a "$USER" docker
sudo systemctl restart docker
sudo newgrp docker &

containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

sudo systemctl reboot

