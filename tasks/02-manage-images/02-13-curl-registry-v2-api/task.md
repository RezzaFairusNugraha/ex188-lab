# Task 02-13: Auditing Registry Repositories and Tags via curl /v2/ HTTP API

## Scenario
Even on minimal hosts, `curl` can directly query the OCI Distribution Spec v2 REST API (`/v2/_catalog` and `/v2/<repo>/tags/list`) across plain HTTP, TLS, and HTTP Basic authenticated registries!

Setup published an image inside the authenticated TLS registry `auth-reg.lab.local:5444` (credentials `student` / `redhat123`, CA `/opt/ex188-lab/certs/ca.crt`) under repository `finance/ledger-sync`.

## Requirements
Using `curl` **only** (with `--cacert /opt/ex188-lab/certs/ca.crt` and `-u student:redhat123`, never `-k`/`--insecure`):
1. Save the raw JSON response of `https://auth-reg.lab.local:5444/v2/_catalog` to `/home/student/workspace/02-13/catalog.json`.
2. Save the raw JSON response of `https://auth-reg.lab.local:5444/v2/finance/ledger-sync/tags/list` to `/home/student/workspace/02-13/ledger-tags.json`.
