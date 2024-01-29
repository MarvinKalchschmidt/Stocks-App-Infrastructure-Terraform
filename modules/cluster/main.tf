locals {
  first_subnet = var.subnet_list[0]
}

resource "ibm_container_vpc_cluster" "cluster" {
  name              = "${var.prefix}-cluster"
  vpc_id            = var.vpc_id
  kube_version      = var.kube_version
  flavor            = var.flavor
  worker_count      = var.worker_count
  resource_group_id = var.resource_group_id

  zones {
    subnet_id = local.first_subnet.id
    name      = local.first_subnet.zone
  }
}
