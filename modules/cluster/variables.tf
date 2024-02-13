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
# Cluster Variables
##############################################################################

variable "vpc_id" {
  description = "The ID of the VPC that you want to use for your cluster."
  type        = string
}

variable "kube_version" {
  description = "Specify the Kubernetes version, including the major.minor version. If you do not include this flag, the default version is used."
  type        = string
}

variable "flavor" {
  description = "The flavor of the VPC worker nodes in the default worker pool. This field only affects cluster creation, to manage the default worker pool, create a dedicated worker pool resource."
  type        = string
}

variable "worker_count" {
  description = "The number of worker nodes per zone in the default worker pool. Default value 1."
  type        = number
  default     = 1
}

variable "subnet_list" {
  description = "The ID of the VPC that you want to use for your cluster."
  type = list(
    object({
      id   = string
      name = string
      zone = string
      cidr = string
  }))
}
