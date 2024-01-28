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


