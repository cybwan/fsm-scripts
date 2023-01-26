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

if [ -z "$3" ]; then
  echo "Error: expected one argument HOSTNAME"
  exit 1
fi

if [ -z "$4" ]; then
  echo "Error: expected one argument STATIC IP"
  exit 1
fi

if [ -z "$5" ]; then
  echo "Error: expected one argument Default Route"
  exit 1
fi

NODE_ARCH=$1
NODE_OS=$2
NODE_HOSTNAME=$3
NODE_STATIC_IPv4=$4
NODE_DEFAULT_ROUTE=$5

sudo hostnamectl set-hostname ${NODE_HOSTNAME}

sudo tee /etc/netplan/00-installer-config.yaml <<EOF
network:
  ethernets:
    ens32:
      dhcp4: false
      addresses: [${NODE_STATIC_IPv4}]
      nameservers:
        addresses: [${NODE_DEFAULT_ROUTE}]
      routes:
      - to: default
        via: ${NODE_DEFAULT_ROUTE}
  version: 2
EOF

sudo systemctl disable --now swap.img.swap
sudo systemctl mask swap.target

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
EOF
sudo sysctl --system

sudo apt -y update
sudo apt -y upgrade
sudo apt -y autoclean
sudo apt -y autoremove

sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt -y update
sudo apt install -y containerd.io

containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

systemctl reboot

