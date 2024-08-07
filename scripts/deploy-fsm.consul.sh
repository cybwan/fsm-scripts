#!/bin/bash

set -aueo pipefail

# shellcheck disable=SC1091

export fsm_namespace=fsm-system
export fsm_mesh_name=fsm
export dns_svc_ip="$(kubectl get svc -n kube-system -l k8s-app=kube-dns -o jsonpath='{.items[0].spec.clusterIP}')"
echo $dns_svc_ip

fsm install \
    --mesh-name "$fsm_mesh_name" \
    --fsm-namespace "$fsm_namespace" \
    --set=fsm.certificateProvider.kind=tresor \
    --set=fsm.image.registry=localhost:5000/flomesh \
    --set=fsm.image.tag=latest \
    --set=fsm.image.pullPolicy=Always \
    --set=fsm.sidecar.sidecarLogLevel=warn \
    --set=fsm.controllerLogLevel=warn \
    --set=fsm.serviceAccessMode=mixed \
    --set=fsm.featureFlags.enableAutoDefaultRoute=true \
    --set=clusterSet.region=LN \
    --set=clusterSet.zone=DL \
    --set=clusterSet.group=FLOMESH \
    --set=clusterSet.name=C1 \
    --set fsm.fsmIngress.enabled=false \
    --set fsm.fsmGateway.enabled=true \
    --set=fsm.localDNSProxy.enable=true \
    --set=fsm.localDNSProxy.wildcard.enable=false \
    --set=fsm.localDNSProxy.primaryUpstreamDNSServerIPAddr=$dns_svc_ip \
    --set fsm.featureFlags.enableValidateHTTPRouteHostnames=false \
    --set fsm.featureFlags.enableValidateGRPCRouteHostnames=false \
    --set fsm.featureFlags.enableValidateTLSRouteHostnames=false \
    --set fsm.featureFlags.enableValidateGatewayListenerHostname=false \
    --set fsm.featureFlags.enableGatewayProxyTag=true \
    --set=fsm.featureFlags.enableSidecarPrettyConfig=true \
    --timeout=900s

kubectl create namespace derive-consul
fsm namespace add derive-consul
kubectl patch namespace derive-consul -p '{"metadata":{"annotations":{"flomesh.io/mesh-service-sync":"consul"}}}'  --type=merge

export fsm_namespace=fsm-system
kubectl apply -n "$fsm_namespace" -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1beta1
kind: Gateway
metadata:
  name: k8s-fgw
spec:
  gatewayClassName: fsm-gateway-cls
  listeners:
    - protocol: HTTP
      port: 10080
      name: igrs-http
    - protocol: HTTP
      port: 10090
      name: egrs-http
    - protocol: HTTP
      port: 10180
      name: igrs-grpc
    - protocol: HTTP
      port: 10190
      name: egrs-grpc
EOF

kubectl apply  -f - <<EOF
kind: GatewayConnector
apiVersion: connector.flomesh.io/v1alpha1
metadata:
  name: fgw-1
spec:
  ingress:
    ipSelector: ExternalIP
    httpPort: 10080
    grpcPort: 10180
  egress:
    ipSelector: ClusterIP
    httpPort: 10090
    grpcPort: 10190
  syncToFgw:
    enable: true
    denyK8sNamespaces:
      - default
      - kube-system
      - fsm-system
EOF

export consul_svc_addr="$(kubectl get svc -n default --field-selector metadata.name=consul -o jsonpath='{.items[0].spec.clusterIP}')"
echo $consul_svc_addr

kubectl apply  -f - <<EOF
kind: ConsulConnector
apiVersion: connector.flomesh.io/v1alpha1
metadata:
  name: cluster-1
spec:
  httpAddr: $consul_svc_addr:8500
  deriveNamespace: derive-consul
  asInternalServices: true
  syncToK8S:
    enable: true
    clusterId: ''
    passingOnly: true
    filterTag: ''
    prefixTag: ''
    suffixTag: version
    withGateway: true
  syncFromK8S:
    enable: true
    consulNodeName: ''
    defaultSync: true
    addServicePrefix: ''
    addK8SNamespaceAsServiceSuffix: false
    appendTags:
      - tag0
      - tag1
    appendMetadatas:
      - key: type
        value: smart-gateway
      - key: version
        value: release
      - key: zone
        value: yinzhou
    allowK8sNamespaces:
      - '*'
    denyK8sNamespaces:
      - default
      - kube-system
      - fsm-system
    syncClusterIPServices: true
    syncIngress: false
    syncIngressLoadBalancerIPs: false
    syncLoadBalancerEndpoints: false
    nodePortSyncType: ExternalOnly
    consulCrossNamespaceACLPolicy: ''
    consulDestinationNamespace: default
    consulEnableK8SNSMirroring: false
    consulEnableNamespaces: false
    consulK8SNSMirroringPrefix: ''
    withGateway: true
EOF