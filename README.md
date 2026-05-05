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
