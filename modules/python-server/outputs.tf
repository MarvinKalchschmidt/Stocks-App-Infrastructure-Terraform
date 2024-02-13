##############################################################################
# Python Server Outputs
##############################################################################

output "python_server_ip" {
  description = "The IP to connect with the python server"
  value       = kubernetes_service.python_server_loadbalancer.status.0.load_balancer.0.ingress.0.hostname
}
