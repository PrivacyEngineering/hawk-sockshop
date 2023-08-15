# Hawk SockShop

We published Hawk at the 16th IEEE International Conference on Cloud Computing 2023, IEEE Cloud 2023.
Please find our paper on Hawk here: https://arxiv.org/abs/2306.02496

## BibTex citation:
```
@misc{grünewald2023hawk,
      title={Hawk: DevOps-driven Transparency and Accountability in Cloud Native Systems}, 
      author={Elias Grünewald and Jannis Kiesel and Siar-Remzi Akbayin and Frank Pallas},
      year={2023},
      eprint={2306.02496},
      archivePrefix={arXiv},
      primaryClass={cs.DC}
}
```
## Overview

An example Hawk installation using the [WeaveWorks SockShop](https://github.com/microservices-demo/microservices-demo), integrated with some of Hawk components.

_We provide a simple [terraform](#terraform-install) install as well as plain [kubernetes](#kubernetes-install) install instructions._

## Terraform install
### Aliases

| Alias | Complete Command  |
|-------|-------------------|
| tf    | terraform         |
| kaf   | kubectl apply -f |

### Steps

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
gcloud container clusters get-credentials --zone us-central1 --project sock-shop $(terraform workspace show)-gke-sock-shop
kubectx gke-$(terraform workspace show)=gke_sock-shop_us-central1_$(terraform workspace show)-gke-sock-shop
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


## Kubernetes install
### Steps

1. Set up a Kubernetes environment and configure kubectl (see https://kubernetes.io/docs/setup/)

2. Install Istio and istioctl following the steps in the Istio getting started documentation under https://istio.io/latest/docs/setup/getting-started/

    2.1 Install Istio in your Kubernetes environment with a [configuration profile](https://istio.io/latest/docs/setup/additional-setup/config-profiles/) of your liking
    ```sh
    istioctl install --set profile=default -y
    ```

3. Clone this repository and change into the new directory
```shell
git clone https://github.com/PrivacyEngineering/hawk-sockshop.git
cd ./hawk-sockshop
```

4. Create the SockShop namespace
```shell
kubectl apply -f ./02.sock-shop/00-sock-shop-ns.yaml
```

5. Apply Hawk - Core to the environment
```shell
kubectl apply -f ./03.hawk-core/
```

6. Apply the ShockShop to the environment
```shell
kubectl apply -f ./02.sock-shop/
```

7. Run the load test
```shell
kubectl apply -f ./05.loadtest/
``` 

8. Access the SockShop front-end
```shell
kubectl -n sock-shop port-forward svc/front-end 8080:80
```

9. Verify that all pods are running as expected
```sh
kubectl get pods -A
```

10. Set up grafana
```
collector.hawk-ns.svc.cluster.local
```
<details>
<summary>This command should produce an output similar to this output. (Click to view full output.)</summary>

```sh
NAMESPACE      NAME                                       READY   STATUS 
hawk-ns        collector-cli-deployment-b499c4bd6-zrcbs   2/2     Running
hawk-ns        collector-db-v1-d869b4bb4-rgsk8            2/2     Running
hawk-ns        collector-go-deployment-6989dbb8b-rshlx    2/2     Running
hawk-ns        collector-v1-7d45888f65-9c72b              2/2     Running
hawk-ns        grafana-deployment-5954d7b4d7-rjqqt        1/1     Running
hawk-ns        rabbitmq-deployment-5df9bcd5b9-bbrbs       2/2     Running
istio-system   istio-ingressgateway-79cc8bf885-xm4kz      1/1     Running
istio-system   istiod-777dc7ffbc-s4brz                    1/1     Running
kube-system    coredns-787d4945fb-jw5df                   1/1     Running
kube-system    etcd-minikube                              1/1     Running
kube-system    kube-apiserver-minikube                    1/1     Running
kube-system    kube-controller-manager-minikube           1/1     Running
kube-system    kube-proxy-mfj8c                           1/1     Running
kube-system    kube-scheduler-minikube                    1/1     Running
kube-system    storage-provisioner                        1/1     Running
loadtest       load-test-v1-78cdbc5956-bwph7              2/2     Running
loadtest       load-test-v1-78cdbc5956-ldfq4              2/2     Running
sock-shop      carts-db-v1-66f65f754d-pqhrq               2/2     Running
sock-shop      carts-v1-7c75f458ff-4mfck                  2/2     Running
sock-shop      catalogue-db-v1-6559f59f5b-j6lpp           2/2     Running
sock-shop      catalogue-v1-5dffc66796-z4kgs              2/2     Running
sock-shop      front-end-v1-5f7df97cbd-t24n5              2/2     Running
sock-shop      orders-db-v1-7795cc68bb-smn75              2/2     Running
sock-shop      orders-v1-75cdd99c49-25pnk                 2/2     Running
sock-shop      payment-v1-8694bd9444-t7vbg                2/2     Running
sock-shop      queue-master-v1-5864c5b6f5-xh6zm           2/2     Running
sock-shop      rabbitmq-v1-7dd9b9f8bc-6c5z8               3/3     Running
sock-shop      session-db-v1-75fbf4d78b-l8djx             2/2     Running
sock-shop      shipping-v1-567486c748-6sgzf               2/2     Running
sock-shop      user-db-v1-584cbb8778-wqbh2                2/2     Running
sock-shop      user-v1-77fd8bccd9-tgpb8                   2/2     Running
```

</details>
