##############################################################################
# Next Frontend Server Pod Variables
##############################################################################

variable "namespace_name" {
  description = "The name of the namespace all Kubernetes resources will be created in."
  type        = string
}

variable "next_frontend_prefix" {
  description = "The storage class of the bucket."
  type        = string
}

variable "docker_image" {
  description = "The docker image for the Next.js Frontend."
  type        = string
}

variable "port_name" {
  description = "The port this server is running on"
  type        = string
}

variable "server_port" {
  description = "The port this server is running on"
  type        = number
}

variable "node_port" {
  description = "The node port this pod is exposed on"
  type        = number
}

variable "replicas" {
  description = "The number of replicas that should be created."
  type        = number
}

variable "revision_history_limit" {
  description = "The number of old ReplicaSets to retain to allow rollback. This is a pointer to distinguish between explicit zero and not specified."
  type        = number
}

variable "port_protocol" {
  description = "The protocol for this"
  type        = string

  validation {
    condition     = can(index(["TCP", "UDP"], var.port_protocol))
    error_message = "Invalid port protocol. Choose from: TCP or UDP."
  }
}

variable "image_pull_policy" {
  description = "The image pull policy for the deployment"
  type        = string

  validation {
    condition     = can(index(["Always", "Never", "IfNotPresent"], var.image_pull_policy))
    error_message = "Invalid image pull policy. Choose from: Always, Never, IfNotPresent."
  }
}

variable "service_type" {
  description = "The type of kubernetes_service to be used"
  type        = string
  default     = "LoadBalancer"

  validation {
    condition     = can(index(["ExternalName", "ClusterIP", "NodePort", "LoadBalancer"], var.service_type))
    error_message = "Invalid service type. Choose from: ExternalName, ClusterIP, NodePort, LoadBalancer."
  }
}

variable "web_server_url" {
  description = "The URL the Web Server can be reached from within the cluster"
  type        = string
}
