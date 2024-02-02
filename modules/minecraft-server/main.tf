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
            container_port = 25565
            name           = "main"
          }

          env {
            name  = "EULA"
            value = "TRUE"
          }

          env {
            name  = "TYPE"
            value = "SPIGOT"
          }

          env {
            name  = "VERSION"
            value = "1.19.3"
          }

          env {
            name  = "MEMORY"
            value = "4G"
          }

          /*dynamic "env" {
            for_each = var.minecraftEnvVariables
            content {
              name = env.value["name"]
              value = env.value["value"]
            }
          }*/

          image_pull_policy = "Always"
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
# Kubernetes Service
##############################################################################

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
}

resource "kubernetes_ingress" "minecraft_server_ingress" {
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
}
