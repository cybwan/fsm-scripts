#!/bin/bash

kubectl create namespace curl
osm namespace add curl
kubectl apply -n curl -f yamls/curl.curl.yaml
sleep 3
kubectl wait --for=condition=ready pod -n curl -l app=curl --timeout=180s