#!/usr/bin/env bash
# Shared 300-point per-task grader for EX188 Full Mock Exams (mock-01 .. mock-05).

if [[ -n "${_EX188_EXAM_GRADE_HELPER_LOADED:-}" ]]; then
    return 0
fi
readonly _EX188_EXAM_GRADE_HELPER_LOADED=1

# shellcheck source=lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

EXAM_EARNED=0
EXAM_MAX=0
TASK_CUR_NUM=""
TASK_CUR_TITLE=""
TASK_CUR_EARNED=0
TASK_CUR_MAX=0
TASK_CUR_REASONS=()

exam_grade_init() {
    EXAM_EARNED=0
    EXAM_MAX=0
}

exam_task_begin() {
    TASK_CUR_NUM="$1"
    TASK_CUR_TITLE="$2"
    TASK_CUR_EARNED=0
    TASK_CUR_MAX=0
    TASK_CUR_REASONS=()
}

# exam_check <pts> <fail_reason> <cmd...>
exam_check() {
    local pts="$1"
    local reason="$2"
    shift 2
    TASK_CUR_MAX=$(( TASK_CUR_MAX + pts ))
    EXAM_MAX=$(( EXAM_MAX + pts ))
    if "$@" >/dev/null 2>&1; then
        TASK_CUR_EARNED=$(( TASK_CUR_EARNED + pts ))
        EXAM_EARNED=$(( EXAM_EARNED + pts ))
    else
        TASK_CUR_REASONS+=("${reason} (-${pts}pt)")
    fi
}

exam_task_end() {
    if [[ "${TASK_CUR_EARNED}" -eq "${TASK_CUR_MAX}" ]]; then
        printf '  %s[PASS %2d/%2d pts]%s Task %s — %s\n' \
            "${C_GREEN}${C_BOLD}" "${TASK_CUR_EARNED}" "${TASK_CUR_MAX}" "${C_RESET}" \
            "${TASK_CUR_NUM}" "${TASK_CUR_TITLE}"
    else
        printf '  %s[FAIL %2d/%2d pts]%s Task %s — %s\n' \
            "${C_RED}${C_BOLD}" "${TASK_CUR_EARNED}" "${TASK_CUR_MAX}" "${C_RESET}" \
            "${TASK_CUR_NUM}" "${TASK_CUR_TITLE}"
        local r
        for r in "${TASK_CUR_REASONS[@]}"; do
            printf '                   %s- %s%s\n' "${C_YELLOW}" "${r}" "${C_RESET}"
        done
    fi
}

# ---------------------------------------------------------------------------
# Short predicates used by generated mock-exam graders
# ---------------------------------------------------------------------------
ev()       { eval "$1"; }
running()  { [[ "$(podman inspect --format '{{.State.Status}}' "$1" 2>/dev/null)" == "running" ]]; }
uactive()  { systemctl --user is-active --quiet "$1"; }
sactive()  { run_privileged systemctl is-active --quiet "$1"; }
http()     { local i; for i in 1 2 3 4 5 6; do curl -fsS --max-time 5 "$1" 2>/dev/null | grep -Eq "$2" && return 0; sleep 0.5; done; return 1; }
wanted()   { grep -Eq "^[[:space:]]*WantedBy=$2([[:space:]]|$)" "$1" 2>/dev/null || run_privileged grep -Eq "^[[:space:]]*WantedBy=$2([[:space:]]|$)" "$1" 2>/dev/null; }
img_user() { [[ "$(podman image inspect --format '{{.Config.User}}' "$1" 2>/dev/null)" == "$2"* ]]; }
lingering() { [[ -f "/var/lib/systemd/linger/$(student_user)" ]]; }
fw() {
    local p
    for p in "$@"; do
        run_privileged firewall-cmd --query-port="${p}/tcp" >/dev/null 2>&1 || return 1
        run_privileged firewall-cmd --permanent --query-port="${p}/tcp" >/dev/null 2>&1 || return 1
    done
}
healthy() {
    podman healthcheck run "$1" >/dev/null 2>&1 || true
    [[ "$(podman inspect --format '{{.State.Health.Status}}' "$1" 2>/dev/null)" == "healthy" ]]
}
remote() {
    # remote <ref> : manifest exists in a lab registry (uses learner auth.json for :5444)
    local ref="$1"
    podman manifest inspect --authfile "$(student_home)/.config/containers/auth.json" "docker://${ref}" >/dev/null 2>&1 \
        || podman manifest inspect "docker://${ref}" >/dev/null 2>&1
}

exam_grade_summary() {
    local eid="$1"
    hr
    local pct=$(( (EXAM_EARNED * 100) / (EXAM_MAX > 0 ? EXAM_MAX : 300) ))
    if [[ "${EXAM_EARNED}" -ge 210 ]]; then
        printf '%sFINAL EXAM RESULT (%s): PASS%s — Score: %s%d / %d (%d%%)%s [Passing: 210 / 300 (70%%)]\n' \
            "${C_GREEN}${C_BOLD}" "${eid}" "${C_RESET}" "${C_BOLD}" "${EXAM_EARNED}" "${EXAM_MAX}" "${pct}" "${C_RESET}"
        return 0
    else
        printf '%sFINAL EXAM RESULT (%s): FAIL%s — Score: %s%d / %d (%d%%)%s [Passing: 210 / 300 (70%%)]\n' \
            "${C_RED}${C_BOLD}" "${eid}" "${C_RESET}" "${C_BOLD}" "${EXAM_EARNED}" "${EXAM_MAX}" "${pct}" "${C_RESET}"
        return 1
    fi
}

export -f ev running uactive sactive http wanted img_user lingering fw healthy remote
