provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

provider "kubernetes" {
  host                   = data.ibm_container_cluster_config.cluster_foo.host
  token                  = data.ibm_container_cluster_config.cluster_foo.token
  cluster_ca_certificate = data.ibm_container_cluster_config.cluster_foo.ca_certificate
}
