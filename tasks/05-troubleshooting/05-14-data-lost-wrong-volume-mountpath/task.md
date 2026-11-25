# Task 05-14: Fixing Data Loss Across Container Recreation (Wrong Volume Mount Destination)

## Scenario
An administrator mounted named volume `orders-pgvol` onto `/var/lib/postgresql/data` on `orders-db` (`quay.io/sclorg/postgresql-16-c10s:latest`). Every time `orders-db` is recreated, all SQL tables disappear! Inspect `quay.io/sclorg/postgresql-16-c10s:latest` (`Config.Volumes` / `PGDATA` env / `podman diff orders-db`) to discover why `orders-pgvol` stays empty!

## Requirements
1. Recreate `orders-db` (`POSTGRESQL_USER=ord`, `POSTGRESQL_PASSWORD=ordpass`, `POSTGRESQL_DATABASE=orddb`) mounting `orders-pgvol` at the **actual** data path used by `quay.io/sclorg/postgresql-16-c10s:latest`.
2. Create table `shipments(code TEXT)` and insert `'SHP-9901'`.
3. Prove persistence: grading will verify `orders-pgvol` holds `PG_VERSION` on disk and `'SHP-9901'` is queryable!
