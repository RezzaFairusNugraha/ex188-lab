#!/usr/bin/env bash
set -uo pipefail
EXAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${EXAM_DIR}/../../lib/common.sh"
source "${EXAM_DIR}/../../lib/exam_grade_helper.sh"
SHOME="$(student_home)"
WORK="${SHOME}/workspace/m03"
QDIR="${SHOME}/.config/containers/systemd"
exam_grade_init

exam_task_begin "01" 'Registry trust and insecure HTTP registry'
exam_check 4 'CA not installed for secure-reg.lab.local:5443' ev 'test -f /etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt'
exam_check 3 'CA not installed for auth-reg.lab.local:5444' ev 'test -f /etc/containers/certs.d/auth-reg.lab.local:5444/ca.crt'
exam_check 3 '50-m03.conf does not mark registry.lab.local:5000 insecure' ev 'grep -q registry.lab.local:5000 /etc/containers/registries.conf.d/50-m03.conf && grep -Eq '"'"'insecure *= *true'"'"' /etc/containers/registries.conf.d/50-m03.conf'
exam_task_end

exam_task_begin "02" 'Persistent registry login'
exam_check 10 'auth.json has no credentials for auth-reg.lab.local:5444' ev 'grep -q auth-reg.lab.local:5444 "${SHOME}/.config/containers/auth.json"'
exam_task_end

exam_task_begin "03" 'Registry mirror'
exam_check 8 '60-m03-mirror.conf has no [[registry.mirror]] to secure-reg.lab.local:5443' ev 'grep -q '"'"'registry.mirror'"'"' /etc/containers/registries.conf.d/60-m03-mirror.conf && grep -q secure-reg.lab.local:5443 /etc/containers/registries.conf.d/60-m03-mirror.conf'
exam_check 7 'mirror-hub.corp.local/m03/base:1.0 not present locally' ev 'podman image exists mirror-hub.corp.local/m03/base:1.0'
exam_task_end

exam_task_begin "04" 'Pin an image by digest'
exam_check 7 'digest-ref.txt does not contain a valid @sha256 reference' ev 'grep -Eq "^secure-reg.lab.local:5443/m03/base@sha256:[0-9a-f]{64}$" "${WORK}/digest-ref.txt"'
exam_check 8 'm03-pinned is not running from an @sha256 reference' ev 'running m03-pinned && podman inspect --format '"'"'{{.ImageName}}'"'"' m03-pinned | grep -q @sha256:'
exam_task_end

exam_task_begin "05" 'Multi-tag promotion'
exam_check 4 'tag 1.0 missing in :5444' ev 'remote auth-reg.lab.local:5444/m03/base:1.0'
exam_check 3 'tag 1 missing in :5444' ev 'remote auth-reg.lab.local:5444/m03/base:1'
exam_check 3 'tag latest missing in :5444' ev 'remote auth-reg.lab.local:5444/m03/base:latest'
exam_task_end

exam_task_begin "06" 'Audit tags with curl'
exam_check 10 'tags.json does not list the pushed tags' ev 'grep -q latest "${WORK}/tags.json" && grep -q '"'"'"1"'"'"' "${WORK}/tags.json"'
exam_task_end

exam_task_begin "07" 'Non-root web image'
exam_check 5 'm03-web:1.0 missing' ev 'podman image exists localhost/m03-web:1.0'
exam_check 5 'm03-web:1.0 does not run as 1001' ev 'img_user localhost/m03-web:1.0 1001'
exam_check 5 'data dir not writable by UID 42420 GID 0' ev 'podman run --rm --user 42420:0 --entrypoint test localhost/m03-web:1.0 -w /var/lib/webapp/data'
exam_task_end

exam_task_begin "08" 'Multi-stage Go image'
exam_check 6 'm03-metrics:1.0 missing or not USER 1001' ev 'img_user localhost/m03-metrics:1.0 1001'
exam_check 7 'Go toolchain found in runtime image' ev '! podman run --rm --entrypoint sh localhost/m03-metrics:1.0 -c '"'"'command -v go'"'"''
exam_check 7 'metrics binary does not start' ev 'podman run --rm -d --name m03-probe -p 18399:9090 localhost/m03-metrics:1.0 >/dev/null && sleep 1 && http http://127.0.0.1:18399/healthz ok; r=$?; podman rm -f m03-probe >/dev/null 2>&1; [[ $r -eq 0 ]]'
exam_task_end

exam_task_begin "09" 'Push application images'
exam_check 5 'm03/web:1.0 missing in :5444' ev 'remote auth-reg.lab.local:5444/m03/web:1.0'
exam_check 5 'm03/metrics:1.0 missing in :5444' ev 'remote auth-reg.lab.local:5444/m03/metrics:1.0'
exam_task_end

exam_task_begin "10" 'Bundle images'
exam_check 10 'bundle.tar does not reference both images' ev 'tar -xOf "${WORK}/bundle.tar" manifest.json | grep -q m03-web && tar -xOf "${WORK}/bundle.tar" manifest.json | grep -q m03-metrics'
exam_task_end

