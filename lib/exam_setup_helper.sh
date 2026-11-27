#!/usr/bin/env bash
# Shared setup/reset helpers for EX188 mock exams (seeding registries, building
# pre-staged images, and prefix-based cleanup of every object an exam creates).

if [[ -n "${_EX188_EXAM_SETUP_HELPER_LOADED:-}" ]]; then
    return 0
fi
readonly _EX188_EXAM_SETUP_HELPER_LOADED=1

# shellcheck source=lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
# shellcheck source=lib/registry.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/registry.sh"

EXAM_BASE_IMAGE="registry.access.redhat.com/ubi10/ubi-minimal:latest"

exam_ensure_image() {
    local img="$1"
    podman image exists "${img}" 2>/dev/null || podman pull -q "${img}" >/dev/null
}

# exam_seed_push <source-image> <fully-qualified-target-ref>
# Pushes into one of the lab registries WITHOUT touching /etc/containers/certs.d,
# so learner-side trust configuration remains part of the exam.
exam_seed_push() {
    local src="$1" ref="$2"
    local host="${ref%%/*}"
    exam_ensure_image "${src}"
    podman tag "${src}" "${ref}"
    case "${host}" in
        *:5000)
            podman push --remove-signatures -q --tls-verify=false "${ref}" >/dev/null
            ;;
        *:5443|*:5444)
            local cdir
            cdir="$(mktemp -d)"
            cp "${LAB_CERTS_DIR}/ca.crt" "${cdir}/ca.crt"
            if [[ "${host}" == *:5444 ]]; then
                podman push --remove-signatures -q --cert-dir "${cdir}" --creds student:redhat123 "${ref}" >/dev/null
            else
                podman push --remove-signatures -q --cert-dir "${cdir}" "${ref}" >/dev/null
            fi
            rm -rf "${cdir}"
            ;;
        *)
            die "exam_seed_push: unsupported registry host '${host}'"
            ;;
    esac
    podman rmi "${ref}" >/dev/null 2>&1 || true
}

# exam_build_app <app-name> <image-tag>
# Builds a vendor application with a known-good Containerfile (used for
# pre-staged images in troubleshooting and dependency tasks).
exam_build_app() {
    local app="$1" tag="$2"
    local tmp
    tmp="$(mktemp -d)"
    cp -a "${LAB_APPS_DIR}/${app}/." "${tmp}/"
    case "${app}" in
        webapp-flask)
            cat > "${tmp}/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 \
    && mkdir -p /opt/webapp /var/lib/webapp/data \
    && chown -R 1001:0 /opt/webapp /var/lib/webapp \
    && chmod -R g=u /var/lib/webapp \
    && dnf clean all
COPY --chown=1001:0 app.py requirements.txt /opt/webapp/
USER 1001
EXPOSE 8080
CMD ["python3", "/opt/webapp/app.py"]
EOF
            ;;
        api-express)
            cat > "${tmp}/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y nodejs \
    && mkdir -p /opt/api-express /var/lib/api-express/audit \
    && chown -R 1001:0 /opt/api-express /var/lib/api-express \
    && chmod -R g=u /var/lib/api-express \
    && dnf clean all
WORKDIR /opt/api-express
COPY --chown=1001:0 package.json server.js /opt/api-express/
COPY --chown=1001:0 config /opt/api-express/config
USER 1001
EXPOSE 3000
CMD ["node", "server.js"]
EOF
            ;;
        worker-py)
            cat > "${tmp}/Containerfile" <<'EOF'
FROM registry.access.redhat.com/ubi10/ubi:latest
RUN dnf install -y python3 \
    && mkdir -p /opt/worker /var/spool/worker/inbox /var/spool/worker/outbox \
    && chown -R 1001:0 /opt/worker /var/spool/worker \
    && chmod -R g=u /var/spool/worker \
    && dnf clean all
COPY --chown=1001:0 worker.py healthcheck.py /opt/worker/
USER 1001
CMD ["python3", "/opt/worker/worker.py", "--interval", "1"]
EOF
            ;;
        *)
            rm -rf "${tmp}"
            die "exam_build_app: unsupported app '${app}'"
            ;;
    esac
    podman build -q -t "${tag}" "${tmp}" >/dev/null
    rm -rf "${tmp}"
}

