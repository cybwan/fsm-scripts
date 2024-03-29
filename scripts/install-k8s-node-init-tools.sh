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

NODE_RELEASE=$(lsb_release -sr)
if [ "${NODE_RELEASE}"z == "22.04"z ]; then
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
elif [ "${NODE_RELEASE}"z == "20.04"z ]; then
sudo curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo tee /etc/apt/sources.list.d/kubernetes.list <<-'EOF'
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
else
sudo curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo tee /etc/apt/sources.list.d/kubernetes.list <<-'EOF'
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
fi

sudo apt -y update
# 查看版本
#sudo apt-cache madison kubeadm|head
sudo apt install -y kubelet=1.24.10-00 kubeadm=1.24.10-00 kubectl=1.24.10-00
sudo apt-mark hold kubelet kubeadm kubectl
sudo apt autoremove -y
sudo apt autoclean -y

system=$(uname -s | tr [:upper:] [:lower:])
arch=$(dpkg --print-architecture)
release=v1.26.0
curl -L https://github.com/kubernetes-sigs/cri-tools/releases/download/${release}/crictl-${release}-${system}-${arch}.tar.gz | tar -vxzf -
cp crictl /usr/local/bin/

cat > /etc/crictl.yaml << EOF
runtime-endpoint: unix:///var/run/containerd/containerd.sock
image-endpoint: unix:///var/run/containerd/containerd.sock
timeout: 10
debug: false
EOF

if [ ! -f /opt/cni-plugins-${system}-${arch}-v1.2.0.tgz ]; then
  curl -L https://github.com/containernetworking/plugins/releases/download/v1.2.0/cni-plugins-${system}-${arch}-v1.2.0.tgz -o /opt/cni-plugins-${system}-${arch}-v1.2.0.tgz
fi

cat >> ~/.bashrc <<EOF
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi
#Enabling tab-completion
complete -cf sudo
complete -cf man
source <(kubectl completion bash)
source <(kubeadm completion bash)
source <(crictl completion bash)
alias wk="watch -n 2 kubectl get pods -A -o wide"
alias k=kubectl
EOF

cat >> /etc/inputrc <<EOF
# do not show hidden files in the list
set match-hidden-files off
# auto complete ignoring case
set show-all-if-ambiguous on
set completion-ignore-case on
"\e[A": history-search-backward
"\e[B": history-search-forward
EOF