exam_task_begin "11" 'Commit a hotfixed container'
exam_check 5 'm03-hotfix:1.1 missing Author/ENV' ev '[[ "$(podman image inspect --format '"'"'{{.Author}}'"'"' localhost/m03-hotfix:1.1)" == student@lab.local ]] && podman run --rm --entrypoint env localhost/m03-hotfix:1.1 | grep -qx HOTFIX_APPLIED=1.1'
exam_check 5 'committed image lost the PATCHED=yes line' ev 'podman run --rm localhost/m03-hotfix:1.1 grep -q PATCHED=yes /etc/hotfix.conf'
exam_task_end

exam_task_begin "12" 'Kubernetes YAML with ConfigMap and PVC'
exam_check 5 'volume m03-pvc not created' ev 'podman volume exists m03-pvc'
exam_check 5 'pod m03-kpod is not Running' ev '[[ "$(podman pod inspect --format '"'"'{{.State}}'"'"' m03-kpod)" == Running ]]'
exam_check 10 'http://127.0.0.1:18301/ does not show M03 Kube' ev 'http http://127.0.0.1:18301/ '"'"'M03 Kube'"'"''
exam_task_end

exam_task_begin "13" 'Persist the kube workload with Quadlet .kube'
exam_check 5 'm03-kube.service not active' ev 'uactive m03-kube.service'
exam_check 5 '.kube file lacks WantedBy=default.target' ev 'wanted "${QDIR}/m03-kube.kube" default.target'
exam_check 5 'workload not answering on 18301' ev 'http http://127.0.0.1:18301/healthz '"'"'"status": *"ok"'"'"''
exam_task_end

exam_task_begin "14" 'Quadlet pod'
exam_check 7 'm03-app-pod.service not active' ev 'uactive m03-app-pod.service'
exam_check 5 'pod unit lacks WantedBy=default.target' ev 'wanted "${QDIR}/m03-app.pod" default.target'
exam_check 8 'm03-app-web not healthy on 18302' ev 'running m03-app-web && http http://127.0.0.1:18302/healthz '"'"'reachable.: *true'"'"''
exam_task_end

exam_task_begin "15" 'Quadlet API with secret and volume'
exam_check 5 'secret m03_tok missing' ev 'podman secret exists m03_tok'
exam_check 5 'm03-api.service not active' ev 'uactive m03-api.service'
exam_check 5 'm03-audit.volume missing' ev 'test -f "${QDIR}/m03-audit.volume"'
exam_check 5 'secret value leaked into Config.Env' ev '! podman inspect m03-api | grep -q M03Token_77'
exam_task_end

exam_task_begin "16" 'Authenticated audit write'
exam_check 10 'audit.log missing on volume m03-audit' ev 'mp=$(podman volume inspect --format "{{.Mountpoint}}" m03-audit 2>/dev/null || podman volume inspect --format "{{.Mountpoint}}" systemd-m03-audit 2>/dev/null) && [[ -n "$mp" ]] && podman unshare test -s "$mp/audit.log"'
exam_task_end

exam_task_begin "17" 'Firewall and linger'
exam_check 6 'firewalld missing a permanent/runtime rule' ev 'fw 18301 18302 18303'
exam_check 4 'linger not enabled' ev lingering
exam_task_end

exam_task_begin "18" 'Capture events'
exam_check 15 'events.log has no start event of m03-api' ev 'grep -q "^start m03-api$" "${WORK}/events.log"'
exam_task_end

exam_task_begin "19" 'Inspect report'
exam_check 3 'API_USER wrong' ev 'grep -qx "API_USER=$(podman inspect --format "{{.Config.User}}" m03-api)" "${WORK}/report.env"'
exam_check 3 'AUDIT_MP wrong' ev 'mp=$(podman volume inspect --format "{{.Mountpoint}}" m03-audit 2>/dev/null || podman volume inspect --format "{{.Mountpoint}}" systemd-m03-audit 2>/dev/null) && grep -qx "AUDIT_MP=${mp}" "${WORK}/report.env"'
exam_check 4 'KPOD_INFRA wrong' ev 'pid=$(podman pod inspect --format "{{.InfraContainerID}}" m03-app 2>/dev/null || podman pod inspect --format "{{.InfraContainerID}}" systemd-m03-app 2>/dev/null) && grep -qx "KPOD_INFRA=${pid}" "${WORK}/report.env"'
exam_task_end

exam_task_begin "20" 'Troubleshoot: exit 127'
exam_check 10 'm03-ts-127 not running' ev 'running m03-ts-127'
exam_task_end

exam_task_begin "21" 'Troubleshoot: SELinux + UID on bind mount'
exam_check 5 'healthz does not report writable storage' ev 'http http://127.0.0.1:18306/healthz writable'
exam_check 5 'se-data is mode 777 or SELinux label missing' ev '[[ "$(stat -c %a "${WORK}/se-data")" != 777 ]] && stat -c %C "${WORK}/se-data" | grep -q container_file_t'
exam_task_end

exam_task_begin "22" 'Troubleshoot: unhealthy container'
exam_check 10 'm03-ts-hc is not healthy' ev 'healthy m03-ts-hc'
exam_task_end

exam_task_begin "23" 'Troubleshoot: stale objects block deployment'
exam_check 5 'stale network still present' ev '! podman network exists m03-ts-stale'
exam_check 5 'm03-ts-keeper was stopped' ev 'running m03-ts-keeper'
exam_check 5 'http://127.0.0.1:18308/healthz not OK' ev 'http http://127.0.0.1:18308/healthz '"'"'reachable.: *true'"'"''
exam_task_end

exam_grade_summary "mock-03"
