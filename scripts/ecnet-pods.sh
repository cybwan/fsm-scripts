#!/bin/bash

kubectl create namespace pipy
kubectl apply -n pipy -f https://raw.githubusercontent.com/cybwan/osm-edge-start-demo/main/demo/ec-bridge/pipy-ok.pipy.yaml

kubectl create namespace pipy
cat <<EOF | kubectl apply -f -
apiVersion: flomesh.io/v1alpha1
kind: ServiceImport
metadata:
  name: pipy-ok
  namespace: pipy
spec:
  ports:
  - endpoints:
    - clusterKey: default/default/default/cluster3
      target:
        host: 192.168.127.91
        ip: 192.168.127.91
        path: /c3/ok
        port: 8093
    - clusterKey: default/default/default/cluster1
      target:
        host: 192.168.127.91
        ip: 192.168.127.91
        path: /c1/ok
        port: 8091
    name: pipy
    port: 8080
    protocol: TCP
  serviceAccountName: '*'
  type: ClusterSetIP
EOF

cat <<EOF | kubectl apply -f -
apiVersion: flomesh.io/v1alpha1
kind: GlobalTrafficPolicy
metadata:
  namespace: pipy
  name: pipy-ok
spec:
  lbType: ActiveActive
EOF

kubectl wait --for=condition=ready pod -n pipy -l app=pipy-ok --timeout=180s