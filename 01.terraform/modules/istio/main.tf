terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.6.1"
    }
  }
}

provider "kubernetes" {
  host                   = "https://${var.endpoint}"
  token                  = var.access_token
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${var.endpoint}"
    token                  = var.access_token
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  }
}

resource "kubernetes_namespace" "istio-system" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio-base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  version    = "${var.istio-version}"
  namespace  = kubernetes_namespace.istio-system.id
  depends_on = [
    kubernetes_namespace.istio-system
  ]
}

resource "helm_release" "istio-istiod" {
  name       = "istio-istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = "${var.istio-version}"
  namespace  = kubernetes_namespace.istio-system.id
  depends_on = [
    kubernetes_namespace.istio-system,
    helm_release.istio-base
  ]
}

resource "kubernetes_namespace" "istio-ingress" {
  metadata {
    name = "istio-ingress"
    labels = {
      istio-injection = "enabled"
    }
  }
}
resource "helm_release" "istio-ingressgateway" {
  name       = "istio-ingressgateway"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  version    = "${var.istio-version}"
  namespace  = kubernetes_namespace.istio-system.id
  depends_on = [
    kubernetes_namespace.istio-system,
    helm_release.istio-base,
    kubernetes_namespace.istio-ingress,
    helm_release.istio-istiod
  ]
}
