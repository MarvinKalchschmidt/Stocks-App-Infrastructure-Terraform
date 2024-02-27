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


