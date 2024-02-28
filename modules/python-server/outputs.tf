##############################################################################
# Python Server Outputs
##############################################################################

output "python_server_url" {
  description = "The URL the Python Server can be reached from within the cluster"
  value       = "http://${kubernetes_service.python_server_service.metadata.0.name}.${var.namespace_name}.svc.cluster.local"
}
