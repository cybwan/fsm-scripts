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
  echo "Error: expected one argument Master Net Device"
  exit 1
fi

if [ -z "$5" ]; then
  echo "Error: expected one argument STATIC IP for Master Net Device"
  exit 1
fi

if [ -z "$6" ]; then
  echo "Error: expected one argument Default Route for Master Net Device"
  exit 1
fi

if [ -z "$7" ]; then
  echo "Error: expected one argument Default DNS Server for Master Net Device"
  exit 1
fi

if [ -z "$8" ]; then
  echo "Error: expected one argument Slaver Net Device"
  exit 1
fi

if [ -z "$9" ]; then
  echo "Error: expected one argument STATIC IP for Slaver Net Device"
  exit 1
fi

NODE_ARCH=$1
NODE_OS=$2
NODE_HOSTNAME=$3
NODE_MASTER_NET_DEVICE=$4
NODE_MASTER_NET_DEVICE_STATIC_IPv4=$5
NODE_MASTER_NET_DEVICE_DEFAULT_ROUTE=$6
NODE_MASTER_NET_DEVICE_DEFAULT_DNS=$7
NODE_SLAVER_NET_DEVICE=$8
NODE_SLAVER_NET_DEVICE_STATIC_IPv4=$9

sudo apt -y autoclean
sudo apt -y autoremove

sudo hostnamectl set-hostname ${NODE_HOSTNAME}

sudo tee /etc/netplan/00-installer-config.yaml <<EOF
network:
  ethernets:
    ${NODE_MASTER_NET_DEVICE}:
      dhcp4: false
      addresses: [${NODE_MASTER_NET_DEVICE_STATIC_IPv4}]
      nameservers:
        addresses: [${NODE_MASTER_NET_DEVICE_DEFAULT_DNS}]
      routes:
      - to: default
        via: ${NODE_MASTER_NET_DEVICE_DEFAULT_ROUTE}
    ${NODE_SLAVER_NET_DEVICE}:
      dhcp4: false
      addresses: [${NODE_SLAVER_NET_DEVICE_STATIC_IPv4}]
  version: 2
EOF

cat >> /etc/hosts <<EOF
192.168.226.50 master
192.168.226.51 node1
192.168.226.52 node2
192.168.226.53 node3
EOF

netplan apply
