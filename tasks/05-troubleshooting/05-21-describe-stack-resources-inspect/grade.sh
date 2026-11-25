#!/usr/bin/env bash
set -uo pipefail
TASK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${TASK_DIR}/../../../lib/common.sh"
source "${TASK_DIR}/../../../lib/grade.sh"

grade_init "05-21"
OUT="$(student_home)/workspace/05-21/resource-inventory.env"

EXP_INFRA="$(podman pod inspect --format '{{.InfraContainerID}}' audit-pod-0521)"
EXP_VOL="$(podman volume inspect --format '{{.Mountpoint}}' audit-vol-0521)"
EXP_SEC="$(podman secret inspect --format '{{.ID}}' audit-sec-0521)"

assert_file_contains 3 "${OUT}" "^POD_INFRA_ID=${EXP_INFRA}$" "POD_INFRA_ID matches podman pod inspect"
assert_file_contains 3 "${OUT}" "^NET_SUBNET=10\.89\.91\.0/24$" "NET_SUBNET matches podman network inspect"
assert_file_contains 3 "${OUT}" "^VOL_MOUNTPOINT=${EXP_VOL}$" "VOL_MOUNTPOINT matches podman volume inspect"
assert_file_contains 3 "${OUT}" "^SECRET_ID=${EXP_SEC}$" "SECRET_ID matches podman secret inspect"
assert_file_contains 3 "${OUT}" "^APP_USER=1009:1009$" "APP_USER matches podman container inspect"

grade_finish
