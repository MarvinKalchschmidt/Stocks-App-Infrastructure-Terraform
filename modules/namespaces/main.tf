##############################################################################
# Kubernetes Namespaces 
##############################################################################

resource "kubernetes_namespace" "namespace" {
  for_each = var.namespace_names
  metadata {
    name = "${each.value}-namespace"
  }
}
