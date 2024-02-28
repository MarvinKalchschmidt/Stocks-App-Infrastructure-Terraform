##############################################################################
# MongoDB Database Outputs
##############################################################################

output "id" {
  description = "MongoDB instance id."
  value       = ibm_database.mongodb.id
}

output "version" {
  description = "MongoDB instance version."
  value       = ibm_database.mongodb.version
}

output "guid" {
  description = "MongoDB instance guid."
  value       = ibm_database.mongodb.guid
}

output "crn" {
  description = "MongoDB instance crn."
  value       = ibm_database.mongodb.resource_crn
}

output "mongodb_binding_secret_name" {
  description = "The name of the secret that binds the cluster with the mongodb database."
  value       = "binding-${ibm_container_bind_service.mongodb_bind_service["operator-role"].service_instance_name}"
}

