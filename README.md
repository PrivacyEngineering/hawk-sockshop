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

This is an example of the Hawk core functionalities using the [WeaveWorks SockShop](https://github.com/microservices-demo/microservices-demo).

_We provide a [Helm](#helm-deployment-on-a-minikube-host) installation instruction as a default deployment example._

_Additionally we provide with legacy installation examples for [terraform](DEPLOYMENT.md#terraform-install) and [kubernetes](DEPLOYMENT.md#kubernetes-install) that you can adapt to your liking._

## Helm deployment on a minikube host

### Requirements
- minikube
- helm
- istioctl

### Getting started

1. Install minikube
2. Enable the minikube ingress addon:
    
    ```minikube addons enable ingress```

3. Follow the helm deployment instructions of the [Hawk](./hawk/README.md#deployment-through-helm) repository. (On GitHub click [here](https://github.com/PrivacyEngineering/hawk/#deployment-through-helm))
4. Follow the deployment instructions of the [envoy integrations](./hawk-envoy-plugin/README.md#deployment-through-helm) repository. (On GitHub click [here](https://github.com/PrivacyEngineering/hawk-envoy-plugin#deployment-through-helm))
5. Install the Sock Shop microservice demo:

    ```kubectl apply -f ./02.sock-shop```
6. If necessary, install the load generator:

    ```kubectl apply -f ./05.loadtest```
7. Get your minikube ingress ip address and append it, as well as the monitor domain of your values file to your _/etc/hosts_ file

    ```echo $(minikube ip) monitor.hawk.local >> /etc/hosts```

8. Access Hawk monitor through your webbrowser.