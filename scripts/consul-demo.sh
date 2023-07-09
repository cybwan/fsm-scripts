#!/bin/bash

export DEMO_HOME=https://raw.githubusercontent.com/cybwan/fsm-start-demo/main

curl $DEMO_HOME/demo/cloud/consul/kubernetes-vault/certs/ca.pem -o /tmp/ca.pem
curl $DEMO_HOME/demo/cloud/consul/kubernetes-vault/certs/consul.pem -o /tmp/consul.pem
curl $DEMO_HOME/demo/cloud/consul/kubernetes-vault/certs/consul-key.pem -o /tmp/consul-key.pem
curl $DEMO_HOME/demo/cloud/consul/kubernetes-vault/consul/config.json -o /tmp/config.json

kubectl create secret generic consul \
  --from-literal="gossip-encryption-key=Jjq06uXduWeU8Bk9a/aV8z9QMa2+ADEXhP9yesp/bGg=" \
  --from-file=/tmp/ca.pem \
  --from-file=/tmp/consul.pem \
  --from-file=/tmp/consul-key.pem

kubectl create configmap consul --from-file=/tmp/config.json

kubectl apply -f $DEMO_HOME/demo/cloud/consul/kubernetes-vault/consul/service.yaml
kubectl apply -f $DEMO_HOME/demo/cloud/consul/kubernetes-vault/consul/statefulset.yaml

kubectl wait --for=condition=ready pod -l app=consul --timeout=180s

kubectl port-forward consul-0 8500:8500 >> /dev/nul 2>&1 &


export fsm_namespace=fsm-system
export fsm_mesh_name=fsm
export consul_svc_addr="$(kubectl get svc -l name=consul -o jsonpath='{.items[0].spec.clusterIP}')"
fsm install \
    --mesh-name "$fsm_mesh_name" \
    --fsm-namespace "$fsm_namespace" \
    --set=fsm.certificateProvider.kind=tresor \
    --set=fsm.image.registry=localhost:5000/flomesh \
    --set=fsm.image.tag=latest \
    --set=fsm.image.pullPolicy=Always \
    --set=fsm.sidecarLogLevel=error \
    --set=fsm.controllerLogLevel=warn \
    --set=fsm.serviceAccessMode=mixed \
    --set=fsm.deployConsulConnector=true \
    --set=fsm.cloudConnector.deriveNamespace=consul-derive \
    --set=fsm.cloudConnector.consul.httpAddr=$consul_svc_addr:8500 \
    --set=fsm.cloudConnector.consul.passingOnly=false \
    --set=fsm.cloudConnector.consul.suffixTag=version \
    --timeout=900s

kubectl create namespace consul-derive
fsm namespace add consul-derive

kubectl create namespace curl
kubectl apply -n curl -f https://raw.githubusercontent.com/cybwan/fsm-start-demo/main/demo/access-control/curl.yaml
kubectl wait --for=condition=ready pod -n curl -l app=curl --timeout=180s

kubectl patch meshconfig fsm-mesh-config -n "$fsm_namespace" -p '{"spec":{"traffic":{"enablePermissiveTrafficPolicyMode":true}}}'  --type=merge
kubectl patch meshconfig fsm-mesh-config -n "$fsm_namespace" -p '{"spec":{"traffic":{"enableEgress":true}}}'  --type=merge
kubectl patch meshconfig fsm-mesh-config -n "$fsm_namespace" -p '{"spec":{"featureFlags":{"enableAccessControlPolicy":true}}}'  --type=merge

kubectl apply -f - <<EOF
kind: AccessControl
apiVersion: policy.flomesh.io/v1alpha1
metadata:
  name: curl
  namespace: curl
spec:
  sources:
  - kind: Service
    namespace: curl
    name: curl
  - kind: Service
    namespace: default
    name: consul
EOF

export BIZ_HOME=https://raw.githubusercontent.com/cybwan/fsm-start-demo/main

kubectl create namespace consul-demo
fsm namespace add consul-demo

kubectl apply -n consul-demo -f $BIZ_HOME/demo/cloud/demo/tiny/tiny-deploy.yaml
kubectl wait --for=condition=ready pod -n consul-demo -l app=sc-tiny --timeout=180s
tiny=$(kubectl get pod -n consul-demo -l app=sc-tiny -o jsonpath='{.items..metadata.name}')
kubectl logs -n consul-demo $tiny

kubectl apply -n consul-demo -f $BIZ_HOME/demo/cloud/demo/server/server-props.yaml
kubectl apply -n consul-demo -f $BIZ_HOME/demo/cloud/demo/server/server-deploy.yaml
kubectl wait --for=condition=ready pod -n consul-demo -l app=server-demo --timeout=180s
serverDemo=$(kubectl get pod -n consul-demo -l app=server-demo -o jsonpath='{.items..metadata.name}')
kubectl logs -n consul-demo $serverDemo

kubectl apply -n consul-demo -f $BIZ_HOME/demo/cloud/demo/client/client-props.yaml
kubectl apply -n consul-demo -f $BIZ_HOME/demo/cloud/demo/client/client-deploy.yaml
kubectl wait --for=condition=ready pod -n consul-demo -l app=client-demo --timeout=180s
clientDemo=$(kubectl get pod -n consul-demo -l app=client-demo -o jsonpath='{.items..metadata.name}')
kubectl logs -n consul-demo $clientDemo



