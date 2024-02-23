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
# Redis Database Module
##############################################################################
module "redis" {
  source            = "./modules/redis"
  prefix            = var.prefix
  region            = var.region
  resource_group_id = data.ibm_resource_group.resource_group.id
}

##############################################################################
# Python Server Module
##############################################################################

module "python-server" {
  source                 = "./modules/python-server"
  python_server_prefix   = var.python_server_prefix
  docker_image           = var.python_server_image
  port_name              = var.python_server_port_name
  server_port            = var.python_server_port
  replicas               = var.replicas
  revision_history_limit = var.revision_history_limit
  redis_url              = module.redis.redis_url
  depends_on             = [module.cluster, module.redis]
}

##############################################################################
# Web Server Module
##############################################################################

module "web-server" {
  source                 = "./modules/web-server"
  web_server_prefix      = var.web_server_prefix
  docker_image           = var.web_server_image
  port_name              = var.web_server_port_name
  server_port            = var.web_server_port
  replicas               = var.replicas
  revision_history_limit = var.revision_history_limit
  depends_on             = [module.cluster]
}

##############################################################################
# Next.js Frontend  Module
##############################################################################

module "next-frontend" {
  source                 = "./modules/next-frontend"
  next_frontend_prefix   = var.next_frontend_prefix
  docker_image           = var.next_frontend_image
  port_name              = var.next_frontend_port_name
  server_port            = var.next_frontend_port
  node_port              = var.next_frontend_node_port
  replicas               = var.replicas
  revision_history_limit = var.revision_history_limit
  depends_on             = [module.cluster]
}
