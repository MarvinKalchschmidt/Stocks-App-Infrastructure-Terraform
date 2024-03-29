##############################################################################
# Web Server Outputs
##############################################################################

output "web_server_service_name" {
  description = "The name of the Web-Server Service."
  value       = kubernetes_service.web_server_service.metadata.0.name
}

output "web_server_port" {
  description = "The port of the Web-Server Service."
  value       = kubernetes_service.web_server_service.spec.0.port.0.port
}

output "web_server_url" {
  description = "The URL the Web Server can be reached from within the cluster"
  value       = "http://${kubernetes_service.web_server_service.metadata.0.name}.${var.namespace_name}.svc.cluster.local"
}

