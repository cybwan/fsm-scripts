#!/bin/bash

kubectl create namespace error
osm namespace add error
kubectl apply -n error -f yamls/error.yaml