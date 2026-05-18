resource "keycloak_openid_client" "fts_agent" {
  realm_id    = data.keycloak_realm.distance_xt.id
  client_id   = "tc-agent"
  name        = "FTS TC Agent"
  description = "FHIR Transfer Services Trust Center Agent"

  valid_redirect_uris = []
  web_origins         = []

  access_type              = "CONFIDENTIAL"
  service_accounts_enabled = true
}

resource "keycloak_openid_client_service_account_realm_role" "fts_agent_ttp_admin" {
  realm_id                = data.keycloak_realm.distance_xt.id
  service_account_user_id = keycloak_openid_client.fts_agent.service_account_user_id
  role                    = keycloak_role.ttp_admin_all.name
}
