##############################################################################
# Sensitive Account Variables
##############################################################################

variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources."
  type        = string
  sensitive   = true
}



##############################################################################
# Account Variables
##############################################################################

variable "prefix" {
  description = "A unique identifier need to provision resources. Must begin with a letter."
  type        = string
  default     = "stock-app"

  validation {
    error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
    condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.prefix))
  }
}

variable "region" {
  description = "IBM Cloud region where all resources will be deployed."
  type        = string
  default     = "eu-de"
}

variable "resource_group" {
  description = "Name of resource group to provision resources."
  type        = string
  default     = "Default"
}



##############################################################################
# VPC Variables
##############################################################################

variable "subnets" {
  description = "List of subnets for the vpc. For each item in each array, a subnet will be created. Items can be either CIDR blocks or total ipv4 addressess."
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
  default = {
    zone-1 = [{
      name = "subnet-1"
      cidr = "10.10.10.0/24"
    }],
    zone-2 = [{
      name = "subnet-2"
      cidr = "10.20.10.0/24"
    }],
    zone-3 = [{
      name = "subnet-3"
      cidr = "10.30.10.0/24"
    }]
  }

  validation {
    error_message = "Keys for `subnets` must be in the order `zone-1`, `zone-2`, `zone-3`."
    condition     = keys(var.subnets)[0] == "zone-1" && keys(var.subnets)[1] == "zone-2" && keys(var.subnets)[2] == "zone-3"
  }
}



##############################################################################
# Cluster Variables
##############################################################################

variable "kube_version" {
  description = "Specify the Kubernetes version, including the major.minor version. If you do not include this flag, the default version is used."
  type        = string
  default     = "1.28.4"
}

variable "flavor" {
  description = "The flavor of the VPC worker nodes in the default worker pool. This field only affects cluster creation, to manage the default worker pool, create a dedicated worker pool resource."
  type        = string
  default     = "cx2.2x4"
}

variable "worker_count" {
  description = "The number of worker nodes per zone in the default worker pool. Default value 1."
  type        = number
  default     = 1
}

##############################################################################
# COS Variables
##############################################################################

variable "service" {
  description = "TThe name of the service offering."
  type        = string
  default     = "cloud-object-storage"
}

variable "plan" {
  description = "The name of the plan type supported by service."
  type        = string
  default     = "standard"
}

variable "location" {
  description = "The name of the plan type supported by service."
  type        = string
  default     = "global"
}

variable "storage_class" {
  description = "The storage class of the bucket."
  type        = string
  default     = "standard"
}
