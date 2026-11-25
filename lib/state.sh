#!/usr/bin/env bash
# Progress tracking (~/.lab/progress.json) and --seed parameter state management.

if [[ -n "${_EX188_STATE_LOADED:-}" ]]; then
    return 0
fi
readonly _EX188_STATE_LOADED=1

# shellcheck source=lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

LAB_PROGRESS_FILE="${LAB_DATA_DIR}/progress.json"
export LAB_PROGRESS_FILE

state_init() {
    ensure_lab_dirs
    if [[ ! -f "${LAB_PROGRESS_FILE}" ]]; then
        printf '{"version":1,"current_task":null,"tasks":{}}\n' > "${LAB_PROGRESS_FILE}"
    fi
}

state_require_jq() {
    command -v jq >/dev/null 2>&1 || die "jq is required. Run ./bootstrap.sh first."
}

state_set_current_task() {
    local task_id="$1"
    state_init
    state_require_jq
    local tmp="${LAB_PROGRESS_FILE}.tmp.$$"
    jq --arg tid "${task_id}" '
        .current_task = $tid |
        .tasks[$tid] = (.tasks[$tid] // {
            "status": "in_progress",
            "attempts": 0,
            "passes": 0,
            "failures": 0,
            "best_score": 0,
            "last_score": 0,
            "max_points": 0,
            "last_updated": ""
        }) |
        if .tasks[$tid].status == "not_started" then .tasks[$tid].status = "in_progress" else . end
    ' "${LAB_PROGRESS_FILE}" > "${tmp}" && mv "${tmp}" "${LAB_PROGRESS_FILE}"
}

state_record_grade() {
    local task_id="$1"
    local earned="$2"
    local max_pts="$3"
    local passed="$4" # 1 or 0
    state_init
    state_require_jq

    local status_str="failed"
    if [[ "${passed}" -eq 1 ]]; then
        status_str="passed"
    fi
    local ts
    ts="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    local tmp="${LAB_PROGRESS_FILE}.tmp.$$"

    jq --arg tid "${task_id}" \
       --arg st "${status_str}" \
       --arg ts "${ts}" \
       --argjson earned "${earned}" \
       --argjson maxp "${max_pts}" \
       --argjson ok "${passed}" '
        .tasks[$tid] = ((.tasks[$tid] // {
            "status": "not_started",
            "attempts": 0,
            "passes": 0,
            "failures": 0,
            "best_score": 0,
            "last_score": 0,
            "max_points": $maxp,
            "last_updated": $ts
        }) |
        .status = $st |
        .attempts = (.attempts + 1) |
        .passes = (.passes + (if $ok == 1 then 1 else 0 end)) |
        .failures = (.failures + (if $ok == 0 then 1 else 0 end)) |
        .last_score = $earned |
        .max_points = $maxp |
        .best_score = (if $earned > .best_score then $earned else .best_score end) |
        .last_updated = $ts)
    ' "${LAB_PROGRESS_FILE}" > "${tmp}" && mv "${tmp}" "${LAB_PROGRESS_FILE}"
}

state_get_task_status() {
    local task_id="$1"
    state_init
    if ! command -v jq >/dev/null 2>&1; then
        printf 'not_started\n'
        return 0
    fi
    jq -r --arg tid "${task_id}" '.tasks[$tid].status // "not_started"' "${LAB_PROGRESS_FILE}"
}

state_reset_task_active() {
    local task_id="$1"
    ensure_lab_dirs
    rm -f "${LAB_ACTIVE_DIR}/${task_id}.env"
}

# ---------------------------------------------------------------------------
# Deterministic --seed parameter generator for anti-memorization practice
# ---------------------------------------------------------------------------

task_env_file() {
    local task_id="$1"
    printf '%s/%s.env\n' "${LAB_ACTIVE_DIR}" "${task_id}"
}

# Initialize seed context inside setup.sh:
# If LAB_SEED is empty or "default", uses canonical task.md defaults.
# If LAB_SEED is "random", picks a fresh integer seed.
seed_init() {
    local task_id="$1"
    local seed_arg="${LAB_SEED:-}"
    ensure_lab_dirs
    local envf
    envf="$(task_env_file "${task_id}")"

    if [[ -z "${seed_arg}" || "${seed_arg}" == "default" ]]; then
        ACTIVE_SEED="default"
    elif [[ "${seed_arg}" == "random" ]]; then
        ACTIVE_SEED="$(( (RANDOM << 15 | RANDOM) % 900000 + 100000 ))"
    else
        # Hash arbitrary string to positive integer
        ACTIVE_SEED="$(printf '%s' "${seed_arg}" | cksum | awk '{print $1 % 900000 + 100000}')"
    fi
    export ACTIVE_SEED
    : > "${envf}"
    printf 'ACTIVE_SEED=%q\n' "${ACTIVE_SEED}" >> "${envf}"
}

# Compute deterministic offset from ACTIVE_SEED + variable salt
_seed_num() {
    local salt="$1"
    printf '%s:%s' "${ACTIVE_SEED:-default}" "${salt}" | cksum | awk '{print $1}'
}

# Pick default when ACTIVE_SEED=="default", otherwise pick deterministically from options
seed_var() {
    local task_id="$1"
    local var_name="$2"
    local default_val="$3"
    shift 3
    local options=("$@")
    local chosen="${default_val}"

    if [[ "${ACTIVE_SEED:-default}" != "default" && "${#options[@]}" -gt 0 ]]; then
        local idx
        idx="$(( $(_seed_num "${var_name}") % ${#options[@]} ))"
        chosen="${options[$idx]}"
    fi

    printf -v "${var_name}" '%s' "${chosen}"
    export "${var_name?}"
    printf '%s=%q\n' "${var_name}" "${chosen}" >> "$(task_env_file "${task_id}")"
}

# Pick default port when ACTIVE_SEED=="default", otherwise pick port in [min..max]
seed_port() {
    local task_id="$1"
    local var_name="$2"
    local default_port="$3"
    local min_port="${4:-18080}"
    local max_port="${5:-28999}"
    local chosen="${default_port}"

    if [[ "${ACTIVE_SEED:-default}" != "default" ]]; then
        local span="$(( max_port - min_port + 1 ))"
        chosen="$(( min_port + ($(_seed_num "${var_name}") % span) ))"
    fi

    printf -v "${var_name}" '%s' "${chosen}"
    export "${var_name?}"
    printf '%s=%q\n' "${var_name}" "${chosen}" >> "$(task_env_file "${task_id}")"
}

# Load previously generated parameters in grade.sh / reset.sh
seed_load() {
    local task_id="$1"
    local envf
    envf="$(task_env_file "${task_id}")"
    if [[ -f "${envf}" ]]; then
        # shellcheck disable=SC1090
        source "${envf}"
    fi
}

seed_print_overrides() {
    local task_id="$1"
    local envf
    envf="$(task_env_file "${task_id}")"
    [[ -f "${envf}" ]] || return 0
    if grep -q '^ACTIVE_SEED=default$' "${envf}" 2>/dev/null; then
        return 0
    fi
    printf '\n%s[SEED ACTIVE]%s Randomized parameters for this attempt (override defaults in task text):\n' "${C_MAGENTA}${C_BOLD}" "${C_RESET}"
    while IFS= read -r line; do
        [[ -z "${line}" || "${line}" == ACTIVE_SEED=* ]] && continue
        printf '  - %s%s%s\n' "${C_BOLD}" "${line}" "${C_RESET}"
    done < "${envf}"
}
