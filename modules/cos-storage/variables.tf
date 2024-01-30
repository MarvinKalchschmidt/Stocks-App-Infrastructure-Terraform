##############################################################################
# Account Variables
##############################################################################

variable "prefix" {
  description = "A unique identifier need to provision resources. Must begin with a letter."
  type        = string
}

variable "resource_group_id" {
  description = "Name of resource group to provision resources."
  type        = string
}

##############################################################################
# COS Instance Variables
##############################################################################

variable "plan" {
  description = "The name of the plan type supported by service."
  type        = string
}

variable "service" {
  description = "The name of the service offering."
  type        = string
}

variable "location" {
  description = "The name of the plan type supported by service."
  type        = string
}


##############################################################################
# COS Bucket Variables
##############################################################################

variable "storage_class" {
  description = "The storage class of the bucket."
  type        = string
}

variable "region_location" {
  description = "The location if you created a regional bucket."
  type        = string
}
