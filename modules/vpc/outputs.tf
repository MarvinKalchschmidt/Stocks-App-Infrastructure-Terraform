##############################################################################
# VPC Outputs
##############################################################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = ibm_is_vpc.vpc.id
}

output "subnet_ids" {
  description = "The IDs of the subnets"
  value = [
    for subnet in ibm_is_subnet.subnet :
    subnet.id
  ]
}

output "zone_list" {
  description = "A list containing subnet IDs and subnet zones"
  value = [
    for subnet in ibm_is_subnet.subnet : {
      name = subnet.name
      id   = subnet.id
      zone = subnet.zone
      cidr = subnet.ipv4_cidr_block
    }
  ]
}
