## Solution
```bash
podman search --tls-verify=false --format "{{.Name}}" registry.lab.local:5000/ops \
  | sort > /home/student/workspace/02-01/repos.txt
```

## Explanation
`podman search` queries a v2 registry's catalog endpoint when given a `host:port/term` prefix, and `--format "{{.Name}}"` omits tabular headers for clean scripting.

## Common Mistakes
- Omitting `/ops` after `registry.lab.local:5000` (`podman search` requires a search term after the registry hostname).