# exam_build_inline <image-tag> <Containerfile-content>
exam_build_inline() {
    local tag="$1" content="$2"
    local tmp
    tmp="$(mktemp -d)"
    printf '%s\n' "${content}" > "${tmp}/Containerfile"
    podman build -q -t "${tag}" "${tmp}" >/dev/null
    rm -rf "${tmp}"
}

_quadlet_unit_for() {
    local base="$1" name ext
    name="${base%.*}"
    ext="${base##*.}"
    case "${ext}" in
        container|kube) printf '%s.service\n' "${name}" ;;
        pod)            printf '%s-pod.service\n' "${name}" ;;
        network)        printf '%s-network.service\n' "${name}" ;;
        volume)         printf '%s-volume.service\n' "${name}" ;;
        *)              printf '\n' ;;
    esac
}

# exam_reset_prefix <prefix> [firewall-port ...]
# Removes every object whose name starts with <prefix>- (or <prefix>_ for secrets).
exam_reset_prefix() {
    local p="$1"
    shift
    local shome qdir work f u
    shome="$(student_home)"
    qdir="${shome}/.config/containers/systemd"
    work="${shome}/workspace/${p}"

    # Compose projects inside the exam workspace
    if [[ -d "${work}" ]] && command -v podman-compose >/dev/null 2>&1; then
        while IFS= read -r f; do
            (cd "$(dirname "${f}")" && podman-compose down -v >/dev/null 2>&1) || true
        done < <(find "${work}" -maxdepth 3 -name compose.yaml 2>/dev/null)
    fi

    # Rootless Quadlets
    for f in "${qdir}/${p}"-* "${qdir}/${p}".*; do
        [[ -e "${f}" ]] || continue
        u="$(_quadlet_unit_for "$(basename "${f}")")"
        [[ -n "${u}" ]] && systemctl --user stop "${u}" >/dev/null 2>&1 || true
        rm -f "${f}"
    done
    rm -f "${shome}/.config/systemd/user/${p}-"* 2>/dev/null || true
    systemctl --user daemon-reload >/dev/null 2>&1 || true

    # Rootful Quadlets
    for f in /etc/containers/systemd/"${p}"-*; do
        [[ -e "${f}" ]] || continue
        u="$(_quadlet_unit_for "$(basename "${f}")")"
        [[ -n "${u}" ]] && run_privileged systemctl stop "${u}" >/dev/null 2>&1 || true
        run_privileged rm -f "${f}"
    done
    run_privileged systemctl daemon-reload >/dev/null 2>&1 || true
    run_privileged podman ps -aq --filter "name=^${p}-" 2>/dev/null | xargs -r run_privileged podman rm -f >/dev/null 2>&1 || true

    # Rootless runtime objects
    podman pod ps -q --filter "name=^${p}-" 2>/dev/null | xargs -r podman pod rm -f >/dev/null 2>&1 || true
    podman ps -aq --filter "name=^${p}-" 2>/dev/null | xargs -r podman rm -f >/dev/null 2>&1 || true
    podman volume ls -q --filter "name=${p}-" 2>/dev/null | xargs -r podman volume rm -f >/dev/null 2>&1 || true
    podman network ls -q --filter "name=${p}-" 2>/dev/null | xargs -r podman network rm -f >/dev/null 2>&1 || true
    podman secret ls --format '{{.Name}}' 2>/dev/null | grep -E "^${p}[_-]" | xargs -r podman secret rm >/dev/null 2>&1 || true
    podman images --format '{{.Repository}}:{{.Tag}}' 2>/dev/null | grep -E "^localhost/${p}-" | xargs -r podman rmi -f >/dev/null 2>&1 || true

    # Host configuration created by the exam
    run_privileged rm -f /etc/containers/registries.conf.d/*"${p}"*.conf
    if ls /etc/sysctl.d/*"${p}"*.conf >/dev/null 2>&1; then
        run_privileged rm -f /etc/sysctl.d/*"${p}"*.conf
        run_privileged sysctl -w net.ipv4.ip_unprivileged_port_start=1024 >/dev/null 2>&1 || true
    fi
    run_privileged rm -rf /etc/containers/certs.d/secure-reg.lab.local:5443 /etc/containers/certs.d/auth-reg.lab.local:5444
    for f in "$@"; do
        run_privileged firewall-cmd --permanent --remove-port="${f}/tcp" >/dev/null 2>&1 || true
    done
    run_privileged firewall-cmd --reload >/dev/null 2>&1 || true

    podman unshare rm -rf "${work}" >/dev/null 2>&1 || rm -rf "${work}"
}
