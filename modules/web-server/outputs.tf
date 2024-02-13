##############################################################################
# Web Server Outputs
##############################################################################

output "web_server_ip" {
  description = "The IP to connect with the web server"
  value       = kubernetes_service.web_server_loadbalancer.status.0.load_balancer.0.ingress.0.hostname
}
