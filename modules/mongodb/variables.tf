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
# MongoDB Database Variables
##############################################################################

variable "mongodb_version" {
  description = "Version of the MongoDB instance to provision. If no value is passed, the current preferred version of IBM Cloud Databases is used."
  type        = string
  default     = "6.0"
  validation {
    condition = anytrue([
      var.mongodb_version == "5.0",
      var.mongodb_version == "6.0"
    ])
    error_message = "Version must be either 5.0 or 6.0. If no value passed, the current ICD preferred version is used."
  }
}
