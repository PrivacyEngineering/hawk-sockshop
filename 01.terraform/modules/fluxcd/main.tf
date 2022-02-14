terraform {
  required_providers {
    flux = {
      source = "fluxcd/flux"
      version = "0.8.0"
    }
  }
}

provider "flux" {
  # Configuration options
}