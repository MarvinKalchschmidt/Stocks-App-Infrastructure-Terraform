data "ibm_resource_group" "resource_group" {
  name = var.resource_group
}

resource "ibm_is_vpc" "vpc" {
  name                      = "${var.prefix}-vpc"
  address_prefix_management = "manual"
  classic_access            = false
  resource_group            = data.ibm_resource_group.resource_group.id
}

resource "ibm_is_subnet" "subnet" {
  depends_on      = [ibm_is_vpc_address_prefix.address_prefix]
  name            = "${var.prefix}-subnet"
  vpc             = ibm_is_vpc.vpc.id
  zone            = "${var.region}-1"
  ipv4_cidr_block = var.ipv4_cidr_block
  resource_group  = data.ibm_resource_group.resource_group.id
}

resource "ibm_is_vpc_address_prefix" "address_prefix" {
  name = "${var.prefix}-address-prefix"
  vpc  = ibm_is_vpc.vpc.id
  cidr = var.ipv4_cidr_block
  zone = "${var.region}-1"
}
