module "gke-cluster" {
  source     = "./modules/gke"
  node_count = 2
}

module "istio" {
  source                 = "./modules/istio"
  endpoint               = module.gke-cluster.kubernetes_cluster_endpoint
  cluster_ca_certificate = module.gke-cluster.kubernetes_cluster_cluster_ca_certificate
  access_token           = module.gke-cluster.kubernetes_cluster_cluster_access_token
}
