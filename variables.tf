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
  default     = "minecraft-on-kubernetes"

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
# Minecraft Server Variables
##############################################################################

variable "kube_prefix" {
  description = "The prefix for all kubernetes components."
  type        = string
  default     = "minecraft-server"

  validation {
    error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
    condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.kube_prefix))
  }
}

variable "minecraft_server_image" {
  description = "The docker image from itzg that dockerizes a Minecraft server in Java version."
  type        = string
  default     = "itzg/minecraft-server"
}

variable "port_name" {
  description = "The port this server is running on."
  type        = string
  default     = "main"
}

variable "server_port" {
  description = "The port this server is running on."
  type        = number
  default     = 25565
}

variable "node_port" {
  description = "The node port this pod is exposed on."
  type        = number
  default     = 30072
}

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

variable "minecraft_server_properties" {
  description = "List of Minecraft server properties."
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    { name = "ALLOW_FLIGHT", value = "false" },
    { name = "ALLOW_NETHER", value = "true" },
    { name = "DIFFICULTY", value = "easy" },
    { name = "MODE", value = "survival" },
    { name = "GENERATE_STRUCTURES", value = "true" },
    { name = "HARDCORE", value = "false" },
    { name = "LEVEL", value = "Minecraft on Kubernetes" },
    { name = "SEED", value = "903249166344263133" },
    { name = "MAX_PLAYERS", value = "10" },
    { name = "MOTD", value = "Deployed with Terraform!!!" },
    { name = "PVP", value = "true" },
    { name = "SERVER_PORT", value = "25565" },
    { name = "MAX_BUILD_HEIGHT", value = "256" },
    { name = "SPAWN_ANIMALS", value = "true" },
    { name = "SPAWN_MONSTERS", value = "true" },
    { name = "SPAWN_NPCS", value = "true" },
    { name = "SPAWN_PROTECTION", value = "12" },
    { name = "VIEW_DISTANCE", value = "12" },
    { name = "ENABLE_WHITELIST", value = "false" },
    { name = "ENABLE_COMMAND_BLOCK", value = "true" },
  ]
}

variable "operators_list" {
  description = "List of Minecraft users that have OP rights on the server."
  type        = string
  default     = "Haikun"
}
