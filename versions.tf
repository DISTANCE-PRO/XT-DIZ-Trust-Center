terraform {
  required_version = ">= 1.6"

  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = "5.7.0"
    }
  }
}

provider "keycloak" {
  url           = "https://auth.distance-xt.life.uni-leipzig.local"
  client_id     = "terraform"
  client_secret = var.keycloak_provider_client_secret
}
