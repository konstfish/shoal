terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "6.32.0"
    }

    talos = {
      source  = "siderolabs/talos"
      version = "0.7.1"
    }
  }
}

// see .env
provider "oci" {}