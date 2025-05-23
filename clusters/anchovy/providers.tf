terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "7.0.0"
    }

    talos = {
      source  = "siderolabs/talos"
      version = "0.8.0"
    }
  }
}

// see .env
provider "oci" {}