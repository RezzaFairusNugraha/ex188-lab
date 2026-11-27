# Task 02-20: End-to-End Secure Promotion Pipeline Across Dev (:5000), QA (:5443), and Prod (:5444)

## Objective
Using **only `podman` and `curl`** (plus host config files), execute a complete three-stage image promotion pipeline across all three lab registries:
- **Dev** (`registry.lab.local:5000` — plain HTTP, already holds `dev/payment-svc:0.9-rc2`)
- **QA** (`secure-reg.lab.local:5443` — HTTPS TLS with `/opt/ex188-lab/certs/ca.crt`)
- **Prod** (`auth-reg.lab.local:5444` — HTTPS TLS + Basic Auth `student` / `redhat123`)

## Specification
1. Configure client trust cleanly:
   - Mark `registry.lab.local:5000` `insecure = true` in `/etc/containers/registries.conf.d/70-dev.conf`.
   - Install `/opt/ex188-lab/certs/ca.crt` into `/etc/containers/certs.d/` for **both** `secure-reg.lab.local:5443` and `auth-reg.lab.local:5444` (never mark `:5443` or `:5444` insecure!).
   - Log in to `auth-reg.lab.local:5444` (`student` / `redhat123`) persisting credentials to `/home/student/.config/containers/auth.json`.
2. Pull `registry.lab.local:5000/dev/payment-svc:0.9-rc2`, promote it to `secure-reg.lab.local:5443/qa/payment-svc:1.0.0`, and promote it to `auth-reg.lab.local:5444/prod/payment-svc:1.0.0` **and** `auth-reg.lab.local:5444/prod/payment-svc:latest`.
3. Verify `prod/payment-svc` tags via `curl` against `https://auth-reg.lab.local:5444/v2/prod/payment-svc/tags/list` and save the JSON response to `/home/student/workspace/02-20/prod-tags.json`.

> *Exam Environment Note*: Pass `--remove-signatures` on `podman push` if pushing any signed Red Hat UBI image.
