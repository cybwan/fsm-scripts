#!/bin/bash

kubectl create namespace curl
osm namespace add curl
kubectl apply -n curl -f https://raw.githubusercontent.com/cybwan/osm-edge-start-demo/main/demo/plugin/curl.curl.yaml

kubectl create namespace pipy
osm namespace add pipy
kubectl apply -n pipy -f https://raw.githubusercontent.com/cybwan/osm-edge-start-demo/main/demo/plugin/pipy-ok.pipy.yaml

#等待依赖的 POD 正常启动
sleep 2
kubectl wait --for=condition=ready pod -n curl -l app=curl --timeout=180s
kubectl wait --for=condition=ready pod -n pipy -l app=pipy-ok -l version=v1 --timeout=180s
kubectl wait --for=condition=ready pod -n pipy -l app=pipy-ok -l version=v2 --timeout=180s

export osm_namespace=osm-system
kubectl patch meshconfig osm-mesh-config -n "$osm_namespace" -p '{"spec":{"featureFlags":{"enablePluginPolicy":true}}}' --type=merge

kubectl apply -f - <<EOF
kind: Plugin
apiVersion: plugin.flomesh.io/v1alpha1
metadata:
  name: logs-demo-1
spec:
  pipyscript: |+
    pipy({})
      .pipeline()
      // send
      .handleData(
        dat => (
          console.log('==============[logs-demo-1] send data size:', dat?.size)
        )
      )
      .chain()
      // receive
      .handleData(
        dat => (
          console.log('==============[logs-demo-1] receive data size:', dat?.size)
        )
      )
EOF

kubectl apply -f - <<EOF
kind: Plugin
apiVersion: plugin.flomesh.io/v1alpha1
metadata:
  name: logs-demo-2
spec:
  pipyscript: |+
    pipy({})
      .pipeline()
      // send
      .handleData(
        dat => (
          console.log('==============[logs-demo-2] send data size:', dat?.size)
        )
      )
      .chain()
      // receive
      .handleData(
        dat => (
          console.log('==============[logs-demo-2] receive data size:', dat?.size)
        )
      )
EOF

kubectl apply -n curl -f - <<EOF
kind: PluginChain
apiVersion: plugin.flomesh.io/v1alpha1
metadata:
  name: logs-demo-chain
spec:
  chains:
    - name: inbound-http
      plugins:
        - logs-demo-1
        - logs-demo-2
    - name: outbound-http
      plugins:
        - logs-demo-1
        - logs-demo-2
  selectors:
    podSelector:
      matchLabels:
        app: curl
      matchExpressions:
        - key: app
          operator: In
          values: ["curl"]
    namespaceSelector:
      matchExpressions:
        - key: openservicemesh.io/monitored-by
          operator: In
          values: ["osm"]
EOF

kubectl apply -n curl -f - <<EOF
kind: PluginConfig
apiVersion: plugin.flomesh.io/v1alpha1
metadata:
  name: curl-logs-demo-1
  namespace: curl
spec:
  config:
    http:
    - matches:
      - path: /get
        pathType: Prefix
        method: .*
      request: 3
      unit: minute
      burst: 10
  plugin: logs-demo-1
  destinationRefs:
    - kind: Service
      name: pipy-ok
      namespace: pipy
    - kind: Service
      name: curl
      namespace: curl
EOF