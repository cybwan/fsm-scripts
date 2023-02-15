#!/bin/bash

set -uo pipefail

if [ -z "$1" ]; then
  echo "Error: expected one argument ControlPlane.advertiseAddress"
  exit 1
fi

ADVERTISE_ADDRESS=$1

if [ ! -f $HOME/kubeadm.yaml ]; then
  kubeadm config print init-defaults > $HOME/kubeadm.yaml
  sed -i "s/advertiseAddress: 1.2.3.4/advertiseAddress: ${ADVERTISE_ADDRESS}/g" $HOME/kubeadm.yaml
  sed -i "s/name: node/name: ${HOSTNAME}/g" $HOME/kubeadm.yaml
  sed -i "s/kubernetesVersion: 1.24.0/kubernetesVersion: 1.24.10/g" $HOME/kubeadm.yaml
  sed -i "s/imageRepository: registry.k8s.io/imageRepository: local.registry/g" $HOME/kubeadm.yaml
  sed -i "/kubernetesVersion: 1.24.10/acontrolPlaneEndpoint: '${ADVERTISE_ADDRESS}:6443'" $HOME/kubeadm.yaml
  sed -i "/dnsDomain: cluster.local/a\ \ podSubnet: 10.244.0.0/16" $HOME/kubeadm.yaml
  cat >> $HOME/kubeadm.yaml <<EOF
---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
cgroupDriver: systemd
EOF
fi

if [ ! -f $HOME/kube-flannel.yml ]; then
  curl -L https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml -o $HOME/kube-flannel.yml
fi

#sudo kubeadm init --control-plane-endpoint=192.168.226.50

kubeadm init \
--config $HOME/kubeadm.yaml \
--ignore-preflight-errors=SystemVerification \
--upload-certs

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

if [ ! -d /opt/cni/bin ]; then
  mkdir -p /opt/cni/bin
fi

system=$(uname -s | tr [:upper:] [:lower:])
arch=$(dpkg --print-architecture)
if [ ! -f /opt/cni/bin/loopback ]; then
  tar zxf /opt/cni-plugins-${system}-${arch}-v1.2.0.tgz -C /opt/cni/bin
fi

kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl taint nodes --all node.kubernetes.io/not-ready:NoSchedule-

kubectl apply -f $HOME/kube-flannel.yml

#curl https://projectcalico.docs.tigera.io/archive/v3.25/manifests/calico.yaml -o $HOME/kube-calico.yaml
#sed -i 's#docker.io#local.registry#g' $HOME/kube-calico.yaml
#kubectl apply -f $HOME/kube-calico.yaml


#curl -L https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml -o $HOME/kube-weave.yaml
#kubectl apply -f $HOME/kube-weave.yaml

TOKEN=`kubeadm token list | grep default | awk -F" " '{print $1}' |head -n 1`
CAHASH=`openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex |  awk -F" " '{print $2}'`
echo kubeadm join ${ADVERTISE_ADDRESS}:6443 --token ${TOKEN}  --discovery-token-ca-cert-hash sha256:${CAHASH} > $HOME/join.sh