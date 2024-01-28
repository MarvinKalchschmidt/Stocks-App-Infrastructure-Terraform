data "ibm_resource_group" "resource_group" {
  name = var.resource_group
}

resource "ibm_is_vpc" "vpc" {
  name           = "vpc"
  resource_group = data.ibm_resource_group.resource_group
}

resource "ibm_is_subnet" "subnet_1" {
  name            = "subnet-1"
  vpc             = ibm_is_vpc.vpc.id
  zone            = "${var.region}-1"
  ipv4_cidr_block = "10.0.0.0/24"
}
