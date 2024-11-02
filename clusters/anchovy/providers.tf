terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "6.15.0"
    }

    talos = {
      source  = "siderolabs/talos"
      version = "0.4.0"
    }
  }
}

// see .env
provider "oci" {}