# DISTANCE:PRO XT — Trust Center

Shared consent management and pseudonymization services for the DISTANCE:PRO XT platform.

## Introduction

The trust center is the privacy-critical part of the platform. It manages patient consent (which data may be used
for which purpose) and performs pseudonymization (replacing identifying information with pseudonyms). Every DIZ site
queries these services before transferring data from the clinical into the research domain.

## Services

| Service            | Technology                                                                            | Role                                                                       |
|--------------------|---------------------------------------------------------------------------------------|----------------------------------------------------------------------------|
| Consent Management | [gICS](https://www.ths-greifswald.de/forscher/gics/) (University Medicine Greifswald) | Stores and evaluates patient consent policies (FHIR + Web UI)              |
| Pseudonymization   | [gPAS](https://www.ths-greifswald.de/forscher/gpas/) (University Medicine Greifswald) | Generates and manages pseudonyms for patient identifiers (FHIR + Web UI)   |
| Trust Center Agent | [FTS-next](https://github.com/medizininformatik-initiative/fts-next)                  | Orchestrates consent lookups and pseudonymization requests from DIZ agents |
| Key Store          | [Valkey](https://valkey.io/)                                                          | Stores cryptographic key material used by the trust center agent           |
| Databases          | MySQL                                                                                 | Persistent storage for gICS and gPAS                                       |

## Component Interaction

The per-site FTS agents (in each DIZ) call the **Trust Center Agent**, which in turn queries **gICS** for consent status
and **gPAS** for pseudonym generation. Only data with valid consent is pseudonymized and forwarded to the research
domain.

## Architecture Context

This is one of three repositories that make up the DISTANCE:PRO XT platform:

- **[core](../core)** — Shared terminology and authentication services
- **trust-center** (this repo) — Consent management and pseudonymization
- **[diz](../diz)** — Per-site data integration (one instance per rollout partner)

## Keycloak Configuration (Terraform)

Keycloak resources are managed as code using the terraform and the official [Keycloak provider][keycloak-provider].

### Design

The `distance-xt` realm is created by the **core** repo. This repo references it via a
`data` source and manages all trust-center-specific resources on top:

**Clients** (`ttp.tf`)

| Client              | Type                        | Purpose                                          |
|---------------------|-----------------------------|--------------------------------------------------|
| `trust-center-web`  | Confidential, standard flow | Browser login for gICS/gPAS web UIs              |
| `trust-center-fhir` | Confidential                | Token introspection for gICS/gPAS FHIR endpoints |

**TC Agent Client** (`tc-agent.tf`)

| Client     | Type                          | Purpose                                                |
|------------|-------------------------------|--------------------------------------------------------|
| `tc-agent` | Confidential, service account | Client credentials flow for the FTS trust center agent |

**Realm Roles** (`ttp.tf`)

| Role                                | Kind                                                |
|-------------------------------------|-----------------------------------------------------|
| `role.gics.user`, `role.gics.admin` | Tool roles (fixed names required by gICS)           |
| `role.gpas.user`, `role.gpas.admin` | Tool roles (fixed names required by gPAS)           |
| `:gics:**`, `:gpas:**`              | Domain wildcard roles (gates access to all domains) |
| `ttp-access-all`                    | Composite: user + wildcard for both tools           |
| `ttp-admin-all`                     | Composite: admin + wildcard for both tools          |

### Cross-Repo Dependency

The realm must exist before this Terraform config can be applied. In practice this means
core's Terraform must run first (or at minimum the realm must already exist in Keycloak).
The dependency is intentionally loose — no remote state references — just a `data` lookup
by realm name.

[keycloak-provider]: https://registry.terraform.io/providers/keycloak/keycloak/latest/docs
