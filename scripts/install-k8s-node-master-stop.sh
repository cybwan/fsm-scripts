#!/bin/bash

set -uo pipefail

kubeadm reset -f

rm -rf ~/.kube
rm -rf /etc/cni
rm -rf /opt/cni
rm -rf /var/lib/etcd
rm -rf /var/etcd