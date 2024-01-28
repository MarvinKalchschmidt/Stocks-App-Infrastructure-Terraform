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
# Cluster Variables
##############################################################################

variable "vpc_id" {
  description = "The ID of the VPC that you want to use for your cluster."
  type        = string
}

variable "kube_version" {
  description = "The ID of the VPC that you want to use for your cluster."
  type        = string
}

variable "flavor" {
  description = "The ID of the VPC that you want to use for your cluster."
  type        = string
}

variable "worker_count" {
  description = "The ID of the VPC that you want to use for your cluster."
  type        = number
}

