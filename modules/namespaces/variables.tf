##############################################################################
# Namespace Variables
##############################################################################

variable "namespace_names" {
  description = "A list with names for all namespaces."
  type        = set(string)
  default     = ["python-server", "web-server", "next-frontend"]
}
