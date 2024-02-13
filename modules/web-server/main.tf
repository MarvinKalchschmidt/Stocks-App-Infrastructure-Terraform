##############################################################################
# Web Server Namespace
##############################################################################

resource "kubernetes_namespace" "web_server_namespace" {
  metadata {
    name = "${var.web_server_prefix}-namespace"
  }
}

##############################################################################
# Kubernetes Deployment
##############################################################################

resource "kubernetes_deployment" "web_server_deployment" {
  metadata {
    name      = var.web_server_prefix
    namespace = kubernetes_namespace.web_server_namespace.metadata.0.name
  }

  spec {
    replicas               = var.replicas
    revision_history_limit = 1

    selector {
      match_labels = {
        app = "${var.web_server_prefix}"
      }
    }

    template {
      metadata {
        name = var.web_server_prefix

        labels = {
          app = "${var.web_server_prefix}"
        }
      }

      spec {
        container {
          name              = var.web_server_prefix
          image             = var.docker_image
          image_pull_policy = var.image_pull_policy

          port {
            name           = var.port_name
            container_port = var.server_port
          }

          env {
            name  = "MONGO_CONNECTION_STRING"
            value = "mongodb://mongodb:27017/"
          }

          volume_mount {
            name       = "${var.web_server_prefix}-data"
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
          name = "${var.web_server_prefix}-data"
          /*persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.web_server_pvc.metadata.0.name
          }*/
          empty_dir {

          }
        }
      }
    }
  }
}

##############################################################################
# Kubernetes Persistent Volume Claim
##############################################################################
/*
resource "kubernetes_persistent_volume_claim" "web_server_pvc" {
  metadata {
    name      = "${var.kube_prefix}-pvc"
    namespace = kubernetes_namespace.web_server_namespace.metadata.0.name
    annotations = {
      "ibm.io/auto-create-bucket" : "false"
      "ibm.io/auto-delete-bucket" : "false"
      "ibm.io/bucket" : var.cos_bucket_name
      "ibm.io/secret-name" : var.cos_secret_name
      "ibm.io/secret-namespace" : kubernetes_namespace.web_server_namespace.metadata.0.name
    }
  }

  spec {
    storage_class_name = "ibmc-s3fs-standard-regional"
    access_modes       = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}*/


##############################################################################
# Kubernetes LoadBalancer Service
##############################################################################

resource "kubernetes_service" "web_server_loadbalancer" {
  metadata {
    name      = "${var.web_server_prefix}-loadbalancer-service"
    namespace = kubernetes_namespace.web_server_namespace.metadata.0.name

    labels = {
      app = "${var.web_server_prefix}"
    }
  }

  spec {
    port {
      protocol    = var.port_protocol
      port        = var.server_port
      target_port = var.server_port
    }

    selector = {
      app = "${var.web_server_prefix}"
    }

    type                    = "ClusterIP"
    external_traffic_policy = "Cluster"
  }
  depends_on = [kubernetes_deployment.web_server_deployment]
}
