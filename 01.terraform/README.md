# terraform - Infrastructure as Code with terraform

Create google cloud kubernetes cluster with default node pool

Experimental: Create kubernetes deployment and service with kubernetes provider from terraform (disable)

## Guides

1. Follow this [GCP terraform tutorial](https://learn.hashicorp.com/collections/terraform/gcp-get-started) to install terraform
1. Follow this [Configure gcloud SDK](https://learn.hashicorp.com/tutorials/terraform/gke) to configure `gcloud`

## Steps

1. Configure gcloud
1. Run `terraform init`
1. Create new workspace `terraform workspace new blue`
1. Run `terraform apply` and then type "yes"

## Optional steps (manual)

These steps will be replace by terraform files

1. Run `gcloud auth login` to get a token
1. Run `gcloud container clusters get-credentials --zone us-central1 --project dsp-sock-shop-juan $(terraform workspace show)-gke-sock-shop` to authenticate with your cluster. Replace project and zone according to your setup
1. Rename cluster with `kubectx gke-$(terraform workspace show)=gke_dsp-sock-shop-juan_us-central1_$(terraform workspace show)-gke-sock-shop`

## Optional: Install istio with istioctl

The current terraform script already provide istio into the cluster using helm. However, it is also possible to install istio using istioctl

1. Install istioctl using `brew install istioctl`
1. Apply istio config `istioctl install`
1. Install istio operators

**Note**: Kiali requires prometheus to works. Additionally, it looks for jeager and grafana.

- `kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/prometheus.yaml`
- `kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/grafana.yaml`
- `kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/jaeger.yaml`
- `kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/kiali.yaml`
- `kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/extras/zipkin.yaml`

### Istio operators dashboards


- **(Kiali)[https://istio.io/latest/docs/ops/integrations/kiali/]**. istioctl dashboard kiali
- **(Prometheus)[https://istio.io/latest/docs/ops/integrations/prometheus/]**. istioctl dashboard prometheus
- **(Grafana)[https://istio.io/latest/docs/ops/integrations/grafana/]**. istioctl dashboard grafana
- **(Jaeger)[https://istio.io/latest/docs/ops/integrations/jaeger/]**. istioctl dashboard jaeger
- **(Zipkin)[https://istio.io/latest/docs/ops/integrations/zipkin/]**. istioctl dashboard zipkin

## Optional: Install istio with helm

Based on (Istio with Helm)[https://istio.io/latest/docs/setup/install/helm/]

```shell
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

kubectl create namespace istio-system

helm install istio-base istio/base -n istio-system
    helm install istiod istio/istiod -n istio-system --wait

kubectl create namespace istio-ingress
kubectl label namespace istio-ingress istio-injection=enabled
helm install istio-ingressgateway istio/gateway -n istio-system --wait

````

