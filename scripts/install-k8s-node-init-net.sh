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

if [ -z "$3" ]; then
  echo "Error: expected one argument HOSTNAME"
  exit 1
fi

if [ -z "$4" ]; then
  echo "Error: expected one argument Net Device"
  exit 1
fi

if [ -z "$5" ]; then
  echo "Error: expected one argument STATIC IP"
  exit 1
fi

if [ -z "$6" ]; then
  echo "Error: expected one argument Default Route"
  exit 1
fi

if [ -z "$7" ]; then
  echo "Error: expected one argument Default DNS Server"
  exit 1
fi

NODE_ARCH=$1
NODE_OS=$2
NODE_HOSTNAME=$3
NODE_NET_DEVICE=$4
NODE_STATIC_IPv4=$5
NODE_DEFAULT_ROUTE=$6
NODE_DEFAULT_DNS=$7

sudo apt -y autoclean
sudo apt -y autoremove

sudo hostnamectl set-hostname ${NODE_HOSTNAME}

sudo tee /etc/netplan/00-installer-config.yaml <<EOF
network:
  ethernets:
    ${NODE_NET_DEVICE}:
      dhcp4: false
      addresses: [${NODE_STATIC_IPv4}]
      nameservers:
        addresses: [${NODE_DEFAULT_DNS}]
      routes:
      - to: default
        via: ${NODE_DEFAULT_ROUTE}
  version: 2
EOF

cat >> /etc/hosts <<EOF
192.168.127.50 master
192.168.127.51 worker1
192.168.127.52 worker2
EOF

netplan apply
