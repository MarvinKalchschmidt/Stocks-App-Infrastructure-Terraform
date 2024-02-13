##############################################################################
# Data Sources
##############################################################################

data "ibm_resource_group" "resource_group" {
  name = var.resource_group
}

data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id   = module.cluster.cluster_id
  resource_group_id = data.ibm_resource_group.resource_group.id
  admin             = true
}

##############################################################################
# VPC Module
##############################################################################

module "vpc" {
  source            = "./modules/vpc"
  prefix            = var.prefix
  region            = var.region
  subnets           = var.subnets
  resource_group_id = data.ibm_resource_group.resource_group.id
}

##############################################################################
# Kubernetes Cluster Module
##############################################################################

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

##############################################################################
# Python Server Module
##############################################################################

module "python-server" {
  source                 = "./modules/python-server"
  python_server_prefix   = "python-server"
  docker_image           = "pb070/python-server"
  port_name              = var.port_name
  server_port            = "8000"
  replicas               = var.replicas
  revision_history_limit = var.revision_history_limit
  depends_on             = [module.cluster]
}

##############################################################################
# Web Server Module
##############################################################################

module "web-server" {
  source                 = "./modules/web-server"
  web_server_prefix      = "web-server"
  docker_image           = "pb070/web-server"
  port_name              = var.port_name
  server_port            = "3000"
  replicas               = var.replicas
  revision_history_limit = var.revision_history_limit
  depends_on             = [module.cluster]
}

##############################################################################
# Next.js Frontend  Module
##############################################################################

module "next-frontend" {
  source                 = "./modules/next-frontend"
  next_frontend_prefix   = "next-frontend"
  docker_image           = "pb070/next-frontend"
  port_name              = var.port_name
  server_port            = "8080"
  node_port              = "30072"
  replicas               = var.replicas
  revision_history_limit = var.revision_history_limit
  depends_on             = [module.cluster]
}
