##############################################################################
# MongoDB Database Creation
##############################################################################

resource "ibm_database" "mongodb" {
  name              = "${var.prefix}-mongo-db"
  service           = "databases-for-mongodb"
  plan              = "standard"
  location          = var.region
  version           = var.mongodb_version
  adminpassword     = "adminpassword1234"
  resource_group_id = var.resource_group_id

  timeouts {
    create = "120m"
    update = "120m"
    delete = "15m"
  }
}
