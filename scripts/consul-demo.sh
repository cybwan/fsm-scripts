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

export fsm_namespace=fsm-system
export fsm_mesh_name=fsm
export dns_svc_ip="$(kubectl get svc -n kube-system -l k8s-app=kube-dns -o jsonpath='{.items[0].spec.clusterIP}')"
export consul_svc_addr="$(kubectl get svc -l name=consul -o jsonpath='{.items[0].spec.clusterIP}')"
fsm install \
    --mesh-name "$fsm_mesh_name" \
    --fsm-namespace "$fsm_namespace" \
    --set=fsm.certificateProvider.kind=tresor \
    --set=fsm.image.registry=localhost:5000/flomesh \
    --set=fsm.image.tag=latest \
    --set=fsm.image.pullPolicy=Always \
    --set=fsm.sidecarLogLevel=debug \
    --set=fsm.controllerLogLevel=warn \
    --set=fsm.serviceAccessMode=mixed \
    --set=fsm.deployConsulConnector=true \
    --set=fsm.cloudConnector.deriveNamespace=consul-derive \
    --set=fsm.cloudConnector.consul.httpAddr=$consul_svc_addr:8500 \
    --set=fsm.cloudConnector.consul.passingOnly=false \
    --set=fsm.cloudConnector.consul.suffixTag=version \
    --set=fsm.localDNSProxy.enable=true \
    --set=fsm.localDNSProxy.primaryUpstreamDNSServerIPAddr="${dns_svc_ip}" \
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

curl $BIZ_HOME/demo/cloud/demo/tiny/tiny-deploy.yaml -o /tmp/tiny-deploy.yaml
kubectl apply -n consul-demo -f /tmp/tiny-deploy.yaml
sleep 5
kubectl wait --for=condition=ready pod -n consul-demo -l app=sc-tiny --timeout=180s
tiny=$(kubectl get pod -n consul-demo -l app=sc-tiny -o jsonpath='{.items..metadata.name}')
kubectl logs -n consul-demo $tiny

export consul_svc_cluster_ip="$(kubectl get svc -n default -l name=consul -o jsonpath='{.items[0].spec.clusterIP}')"
#export consul_svc_cluster_ip=consul.default.svc.cluster.local
export tiny_svc_cluster_ip="$(kubectl get svc -n consul-demo -l app=tiny -o jsonpath='{.items[0].spec.clusterIP}')"
#export tiny_svc_cluster_ip=tiny.consul-demo.svc.cluster.local

curl $BIZ_HOME/demo/cloud/demo/server/server-props.yaml -o /tmp/server-props.yaml
cat /tmp/server-props.yaml | envsubst | kubectl apply -n consul-demo -f -
curl $BIZ_HOME/demo/cloud/demo/server/server-deploy.yaml -o /tmp/server-deploy.yaml
kubectl apply -n consul-demo -f /tmp/server-deploy.yaml
sleep 5
kubectl wait --for=condition=ready pod -n consul-demo -l app=server-demo --timeout=180s
serverDemo=$(kubectl get pod -n consul-demo -l app=server-demo -o jsonpath='{.items..metadata.name}')
kubectl logs -n consul-demo $serverDemo

export server_demo_pod_ip=$(kubectl get pod -n consul-demo -l app=server-demo -o jsonpath='{.items[0].status.podIP}')

curl $BIZ_HOME/demo/cloud/demo/client/client-props.yaml -o /tmp/client-props.yaml
cat /tmp/client-props.yaml | envsubst | kubectl apply -n consul-demo -f -
curl $BIZ_HOME/demo/cloud/demo/client/client-deploy.yaml -o /tmp/client-deploy.yaml
cat /tmp/client-deploy.yaml | envsubst | kubectl apply -n consul-demo -f -
sleep 5
kubectl wait --for=condition=ready pod -n consul-demo -l app=client-demo --timeout=180s
clientDemo=$(kubectl get pod -n consul-demo -l app=client-demo -o jsonpath='{.items..metadata.name}')
kubectl logs -n consul-demo $clientDemo

#kubectl apply -n consul-derive -f - <<EOF
#apiVersion: specs.smi-spec.io/v1alpha4
#kind: HTTPRouteGroup
#metadata:
#  name: grpc-server-v1
#spec:
#  matches:
#  - name: tag
#    headers:
#    - "version": "v1"
#EOF
#
#kubectl apply -n consul-derive -f - <<EOF
#apiVersion: split.smi-spec.io/v1alpha4
#kind: TrafficSplit
#metadata:
#  name: grpc-server-split
#spec:
#  service: grpc-server
#  matches:
#  - kind: HTTPRouteGroup
#    name: grpc-server-v1
#  backends:
#  - service: grpc-server-v1
#    weight: 50
#EOF

kubectl port-forward consul-0 8500:8500 1>/dev/null 2>&1 &

cd ${FSM_HOME};./scripts/port-forward-fsm-repo.sh &