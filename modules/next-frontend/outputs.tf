##############################################################################
# Next Frontend Server Outputs
##############################################################################

output "next_frontend_ip" {
  description = "The IP to connect with the Next.js frontend server"
  value       = kubernetes_service.next_frontend_loadbalancer.status.0.load_balancer.0.ingress.0.hostname
}
