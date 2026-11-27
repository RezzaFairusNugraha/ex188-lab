#!/usr/bin/env bash
# Deterministic final-state grading assertions for Podman v5, systemd/Quadlet,
# registries, SELinux, firewalld, and HTTP services. Supports partial credit.

if [[ -n "${_EX188_GRADE_LOADED:-}" ]]; then
    return 0
fi
readonly _EX188_GRADE_LOADED=1

# shellcheck source=lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
# shellcheck source=lib/state.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/state.sh"

GRADE_TASK_ID=""
GRADE_EARNED=0
GRADE_TOTAL=0
GRADE_CHECKS_PASSED=0
GRADE_CHECKS_FAILED=0

grade_init() {
    GRADE_TASK_ID="$1"
    GRADE_EARNED=0
    GRADE_TOTAL=0
    GRADE_CHECKS_PASSED=0
    GRADE_CHECKS_FAILED=0
    seed_load "${GRADE_TASK_ID}"
    if [[ "${LAB_QUIET_HEADER:-0}" != "1" ]]; then
        log_header "Grading Task ${GRADE_TASK_ID}"
    fi
}

pass_check() {
    local pts="$1"
    local desc="$2"
    GRADE_TOTAL=$(( GRADE_TOTAL + pts ))
    GRADE_EARNED=$(( GRADE_EARNED + pts ))
    GRADE_CHECKS_PASSED=$(( GRADE_CHECKS_PASSED + 1 ))
    printf '  %s[PASS +%2spt]%s %s\n' "${C_GREEN}${C_BOLD}" "${pts}" "${C_RESET}" "${desc}"
}

fail_check() {
    local pts="$1"
    local desc="$2"
    local reason="${3:-check failed}"
    GRADE_TOTAL=$(( GRADE_TOTAL + pts ))
    GRADE_CHECKS_FAILED=$(( GRADE_CHECKS_FAILED + 1 ))
    printf '  %s[FAIL  0/%2spt]%s %s\n' "${C_RED}${C_BOLD}" "${pts}" "${C_RESET}" "${desc}"
    printf '               %sReason:%s %s\n' "${C_YELLOW}" "${C_RESET}" "${reason}"
}

# Generic command check: check_cmd <pts> <desc> <fail_reason> <cmd...>
check_cmd() {
    local pts="$1"
    local desc="$2"
    local reason="$3"
    shift 3
    if "$@" >/dev/null 2>&1; then
        pass_check "${pts}" "${desc}"
    else
        fail_check "${pts}" "${desc}" "${reason}"
    fi
}

# ---------------------------------------------------------------------------
# Filesystem & SELinux assertions
# ---------------------------------------------------------------------------

assert_file_exists() {
    local pts="$1" path="$2" desc="${3:-File ${2} exists}"
    if [[ -f "${path}" ]]; then
        pass_check "${pts}" "${desc}"
    else
        fail_check "${pts}" "${desc}" "file '${path}' was not found"
    fi
}

assert_dir_exists() {
    local pts="$1" path="$2" desc="${3:-Directory ${2} exists}"
    if [[ -d "${path}" ]]; then
        pass_check "${pts}" "${desc}"
    else
        fail_check "${pts}" "${desc}" "directory '${path}' was not found"
    fi
}

assert_file_contains() {
    local pts="$1" path="$2" regex="$3" desc="${4:-${2} matches required pattern}"
    if [[ ! -f "${path}" ]]; then
        fail_check "${pts}" "${desc}" "file '${path}' does not exist"
        return
    fi
    if grep -Eq "${regex}" "${path}"; then
        pass_check "${pts}" "${desc}"
    else
        fail_check "${pts}" "${desc}" "file '${path}' does not match expected configuration (${regex})"
    fi
}

assert_file_not_contains() {
    local pts="$1" path="$2" regex="$3" desc="${4:-${2} omits prohibited pattern}"
    if [[ ! -f "${path}" ]]; then
        fail_check "${pts}" "${desc}" "file '${path}' does not exist"
        return
    fi
    if ! grep -Eq "${regex}" "${path}"; then
        pass_check "${pts}" "${desc}"
    else
        fail_check "${pts}" "${desc}" "file '${path}' still contains prohibited pattern (${regex})"
    fi
}

assert_selinux_type() {
    local pts="$1" path="$2" expected_type="$3" desc="${4:-SELinux type on ${2} is ${3}}"
    if [[ ! -e "${path}" ]]; then
        fail_check "${pts}" "${desc}" "path '${path}' does not exist"
        return
    fi
    local ctx
    ctx="$(stat -c '%C' "${path}" 2>/dev/null || ls -dZ "${path}" 2>/dev/null | awk '{print $1}')"
    if [[ "${ctx}" == *":${expected_type}:"* ]]; then
        pass_check "${pts}" "${desc}"
    else
        fail_check "${pts}" "${desc}" "found context '${ctx}', expected type '${expected_type}'"
    fi
}

