#!/usr/bin/env bash
set -uo pipefail
EXAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${EXAM_DIR}/../../lib/common.sh"
source "${EXAM_DIR}/../../lib/exam_grade_helper.sh"
SHOME="$(student_home)"
WORK="${SHOME}/workspace/m05"
QDIR="${SHOME}/.config/containers/systemd"
exam_grade_init

exam_task_begin "01" 'Registry trust and insecure HTTP registry'
exam_check 4 'CA missing for :5443' ev 'test -f /etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt'
exam_check 3 'CA missing for :5444' ev 'test -f /etc/containers/certs.d/auth-reg.lab.local:5444/ca.crt'
exam_check 3 '50-m05.conf missing insecure :5000' ev 'grep -q registry.lab.local:5000 /etc/containers/registries.conf.d/50-m05.conf && grep -Eq '"'"'insecure *= *true'"'"' /etc/containers/registries.conf.d/50-m05.conf'
exam_task_end

exam_task_begin "02" 'Persistent login'
exam_check 10 'auth.json lacks :5444' ev 'grep -q auth-reg.lab.local:5444 "${SHOME}/.config/containers/auth.json"'
exam_task_end

exam_task_begin "03" 'Registry mirror'
exam_check 5 'mirror drop-in missing' ev 'grep -q registry.mirror /etc/containers/registries.conf.d/60-m05-mirror.conf'
exam_check 5 'mirror pull did not happen' ev 'podman image exists mirror-m05.corp.local/m05/core:1.0'
exam_task_end

exam_task_begin "04" 'Offline transports'
exam_check 5 'm05-fromdir:1.0 missing' ev 'podman image exists localhost/m05-fromdir:1.0'
exam_check 5 'm05-fromoci:1.0 missing' ev 'podman image exists localhost/m05-fromoci:1.0'
exam_task_end

exam_task_begin "05" 'Web image with healthcheck'
exam_check 5 'm05-web:1.0 missing/not 1001' ev 'img_user localhost/m05-web:1.0 1001'
exam_check 10 'healthcheck not stored in image (use --format docker)' ev 'podman image inspect --format '"'"'{{json .Config.Healthcheck}}'"'"' localhost/m05-web:1.0 | grep -q Test'
exam_task_end

exam_task_begin "06" 'Worker with ENTRYPOINT + CMD'
exam_check 7 'ENTRYPOINT/CMD not in exec form' ev 'podman image inspect --format '"'"'{{json .Config.Entrypoint}}{{json .Config.Cmd}}'"'"' localhost/m05-worker:1.0 | grep -q worker.py && podman image inspect --format '"'"'{{json .Config.Cmd}}'"'"' localhost/m05-worker:1.0 | grep -q M05'
exam_check 8 'worker image not USER 1001' ev 'img_user localhost/m05-worker:1.0 1001'
exam_task_end

exam_task_begin "07" 'Multi-stage Go image'
exam_check 7 'm05-metrics:1.0 missing/not 1001' ev 'img_user localhost/m05-metrics:1.0 1001'
exam_check 8 'Go toolchain in runtime image' ev '! podman run --rm --entrypoint sh localhost/m05-metrics:1.0 -c '"'"'command -v go'"'"''
exam_task_end

exam_task_begin "08" 'Push images'
exam_check 3 'm05/web missing' ev 'remote auth-reg.lab.local:5444/m05/web:1.0'
exam_check 2 'm05/worker missing' ev 'remote auth-reg.lab.local:5444/m05/worker:1.0'
exam_check 2 'm05/metrics missing in :5444' ev 'remote auth-reg.lab.local:5444/m05/metrics:1.0'
exam_check 3 'm05/metrics missing in :5443' ev 'remote secure-reg.lab.local:5443/m05/metrics:1.0'
exam_task_end

exam_task_begin "09" 'Flatten with export/import'
exam_check 4 'm05-flat:1.0 has more than one layer' ev '[[ "$(podman image inspect --format '"'"'{{len .RootFS.Layers}}'"'"' localhost/m05-flat:1.0)" == 1 ]]'
exam_check 6 'm05-flat:1.0 does not print the stamp as USER 1001' ev 'img_user localhost/m05-flat:1.0 1001 && [[ "$(podman run --rm localhost/m05-flat:1.0)" == stamp-m05 ]]'
exam_task_end

exam_task_begin "10" 'OCI archive'
exam_check 10 'not an OCI archive' ev 'tar -tf "${WORK}/metrics-oci.tar" | grep -qx oci-layout'
exam_task_end

exam_task_begin "11" 'Commit a container'
exam_check 10 'committed image lacks ENV or file content' ev 'podman run --rm --entrypoint env localhost/m05-hotfix:1.1 | grep -qx HOTFIX=1.1 && podman run --rm localhost/m05-hotfix:1.1 grep -q PATCHED=yes /etc/hotfix.conf'
exam_task_end

