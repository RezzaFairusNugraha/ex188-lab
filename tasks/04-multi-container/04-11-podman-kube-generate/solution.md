## Solution
```bash
podman kube generate -s \
  -f /home/student/workspace/04-11/exported-stack.yaml \
  export-source-pod

podman pod rm -f export-source-pod
podman kube play /home/student/workspace/04-11/exported-stack.yaml
```

## Explanation
Exam pro-tip: When asked to write a complex Kubernetes Pod YAML from scratch on the EX188 exam, build the Pod with `podman pod create` + `podman run --pod`, export clean valid YAML via `podman kube generate -f ...`, tweak any extra fields in `vim`, remove the imperative pod, and run `podman kube play`!

## Common Mistakes
- Forgetting `-s` (`--service`) when the task explicitly asks for a generated `kind: Service` document alongside `kind: Pod`.
