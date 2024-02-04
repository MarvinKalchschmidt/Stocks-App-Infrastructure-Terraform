data "ibm_resource_group" "resource_group" {
  name = var.resource_group
}

data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id   = module.cluster.cluster_id
  resource_group_id = data.ibm_resource_group.resource_group.id
  admin             = true
}


module "vpc" {
  source            = "./modules/vpc"
  prefix            = var.prefix
  region            = var.region
  subnets           = var.subnets
  resource_group_id = data.ibm_resource_group.resource_group.id
}

module "cluster" {
  source            = "./modules/cluster"
  prefix            = var.prefix
  vpc_id            = module.vpc.vpc_id
  kube_version      = var.kube_version
  flavor            = var.flavor
  worker_count      = var.worker_count
  subnet_list       = module.vpc.subnet_list
  resource_group_id = data.ibm_resource_group.resource_group.id
  depends_on        = [module.vpc]
}

module "cos-storage" {
  source            = "./modules/cos-storage"
  prefix            = var.prefix
  plan              = var.plan
  service           = var.service
  location          = var.location
  region_location   = var.region
  storage_class     = var.storage_class
  resource_group_id = data.ibm_resource_group.resource_group.id
}

module "minecraft-server" {
  source     = "./modules/minecraft-server"
  depends_on = [module.cluster]
}
