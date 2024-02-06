##############################################################################
# Kubernetes Namespace
##############################################################################

resource "kubernetes_namespace" "minecraft_namespace" {
  metadata {
    name = "minecraft-namespace"
  }
}


##############################################################################
# Kubernetes Namespace
##############################################################################

resource "kubernetes_namespace" "compose_namespace" {
  metadata {
    name = "compose-namespace"
  }
}

##############################################################################
# Redis Service
##############################################################################

resource "kubernetes_deployment" "redis" {
  metadata {
    name      = "redis"
    namespace = kubernetes_namespace.compose_namespace.metadata.0.name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "redis"
      }
    }

    template {
      metadata {
        labels = {
          app = "redis"
        }
      }

      spec {
        container {
          name  = "redis"
          image = "redis:latest"

          port {
            container_port = 6379
          }
        }
      }
    }
  }
}

##############################################################################
# MongoDB Service
##############################################################################

resource "kubernetes_deployment" "mongodb" {
  metadata {
    name      = "mongodb"
    namespace = kubernetes_namespace.compose_namespace.metadata.0.name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mongodb"
      }
    }

    template {
      metadata {
        labels = {
          app = "mongodb"
        }
      }

      spec {
        container {
          name  = "mongodb"
          image = "mongo:latest"

          port {
            container_port = 27017
          }

          env {
            name  = "MONGO_INITDB_ROOT_USERNAME"
            value = "admin"
          }

          env {
            name  = "MONGO_INITDB_ROOT_PASSWORD"
            value = "password"
          }
        }
      }
    }
  }
}

##############################################################################
# Python Server Service
##############################################################################

resource "kubernetes_deployment" "python_server" {
  metadata {
    name      = "python-server"
    namespace = kubernetes_namespace.compose_namespace.metadata.0.name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "python-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "python-server"
        }
      }

      spec {
        container {
          name  = "python-server"
          image = "python-server:latest"

          port {
            container_port = 8000
          }

          env {
            name  = "AV_API_KEYS"
            value = "DTCU39VCLLOGPXW8"
          }

          env {
            name  = "REDIS_URL"
            value = "redis://redis:6379"
          }
        }
      }
    }
  }
}

##############################################################################
# Web Server Service
##############################################################################

resource "kubernetes_deployment" "web_server" {
  metadata {
    name      = "web-server"
    namespace = kubernetes_namespace.compose_namespace.metadata.0.name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "web-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "web-server"
        }
      }

      spec {
        container {
          name  = "web-server"
          image = "web-server:latest"

          port {
            container_port = 8080
          }

          env {
            name  = "MONGO_CONNECTION_STRING"
            value = "mongodb://mongodb:27017/"
          }
        }
      }
    }
  }
}

##############################################################################
# Next.js Frontend Service
##############################################################################

resource "kubernetes_deployment" "next_frontend" {
  metadata {
    name      = "next-frontend"
    namespace = kubernetes_namespace.compose_namespace.metadata.0.name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "next-frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "next-frontend"
        }
      }

      spec {
        container {
          name  = "next-frontend"
          image = "next-frontend:latest"

          port {
            container_port = 3000
          }
        }
      }
    }
  }
}


 


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
