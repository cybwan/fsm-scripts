#!/bin/bash

curl="$(kubectl get pod -n curl -l app=curl -o jsonpath='{.items..metadata.name}')"
clientDemo=$(kubectl get pod -n consul-demo -l app=client-demo -o jsonpath='{.items[0].status.podIP}')
kubectl exec $curl -n curl -- curl -s -H "versiontag:v1" http://$clientDemo:8083/api/sc/tetGrpc?param=222
kubectl exec $curl -n curl -- curl -s -H "versiontag:v1" http://$clientDemo:8083/api/sc/tetGrpc?param=222
kubectl exec $curl -n curl -- curl -s -H "versiontag:v2" http://$clientDemo:8083/api/sc/tetGrpc?param=222
kubectl exec $curl -n curl -- curl -s -H "versiontag:v2" http://$clientDemo:8083/api/sc/tetGrpc?param=222