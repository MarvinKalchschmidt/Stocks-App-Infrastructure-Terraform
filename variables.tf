##############################################################################
# Sensitive Account Variables
##############################################################################

variable ibmcloud_api_key {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
}


##############################################################################
# Account Variables
##############################################################################

variable region {
  description = "IBM Cloud region where all resources will be deployed"
}

variable resource_group {
  description = "Name of resource group to provision resources"
}