# ---------------------------------------------------------------------------
# Podman image & container assertions
# ---------------------------------------------------------------------------

assert_image_exists() {
    local pts="$1" img="$2" desc="${3:-Image ${2} exists in local storage}"
    if podman image exists "${img}" 2>/dev/null; then
        pass_check "${pts}" "${desc}"
    else
        fail_check "${pts}" "${desc}" "image '${img}' does not exist in local Podman storage"
    fi
}

assert_image_user() {
    local pts="$1" img="$2" expected="$3" desc="${4:-Image ${2} runs as user ${3}}"
    local actual
    actual="$(podman image inspect --format '{{.Config.User}}' "${img}" 2>/dev/null || true)"
    if [[ "${actual}" == "${expected}" || "${actual}" == "${expected}:"* ]]; then
        pass_check "${pts}" "${desc}"
    else
        fail_check "${pts}" "${desc}" "image User is '${actual:-<root/empty>}', expected '${expected}'"
    fi
}

assert_container_running() {
    local pts="$1" cname="$2" desc="${3:-Container '${2}' is running}"
    local state
    state="$(podman container inspect --format '{{.State.Status}}' "${cname}" 2>/dev/null || true)"
    if [[ "${state}" == "running" ]]; then
        pass_check "${pts}" "${desc}"
    elif [[ -z "${state}" ]]; then
        fail_check "${pts}" "${desc}" "container '${cname}' does not exist"
    else
        fail_check "${pts}" "${desc}" "container '${cname}' state is '${state}' (expected 'running')"
    fi
}

assert_container_healthy() {
    local pts="$1" cname="$2" desc="${3:-Container '${2}' health status is healthy}"
    local health
    health="$(podman container inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}' "${cname}" 2>/dev/null || true)"
    if [[ "${health}" == "starting" ]]; then
        podman healthcheck run "${cname}" >/dev/null 2>&1 || true
        health="$(podman container inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}' "${cname}" 2>/dev/null || true)"
    fi
    if [[ "${health}" == "healthy" ]]; then
        pass_check "${pts}" "${desc}"
    else
        fail_check "${pts}" "${desc}" "container '${cname}' health status is '${health:-missing}' (expected 'healthy')"
    fi
}

assert_container_port() {
    local pts="$1" cname="$2" cport="$3" hport="$4" bind_ip="${5:-}"
    local desc="Container '${cname}' publishes container port ${cport} on host port ${hport}"
    [[ -n "${bind_ip}" ]] && desc="${desc} (${bind_ip})"
    local mapping
    mapping="$(podman port "${cname}" "${cport}" 2>/dev/null || true)"
    if [[ -z "${mapping}" ]]; then
        fail_check "${pts}" "${desc}" "container port '${cport}' is not published on '${cname}'"
        return
    fi
    if [[ -n "${bind_ip}" ]]; then
        if grep -Fq "${bind_ip}:${hport}" <<< "${mapping}"; then
            pass_check "${pts}" "${desc}"
        else
            fail_check "${pts}" "${desc}" "published as '${mapping}', expected '${bind_ip}:${hport}'"
        fi
    else
        if grep -Eq ":${hport}(\$|[[:space:]])" <<< "${mapping}"; then
            pass_check "${pts}" "${desc}"
        else
            fail_check "${pts}" "${desc}" "published as '${mapping}', expected host port '${hport}'"
        fi
    fi
}

assert_container_env() {
    local pts="$1" cname="$2" key="$3" expected="${4:-}"
    local desc="Container '${cname}' defines environment variable ${key}"
    local val
    val="$(podman container inspect --format '{{range .Config.Env}}{{println .}}{{end}}' "${cname}" 2>/dev/null | awk -F= -v k="${key}" '$1==k {sub(/^[^=]*=/, ""); print; found=1; exit} END{if(!found) exit 1}' || true)"
    if [[ -z "${val}" ]] && ! podman container inspect --format '{{range .Config.Env}}{{println .}}{{end}}' "${cname}" 2>/dev/null | grep -q "^${key}="; then
        fail_check "${pts}" "${desc}" "environment variable '${key}' not set on '${cname}'"
        return
    fi
    if [[ -n "${expected}" && "${val}" != "${expected}" ]]; then
        fail_check "${pts}" "${desc}" "${key}='${val}', expected '${expected}'"
    else
        pass_check "${pts}" "${desc}"
    fi
}

