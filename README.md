# distance-xt-trust-center

Shared trust/identity services for the distance-xt platform.

Namespace: `distance-xt-trust-center`

## Components

- **gics** — gICS (consent management, University Medicine Greifswald). App + MySQL.
  - Ingress: `https://gics.distance-xt.life.uni-leipzig.local/gics/...`
- **gpas** — gPAS (pseudonymization). App + MySQL.
  - Ingress: `https://gpas.distance-xt.life.uni-leipzig.local/gpas/...`

## Required CI variables

Assembled into a `credentials` secret by `.app/apply`:

- `GICS_DB_PASSWORD`, `GICS_DB_ROOT_PASSWORD`
- `GPAS_DB_PASSWORD`, `GPAS_DB_ROOT_PASSWORD`

## Open items

- **tc-agent (FTS-next trust-center agent)** — not yet scaffolded. Decision
  pending: shared single instance here, or per-DIZ in each DIZ namespace? (see
  `PLANNING.md`).
- Initdb scripts from the FTS-next reference compose (`gics/initdb/`,
  `gpas/initdb/`) are not wired in. Either mount as ConfigMap or pre-seed the
  PVC; confirm whether the vendor images auto-bootstrap on an empty DB.
- Notification services (`TTP_DISABLE_NOTI_*`) currently off — matches the
  FTS-next test compose. Revisit for prod.
