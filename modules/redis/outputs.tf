##############################################################################
# Redis Database Outputs
##############################################################################

output "id" {
  description = "Redis instance id."
  value       = ibm_database.redis_database.id
}

output "version" {
  description = "Redis instance version."
  value       = ibm_database.redis_database.version
}

output "guid" {
  description = "Redis instance guid."
  value       = ibm_database.redis_database.guid
}

output "crn" {
  description = "Redis instance crn."
  value       = ibm_database.redis_database.resource_crn
}

output "service_credentials_json" {
  description = "Service credentials json map."
  value       = local.service_credentials_json
  sensitive   = true
}

output "service_credentials_object" {
  description = "Service credentials object."
  value       = local.service_credentials_object
  sensitive   = true
}

output "redis_url" {
  description = "URL to connect to redis database."
  value       = local.service_credentials_object.url
  sensitive   = true
}

output "redis_binding_secret_name" {
  description = "The name of the secret that binds the cluster with the redis database."
  value       = "binding-${ibm_container_bind_service.redis_bind_service["operator-role"].service_instance_name}"
}

