#!/usr/bin/env bash
set -uo pipefail
EXAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${EXAM_DIR}/../../lib/common.sh"
source "${EXAM_DIR}/../../lib/exam_grade_helper.sh"

SHOME="$(student_home)"
WORK="${SHOME}/workspace/m01"
QDIR="${SHOME}/.config/containers/systemd"
exam_grade_init

exam_task_begin "01" "Registry TLS certs.d and HTTP drop-in"
exam_check 5 "ca.crt missing for secure-reg.lab.local:5443" test -f /etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt
exam_check 5 "ca.crt missing for auth-reg.lab.local:5444" test -f /etc/containers/certs.d/auth-reg.lab.local:5444/ca.crt
exam_check 5 "50-m01.conf missing insecure=true for registry.lab.local:5000" grep -q "insecure *= *true" /etc/containers/registries.conf.d/50-m01.conf
exam_task_end

exam_task_begin "02" "Persistent registry credentials in ~/.config/containers/auth.json"
exam_check 15 "auth.json missing or lacks auth-reg.lab.local:5444" grep -q "auth-reg.lab.local:5444" "${SHOME}/.config/containers/auth.json"
exam_task_end

exam_task_begin "03" "Registry /v2/_catalog audit JSON"
exam_check 15 "auth-catalog.json missing seed/catalog-check" grep -q "catalog-check" "${WORK}/auth-catalog.json"
exam_task_end

exam_task_begin "04" "Base image promoted to :5443 (1.0 and latest)"
exam_check 8 "m01/ubi-base:1.0 not pullable from :5443" podman pull -q --tls-verify=true secure-reg.lab.local:5443/m01/ubi-base:1.0
exam_check 7 "m01/ubi-base:latest not pullable from :5443" podman pull -q --tls-verify=true secure-reg.lab.local:5443/m01/ubi-base:latest
exam_task_end

exam_task_begin "05" "Portal Containerfile and image localhost/m01-portal:1.0"
exam_check 7 "localhost/m01-portal:1.0 does not exist" podman image exists localhost/m01-portal:1.0
exam_check 8 "Label com.exam.suite=mock-01 missing on m01-portal:1.0" bash -c "[[ \"\$(podman image inspect --format '{{index .Config.Labels \"com.exam.suite\"}}' localhost/m01-portal:1.0)\" == 'mock-01' ]]"
exam_task_end

exam_task_begin "06" "Non-root webapp-flask image localhost/m01-webapp:1.0"
exam_check 8 "localhost/m01-webapp:1.0 missing" podman image exists localhost/m01-webapp:1.0
exam_check 7 "m01-webapp:1.0 User is not 1001" bash -c "[[ \"\$(podman image inspect --format '{{.Config.User}}' localhost/m01-webapp:1.0)\" == 1001* ]]"
exam_task_end

exam_task_begin "07" "Portal and Webapp pushed to auth-reg.lab.local:5444"
exam_check 8 "m01/portal:1.0 not in :5444" podman pull -q --authfile "${SHOME}/.config/containers/auth.json" auth-reg.lab.local:5444/m01/portal:1.0
exam_check 7 "m01/webapp:1.0 not in :5444" podman pull -q --authfile "${SHOME}/.config/containers/auth.json" auth-reg.lab.local:5444/m01/webapp:1.0
exam_task_end

exam_task_begin "08" "Multi-stage Go metrics image built and pushed to :5443"
exam_check 8 "m01/metrics:1.0 missing in :5443" podman pull -q secure-reg.lab.local:5443/m01/metrics:1.0
exam_check 7 "Go compiler leaked or User != 1001 in m01-metrics:1.0" bash -c "[[ \"\$(podman image inspect --format '{{.Config.User}}' localhost/m01-metrics:1.0)\" == '1001' ]] && ! podman run --rm --entrypoint sh localhost/m01-metrics:1.0 -c 'command -v go'"
exam_task_end

exam_task_begin "09" "OCI archive saved at metrics-oci.tar"
exam_check 15 "metrics-oci.tar missing or not oci-archive format" bash -c "tar -tf '${WORK}/metrics-oci.tar' | grep -qx 'oci-layout'"
exam_task_end

exam_task_begin "10" "Persistent Quadlet m01-portal.service on port 18101"
exam_check 8 "m01-portal.service not active or missing WantedBy=default.target" bash -c "systemctl --user is-active --quiet m01-portal.service && grep -q '^WantedBy=default.target' '${QDIR}/m01-portal.container'"
exam_check 7 "http://127.0.0.1:18101/config.js missing Mock-01 Live Portal" bash -c "curl -fsS http://127.0.0.1:18101/config.js | grep -q 'Mock-01 Live Portal'"
exam_task_end

