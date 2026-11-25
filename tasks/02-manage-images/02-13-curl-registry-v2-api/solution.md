## Solution
```bash
curl -fsS --cacert /opt/ex188-lab/certs/ca.crt -u student:redhat123 \
  https://auth-reg.lab.local:5444/v2/_catalog \
  -o /home/student/workspace/02-13/catalog.json

curl -fsS --cacert /opt/ex188-lab/certs/ca.crt -u student:redhat123 \
  https://auth-reg.lab.local:5444/v2/finance/ledger-sync/tags/list \
  -o /home/student/workspace/02-13/ledger-tags.json
```

## Explanation
Memorizing the two OCI v2 endpoints — `/v2/_catalog` and `/v2/<namespace>/<repo>/tags/list` — gives you an instant, dependency-free way to verify registry state during any exam task!

## Common Mistakes
- Querying `/v2/tags/list` without the repository path `/v2/finance/ledger-sync/tags/list`.
