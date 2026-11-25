## Solution
```bash
podman kube generate \
  -f /home/student/workspace/05-22/remediated-pod.yaml \
  misconfigured-pod

# Update hostPort, env values, and resources.limits.memory on the web container:
python3 - <<'PY'
from pathlib import Path
p = Path("/home/student/workspace/05-22/remediated-pod.yaml")
s = p.read_text()
s = s.replace("hostPort: 18599", "hostPort: 8522")
s = s.replace("value: development", "value: production")
s = s.replace("value: wrong-redis-host", "value: 127.0.0.1")
s = s.replace("resources: {}", "resources:\n      limits:\n        memory: 192Mi", 1)
p.write_text(s)
PY

podman pod rm -f misconfigured-pod
podman kube play /home/student/workspace/05-22/remediated-pod.yaml
```

## Explanation
Notice that `podman kube generate` emits `resources: {}` on containers without resource constraints — replacing `{}` with nested two-space YAML `limits: memory: 192Mi` (`201326592` bytes) applies cgroup v2 memory enforcement when replayed via `podman kube play`!

## Common Mistakes
- Leaving `resources: {}` on the same line when adding `limits:` underneath (`resources: {}\n limits:` is invalid YAML!).
