##############################################################################
# Next Frontend Server Outputs
##############################################################################

output "next_frontend_ip" {
  description = "The IP to connect with the Next.js frontend server"
  value       = kubernetes_service.next_frontend_loadbalancer.status.0.load_balancer.0.ingress.0.hostname
}

output "next_frontend_url" {
  description = "The URL the Next.js Frontend can be reached from within the cluster"
  value       = "http://${kubernetes_service.next_frontend_service.metadata.0.name}.${var.namespace_name}.svc.cluster.local"
}
