##############################################################################
# VPC Creation
##############################################################################

resource "ibm_is_vpc" "vpc" {
  name                      = "${var.prefix}-vpc"
  address_prefix_management = var.address_prefix_management
  classic_access            = var.classic_access
  resource_group            = var.resource_group_id
}

##############################################################################
# Subnet and Respective Address Prefix Creation
##############################################################################

locals {
  # Convert subnets into a single list
  subnet_list = flatten([
    # For each key in the object create an array
    for zone in keys(var.subnets) :
    # Each item in the list contains information about a single subnet
    [
      for value in var.subnets[zone] :
      {
        subnet_name         = "${var.prefix}-${value.name}"
        address_prefix_name = "${var.prefix}-address-prefix-${value.name}"
        zone_name           = "${var.region}-${index(keys(var.subnets), zone) + 1}" # Contains region and zone
        cidr                = value.cidr
      }
    ]
  ])

  # Create an object from the array for human readable reference
  subnet_object = {
    for subnet in local.subnet_list :
    "${subnet.subnet_name}" => subnet
  }

}

resource "ibm_is_vpc_address_prefix" "address_prefix" {
  for_each = local.subnet_object
  name     = each.value.address_prefix_name
  vpc      = ibm_is_vpc.vpc.id
  cidr     = each.value.cidr
  zone     = each.value.zone_name
}

resource "ibm_is_subnet" "subnet" {
  for_each        = local.subnet_object
  name            = each.value.subnet_name
  vpc             = ibm_is_vpc.vpc.id
  zone            = each.value.zone_name
  ipv4_cidr_block = ibm_is_vpc_address_prefix.address_prefix[each.value.subnet_name].cidr
  resource_group  = var.resource_group_id
}

##############################################################################
# Public Gateway Creation
##############################################################################

/*
resource "ibm_is_public_gateway" "public_gateway" {
  name           = "${var.prefix}-public-gateway"
  vpc            = ibm_is_vpc.vpc.id
  zone           = ibm_is_subnet.subnet["stock-app-subnet-1"].id
  resource_group = var.resource_group_id
}*/
