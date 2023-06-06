#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

#集群 cluster1 部署不被 fsm edge 纳管的业务服务
kubecm switch kind-cluster1
kubectl create namespace pipy
kubectl apply -n pipy -f https://raw.githubusercontent.com/cybwan/fsm-start-demo/main/demo/multi-cluster/pipy-ok-c1.pipy.yaml
#等待依赖的 POD 正常启动
sleep 10
kubectl wait --for=condition=ready pod -n pipy -l app=pipy-ok-c1 --timeout=180s

#集群 cluster1 部署被 fsm edge 纳管的业务服务
kubecm switch kind-cluster1
kubectl create namespace pipy-fsm
fsm namespace add pipy-fsm
kubectl apply -n pipy-fsm -f https://raw.githubusercontent.com/cybwan/fsm-start-demo/main/demo/multi-cluster/pipy-ok-c1.pipy-fsm.yaml
#等待依赖的 POD 正常启动
sleep 10
kubectl wait --for=condition=ready pod -n pipy-fsm -l app=pipy-ok-c1 --timeout=180s

#集群 cluster1 导出任意 SA 业务服务
kubecm switch kind-cluster1

cat <<EOF | kubectl apply -f -
apiVersion: flomesh.io/v1alpha1
kind: ServiceExport
metadata:
  namespace: pipy
  name: pipy-ok
spec:
  serviceAccountName: "*"
  rules:
    - portNumber: 8080
      path: "/c1/ok"
      pathType: Prefix
---
apiVersion: flomesh.io/v1alpha1
kind: ServiceExport
metadata:
  namespace: pipy
  name: pipy-ok-c1
spec:
  serviceAccountName: "*"
  rules:
    - portNumber: 8080
      path: "/c1/ok-c1"
      pathType: Prefix
---
apiVersion: flomesh.io/v1alpha1
kind: ServiceExport
metadata:
  namespace: pipy-fsm
  name: pipy-ok
spec:
  serviceAccountName: "*"
  rules:
    - portNumber: 8080
      path: "/c1/ok-fsm"
      pathType: Prefix
---
apiVersion: flomesh.io/v1alpha1
kind: ServiceExport
metadata:
  namespace: pipy-fsm
  name: pipy-ok-c1
spec:
  serviceAccountName: "*"
  rules:
    - portNumber: 8080
      path: "/c1/ok-fsm-c1"
      pathType: Prefix
EOF
sleep 3
kubectl get serviceexports.flomesh.io -A
curl -s http://$API_SERVER_ADDR:8091/c1/ok
curl -s http://$API_SERVER_ADDR:8091/c1/ok-c1
curl -s http://$API_SERVER_ADDR:8091/c1/ok-fsm
curl -s http://$API_SERVER_ADDR:8091/c1/ok-fsm-c1

#集群 cluster3 部署不被 fsm edge 纳管的业务服务
kubecm switch kind-cluster3
#kubectl create namespace pipy
kubectl apply -n pipy -f https://raw.githubusercontent.com/cybwan/fsm-start-demo/main/demo/multi-cluster/pipy-ok-c3.pipy.yaml
#等待依赖的 POD 正常启动
sleep 10
kubectl wait --for=condition=ready pod -n pipy -l app=pipy-ok-c3 --timeout=180s

#集群 cluster3 部署被 fsm edge 纳管的业务服务
kubecm switch kind-cluster3
#kubectl create namespace pipy-fsm
fsm namespace add pipy-fsm
kubectl apply -n pipy-fsm -f https://raw.githubusercontent.com/cybwan/fsm-start-demo/main/demo/multi-cluster/pipy-ok-c3.pipy-fsm.yaml
#等待依赖的 POD 正常启动
sleep 10
kubectl wait --for=condition=ready pod -n pipy-fsm -l app=pipy-ok-c3 --timeout=180s

#集群 cluster3 导出任意 SA 业务服务
kubecm switch kind-cluster3

cat <<EOF | kubectl apply -f -
apiVersion: flomesh.io/v1alpha1
kind: ServiceExport
metadata:
  namespace: pipy
  name: pipy-ok
spec:
  serviceAccountName: "*"
  rules:
    - portNumber: 8080
      path: "/c3/ok"
      pathType: Prefix
---
apiVersion: flomesh.io/v1alpha1
kind: ServiceExport
metadata:
  namespace: pipy
  name: pipy-ok-c3
spec:
  serviceAccountName: "*"
  rules:
    - portNumber: 8080
      path: "/c3/ok-c3"
      pathType: Prefix
---
apiVersion: flomesh.io/v1alpha1
kind: ServiceExport
metadata:
  namespace: pipy-fsm
  name: pipy-ok
spec:
  serviceAccountName: "*"
  rules:
    - portNumber: 8080
      path: "/c3/ok-fsm"
      pathType: Prefix
---
apiVersion: flomesh.io/v1alpha1
kind: ServiceExport
metadata:
  namespace: pipy-fsm
  name: pipy-ok-c3
spec:
  serviceAccountName: "*"
  rules:
    - portNumber: 8080
      path: "/c3/ok-fsm-c3"
      pathType: Prefix
EOF

sleep 3
kubectl get serviceexports.flomesh.io -A
curl -s http://$API_SERVER_ADDR:8093/c3/ok
curl -s http://$API_SERVER_ADDR:8093/c3/ok-c3
curl -s http://$API_SERVER_ADDR:8093/c3/ok-fsm
curl -s http://$API_SERVER_ADDR:8093/c3/ok-fsm-c3

#集群 cluster2 导入业务服务
kubecm switch kind-cluster2
fsm namespace add pipy-fsm

#创建完 Namespace, 补偿创建ServiceImporI,有延迟,需等待
sleep 3
kubectl get serviceimports.flomesh.io -A
kubectl get serviceimports.flomesh.io -n pipy pipy-ok -o yaml
kubectl get serviceimports.flomesh.io -n pipy pipy-ok-c1 -o yaml
kubectl get serviceimports.flomesh.io -n pipy pipy-ok-c3 -o yaml
kubectl get serviceimports.flomesh.io -n pipy-fsm pipy-ok -o yaml
kubectl get serviceimports.flomesh.io -n pipy-fsm pipy-ok-c1 -o yaml
kubectl get serviceimports.flomesh.io -n pipy-fsm pipy-ok-c3 -o yaml

#集群 cluster2 部署被 fsm edge 纳管的客户端
kubecm switch kind-cluster2
kubectl create namespace curl
fsm namespace add curl
kubectl apply -n curl -f https://raw.githubusercontent.com/cybwan/fsm-start-demo/main/demo/multi-cluster/curl.curl.yaml
#等待依赖的 POD 正常启动
sleep 10
kubectl wait --for=condition=ready pod -n curl -l app=curl --timeout=180s