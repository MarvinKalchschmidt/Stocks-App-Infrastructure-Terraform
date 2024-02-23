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
# Redis Database Variables
##############################################################################

variable "redis_version" {
  description = "Version of the Redis instance to provision. If no value is passed, the current preferred version of IBM Cloud Databases is used."
  type        = string
  default     = "6.2"
  validation {
    condition = anytrue([
      var.redis_version == "5",
      var.redis_version == "6",
      var.redis_version == "6.2"
    ])
    error_message = "Version must be 5, 6 or 6.2. If no value passed, the current ICD preferred version is used."
  }
}

variable "configuration" {
  description = "Database Configuration. Default values will get picked up if not all the values are passed."
  type = object({
    maxmemory                   = optional(number)
    maxmemory-policy            = optional(string)
    appendonly                  = optional(string)
    maxmemory-samples           = optional(number)
    stop-writes-on-bgsave-error = optional(string)
  })
  default = null
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
