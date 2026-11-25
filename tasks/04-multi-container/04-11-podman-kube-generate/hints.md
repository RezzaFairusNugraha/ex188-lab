## Level 1 — Nudge
Check `man podman-kube-generate` (`-s` / `--service` and `-f` output file) and `man podman-kube-play`.

## Level 2 — Approach
1. Run `podman kube generate -s -f ~/workspace/04-11/exported-stack.yaml export-source-pod`.
2. Run `podman pod rm -f export-source-pod`.
3. Run `podman kube play ~/workspace/04-11/exported-stack.yaml`.

## Level 3 — Key Commands
```bash
podman kube generate -s -f ~/workspace/04-11/exported-stack.yaml export-source-pod
podman pod rm -f export-source-pod
podman kube play ~/workspace/04-11/exported-stack.yaml
```
