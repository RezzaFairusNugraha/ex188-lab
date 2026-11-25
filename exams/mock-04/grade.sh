#!/usr/bin/env bash
set -uo pipefail
EXAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${EXAM_DIR}/../../lib/common.sh"
source "${EXAM_DIR}/../../lib/exam_grade_helper.sh"
SHOME="$(student_home)"
WORK="${SHOME}/workspace/m04"
QDIR="${SHOME}/.config/containers/systemd"
exam_grade_init

exam_task_begin "01" 'Registry trust and insecure HTTP registry'
exam_check 4 'CA missing for :5443' ev 'test -f /etc/containers/certs.d/secure-reg.lab.local:5443/ca.crt'
exam_check 3 'CA missing for :5444' ev 'test -f /etc/containers/certs.d/auth-reg.lab.local:5444/ca.crt'
exam_check 3 '50-m04.conf does not mark :5000 insecure' ev 'grep -q registry.lab.local:5000 /etc/containers/registries.conf.d/50-m04.conf && grep -Eq '"'"'insecure *= *true'"'"' /etc/containers/registries.conf.d/50-m04.conf'
exam_task_end

exam_task_begin "02" 'Persistent login'
exam_check 10 'auth.json lacks :5444 credentials' ev 'grep -q auth-reg.lab.local:5444 "${SHOME}/.config/containers/auth.json"'
exam_task_end

exam_task_begin "03" 'List remote tags'
exam_check 10 'tags.txt lacks tag 2.0' ev 'grep -q "2.0" "${WORK}/tags.txt"'
exam_task_end

exam_task_begin "04" 'Promote between registries'
exam_check 10 'm04/tool:2.0 missing in :5443' ev 'remote secure-reg.lab.local:5443/m04/tool:2.0'
exam_task_end

exam_task_begin "05" 'Build the voting images'
exam_check 10 'm04-vote-api:1.0 missing/not 1001' ev 'img_user localhost/m04-vote-api:1.0 1001'
exam_check 10 'm04-vote-ui:1.0 missing/not 1001' ev 'img_user localhost/m04-vote-ui:1.0 1001'
exam_task_end

exam_task_begin "06" 'Build-time secret'
exam_check 7 '/etc/bkey.sha256 missing' ev 'podman run --rm localhost/m04-secret-build:1.0 test -s /etc/bkey.sha256'
exam_check 8 'raw build key leaked into history' ev '! podman history --no-trunc localhost/m04-secret-build:1.0 | grep -q M04_BuildKey'
exam_task_end

exam_task_begin "07" 'Push voting images'
exam_check 5 'vote-api not in :5444' ev 'remote auth-reg.lab.local:5444/m04/vote-api:1.0'
exam_check 5 'vote-ui not in :5444' ev 'remote auth-reg.lab.local:5444/m04/vote-ui:1.0'
exam_task_end

exam_task_begin "08" 'Create the database secret'
exam_check 10 'secret missing or value has trailing newline' ev '[[ "$(podman secret inspect --showsecret --format "{{.SecretData}}" m04_db_pass 2>/dev/null)" == M04DbPass_55 ]]'
exam_task_end

exam_task_begin "09" 'Compose deployment (the only compose task)'
exam_check 3 'm04-db not running' ev 'running m04-db'
exam_check 3 'm04-cache not running' ev 'running m04-cache'
exam_check 3 'm04-api not running' ev 'running m04-api'
exam_check 3 'm04-ui not running' ev 'running m04-ui'
exam_check 8 'UI health does not show db_reachable true' ev 'http http://127.0.0.1:18401/healthz '"'"'db_reachable.: *true'"'"''
exam_check 10 'only the UI should publish a host port' ev '[[ -z "$(podman port m04-db)" && -z "$(podman port m04-api)" ]]'
exam_task_end

exam_task_begin "10" 'Bring compose down but keep data'
exam_check 10 'containers still present or volumes were deleted' ev '! podman container exists m04-ui && podman volume ls -q | grep -q .'
exam_task_end

