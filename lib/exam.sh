#!/usr/bin/env bash
# Mock Exam engine: 150-minute timer, hint/solution lock, 300-point grading (70% pass),
# and post-reboot persistence verification (`lab exam check-reboot`).

if [[ -n "${_EX188_EXAM_LOADED:-}" ]]; then
    return 0
fi
readonly _EX188_EXAM_LOADED=1

# shellcheck source=lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
# shellcheck source=lib/state.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/state.sh"
# shellcheck source=lib/grade.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/grade.sh"

EXAM_SESSION_FILE="${LAB_DATA_DIR}/exam_session.json"
EXAM_DURATION_SECS=9000   # 150 minutes
EXAM_PASS_SCORE=210       # 70% of 300 points

export EXAM_SESSION_FILE EXAM_DURATION_SECS EXAM_PASS_SCORE

exam_is_active() {
    [[ -f "${EXAM_SESSION_FILE}" ]] || return 1
    if command -v jq >/dev/null 2>&1; then
        [[ "$(jq -r '.active // false' "${EXAM_SESSION_FILE}" 2>/dev/null)" == "true" ]]
    else
        grep -q '"active":true' "${EXAM_SESSION_FILE}" 2>/dev/null
    fi
}

exam_assert_unlocked() {
    if exam_is_active; then
        local eid
        eid="$(jq -r '.exam_id' "${EXAM_SESSION_FILE}" 2>/dev/null || printf 'mock')"
        die "[EXAM LOCK] Hints and solutions are disabled while '${eid}' is active. Run 'lab exam grade' to finish or 'lab reset --all' to abort."
    fi
}

exam_resolve_dir() {
    local arg="$1"
    local padded
    if [[ "${arg}" =~ ^[0-9]+$ ]]; then
        padded="$(printf 'mock-%02d' "${arg}")"
    else
        padded="${arg}"
    fi
    if [[ -d "${LAB_EXAMS_DIR}/${padded}" ]]; then
        printf '%s\n' "${LAB_EXAMS_DIR}/${padded}"
        return 0
    fi
    return 1
}

exam_current_boot_id() {
    if [[ -r /proc/sys/kernel/random/boot_id ]]; then
        cat /proc/sys/kernel/random/boot_id
    else
        uptime -s 2>/dev/null || printf 'unknown-boot'
    fi
}

exam_start() {
    local num="$1"
    state_init
    state_require_jq

    local edir
    edir="$(exam_resolve_dir "${num}")" || die "Mock exam '${num}' not found under ${LAB_EXAMS_DIR} (available: 1..5)"
    local eid
    eid="$(basename "${edir}")"

    if exam_is_active; then
        local cur
        cur="$(jq -r '.exam_id' "${EXAM_SESSION_FILE}")"
        log_warn "Mock exam '${cur}' is already active. Resetting previous session before starting '${eid}'..."
        local prev_dir="${LAB_EXAMS_DIR}/${cur}"
        [[ -x "${prev_dir}/reset.sh" ]] && bash "${prev_dir}/reset.sh" || true
    fi

    log_header "Starting Full EX188 Mock Exam: ${eid} (300 Points | 150 Minutes)"
    log_info "Preparing live exam environment..."
    bash "${edir}/setup.sh"

    local now deadline boot_id
    now="$(date +%s)"
    deadline=$(( now + EXAM_DURATION_SECS ))
    boot_id="$(exam_current_boot_id)"

    jq -n \
        --arg eid "${eid}" \
        --arg edir "${edir}" \
        --arg boot "${boot_id}" \
        --argjson start "${now}" \
        --argjson dl "${deadline}" \
        '{
            active: true,
            exam_id: $eid,
            exam_dir: $edir,
            started_epoch: $start,
            deadline_epoch: $dl,
            boot_id_at_start: $boot,
            reboot_verified: false
        }' > "${EXAM_SESSION_FILE}"

    cp "${edir}/exam.md" "${LAB_DATA_DIR}/current-exam.md"
    printf '\n'
    cat "${edir}/exam.md"
    hr
    log_info "Exam brief saved to: ${LAB_DATA_DIR}/current-exam.md"
    log_info "Time limit: 150 minutes (passing score: 210 / 300 = 70%)"
    log_info "Hints and solutions are LOCKED until you run: lab exam grade"
    log_info "Before finishing, reboot the host and verify persistence with: lab exam check-reboot"
}

exam_status_banner() {
    exam_is_active || die "No mock exam is currently active. Start one with: lab exam <1..5>"
    local eid start dl now rem elapsed_m rem_m
    eid="$(jq -r '.exam_id' "${EXAM_SESSION_FILE}")"
    start="$(jq -r '.started_epoch' "${EXAM_SESSION_FILE}")"
    dl="$(jq -r '.deadline_epoch' "${EXAM_SESSION_FILE}")"
    now="$(date +%s)"
    elapsed_m=$(( (now - start) / 60 ))
    rem=$(( dl - now ))
    rem_m=$(( rem / 60 ))

    log_header "Mock Exam Session: ${eid}"
    if [[ "${rem}" -ge 0 ]]; then
        printf '  Elapsed: %d min | Remaining: %s%d min%s\n' "${elapsed_m}" "${C_GREEN}${C_BOLD}" "${rem_m}" "${C_RESET}"
    else
        printf '  Elapsed: %d min | %sOVERTIME by %d min%s\n' "${elapsed_m}" "${C_RED}${C_BOLD}" "$(( -rem_m ))" "${C_RESET}"
    fi
}

exam_grade() {
    exam_status_banner
    local eid edir
    eid="$(jq -r '.exam_id' "${EXAM_SESSION_FILE}")"
    edir="$(jq -r '.exam_dir' "${EXAM_SESSION_FILE}")"

    local rc=0
    bash "${edir}/grade.sh" || rc=$?

    # Unlock hints/solutions once official exam grading completes
    local tmp="${EXAM_SESSION_FILE}.tmp.$$"
    jq '.active = false | .graded_epoch = (now | floor)' "${EXAM_SESSION_FILE}" > "${tmp}" && mv "${tmp}" "${EXAM_SESSION_FILE}"
    log_info "Mock exam '${eid}' session closed. Hints and solutions are now unlocked."
    return "${rc}"
}

exam_check_reboot() {
    [[ -f "${EXAM_SESSION_FILE}" ]] || die "No mock exam session found. Start one with: lab exam <1..5>"
    local eid edir boot_before boot_now
    eid="$(jq -r '.exam_id' "${EXAM_SESSION_FILE}")"
    edir="$(jq -r '.exam_dir' "${EXAM_SESSION_FILE}")"
    boot_before="$(jq -r '.boot_id_at_start' "${EXAM_SESSION_FILE}")"
    boot_now="$(exam_current_boot_id)"

    log_header "Post-Reboot Persistence Check — ${eid}"
    if [[ "${boot_before}" == "${boot_now}" ]]; then
        log_warn "System boot ID has NOT changed since '${eid}' started (${boot_now})."
        log_warn "Running live service persistence checks now, but for a true exam test, run 'sudo systemctl reboot' and re-run 'lab exam check-reboot' immediately after login!"
    else
        log_ok "Confirmed fresh OS boot since exam start (${boot_before} -> ${boot_now})."
        local tmp="${EXAM_SESSION_FILE}.tmp.$$"
        jq '.reboot_verified = true' "${EXAM_SESSION_FILE}" > "${tmp}" && mv "${tmp}" "${EXAM_SESSION_FILE}"
    fi

    bash "${edir}/check-reboot.sh"
}
