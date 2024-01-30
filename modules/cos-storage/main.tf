##############################################################################
# COS Instance Creation
##############################################################################

resource "ibm_resource_instance" "cos_instance" {
  name              = "${var.prefix}-cos-instance"
  service           = var.service
  plan              = var.plan
  location          = var.location
  resource_group_id = var.resource_group_id
}

resource "ibm_cos_bucket" "cos_bucket" {
  bucket_name          = "${var.prefix}-cos-bucket"
  storage_class        = var.storage_class
  region_location      = var.region_location
  resource_instance_id = ibm_resource_instance.cos_instance.id
}
