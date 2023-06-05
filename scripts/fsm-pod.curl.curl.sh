#!/bin/bash

kubectl create namespace curl
fsm namespace add curl
kubectl apply -n curl -f yamls/curl.curl.yaml
sleep 2
kubectl wait --for=condition=ready pod -n curl -l app=curl --timeout=180s