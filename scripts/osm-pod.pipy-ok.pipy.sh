#!/bin/bash

kubectl create namespace pipy
osm namespace add pipy
kubectl apply -n pipy -f yamls/pipy-ok.pipy.yaml
sleep 2
kubectl wait --for=condition=ready pod -n pipy -l app=pipy-ok --timeout=180s