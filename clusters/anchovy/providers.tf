terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "6.21.0"
    }

    talos = {
      source  = "siderolabs/talos"
      version = "0.6.1"
    }
  }
}

// see .env
provider "oci" {}