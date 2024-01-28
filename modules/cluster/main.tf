resource "ibm_container_vpc_cluster" "cluster" {
  name              = "${var.prefix}-cluster"
  vpc_id            = var.vpc_id
  kube_version      = var.kube_version
  flavor            = var.flavor
  worker_count      = var.worker_count
  resource_group_id = data.ibm_resource_group.resource_group.id
  zones {
    subnet_id = "0717-0c0899ce-48ac-4eb6-892d-4e2e1ff8c9478"
    name      = "us-south-1"
  }
}
