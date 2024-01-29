data "ibm_resource_group" "resource_group" {
  name = var.resource_group
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

