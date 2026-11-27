#!/usr/bin/env bash
# Shared constants, ANSI colors, logging, and metadata helpers for ex188-lab.
# Target OS: RHEL 10 / AlmaLinux 10 / Rocky Linux 10 / CentOS Stream 10 with Podman v5.

if [[ -n "${_EX188_COMMON_LOADED:-}" ]]; then
    return 0
fi
readonly _EX188_COMMON_LOADED=1

# Resolve repository root dynamically
LAB_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_ROOT="$(cd "${LAB_LIB_DIR}/.." && pwd)"
LAB_BIN_DIR="${LAB_ROOT}/bin"
LAB_APPS_DIR="${LAB_ROOT}/apps"
LAB_TASKS_DIR="${LAB_ROOT}/tasks"
LAB_EXAMS_DIR="${LAB_ROOT}/exams"
# LAB_DATA_DIR and LAB_ACTIVE_DIR are resolved below after student_home() is defined
LAB_CERTS_DIR="${LAB_CERTS_DIR:-/opt/ex188-lab/certs}"

export LAB_LIB_DIR LAB_ROOT LAB_BIN_DIR LAB_APPS_DIR LAB_TASKS_DIR LAB_EXAMS_DIR LAB_DATA_DIR LAB_ACTIVE_DIR LAB_CERTS_DIR

# ANSI Colors (respect NO_COLOR; enable when stdout is a terminal or LAB_FORCE_COLOR=1)
if [[ -z "${NO_COLOR:-}" ]] && { [[ -t 1 ]] || [[ "${LAB_FORCE_COLOR:-0}" == "1" ]]; }; then
    C_RESET=$'\033[0m'
    C_BOLD=$'\033[1m'
    C_DIM=$'\033[2m'
    C_RED=$'\033[31m'
    C_GREEN=$'\033[32m'
    C_YELLOW=$'\033[33m'
    C_BLUE=$'\033[34m'
    C_MAGENTA=$'\033[35m'
    C_CYAN=$'\033[36m'
else
    C_RESET=""
    C_BOLD=""
    C_DIM=""
    C_RED=""
    C_GREEN=""
    C_YELLOW=""
    C_BLUE=""
    C_MAGENTA=""
    C_CYAN=""
fi

export C_RESET C_BOLD C_DIM C_RED C_YELLOW C_GREEN C_BLUE C_MAGENTA C_CYAN

hr() {
    printf '%s\n' "${C_DIM}------------------------------------------------------------------------------${C_RESET}"
}

log_header() {
    printf '\n%s%s%s\n' "${C_BOLD}${C_CYAN}" "$*" "${C_RESET}"
    hr
}

log_info() {
    printf '%s[INFO]%s %s\n' "${C_BLUE}${C_BOLD}" "${C_RESET}" "$*"
}

log_ok() {
    printf '%s[PASS]%s %s\n' "${C_GREEN}${C_BOLD}" "${C_RESET}" "$*"
}

log_warn() {
    printf '%s[WARN]%s %s\n' "${C_YELLOW}${C_BOLD}" "${C_RESET}" "$*" >&2
}

log_err() {
    printf '%s[FAIL]%s %s\n' "${C_RED}${C_BOLD}" "${C_RESET}" "$*" >&2
}

die() {
    log_err "$*"
    exit 1
}

ensure_lab_dirs() {
    local shome
    shome="$(student_home)"
    mkdir -p "${LAB_DATA_DIR}" "${LAB_ACTIVE_DIR}" "${shome}/workspace"
    chown "$(student_user):$(student_user)" "${LAB_DATA_DIR}" "${LAB_ACTIVE_DIR}" "${shome}/workspace" 2>/dev/null || true
}

# Return home directory of primary exam user (`student` if present, otherwise $HOME)
student_user() {
    if id student >/dev/null 2>&1; then
        printf 'student\n'
    else
        id -un
    fi
}

student_home() {
    local u
    u="$(student_user)"
    getent passwd "${u}" | cut -d: -f6
}

student_uid() {
    local u
    u="$(student_user)"
    id -u "${u}"
}

