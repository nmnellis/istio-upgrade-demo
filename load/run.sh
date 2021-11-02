#!/bin/bash -x

RUN_TIME_SECONDS=600

INGRESS_IP=$(minikube -p istio-upgrade-demo ip)
INGRESS_PORT=$(kubectl get svc -n istio-gateways istio-ingressgateway -ojsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
echo "GET http://$INGRESS_IP:$INGRESS_PORT/productpage" | vegeta attack -rate 10/1s -duration=${RUN_TIME_SECONDS}s > results.bin

cat results.bin | vegeta plot > plot.html

rm results.bin