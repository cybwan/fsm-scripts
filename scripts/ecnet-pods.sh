#!/bin/bash

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
        host: 3.226.203.163
        ip: 3.226.203.163
        path: /
        port: 80
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

#cat <<EOF | kubectl apply -n pipy -f -
#apiVersion: v1
#kind: Service
#metadata:
#  name: pipy-ok
#  labels:
#    app: pipy-ok
#    service: pipy-ok
#spec:
#  ports:
#    - name: http
#      port: 8080
#  selector:
#    app: pipy-ok
#---
#apiVersion: apps/v1
#kind: Deployment
#metadata:
#  name: pipy-ok
#  labels:
#    app: pipy-ok
#spec:
#  replicas: 1
#  selector:
#    matchLabels:
#      app: pipy-ok
#  template:
#    metadata:
#      labels:
#        app: pipy-ok
#    spec:
#      containers:
#        - name: pipy
#          image: local.registry/flomesh/pipy-nightly:latest
#          imagePullPolicy: IfNotPresent
#          ports:
#            - name: http
#              containerPort: 8080
#          command:
#            - pipy
#            - -e
#            - |
#              pipy()
#              .listen(8080)
#              .serveHTTP(new Message('Hi, I am pipy ok at node1 !'))
#      nodeName: node2
#EOF
#
#kubectl wait --for=condition=ready pod -n pipy -l app=pipy-ok --timeout=180s

kubectl create namespace demo
cat <<EOF | kubectl apply -n demo -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: sleep
---
apiVersion: v1
kind: Service
metadata:
  name: sleep
  labels:
    app: sleep
    service: sleep
spec:
  ports:
  - port: 80
    name: http
  selector:
    app: sleep
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sleep
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sleep
  template:
    metadata:
      labels:
        app: sleep
    spec:
      terminationGracePeriodSeconds: 0
      serviceAccountName: sleep
      containers:
      - name: sleep
        image: local.registry/curlimages/curl
        imagePullPolicy: Always
        command: ["/bin/sleep", "infinity"]
      nodeName: node2
EOF

kubectl wait --for=condition=ready pod -n demo -l app=sleep --timeout=180s