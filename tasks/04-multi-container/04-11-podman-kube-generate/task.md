# Task 04-11: Exporting a Running Multi-Container Pod to Kubernetes YAML with podman kube generate

## Scenario
`podman kube generate` turns imperative Podman pods, containers, and volumes into portable Kubernetes `Pod` + `Service` YAML manifests ready for `podman kube play`, Quadlet `.kube`, or OpenShift!

Setup started running pod `export-source-pod` containing `web` and `cache` containers.

## Requirements
1. Export `export-source-pod` (including a Kubernetes `Service` object via `-s`) to `/home/student/workspace/04-11/exported-stack.yaml` using `podman kube generate`.
2. Stop and remove `export-source-pod` completely (`podman pod rm -f export-source-pod`).
3. Re-create the workload solely from `/home/student/workspace/04-11/exported-stack.yaml` using `podman kube play` and verify `http://127.0.0.1:8411/healthz` returns `200 OK`!