exam_task_begin "12" 'Rootful system Quadlet'
exam_check 8 'm05-sys-metrics.service not active' ev 'sactive m05-sys-metrics.service'
exam_check 4 'missing WantedBy=multi-user.target' ev 'wanted /etc/containers/systemd/m05-sys-metrics.container multi-user.target'
exam_check 3 'metrics not answering on 18501' ev 'http http://127.0.0.1:18501/metrics m05-sys'
exam_task_end

exam_task_begin "13" 'Persistent low-port sysctl'
exam_check 6 'sysctl drop-in missing or live value too high' ev 'grep -Eq '"'"'ip_unprivileged_port_start *= *780'"'"' /etc/sysctl.d/90-m05-lowport.conf && (( $(sysctl -n net.ipv4.ip_unprivileged_port_start) <= 780 ))'
exam_check 4 '790/tcp not open' ev 'fw 790'
exam_task_end

exam_task_begin "14" 'Rootless Quadlet on a privileged port'
exam_check 15 'm05-edge not active/persistent or 790 unreachable' ev 'uactive m05-edge.service && wanted "${QDIR}/m05-edge.container" default.target && http http://127.0.0.1:790/ nginx'
exam_task_end

exam_task_begin "15" 'Web Quadlet with secret, volume and env file'
exam_check 4 'secret missing' ev 'podman secret exists m05_web_sec'
exam_check 5 'm05-web.service not active/persistent' ev 'uactive m05-web.service && wanted "${QDIR}/m05-web.container" default.target'
exam_check 6 'secret not loaded from file' ev 'http http://127.0.0.1:18502/ '"'"'secret_source.: *.file.'"'"''
exam_task_end

exam_task_begin "16" 'Prove persistence across restart'
exam_check 10 'note lost after restart' ev 'http http://127.0.0.1:18502/entries m05-persist'
exam_task_end

exam_task_begin "17" 'Quadlet pod'
exam_check 8 'm05-pod-pod.service not active' ev 'uactive m05-pod-pod.service'
exam_check 4 'pod unit lacks WantedBy' ev 'wanted "${QDIR}/m05-pod.pod" default.target'
exam_check 8 'pod web not reachable/healthy' ev 'running m05-pod-web && http http://127.0.0.1:18503/healthz '"'"'reachable.: *true'"'"''
exam_task_end

exam_task_begin "18" 'Compose (the only compose task)'
exam_check 5 'm05-cpg not running' ev 'running m05-cpg'
exam_check 5 'm05-capi not running' ev 'running m05-capi'
exam_check 5 'API not answering on 18504' ev 'http http://127.0.0.1:18504/api/v1/items RHEL-SUB-01'
exam_task_end

exam_task_begin "19" 'Export the pod'
exam_check 10 'pod.yaml not a Pod manifest' ev 'grep -q "^kind: Pod$" "${WORK}/pod.yaml" && grep -q m05 "${WORK}/pod.yaml"'
exam_task_end

exam_task_begin "20" 'Firewall and linger'
exam_check 6 'firewalld rules missing' ev 'fw 18501 18502 18503 18504'
exam_check 4 'linger not enabled' ev lingering
exam_task_end

exam_task_begin "21" 'Troubleshoot: exit 126'
exam_check 10 'm05-ts-126 not running' ev 'running m05-ts-126'
exam_task_end

exam_task_begin "22" 'Troubleshoot: isolated network'
exam_check 15 'healthz not reachable' ev 'http http://127.0.0.1:18507/healthz '"'"'reachable.: *true'"'"''
exam_task_end

exam_task_begin "23" 'Troubleshoot: Quadlet will not survive reboot'
exam_check 10 'm05-ts-persist lacks WantedBy=default.target' ev 'uactive m05-ts-persist.service && wanted "${QDIR}/m05-ts-persist.container" default.target'
exam_task_end

exam_task_begin "24" 'Troubleshoot: unhealthy'
exam_check 10 'm05-ts-hc not healthy' ev 'healthy m05-ts-hc'
exam_task_end

exam_task_begin "25" 'Inventory report'
exam_check 4 'POD_INFRA wrong' ev 'grep -qx "POD_INFRA=$(podman pod inspect --format "{{.InfraContainerID}}" m05-audit-pod)" "${WORK}/inventory.env"'
exam_check 3 'NET_SUBNET wrong' ev 'grep -qx "NET_SUBNET=10.89.95.0/24" "${WORK}/inventory.env"'
exam_check 3 'SECRET_ID wrong' ev 'grep -qx "SECRET_ID=$(podman secret inspect --format "{{.ID}}" m05-audit-sec)" "${WORK}/inventory.env"'
exam_task_end

exam_grade_summary "mock-05"
