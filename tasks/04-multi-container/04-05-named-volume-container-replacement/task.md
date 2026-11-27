# Task 04-05: Named Volume Lifecycle and Data Survival Across Container Replacement

## Objective
Prove database state survives full container deletion and replacement when backed by a Podman named volume.

## Specification
1. Create named volume `customers-pgvol`.
2. Start PostgreSQL container `customers-db-v1` (`quay.io/sclorg/postgresql-16-c10s:latest`) mounting `customers-pgvol` at `/var/lib/pgsql/data` with `POSTGRESQL_USER=crm`, `POSTGRESQL_PASSWORD=crmpass`, `POSTGRESQL_DATABASE=crmdb`.
3. Create table `accounts(id INT, name TEXT)` and insert `(1, 'RedHat-Enterprise')`.
4. **Delete** container `customers-db-v1` completely (`podman rm -f`), then launch replacement container `customers-db-v2` mounting the **same** `customers-pgvol` volume and verify `SELECT name FROM accounts WHERE id=1;` still returns `RedHat-Enterprise`!