assert_container_mount() {
    local pts="$1" cname="$2" dest="$3" mode="${4:-}"
    local desc="Container '${cname}' mounts persistent storage at ${dest}"
    local info
    info="$(podman container inspect --format "{{range .Mounts}}{{if eq .Destination \"${dest}\"}}{{.Type}}:{{.RW}}{{end}}{{end}}" "${cname}" 2>/dev/null || true)"
    if [[ -z "${info}" ]]; then
        fail_check "${pts}" "${desc}" "no mount found at destination '${dest}' on '${cname}'"
        return
    fi
    if [[ "${mode}" == "ro" && "${info}" != *":false" ]]; then
        fail_check "${pts}" "${desc} (read-only)" "mount at '${dest}' is writable, expected read-only (:ro)"
    elif [[ "${mode}" == "rw" && "${info}" != *":true" ]]; then
        fail_check "${pts}" "${desc} (read-write)" "mount at '${dest}' is read-only, expected writable"
    else
        pass_check "${pts}" "${desc}"
    fi
}

# ---------------------------------------------------------------------------
# Network, HTTP, firewalld & Registry assertions
# ---------------------------------------------------------------------------

assert_http_ok() {
    local pts="$1" url="$2" regex="${3:-}" expected_code="${4:-200}"
    local desc="HTTP endpoint ${url} returns ${expected_code}"
    local tmp_body code attempt
    tmp_body="$(mktemp)"
    code="000"
    for attempt in 1 2 3 4 5 6; do
        code="$(curl -ksS -o "${tmp_body}" -w '%{http_code}' --max-time 5 "${url}" 2>/dev/null || printf '000')"
        if [[ "${code}" == "${expected_code}" ]]; then
            if [[ -z "${regex}" ]] || grep -Eq "${regex}" "${tmp_body}"; then
                break
            fi
        fi
        sleep 0.5
    done
    if [[ "${code}" != "${expected_code}" ]]; then
        rm -f "${tmp_body}"
        fail_check "${pts}" "${desc}" "HTTP status was ${code} (expected ${expected_code})"
        return
    fi
    if [[ -n "${regex}" ]] && ! grep -Eq "${regex}" "${tmp_body}"; then
        local sample
        sample="$(head -c 120 "${tmp_body}" | tr '\n' ' ')"
        rm -f "${tmp_body}"
        fail_check "${pts}" "${desc} with expected payload" "response body '${sample}' did not match '${regex}'"
        return
    fi
    rm -f "${tmp_body}"
    pass_check "${pts}" "${desc}"
}

assert_firewall_port() {
    local pts="$1" port_proto="$2" desc="${3:-Firewall permanently allows ${2}}"
    local rt perm
    rt="$(run_privileged firewall-cmd --query-port="${port_proto}" 2>/dev/null || true)"
    perm="$(run_privileged firewall-cmd --permanent --query-port="${port_proto}" 2>/dev/null || true)"
    if [[ "${rt}" == "yes" && "${perm}" == "yes" ]]; then
        pass_check "${pts}" "${desc}"
    else
        fail_check "${pts}" "${desc}" "runtime='${rt:-no}', permanent='${perm:-no}' for port ${port_proto} (remember --permanent and --reload)"
    fi
}

assert_user_linger() {
    local pts="$1" user="${2:-$(student_user)}"
    local desc="User lingering enabled for '${user}' (survives logout/reboot)"
    if [[ -f "/var/lib/systemd/linger/${user}" ]] || [[ "$(loginctl show-user "${user}" -p Linger --value 2>/dev/null || true)" == "yes" ]]; then
        pass_check "${pts}" "${desc}"
    else
        fail_check "${pts}" "${desc}" "linger is not enabled for '${user}' (use loginctl enable-linger ${user})"
    fi
}

# Verify systemd / Quadlet unit is active AND configured to start on boot.
# Handles both native .service units (is-enabled == enabled) and Podman v5 Quadlets
# (is-enabled == generated/transient with [Install] WantedBy= in the Quadlet source).
assert_service_persistent() {
    local pts="$1" scope="$2" unit="$3"
    local desc="Service '${unit}' (${scope}) is active and persistent across reboot"
    local ctl=(systemctl)
    [[ "${scope}" == "user" ]] && ctl=(systemctl --user)

    local active enabled
    active="$("${ctl[@]}" is-active "${unit}" 2>/dev/null || true)"
    if [[ "${active}" != "active" ]]; then
        fail_check "${pts}" "${desc}" "unit '${unit}' is '${active:-inactive}', expected 'active'"
        return
    fi

    enabled="$("${ctl[@]}" is-enabled "${unit}" 2>/dev/null || true)"
    if [[ "${enabled}" == "enabled" ]]; then
        pass_check "${pts}" "${desc}"
        return
    fi

    # For Podman v5 Quadlet units, systemd reports 'generated' or 'transient';
    # persistence requires WantedBy= in the source Quadlet file.
    if [[ "${enabled}" == "generated" || "${enabled}" == "transient" ]]; then
        local src_path
        src_path="$("${ctl[@]}" show -p SourcePath --value "${unit}" 2>/dev/null || true)"
        if [[ -n "${src_path}" ]]; then
            if [[ "${scope}" == "user" ]]; then
                if [[ -f "${src_path}" ]] && grep -Eq '^[[:space:]]*WantedBy=(default|timers)\.target([[:space:]]|$)' "${src_path}" 2>/dev/null; then
                    pass_check "${pts}" "${desc}"
                    return
                fi
                fail_check "${pts}" "${desc}" "User Quadlet '${unit}' requires 'WantedBy=default.target' under [Install] in '${src_path}'"
                return
            else
                if run_privileged grep -Eq '^[[:space:]]*WantedBy=(multi-user|default)\.target([[:space:]]|$)' "${src_path}" 2>/dev/null; then
                    pass_check "${pts}" "${desc}"
                    return
                fi
                fail_check "${pts}" "${desc}" "System Quadlet '${unit}' requires 'WantedBy=multi-user.target' under [Install] in '${src_path}'"
                return
            fi
        fi
        fail_check "${pts}" "${desc}" "Quadlet unit '${unit}' is active (${enabled}) but lacks WantedBy= under [Install]"
        return
    fi

    fail_check "${pts}" "${desc}" "unit '${unit}' is active but is-enabled='${enabled:-disabled}' (will not start after reboot)"
}

assert_registry_image() {
    local pts="$1" ref="$2" extra_flags="${3:-}" desc="${4:-Remote image ${2} exists in registry}"
    local cmd=(skopeo inspect)
    if [[ -n "${extra_flags}" ]]; then
        # shellcheck disable=SC2206
        local flags_arr=( ${extra_flags} )
        cmd+=("${flags_arr[@]}")
    fi
    cmd+=("docker://${ref}")
    if "${cmd[@]}" >/dev/null 2>&1 || podman manifest inspect --authfile "$(student_home)/.config/containers/auth.json" "docker://${ref}" >/dev/null 2>&1 || podman manifest inspect "docker://${ref}" >/dev/null 2>&1; then
        pass_check "${pts}" "${desc}"
    else
        fail_check "${pts}" "${desc}" "remote image '${ref}' was not found or accessible in the registry"
    fi
}

grade_finish() {
    hr
    local passed=0
    if [[ "${GRADE_TOTAL}" -gt 0 && "${GRADE_EARNED}" -eq "${GRADE_TOTAL}" && "${GRADE_CHECKS_FAILED}" -eq 0 ]]; then
        passed=1
    fi

    if [[ -n "${GRADE_TASK_ID}" && "${LAB_SKIP_PROGRESS:-0}" != "1" ]]; then
        state_record_grade "${GRADE_TASK_ID}" "${GRADE_EARNED}" "${GRADE_TOTAL}" "${passed}"
    fi

    if [[ -n "${LAB_SCORE_OUT_FILE:-}" ]]; then
        printf '%d %d %d\n' "${GRADE_EARNED}" "${GRADE_TOTAL}" "${passed}" > "${LAB_SCORE_OUT_FILE}"
    fi

    if [[ "${passed}" -eq 1 ]]; then
        printf '%sRESULT: PASS%s — Score: %s%d / %d%s (%d checks passed)\n' \
            "${C_GREEN}${C_BOLD}" "${C_RESET}" "${C_BOLD}" "${GRADE_EARNED}" "${GRADE_TOTAL}" "${C_RESET}" "${GRADE_CHECKS_PASSED}"
        return 0
    else
        printf '%sRESULT: FAIL%s — Score: %s%d / %d%s (%d passed, %d failed)\n' \
            "${C_RED}${C_BOLD}" "${C_RESET}" "${C_BOLD}" "${GRADE_EARNED}" "${GRADE_TOTAL}" "${C_RESET}" \
            "${GRADE_CHECKS_PASSED}" "${GRADE_CHECKS_FAILED}"
        return 1
    fi
}

export -f pass_check fail_check check_cmd assert_file_exists assert_dir_exists assert_file_contains assert_file_not_contains assert_selinux_type assert_image_exists assert_image_user assert_container_running assert_container_healthy assert_container_port assert_container_env assert_container_mount assert_http_ok assert_firewall_port assert_user_linger assert_service_persistent assert_registry_image
