##############################################################################
# Web Server Kubernetes Deployment
##############################################################################

resource "kubernetes_deployment" "web_server_deployment" {
  metadata {
    name      = var.web_server_prefix
    namespace = var.namespace_name
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
            value = "mongodb://ibm_cloud_10df7442_858e_44d5_a97c_de191221ac88:d23f84bbbea6e55a8d8e5d6ed9dab96b52878487078c41f2214527507bc6a9b1@c395d4c5-3794-4e86-93b1-a17a7953116b-0.b9366f7fcf0b43acb51a70da08153291.databases.appdomain.cloud:32454,c395d4c5-3794-4e86-93b1-a17a7953116b-1.b9366f7fcf0b43acb51a70da08153291.databases.appdomain.cloud:32454,c395d4c5-3794-4e86-93b1-a17a7953116b-2.b9366f7fcf0b43acb51a70da08153291.databases.appdomain.cloud:32454/ibmclouddb?authSource=admin&replicaSet=replset&tls=true"
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
# Web Server Kubernetes Persistent Volume Claim
##############################################################################
/*
resource "kubernetes_persistent_volume_claim" "web_server_pvc" {
  metadata {
    name      = "${var.kube_prefix}-pvc"
    namespace = var.namespace_name
    annotations = {
      "ibm.io/auto-create-bucket" : "false"
      "ibm.io/auto-delete-bucket" : "false"
      "ibm.io/bucket" : var.cos_bucket_name
      "ibm.io/secret-name" : var.cos_secret_name
      "ibm.io/secret-namespace" : var.namespace_name
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
# Web Server Kubernetes Service
##############################################################################

resource "kubernetes_service" "web_server_service" {
  metadata {
    name      = "${var.web_server_prefix}-service"
    namespace = var.namespace_name

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

    type = "ClusterIP"
  }
  depends_on = [kubernetes_deployment.web_server_deployment]
}
