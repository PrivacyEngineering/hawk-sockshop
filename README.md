# hawk
Instructions to install complete hawk solution using sock shop microservices

## Aliases

| Alias | Complete Command  |
|-------|-------------------|
| tf    | terraform         |
| kaf   | kubectl apply -f |

## Steps

1. Create infrastructure in Google Cloud using terraform

```shell
cd 01.terraform
tf init
tf workspace new blue
tf apply
```

[Video create infrastructure and install istio](https://asciinema.org/a/MzscarSqYi1P3z3LNUV9vm0JR)

2. Authenticate google cluster in local machine

```shell
gcloud container clusters get-credentials --zone us-central1 --project dsp-sock-shop-juan $(terraform workspace show)-gke-sock-shop
kubectx gke-$(terraform workspace show)=gke_dsp-sock-shop-juan_us-central1_$(terraform workspace show)-gke-sock-shop
```

4. Install sock-shop microservices

```shell
cd 02.sock-shop
kaf .
```

[Video install sock shop](https://asciinema.org/a/uN3g87DLAzl1B9c2qr2zjMREk)

5. Install istio addons (prometheus, grafana, jaeger, kiali)

````shell
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/prometheus.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/grafana.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/jaeger.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/kiali.yaml
````

[Video install istio addons](https://asciinema.org/a/ABzY6L75Bvp5H0nvd9SwL7JfG)

4. Install Hawk core

```shell
cd 03.hawk-core
kaf .
```

5. Run load test

```shell
cd 05.loadtest
kaf .
```