exam_task_begin "11" "Firewall ports (18101..18103) and student linger"
exam_check 10 "firewalld permanent/runtime missing 18101, 18102, or 18103" bash -c "for p in 18101 18102 18103; do run_privileged firewall-cmd --query-port=\${p}/tcp >/dev/null && run_privileged firewall-cmd --permanent --query-port=\${p}/tcp >/dev/null || exit 1; done"
exam_check 5 "linger not enabled for student" test -f "/var/lib/systemd/linger/$(student_user)"
exam_task_end

exam_task_begin "12" "Hardened Quadlet m01-metrics.service on port 18102"
exam_check 8 "m01-metrics.service not active or not ReadOnly" bash -c "systemctl --user is-active --quiet m01-metrics.service && [[ \"\$(podman inspect --format '{{.HostConfig.ReadonlyRootfs}}' m01-metrics)\" == 'true' ]]"
exam_check 7 "http://127.0.0.1:18102/metrics did not return m01-edge" bash -c "curl -fsS http://127.0.0.1:18102/metrics | grep -q 'm01-edge'"
exam_task_end

exam_task_begin "13" "Inspect summary metrics-inspect.env"
exam_check 15 "metrics-inspect.env missing PID, USER=1001, or MEMORY=134217728" bash -c "grep -q '^USER=1001$' '${WORK}/metrics-inspect.env' && grep -q '^MEMORY=134217728$' '${WORK}/metrics-inspect.env' && grep -Eq '^PID=[0-9]+$' '${WORK}/metrics-inspect.env'"
exam_task_end

exam_task_begin "14" "Secret m01_web_sec and SELinux-labeled notes-data"
exam_check 8 "Podman secret m01_web_sec missing" podman secret exists m01_web_sec
exam_check 7 "notes-data missing container_file_t SELinux label" bash -c "stat -c '%C' '${WORK}/notes-data' | grep -q ':container_file_t:'"
exam_task_end

exam_task_begin "15" "Quadlet Pod stack m01-app-pod.service on port 18103"
exam_check 8 "m01-app-pod.service not active or missing m01-app.pod" bash -c "systemctl --user is-active --quiet m01-app-pod.service && test -f '${QDIR}/m01-app.pod'"
exam_check 7 "http://127.0.0.1:18103/healthz not returning 200 OK" bash -c "curl -fsS http://127.0.0.1:18103/healthz | grep -q '\"status\": *\"ok\"'"
exam_task_end

exam_task_begin "16" "Persisted note and exported m01-app-pod.yaml"
exam_check 8 "mock01-note-ok missing from /entries" bash -c "curl -fsS http://127.0.0.1:18103/entries | grep -q 'mock01-note-ok'"
exam_check 7 "m01-app-pod.yaml missing kind: Pod" grep -q "^kind: Pod$" "${WORK}/m01-app-pod.yaml"
exam_task_end

exam_task_begin "17" "Compose stack m01-pg + m01-api on port 18104"
exam_check 8 "m01-pg or m01-api container not running" bash -c "[[ \"\$(podman inspect --format '{{.State.Status}}' m01-pg 2>/dev/null)\" == 'running' && \"\$(podman inspect --format '{{.State.Status}}' m01-api 2>/dev/null)\" == 'running' ]]"
exam_check 7 "http://127.0.0.1:18104/api/v1/items not reachable" bash -c "curl -fsS http://127.0.0.1:18104/api/v1/items | grep -q 'RHEL-SUB-01'"
exam_task_end

exam_task_begin "18" "Troubleshoot exit 126 on m01-broken-126"
exam_check 10 "m01-broken-126 is not running" bash -c "[[ \"\$(podman inspect --format '{{.State.Status}}' m01-broken-126 2>/dev/null)\" == 'running' ]]"
exam_task_end

exam_task_begin "19" "Troubleshoot port mapping on m01-broken-port (18105)"
exam_check 10 "http://127.0.0.1:18105/ not responding 200" bash -c "curl -fsS http://127.0.0.1:18105/ | grep -qi 'nginx'"
exam_task_end

exam_task_begin "20" "Troubleshoot misplaced Quadlet m01-lost.service (18106)"
exam_check 10 "m01-lost.service not active or port 18106 unreachable" bash -c "systemctl --user is-active --quiet m01-lost.service && curl -fsS http://127.0.0.1:18106/ >/dev/null"
exam_task_end

exam_task_begin "21" "Troubleshoot OOM 137 on m01-oom-worker"
exam_check 10 "m01-oom-worker not running with OOM_FIXED" bash -c "[[ \"\$(podman inspect --format '{{.State.Status}}' m01-oom-worker 2>/dev/null)\" == 'running' ]] && podman logs m01-oom-worker | grep -q 'OOM_FIXED'"
exam_task_end

exam_task_begin "22" "Prune dangling images and save df.txt"
exam_check 5 "dangling images remain or df.txt missing" bash -c "[[ -z \"\$(podman images -f dangling=true -q)\" ]] && test -s '${WORK}/df.txt'"
exam_task_end

exam_grade_summary "mock-01"
