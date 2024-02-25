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
      cidr = "10.0.0.0/18"
    }],
    zone-2 = [{
      name = "subnet-2"
      cidr = "10.0.64.0/18"
    }],
    zone-3 = [{
      name = "subnet-3"
      cidr = "10.0.128.0/18"
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
  default     = "1.28.6"
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




##############################################################################
# Default Kubernetes Deployment Variables
##############################################################################


variable "replicas" {
  description = "The number of replicas that should be created."
  type        = number
  default     = 1
}

variable "revision_history_limit" {
  description = "The number of old ReplicaSets to retain to allow rollback. This is a pointer to distinguish between explicit zero and not specified."
  type        = number
  default     = 1
}

variable "image_pull_policy" {
  description = "The image pull policy for the deployment"
  type        = string
  default     = "Always"

  validation {
    condition     = can(index(["Always", "Never", "IfNotPresent"], var.image_pull_policy))
    error_message = "Invalid image pull policy. Choose from: Always, Never, IfNotPresent."
  }
}

variable "port_protocol" {
  description = "The protocol for this"
  type        = string
  default     = "TCP"

  validation {
    condition     = can(index(["TCP", "UDP"], var.port_protocol))
    error_message = "Invalid port protocol. Choose from: TCP or UDP."
  }
}


##############################################################################
# Python Server Deployment Variables
##############################################################################

variable "python_server_prefix" {
  description = "The prefix for all Python Server related Kubernetes resources."
  type        = string
  default     = "python-server"

  validation {
    error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
    condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.python_server_prefix))
  }
}

variable "python_server_image" {
  description = "The docker image for the python server."
  type        = string
  default     = "pb070/python-server"
}

variable "python_server_port_name" {
  description = "The port the Python Server can be accessed with."
  type        = string
  default     = "pyhton-server"
}

variable "python_server_port" {
  description = "The port the Python Server can be accessed with."
  type        = number
  default     = 8000
}



##############################################################################
# Web Server Deployment Variables
##############################################################################

variable "web_server_prefix" {
  description = "The prefix for all Web Server related Kubernetes resources."
  type        = string
  default     = "web-server"

  validation {
    error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
    condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.web_server_prefix))
  }
}

variable "web_server_image" {
  description = "The docker image for the Node.js Backend web server."
  type        = string
  default     = "pb070/web-server"
}

variable "web_server_port_name" {
  description = "The name the Web Server can be accessed with."
  type        = string
  default     = "web-server"
}

variable "web_server_port" {
  description = "The port the Web Server can be accessed with."
  type        = number
  default     = 3000
}


##############################################################################
# Next.js Frontend Deployment Variables
##############################################################################

variable "next_frontend_prefix" {
  description = "The prefix for all Next.js Frontend related Kubernetes resources."
  type        = string
  default     = "next-frontend"

  validation {
    error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
    condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.next_frontend_prefix))
  }
}

variable "next_frontend_image" {
  description = "The docker image for the Next.js Frontend."
  type        = string
  default     = "pb070/next-frontend"
}

variable "next_frontend_port_name" {
  description = "The name of the port the Next.js Frontend can be accessed with."
  type        = string
  default     = "next-frontend"
}

variable "next_frontend_port" {
  description = "The port the Next.js Frontend can be accessed with."
  type        = number
  default     = 8080
}

variable "next_frontend_node_port" {
  description = "The NodePort the Next.js Frontend is exposed on."
  type        = number
  default     = 30072
}
