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

variable "service_credential_names" {
  description = "Map of name, role for service credentials that you want to create for the database"
  type        = map(string)
  default     = { "operator-role" : "Operator" }

  validation {
    condition     = alltrue([for name, role in var.service_credential_names : contains(["Administrator", "Operator", "Viewer", "Editor"], role)])
    error_message = "Valid values for service credential roles are 'Administrator', 'Operator', 'Viewer', and `Editor`"
  }
}

##############################################################################
# Cluster Service Binding Variables
##############################################################################

variable "cluster_id" {
  description = "The name of the cluster for this binding."
  type        = string
}

variable "namespace_name" {
  description = "The name of the namespace the binding secret will be created in."
  type        = string
}
