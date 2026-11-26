#!/usr/bin/env bash
set -uo pipefail
EXAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${EXAM_DIR}/../../lib/common.sh"
source "${EXAM_DIR}/../../lib/exam_grade_helper.sh"

SHOME="$(student_home)"
WORK="${SHOME}/workspace/m02"
QDIR="${SHOME}/.config/containers/systemd"
exam_grade_init

exam_task_begin "01" "CA trust and persistent auth.json for :5443/:5444"
exam_check 8 "ca.crt missing in certs.d for :5443 or :5444" bash -c "test -f /etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt && test -f /etc/containers/certs.d/auth-reg.lab.local:5444/ca.crt"
exam_check 7 "auth.json missing auth-reg.lab.local:5444" grep -q "auth-reg.lab.local:5444" "${SHOME}/.config/containers/auth.json"
exam_task_end

exam_task_begin "02" "Registry mirror [[registry.mirror]] in 60-m02-mirror.conf"
exam_check 8 "60-m02-mirror.conf missing [[registry.mirror]]" grep -q '\[\[registry\.mirror\]\]' /etc/containers/registries.conf.d/60-m02-mirror.conf
exam_check 7 "mirror-ext.corp.local/m02/ubi-minimal:latest not pulled" podman image exists mirror-ext.corp.local/m02/ubi-minimal:latest
exam_task_end

exam_task_begin "03" "Ingest dir: transport and push to :5444"
exam_check 15 "m02/seed-tool:1.0 missing in auth-reg.lab.local:5444" podman pull -q --authfile "${SHOME}/.config/containers/auth.json" auth-reg.lab.local:5444/m02/seed-tool:1.0
exam_task_end

exam_task_begin "04" "Remote manifest saved to seed-manifest.json"
exam_check 15 "seed-manifest.json missing schemaVersion 2" grep -q '"schemaVersion": *2' "${WORK}/seed-manifest.json"
exam_task_end

exam_task_begin "05" "Worker image with HEALTHCHECK and exec ENTRYPOINT/CMD"
exam_check 8 "localhost/m02-worker:1.0 missing or User != 1001" bash -c "[[ \"\$(podman image inspect --format '{{.Config.User}}' localhost/m02-worker:1.0)\" == 1001* ]]"
exam_check 7 "Healthcheck metadata missing on m02-worker:1.0 (forgot --format docker?)" bash -c "podman image inspect --format '{{json .Config.Healthcheck}}' localhost/m02-worker:1.0 | grep -q 'healthcheck.py'"
exam_task_end

exam_task_begin "06" "Arbitrary-UID api-express image pushed to :5444"
exam_check 15 "auth-reg.lab.local:5444/m02/api:1.0 missing or /var/lib/api-express/audit not GID 0 writable" bash -c "podman pull -q --authfile '${SHOME}/.config/containers/auth.json' auth-reg.lab.local:5444/m02/api:1.0 && podman run --rm --user 42420:0 --entrypoint test localhost/m02-api:1.0 -w /var/lib/api-express/audit"
exam_task_end

exam_task_begin "07" "Build-time --secret without history leak"
exam_check 15 "localhost/m02-secret-build:1.0 missing /etc/bkey.sha256 or leaked M02_BuildKey" bash -c "podman run --rm localhost/m02-secret-build:1.0 test -s /etc/bkey.sha256 && ! podman history --no-trunc localhost/m02-secret-build:1.0 | grep -q 'M02_BuildKey'"
exam_task_end

exam_task_begin "08" "Refactored m02-webapp:2.0 pushed to :5443"
exam_check 15 "m02/webapp:2.0 missing in :5443 or still has API_SECRET / root user" bash -c "podman pull -q secure-reg.lab.local:5443/m02/webapp:2.0 && [[ \"\$(podman image inspect --format '{{.Config.User}}' localhost/m02-webapp:2.0)\" == 1001* ]] && ! podman image inspect localhost/m02-webapp:2.0 | grep -q 'BadHardcodedSecret'"
exam_task_end

exam_task_begin "09" "Flattened single-layer export/import image m02-worker-flat:1.0"
exam_check 15 "m02-worker-flat:1.0 missing or RootFS.Layers != 1" bash -c "[[ \"\$(podman image inspect --format '{{len .RootFS.Layers}}' localhost/m02-worker-flat:1.0 2>/dev/null)\" == '1' ]]"
exam_task_end