exam_task_begin "11" 'Quadlet three-tier stack'
exam_check 5 'network/volume Quadlet files missing' ev 'test -f "${QDIR}/m04-q.network" && ls "${QDIR}"/*.volume >/dev/null 2>&1'
exam_check 5 'm04-q-db.service not active' ev 'uactive m04-q-db.service'
exam_check 5 'm04-q-cache.service not active' ev 'uactive m04-q-cache.service'
exam_check 5 'm04-q-api.service not active or secret not mounted' ev 'uactive m04-q-api.service && podman exec m04-q-api test -s /run/secrets/db_password'
exam_check 5 'm04-q-ui.service not active/persistent' ev 'uactive m04-q-ui.service && wanted "${QDIR}/m04-q-ui.container" default.target'
exam_check 5 'stack not healthy on 18402' ev 'http http://127.0.0.1:18402/healthz '"'"'secret_loaded.: *true'"'"''
exam_task_end

exam_task_begin "12" 'Export the API definition'
exam_check 10 'api-export.yaml is not a Pod manifest' ev 'grep -q "^kind: Pod$" "${WORK}/api-export.yaml" && grep -q vote-api "${WORK}/api-export.yaml"'
exam_task_end

exam_task_begin "13" 'Firewall and linger'
exam_check 6 'firewalld rules missing' ev 'fw 18401 18402'
exam_check 4 'linger not enabled' ev lingering
exam_task_end

exam_task_begin "14" 'Lifecycle events'
exam_check 10 'ui-events.log has no start event' ev 'grep -q "^start m04-q-ui$" "${WORK}/ui-events.log"'
exam_task_end

exam_task_begin "15" 'Copy a file out of a running container'
exam_check 15 'ui-app.py missing' ev 'grep -q VoteUIHandler "${WORK}/ui-app.py"'
exam_task_end

exam_task_begin "16" 'Inspect report'
exam_check 5 'UI_USER wrong' ev 'grep -qx "UI_USER=$(podman inspect --format "{{.Config.User}}" m04-q-ui)" "${WORK}/inspect.env"'
exam_check 10 'API_DB_HOST wrong' ev 'grep -qx "API_DB_HOST=m04-q-db" "${WORK}/inspect.env"'
exam_task_end

exam_task_begin "17" 'Troubleshoot: UID mismatch'
exam_check 15 'POST /entries does not succeed' ev '[[ "$(curl -s -o /dev/null -w '"'"'%{http_code}'"'"' -X POST '"'"'http://127.0.0.1:18405/entries?msg=m04'"'"')" == 201 ]]'
exam_task_end

exam_task_begin "18" 'Troubleshoot: DNS/network'
exam_check 15 'healthz does not report reachable' ev 'http http://127.0.0.1:18406/healthz '"'"'reachable.: *true'"'"''
exam_task_end

exam_task_begin "19" 'Troubleshoot: Quadlet not found'
exam_check 15 'm04-ts-lost.service not active/persistent or 18407 down' ev 'uactive m04-ts-lost.service && http http://127.0.0.1:18407/ nginx && ls "${QDIR}"/m04-ts-lost.container >/dev/null'
exam_task_end

exam_task_begin "20" 'Troubleshoot: OOM kill'
exam_check 15 'm04-ts-oom not running with 128m' ev 'running m04-ts-oom && [[ "$(podman inspect --format '"'"'{{.HostConfig.Memory}}'"'"' m04-ts-oom)" == 134217728 ]]'
exam_task_end

exam_task_begin "21" 'Troubleshoot: wrong tag and short name'
exam_check 15 'm04-ts-deploy not running from a qualified image' ev 'running m04-ts-deploy && podman inspect --format '"'"'{{.ImageName}}'"'"' m04-ts-deploy | grep -q registry.lab.local:5000/'
exam_task_end

exam_grade_summary "mock-04"
