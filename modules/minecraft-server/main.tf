##############################################################################
# Kubernetes Namespace
##############################################################################

resource "kubernetes_namespace" "minecraft_namespace" {
  metadata {
    name = "minecraft-namespace"
  }
}


##############################################################################
# Kubernetes Deployment
##############################################################################

resource "kubernetes_deployment" "minecraft_server" {
  metadata {
    name      = "minecraft-server"
    namespace = kubernetes_namespace.minecraft_namespace.metadata.0.name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "minecraft-server"
      }
    }

    template {
      metadata {
        name = "minecraft-server"

        labels = {
          app = "minecraft-server"
        }
      }

      spec {
        container {
          name  = "minecraft-server"
          image = "itzg/minecraft-server"

          port {
            name           = "main"
            container_port = 25565
          }

          env {
            name  = "EULA"
            value = "TRUE"
          }

          volume_mount {
            name       = "mc-data"
            mount_path = "/data"
          }

          /*env {
            name  = "TYPE"
            value = "SPIGOT"
          }

          env {
            name  = "VERSION"
            value = "LATEST"
          }

          env {
            name  = "MEMORY"
            value = "4G"
          }*/

          /*dynamic "env" {
            for_each = var.minecraftEnvVariables
            content {
              name = env.value["name"]
              value = env.value["value"]
            }
          }*/

          liveness_probe {
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
          }

          //image_pull_policy = "Always"
        }

        volume {
          name = "mc-data"
          empty_dir {

          }
        }
      }
    }
  }
}

##############################################################################
# Kubernetes Persistent Volume
##############################################################################
/*
resource "kubernetes_persistent_volume_claim" "cos_claim" {
  metadata {
    name      = "cos-claim"
    namespace = kubernetes_namespace.minecraft_namespace.metadata.0.name
  }

  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "5Gi" // Adjust the storage capacity as needed
      }
    }
  }
}*/


##############################################################################
# Kubernetes LoadBalancer Service
##############################################################################

resource "kubernetes_service" "minecraft_loadbalancer" {
  metadata {
    name      = "minecraft-loadbalancer-service"
    namespace = kubernetes_namespace.minecraft_namespace.metadata.0.name

    labels = {
      app = "minecraft-server"
    }
  }

  spec {
    port {
      protocol    = "TCP"
      port        = 25565
      target_port = 25565
      node_port   = 30072
    }

    selector = {
      app = "minecraft-server"
    }

    type                    = "LoadBalancer"
    external_traffic_policy = "Cluster"
  }
}




/*
resource "kubernetes_service" "minecraft_server_service" {
  metadata {
    name      = "minecraft-server-service"
    namespace = kubernetes_namespace.minecraft_namespace.metadata.0.name

    labels = {
      app = "minecraft-server"
    }
  }

  spec {
    port {
      protocol  = "TCP"
      port      = 25565
      node_port = 30072
    }

    selector = {
      app = "minecraft-server"
    }

    type = "NodePort"
  }
}*/

/*resource "kubernetes_ingress" "minecraft_server_ingress" {
  metadata {
    name      = "minecraft-server-ingress"
    namespace = kubernetes_namespace.minecraft_namespace.metadata.0.name
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    rule {
      host = "minecraft.yourdomain.com"
      http {
        path {
          path = "/"
          backend {
            service_name = kubernetes_service.minecraft_server_service.metadata.0.name
            service_port = kubernetes_service.minecraft_server_service.spec.0.port.0.node_port
          }
        }
      }
    }
  }
}*/
