# Install Istio 1-9-7

* install operator

```sh
kubectl create namespace istio-system 
kubectl create namespace istio-gateways 
kubectl create namespace istio-config

pushd /tmp

ISTIO_VERSION=1.9.7
REVISION=1-9-7

curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION sh -

cd istio-$ISTIO_VERSION

# Deploy operator
# cannot use helm install due to namespace ownership https://github.com/istio/istio/pull/30741
TEMPLATE=$(helm template istio-operator-$REVISION manifests/charts/istio-operator \
  --set operatorNamespace=istio-operator \
  --set watchedNamespaces="istio-system\,istio-gateways" \
  --set global.hub="docker.io/istio" \
  --set global.tag="$ISTIO_VERSION" \
  --set revision="$REVISION")

popd

echo $TEMPLATE > operator.yaml
kubectl apply -f operator.yaml
```

* install istio

```sh
kubectl apply -f istiooperator.yaml
```

* install gateway

```sh
# copy configmap from istio-system to istio-gateways
REVISION=1-9-7
CM_DATA=$(kubectl get configmap istio-$REVISION -n istio-system -o jsonpath={.data})

cat <<EOF > ./istio-$REVISION.json
{
    "apiVersion": "v1",
    "data": $CM_DATA,
    "kind": "ConfigMap",
    "metadata": {
        "labels": {
            "istio.io/rev": "1-9-7"
        },
        "name": "istio-1-9-7",
        "namespace": "istio-gateways"
    }
}
EOF

kubectl apply -f istio-$REVISION.json

kubectl apply -n istio-gateways -f ingressgateway.yaml

```
