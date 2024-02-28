##############################################################################
# Next.js Frontend Kubernetes Deployment
##############################################################################

resource "kubernetes_deployment" "next_frontend_deployment" {
  metadata {
    name      = var.next_frontend_prefix
    namespace = var.namespace_name
  }

  spec {
    replicas               = var.replicas
    revision_history_limit = 1

    selector {
      match_labels = {
        app = "${var.next_frontend_prefix}"
      }
    }

    template {
      metadata {
        name = var.next_frontend_prefix

        labels = {
          app = "${var.next_frontend_prefix}"
        }
      }

      spec {
        container {
          name              = var.next_frontend_prefix
          image             = var.docker_image
          image_pull_policy = var.image_pull_policy

          resources {
            requests = {
              memory = "512Mi"
              cpu    = "128m"
            }
            limits = {
              memory = "768Mi"
              cpu    = "256m"
            }
          }

          port {
            name           = var.port_name
            container_port = var.server_port
          }

          env {
            name  = "GOOGLE_CLIENT_ID"
            value = "687886123605-6261hrqm3j7no9nd0sqrkuc6tg429sa9.apps.googleusercontent.com"
          }

          env {
            name  = "WEB_SERVER_SERVICE_NAME"
            value = var.web_server_service_name
          }

          env {
            name  = "WEB_SERVER_PORT"
            value = var.web_server_port
          }

          volume_mount {
            name       = "${var.next_frontend_prefix}-data"
            mount_path = "/data"
          }

          /*liveness_probe {
            exec {
              command = ["/usr/local/bin/mc-monitor", "status", "--host", "localhost"]
            }

            initial_delay_seconds = 120
            period_seconds        = 60
          }

          readiness_probe {
            exec {
              command = ["/usr/local/bin/mc-monitor", "status", "--host", "localhost"]
            }

            initial_delay_seconds = 60
            period_seconds        = 5
            failure_threshold     = 20
          }*/

        }

        volume {
          name = "${var.next_frontend_prefix}-data"
          empty_dir {

          }
        }
      }
    }
  }
}

##############################################################################
# Next.js Frontend Kubernetes LoadBalancer Service
##############################################################################

resource "kubernetes_service" "next_frontend_loadbalancer" {
  metadata {
    name      = "${var.next_frontend_prefix}-loadbalancer-service"
    namespace = var.namespace_name

    labels = {
      app = "${var.next_frontend_prefix}"
    }
  }

  spec {
    port {
      protocol    = var.port_protocol
      port        = var.server_port
      target_port = var.server_port
      node_port   = var.node_port
    }

    selector = {
      app = "${var.next_frontend_prefix}"
    }

    type                    = var.service_type
    external_traffic_policy = "Cluster"
  }
  depends_on = [kubernetes_deployment.next_frontend_deployment]
}
