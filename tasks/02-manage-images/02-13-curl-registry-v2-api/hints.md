## Level 1 — Nudge
Pass `--cacert /opt/ex188-lab/certs/ca.crt` and `-u student:redhat123` to `curl` against both `/v2/_catalog` and `/v2/finance/ledger-sync/tags/list`.

## Level 2 — Approach
Run `curl -fsS --cacert /opt/ex188-lab/certs/ca.crt -u student:redhat123 https://auth-reg.lab.local:5444/v2/_catalog -o ~/workspace/02-13/catalog.json` and repeat for `/v2/finance/ledger-sync/tags/list`.

## Level 3 — Key Commands
```bash
curl -fsS --cacert /opt/ex188-lab/certs/ca.crt -u student:redhat123 \
  https://auth-reg.lab.local:5444/v2/_catalog -o ~/workspace/02-13/catalog.json

curl -fsS --cacert /opt/ex188-lab/certs/ca.crt -u student:redhat123 \
  https://auth-reg.lab.local:5444/v2/finance/ledger-sync/tags/list -o ~/workspace/02-13/ledger-tags.json
```
