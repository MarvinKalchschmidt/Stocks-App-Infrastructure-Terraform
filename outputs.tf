##############################################################################
# Account Outputs
##############################################################################

output "resource_group_name" {
  description = "The name of the resource group."
  value       = data.ibm_resource_group.resource_group.name
}

output "resource_group_id" {
  description = "The ID of the resource group."
  value       = data.ibm_resource_group.resource_group.id
}

##############################################################################
# VPC Outputs
##############################################################################

output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.vpc.vpc_id
}

output "subnet_ids" {
  description = "The IDs of the subnets."
  value       = module.vpc.subnet_ids
}

output "zone_list" {
  description = "A list containing subnet IDs and subnet zones."
  value       = module.vpc.subnet_list
}


##############################################################################
# Cluster Outputs
##############################################################################
