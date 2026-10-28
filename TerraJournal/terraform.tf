# Configure TerraBlog specific requirements, such as required Terraform version and providers

terraform {
  required_version = "~>1.17.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~>2.9.1"
    }
    external = {
      source  = "hashicorp/external"
      version = "~>2.4.2"
    }
  }
}