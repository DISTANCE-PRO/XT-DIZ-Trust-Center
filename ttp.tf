
resource "keycloak_openid_client" "ttp_fhir" {
  realm_id    = data.keycloak_realm.distance_xt.id
  client_id   = "trust-center-fhir"
  name        = "Trust Center FHIR"
  description = "Trust Center FHIR APIs and services."

  valid_redirect_uris = []
  web_origins         = []

  access_type = "CONFIDENTIAL"
}

resource "keycloak_openid_client" "ttp_web" {
  realm_id    = data.keycloak_realm.distance_xt.id
  client_id   = "trust-center-web"
  name        = "Trust Center Web Apps"
  description = "Trust Center web applications (gICS, gPAS)"

  root_url = "https://gpas.distance-xt.life.uni-leipzig.local"
  valid_redirect_uris = [
    "https://gics.distance-xt.life.uni-leipzig.local/*",
    "https://gpas.distance-xt.life.uni-leipzig.local/*",
  ]
  web_origins = [
    "https://gics.distance-xt.life.uni-leipzig.local",
    "https://gpas.distance-xt.life.uni-leipzig.local",
  ]

  access_type              = "CONFIDENTIAL"
  standard_flow_enabled    = true
  service_accounts_enabled = true
}

resource "keycloak_role" "gics_wildcard" {
  realm_id = data.keycloak_realm.distance_xt.id
  name     = ":gics:**"
}

resource "keycloak_role" "gics_admin" {
  realm_id = data.keycloak_realm.distance_xt.id
  name     = "role.gics.admin"
}

resource "keycloak_role" "gics_user" {
  realm_id = data.keycloak_realm.distance_xt.id
  name     = "role.gics.user"
}

resource "keycloak_role" "gpas_wildcard" {
  realm_id = data.keycloak_realm.distance_xt.id
  name     = ":gpas:**"
}

resource "keycloak_role" "gpas_admin" {
  realm_id = data.keycloak_realm.distance_xt.id
  name     = "role.gpas.admin"
}

resource "keycloak_role" "gpas_user" {
  realm_id = data.keycloak_realm.distance_xt.id
  name     = "role.gpas.user"
}

resource "keycloak_role" "ttp_access_all" {
  realm_id = data.keycloak_realm.distance_xt.id
  name     = "ttp-access-all"
  composite_roles = [
    keycloak_role.gics_user.id,
    keycloak_role.gics_wildcard.id,
    keycloak_role.gpas_user.id,
    keycloak_role.gpas_wildcard.id,
  ]
}

resource "keycloak_role" "ttp_admin_all" {
  realm_id = data.keycloak_realm.distance_xt.id
  name     = "ttp-admin-all"
  composite_roles = [
    keycloak_role.ttp_access_all.id,
    keycloak_role.gics_admin.id,
    keycloak_role.gics_wildcard.id,
    keycloak_role.gpas_admin.id,
    keycloak_role.gpas_wildcard.id,
  ]
}
