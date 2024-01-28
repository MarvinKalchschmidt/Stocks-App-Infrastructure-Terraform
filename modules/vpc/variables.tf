##############################################################################
# Account Variables
##############################################################################

variable "prefix" {
  description = "A unique identifier need to provision resources. Must begin with a letter."
  type        = string
}

variable "region" {
  description = "IBM Cloud region where all resources will be deployed."
  type        = string
}

variable "resource_group_id" {
  description = "Name of resource group to provision resources."
  type        = string
}

##############################################################################
# VPC Variables
##############################################################################

variable "classic_access" {
  description = "The IPv4 range of the subnet."
  type        = bool
  default     = false
}

variable "address_prefix_management" {
  description = "The IPv4 range of the subnet."
  type        = string
  default     = "manual"
}

##############################################################################
# Subnet Variables
##############################################################################

variable "subnets" {
  description = "List of subnets for the vpc. For each item in each array, a subnet will be created. Items can be either CIDR blocks or total ipv4 addressess. Public gateways will be enabled only in zones where a gateway has been created"
  type = object({
    zone-1 = list(
      object({
        name = string
        cidr = string
    }))
    zone-2 = list(
      object({
        name = string
        cidr = string
    }))
    zone-3 = list(
      object({
        name = string
        cidr = string
    }))
  })
}
