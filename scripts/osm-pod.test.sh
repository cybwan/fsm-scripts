#!/bin/bash

curl_client="$(kubectl get pod -n curl -l app=curl -o jsonpath='{.items[0].metadata.name}')"

kubectl exec "$curl_client" -n curl -c curl -- curl -si -v pipy-ok.pipy:8080
kubectl exec "$curl_client" -n curl -c curl -- curl -si -v pipy-ok.pipy:8080

kubectl exec "$curl_client" -n curl -c curl -- curl -si -v pipy-ok-v1.pipy:8080
kubectl exec "$curl_client" -n curl -c curl -- curl -si -v pipy-ok-v2.pipy:8080