exam_task_begin "10" "Persistent low-port sysctl (<=800) and firewalld rules"
exam_check 8 "sysctl 90-m02-lowport.conf missing or live value > 800" bash -c "test -f /etc/sysctl.d/90-m02-lowport.conf && (( \$(sysctl -n net.ipv4.ip_unprivileged_port_start) <= 800 ))"
exam_check 7 "firewalld missing permanent/active 820, 18201, or 18202" bash -c "for p in 820 18201 18202; do run_privileged firewall-cmd --query-port=\${p}/tcp >/dev/null && run_privileged firewall-cmd --permanent --query-port=\${p}/tcp >/dev/null || exit 1; done"
exam_task_end

exam_task_begin "11" "Rootless Quadlet m02-lowedge.service on port 820"
exam_check 15 "m02-lowedge.service not active/persistent or port 820 unreachable" bash -c "systemctl --user is-active --quiet m02-lowedge.service && grep -q '^WantedBy=default.target' '${QDIR}/m02-lowedge.container' && curl -fsS http://127.0.0.1:820/ >/dev/null"
exam_task_end

exam_task_begin "12" "Rootful system Quadlet m02-sys-worker.service"
exam_check 15 "system unit m02-sys-worker.service not active or missing WantedBy=multi-user.target" bash -c "run_privileged systemctl is-active --quiet m02-sys-worker.service && grep -q '^WantedBy=multi-user.target' /etc/containers/systemd/m02-sys-worker.container"
exam_task_end

exam_task_begin "13" "Captured start event in lowedge-events.log"
exam_check 15 "lowedge-events.log missing m02-lowedge start event" grep -q "m02-lowedge" "${WORK}/lowedge-events.log"
exam_task_end

exam_task_begin "14" "Quadlet network, volume, secret, and m02-api.service (18201)"
exam_check 15 "m02-api.service not active or missing m02-net.network / m02-audit.volume" bash -c "systemctl --user is-active --quiet m02-api.service && test -f '${QDIR}/m02-net.network' && test -f '${QDIR}/m02-audit.volume'"
exam_task_end

exam_task_begin "15" "Authenticated audit write on m02-api"
exam_check 15 "audit.log missing on m02-audit volume or token auth not enforced" bash -c "mp=\$(podman volume inspect --format '{{.Mountpoint}}' m02-audit) && test -s \"\${mp}/audit.log\""
exam_task_end

exam_task_begin "16" "Kubernetes ConfigMap + Pod YAML manifests"
exam_check 15 "kube-cm.yaml or kube-pod.yaml missing" bash -c "test -f '${WORK}/kube-cm.yaml' && test -f '${WORK}/kube-pod.yaml'"
exam_task_end

exam_task_begin "17" "Persistent Quadlet m02-kube.service on port 18202"
exam_check 15 "m02-kube.service not active or http://127.0.0.1:18202/ missing M02 Kube Stack" bash -c "systemctl --user is-active --quiet m02-kube.service && curl -fsS http://127.0.0.1:18202/ | grep -q 'M02 Kube Stack'"
exam_task_end

exam_task_begin "18" "Fix SELinux + UID mismatch on m02-selinux-fail (18205)"
exam_check 10 "http://127.0.0.1:18205/healthz not returning writable" bash -c "curl -fsS http://127.0.0.1:18205/healthz | grep -q 'writable'"
exam_task_end

exam_task_begin "19" "Fix unhealthy probe on m02-bad-hc (18206)"
podman healthcheck run m02-bad-hc >/dev/null 2>&1 || true
exam_check 10 "m02-bad-hc health status is not healthy" bash -c "[[ \"\$(podman inspect --format '{{.State.Health.Status}}' m02-bad-hc 2>/dev/null)\" == 'healthy' ]]"
exam_task_end

exam_task_begin "20" "Fix PostgreSQL mount path on m02-db-loss"
exam_check 10 "m02-db-loss not mounting m02-pgvol at /var/lib/pgsql/data" bash -c "podman inspect --format '{{range .Mounts}}{{.Destination}}{{end}}' m02-db-loss | grep -q '/var/lib/pgsql/data'"
exam_task_end

exam_task_begin "21" "Export and fix m02-fixme-pod (port 18207, memory 128Mi)"
exam_check 10 "18207 unreachable or memory limit != 134217728" bash -c "curl -fsS http://127.0.0.1:18207/ >/dev/null && [[ \"\$(podman inspect --format '{{.HostConfig.Memory}}' m02-fixme-pod-fixme-web 2>/dev/null)\" == '134217728' ]]"
exam_task_end

exam_task_begin "22" "Resource inspection report inspect-report.env"
exam_check 5 "inspect-report.env missing VOL_PATH or SUBNET" bash -c "grep -q '^VOL_PATH=' '${WORK}/inspect-report.env' && grep -q '^SUBNET=' '${WORK}/inspect-report.env'"
exam_task_end

exam_grade_summary "mock-02"
