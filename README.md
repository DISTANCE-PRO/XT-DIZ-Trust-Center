# distance-xt-trust-center

Shared trust/identity services for the distance-xt platform.

Namespace: `distance-xt-trust-center`

## Components

- **gics** — gICS (consent management, University Medicine Greifswald). App + MySQL.
  - Ingress: `https://gics.distance-xt.life.uni-leipzig.local/gics/...`
- **gpas** — gPAS (pseudonymization). App + MySQL.
  - Ingress: `https://gpas.distance-xt.life.uni-leipzig.local/gpas/...`
- **tc-agent** — FTS-next trust-center agent, with Valkey keystore.
  - Ingress: `https://tc-agent.distance-xt.life.uni-leipzig.local/`

## Database bootstrap

gICS/gPAS do not self-initialize. An initContainer on each db StatefulSet copies the SQL shipped inside the app image (
`/entrypoint-help-and-usage/examples/compose-g{ics,pas}/sqls/*.sql`) into the MySQL `/docker-entrypoint-initdb.d/`
volume, stripping `CREATE USER` / `GRANT ALL` lines (the user is already created from `MYSQL_USER`/`MYSQL_PASSWORD`).
MySQL's first-start guard makes this idempotent.

## Schema migrations — TODO

Mosaic ships numbered upgrade scripts at `/entrypoint-help-and-usage/examples/compose-g{ics,pas}/update_sqls/` inside
the app image, e.g. `03_update_database_gpas_2025.1.2_2025.2.0.sql`. They are **not applied automatically** and are *
*not idempotent across versions** (older scripts may `ALTER`/`DROP` against a newer schema).

We need to apply migrations manually.

## Required CI variables

Assembled into `gics/gpas-db-credentials` secrets by `.app/apply`:

- `GICS_DB_PASSWORD`, `GICS_DB_ROOT_PASSWORD`
- `GPAS_DB_PASSWORD`, `GPAS_DB_ROOT_PASSWORD`

## Open items

- Notification services (`TTP_DISABLE_NOTI_*`) currently off — matches the
  FTS-next test compose. Revisit for prod.
