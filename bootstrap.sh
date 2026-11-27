#!/usr/bin/env bash
# Bootstrap script for Red Hat EX188 Practice Lab Suite on RHEL 10 family
# (RHEL 10, AlmaLinux 10, Rocky Linux 10, CentOS Stream 10) with Podman v5.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"
# shellcheck source=lib/registry.sh
source "${SCRIPT_DIR}/lib/registry.sh"

log_header "Bootstrapping EX188 Lab Environment (RHEL 10 + Podman v5)"

if [[ -f /etc/os-release ]]; then
    # shellcheck disable=SC1091
    source /etc/os-release
    log_info "Detected OS: ${PRETTY_NAME:-Linux}"
fi

# 1. Install required RHEL 10 packages (Podman + internal grading helpers; NO Docker)
PACKAGES=(
    podman
    skopeo
    jq
    httpd-tools
    firewalld
    vim-enhanced
    curl
    iproute
    openssl
    tar
    gzip
    findutils
    procps-ng
    policycoreutils
    policycoreutils-python-utils
    container-selinux
    systemd-container
    python3
    python3-pip
    python3-pyyaml
)

log_info "Installing required packages via dnf..."
run_privileged dnf install -y "${PACKAGES[@]}"

# Ensure podman-compose is installed (via AppStream/EPEL 10 or pip fallback)
if ! command -v podman-compose >/dev/null 2>&1; then
    if run_privileged dnf list --available podman-compose >/dev/null 2>&1; then
        run_privileged dnf install -y podman-compose
    elif run_privileged dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm >/dev/null 2>&1         && run_privileged dnf install -y podman-compose >/dev/null 2>&1; then
        log_ok "Installed podman-compose via EPEL 10."
    elif run_privileged python3 -m pip install --break-system-packages -q podman-compose >/dev/null 2>&1 || run_privileged python3 -m pip install -q podman-compose >/dev/null 2>&1; then
        log_ok "Installed podman-compose via pip."
    else
        log_warn "Could not install podman-compose automatically (offline without EPEL)."
    fi
fi

# Ensure firewalld is enabled and running
log_info "Enabling firewalld..."
run_privileged systemctl enable --now firewalld

# 2. Configure exam user `student` + rootless subuid/subgid + lingering
if ! id student >/dev/null 2>&1; then
    log_info "Creating primary practice user 'student'..."
    run_privileged useradd -m -s /bin/bash student
    printf 'student:student\n' | run_privileged chpasswd
fi

if ! grep -q '^student:' /etc/subuid 2>/dev/null; then
    run_privileged usermod --add-subuids 100000-165535 --add-subgids 100000-165535 student
fi

log_info "Configuring passwordless sudo for 'student' (required for rootful/firewall/SELinux tasks)..."
printf 'student ALL=(ALL) NOPASSWD: ALL\n' | run_privileged tee /etc/sudoers.d/90-ex188-student >/dev/null
run_privileged chmod 0440 /etc/sudoers.d/90-ex188-student

log_info "Enabling systemd user linger and podman-restart services..."
run_privileged loginctl enable-linger student
run_privileged systemctl enable podman-restart.service >/dev/null 2>&1 || true
getent group devshare >/dev/null 2>&1 || run_privileged groupadd -g 2460 devshare
run_privileged usermod -aG devshare student >/dev/null 2>&1 || true

# 3. Install lab suite to /opt/ex188-lab and expose `lab` CLI globally + in ~/bin
INSTALL_DIR="/opt/ex188-lab"
if [[ "${SCRIPT_DIR}" != "${INSTALL_DIR}" ]]; then
    log_info "Syncing ex188-lab to ${INSTALL_DIR}..."
    run_privileged mkdir -p "${INSTALL_DIR}"
    run_privileged cp -a "${SCRIPT_DIR}/." "${INSTALL_DIR}/"
fi

run_privileged chmod +x "${INSTALL_DIR}/bin/lab" "${INSTALL_DIR}/bootstrap.sh" "${INSTALL_DIR}/prefetch-images.sh"
run_privileged find "${INSTALL_DIR}/tasks" "${INSTALL_DIR}/exams" "${INSTALL_DIR}/lib" -name '*.sh' -exec chmod +x {} + 2>/dev/null || true

run_privileged ln -sf "${INSTALL_DIR}/bin/lab" /usr/local/bin/lab
STUDENT_HOME="$(getent passwd student | cut -d: -f6)"
run_privileged mkdir -p "${STUDENT_HOME}/bin" "${STUDENT_HOME}/apps" "${STUDENT_HOME}/workspace"
run_privileged ln -sf "${INSTALL_DIR}/bin/lab" "${STUDENT_HOME}/bin/lab"

# Copy pre-written sample apps to ~/apps as read-only vendor code
run_privileged rm -rf "${STUDENT_HOME}/apps"
run_privileged cp -a "${INSTALL_DIR}/apps" "${STUDENT_HOME}/apps"
run_privileged chown -R root:root "${STUDENT_HOME}/apps"
run_privileged chmod -R a+rX,u+w,go-w "${STUDENT_HOME}/apps"
run_privileged chcon -Rt container_file_t "${STUDENT_HOME}/apps" >/dev/null 2>&1 || true
run_privileged chown -R student:student "${STUDENT_HOME}/bin" "${STUDENT_HOME}/workspace"

# 4. Start local container registries (:5000 HTTP, :5443 TLS, :5444 TLS+Auth)
log_info "Starting local container registries (:5000 HTTP, :5443 TLS, :5444 TLS+htpasswd)..."
registry_start_all
registry_status

hr
log_ok "Bootstrap complete!"
printf '\nNext steps:\n'
printf '  1. Switch to practice user:  %ssudo -iu student%s\n' "${C_BOLD}" "${C_RESET}"
printf '  2. (Optional offline prep):  %s/opt/ex188-lab/prefetch-images.sh%s\n' "${C_BOLD}" "${C_RESET}"
printf '  3. Browse all tasks:         %slab list%s\n' "${C_BOLD}" "${C_RESET}"
printf '  4. Start your first task:    %slab start 00-01%s\n' "${C_BOLD}" "${C_RESET}"
printf '  5. Take Mock Exam 1:         %slab exam 1%s\n' "${C_BOLD}" "${C_RESET}"
