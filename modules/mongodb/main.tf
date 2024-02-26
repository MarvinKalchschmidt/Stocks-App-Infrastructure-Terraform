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


##############################################################################
# Service Credentials
##############################################################################

resource "ibm_resource_key" "service_credentials" {
  for_each             = var.service_credential_names
  name                 = "${var.prefix}-${each.key}"
  role                 = each.value
  resource_instance_id = ibm_database.mongodb.id
}
/*
locals {
  # used for output only
  service_credentials_json = length(var.service_credential_names) > 0 ? {
    for service_credential in ibm_resource_key.service_credentials :
    service_credential["name"] => service_credential["credentials_json"]
  } : null

  service_credentials_object = length(var.service_credential_names) > 0 ? {
    hostname    = ibm_resource_key.service_credentials[keys(var.service_credential_names)[0]].credentials["connection.rediss.hosts.0.hostname"]
    certificate = ibm_resource_key.service_credentials[keys(var.service_credential_names)[0]].credentials["connection.rediss.certificate.certificate_base64"]
    port        = ibm_resource_key.service_credentials[keys(var.service_credential_names)[0]].credentials["connection.rediss.hosts.0.port"]
    url         = ibm_resource_key.service_credentials[keys(var.service_credential_names)[0]].credentials["connection.rediss.composed.0"]
    credentials = {
      for service_credential in ibm_resource_key.service_credentials :
      service_credential["name"] => {
        username = service_credential.credentials["connection.rediss.authentication.username"]
        password = service_credential.credentials["connection.rediss.authentication.password"]
      }
    }
  } : null
}*/

##############################################################################
# Container Bind Service 
##############################################################################

resource "ibm_container_bind_service" "mongodb_bind_service" {
  for_each              = var.service_credential_names
  cluster_name_id       = var.cluster_id
  service_instance_name = ibm_database.mongodb.name
  namespace_id          = var.namespace_name
  key                   = ibm_resource_key.service_credentials[each.key].guid
}

