terraform {
  
  backend "oci" {
    #bucket = "tfstate_bucket"
    #key = "tfstate_1.tfstate"
    #namespace = "idjuatm1d4mr"
    config_file_profile = "DEFAULT"
    auth = "SecurityToken"
    #region = "eu-frankfurt-1"
  }
}

provider "oci" {
  region              = var.region
  auth                 = "SecurityToken"
  config_file_profile  = "DEFAULT"
}


resource "oci_core_virtual_network" "demo_vcn" {
  cidr_block     = "10.10.0.0/16"
  compartment_id = var.compartment_id
  display_name   = "demo_vcn"
}

output "vcn_details" {
  value = oci_core_virtual_network.demo_vcn
}