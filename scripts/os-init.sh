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

if [ ! -f /etc/sysctl.d/fs.conf ]; then
sudo tee /etc/sysctl.d/fs.conf <<EOF
fs.file-max=655360
fs.inotify.max_user_watches = 655350
fs.inotify.max_user_instances = 1024
EOF
fi

sudo sysctl --system

if ! $(grep proxy /etc/profile); then
sudo cat >> /etc/profile <<EOF
export https_proxy=http://192.168.226.1:7890
export http_proxy=http://192.168.226.1:7890
export all_proxy=socks5://192.168.226.1:7890
EOF
fi

default_dev=$(ip r show default | cut -d' ' -f5)
sudo sed -i "/mtu:/d" /etc/netplan/00-installer-config.yaml
sudo sed -i "/${default_dev}:/a\ \ \ \ \ \ mtu: 1436" /etc/netplan/00-installer-config.yaml

sudo ifconfig ${default_dev} mtu 1436

export https_proxy=http://192.168.226.1:7890
export http_proxy=http://192.168.226.1:7890
export all_proxy=socks5://192.168.226.1:7890

sudo apt -y update

sudo apt install -y chrony
sudo chronyc sources -v
sudo timedatectl set-timezone Asia/Shanghai

sudo apt -y upgrade

sudo systemctl reboot