# Run a command with root privileges if needed
run_privileged() {
    if [[ "${EUID}" -eq 0 ]]; then
        "$@"
    elif command -v sudo >/dev/null 2>&1; then
        sudo "$@"
    else
        die "Root privileges required for: $*"
    fi
}

if [[ -z "${LAB_DATA_DIR:-}" ]]; then
    _shome="$(student_home 2>/dev/null || printf '%s' "${HOME}")"
    LAB_DATA_DIR="${_shome:-${HOME}}/.lab"
    unset _shome
fi
LAB_ACTIVE_DIR="${LAB_DATA_DIR}/active"
export LAB_DATA_DIR LAB_ACTIVE_DIR

# Copy a read-only vendor app into a writable student build directory (Red Hat exam style)
stage_vendor_app() {
    local app="$1"
    local dest="$2"
    mkdir -p "${dest}"
    cp -a "${LAB_APPS_DIR}/${app}/." "${dest}/"
    chmod -R u+rwX,go+rX "${dest}" 2>/dev/null || true
    chown -R "$(student_user):$(student_user)" "${dest}" 2>/dev/null || true
}

export -f hr log_header log_info log_ok log_warn log_err die ensure_lab_dirs student_user student_home student_uid run_privileged stage_vendor_app

# Lightweight YAML scalar reader for simple flat meta.yaml files (no external yq required)
meta_get() {
    local file="$1"
    local key="$2"
    [[ -f "${file}" ]] || return 1
    awk -F': *' -v k="${key}" '
        $1 == k {
            val = substr($0, index($0, ":") + 1)
            sub(/^ +/, "", val)
            sub(/ +$/, "", val)
            gsub(/^["'\'']|["'\'']$/, "", val)
            print val
            exit
        }
    ' "${file}"
}

# Lightweight YAML list reader (supports inline [a, b] or indented "- item")
meta_list() {
    local file="$1"
    local key="$2"
    [[ -f "${file}" ]] || return 1
    awk -v k="${key}" '
        $0 ~ "^" k ": *\\[" {
            line = $0
            sub("^" k ": *\\[", "", line)
            sub("\\] *$", "", line)
            n = split(line, arr, ",")
            for (i = 1; i <= n; i++) {
                gsub(/^ +| +$/, "", arr[i])
                gsub(/^["'\'']|["'\'']$/, "", arr[i])
                if (arr[i] != "") print arr[i]
            }
            exit
        }
        $0 ~ "^" k ": *$" { in_list = 1; next }
        in_list && $0 ~ "^  *- " {
            item = $0
            sub("^  *- +", "", item)
            gsub(/^["'\'']|["'\'']$/, "", item)
            sub(/ +$/, "", item)
            print item
            next
        }
        in_list && $0 ~ "^[^ ]" { exit }
    ' "${file}"
}

# Locate task directory by ID (e.g. "01-01" or "01-containerfile/01-01")
find_task_dir() {
    local query="$1"
    if [[ -d "${LAB_TASKS_DIR}/${query}" && -f "${LAB_TASKS_DIR}/${query}/meta.yaml" ]]; then
        printf '%s\n' "${LAB_TASKS_DIR}/${query}"
        return 0
    fi
    local match
    for match in "${LAB_TASKS_DIR}"/*/"${query}" "${LAB_TASKS_DIR}"/*/"${query}"-*; do
        if [[ -d "${match}" && -f "${match}/meta.yaml" ]]; then
            printf '%s\n' "${match}"
            return 0
        fi
    done
    return 1
}

# List all task directories sorted by domain and ID
list_all_task_dirs() {
    local domain_filter="${1:-}"
    local d t
    for d in "${LAB_TASKS_DIR}"/*; do
        [[ -d "${d}" ]] || continue
        if [[ -n "${domain_filter}" && "$(basename "${d}")" != *"${domain_filter}"* ]]; then
            continue
        fi
        for t in "${d}"/*; do
            if [[ -d "${t}" && -f "${t}/meta.yaml" ]]; then
                printf '%s\n' "${t}"
            fi
        done
    done
}
