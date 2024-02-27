##############################################################################
# Namespaces Outputs
##############################################################################

output "python_server_namespace_name" {
  description = "Name of the Python Server namespace."
  value       = kubernetes_namespace.namespace["python-server"].metadata.0.name
}

output "web_server_namespace_name" {
  description = "Name of the Web Server namespace."
  value       = kubernetes_namespace.namespace["web-server"].metadata.0.name
}

output "next_frontend_namespace_name" {
  description = "Name of the Next.js Frontend namespace."
  value       = kubernetes_namespace.namespace["next-frontend"].metadata.0.name
}
