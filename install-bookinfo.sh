#!/bin/bash

kubectl create namespace bookinfo

kubectl label namespace bookinfo istio.io/rev=1-9-7 --overwrite

pushd /tmp

ISTIO_VERSION=1.9.7

curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION sh -

cd istio-$ISTIO_VERSION

kubectl apply -n bookinfo -f samples/bookinfo/platform/kube/bookinfo.yaml

kubectl apply -n bookinfo -f samples/bookinfo/networking/bookinfo-gateway.yaml

# scale apps to 2
kubectl scale -n bookinfo --replicas=2 deployment/ratings-v1 deployment/productpage-v1 deployment/reviews-v1 deployment/reviews-v2 deployment/reviews-v3

popd
