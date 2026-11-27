#!/usr/bin/env bash
# Local Podman registry infrastructure helper:
#   1) registry.lab.local:5000     -> Plain HTTP (insecure)
#   2) secure-reg.lab.local:5443   -> HTTPS TLS (self-signed CA at /opt/ex188-lab/certs/ca.crt)
#   3) auth-reg.lab.local:5444     -> HTTPS TLS + htpasswd auth (student:redhat123, ci-bot:Ex188Pass!)

if [[ -n "${_EX188_REGISTRY_LOADED:-}" ]]; then
    return 0
fi
readonly _EX188_REGISTRY_LOADED=1

# shellcheck source=lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

REG_IMAGE="${REG_IMAGE:-docker.io/library/registry:2}"
REG_STATE_ROOT="${REG_STATE_ROOT:-/opt/ex188-lab/registries}"
REG_INSECURE_HOST="registry.lab.local:5000"
REG_TLS_HOST="secure-reg.lab.local:5443"
REG_AUTH_HOST="auth-reg.lab.local:5444"

export REG_IMAGE REG_STATE_ROOT REG_INSECURE_HOST REG_TLS_HOST REG_AUTH_HOST

registry_generate_certs_and_auth() {
    run_privileged mkdir -p "${LAB_CERTS_DIR}" "${REG_STATE_ROOT}/auth" \
        "${REG_STATE_ROOT}/data-5000" "${REG_STATE_ROOT}/data-5443" "${REG_STATE_ROOT}/data-5444"

    if [[ ! -f "${LAB_CERTS_DIR}/ca.crt" ]]; then
        log_info "Generating Lab Root CA and TLS certificates for local registries..."
        local tmpdir
        tmpdir="$(mktemp -d)"

        openssl req -x509 -newkey rsa:4096 -days 3650 -nodes \
            -subj "/CN=EX188 Lab Root CA/O=EX188 Practice Lab" \
            -keyout "${tmpdir}/ca.key" -out "${tmpdir}/ca.crt" >/dev/null 2>&1

        cat > "${tmpdir}/san.cnf" <<'EOF'
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
CN = secure-reg.lab.local

[v3_req]
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
DNS.2 = registry.lab.local
DNS.3 = secure-reg.lab.local
DNS.4 = auth-reg.lab.local
IP.1 = 127.0.0.1
EOF
        openssl req -newkey rsa:2048 -nodes \
            -keyout "${tmpdir}/registry.key" \
            -out "${tmpdir}/registry.csr" \
            -config "${tmpdir}/san.cnf" >/dev/null 2>&1

        openssl x509 -req -in "${tmpdir}/registry.csr" \
            -CA "${tmpdir}/ca.crt" -CAkey "${tmpdir}/ca.key" -CAcreateserial \
            -out "${tmpdir}/registry.crt" -days 3650 \
            -extensions v3_req -extfile "${tmpdir}/san.cnf" >/dev/null 2>&1

        run_privileged install -m 0644 "${tmpdir}/ca.crt" "${LAB_CERTS_DIR}/ca.crt"
        run_privileged install -m 0644 "${tmpdir}/registry.crt" "${LAB_CERTS_DIR}/registry.crt"
        run_privileged install -m 0644 "${tmpdir}/registry.key" "${LAB_CERTS_DIR}/registry.key"
        rm -rf "${tmpdir}"
    fi

    if [[ ! -f "${REG_STATE_ROOT}/auth/htpasswd" ]]; then
        log_info "Generating htpasswd credentials for ${REG_AUTH_HOST}..."
        local tmp_ht
        tmp_ht="$(mktemp)"
        htpasswd -Bbn student redhat123 > "${tmp_ht}"
        htpasswd -Bbn ci-bot 'Ex188Pass!' >> "${tmp_ht}"
        run_privileged install -m 0644 "${tmp_ht}" "${REG_STATE_ROOT}/auth/htpasswd"
        rm -f "${tmp_ht}"
    fi
}

registry_ensure_hosts() {
    if ! grep -q 'secure-reg.lab.local' /etc/hosts 2>/dev/null; then
        log_info "Adding registry.lab.local, secure-reg.lab.local, auth-reg.lab.local to /etc/hosts"
        printf '127.0.0.1 registry.lab.local secure-reg.lab.local auth-reg.lab.local\n' | run_privileged tee -a /etc/hosts >/dev/null
    fi
}

registry_start_all() {
    registry_ensure_hosts
    registry_generate_certs_and_auth

    # 1) Plain HTTP registry on :5000
    if ! run_privileged podman container exists ex188-reg-http 2>/dev/null; then
        run_privileged podman run -d --name ex188-reg-http --restart=always \
            -p 5000:5000 \
            -v "${REG_STATE_ROOT}/data-5000:/var/lib/registry:Z" \
            "${REG_IMAGE}" >/dev/null
    else
        run_privileged podman start ex188-reg-http >/dev/null 2>&1 || true
    fi

    # 2) Self-signed TLS registry on :5443 (no auth)
    if ! run_privileged podman container exists ex188-reg-tls 2>/dev/null; then
        run_privileged podman run -d --name ex188-reg-tls --restart=always \
            -p 5443:5000 \
            -v "${REG_STATE_ROOT}/data-5443:/var/lib/registry:Z" \
            -v "${LAB_CERTS_DIR}:/certs:ro,z" \
            -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt \
            -e REGISTRY_HTTP_TLS_KEY=/certs/registry.key \
            "${REG_IMAGE}" >/dev/null
    else
        run_privileged podman start ex188-reg-tls >/dev/null 2>&1 || true
    fi

    # 3) Self-signed TLS + htpasswd registry on :5444
    if ! run_privileged podman container exists ex188-reg-auth 2>/dev/null; then
        run_privileged podman run -d --name ex188-reg-auth --restart=always \
            -p 5444:5000 \
            -v "${REG_STATE_ROOT}/data-5444:/var/lib/registry:Z" \
            -v "${LAB_CERTS_DIR}:/certs:ro,z" \
            -v "${REG_STATE_ROOT}/auth:/auth:ro,z" \
            -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt \
            -e REGISTRY_HTTP_TLS_KEY=/certs/registry.key \
            -e REGISTRY_AUTH=htpasswd \
            -e "REGISTRY_AUTH_HTPASSWD_REALM=EX188 Authenticated Registry" \
            -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
            "${REG_IMAGE}" >/dev/null
    else
        run_privileged podman start ex188-reg-auth >/dev/null 2>&1 || true
    fi

    # Enable podman-restart.service so --restart=always brings all 3 registries up on VM reboot
    run_privileged systemctl enable podman-restart.service >/dev/null 2>&1 || true
}

# Fast non-privileged port check; starts registries automatically only if any is down
registry_ensure_running() {
    local listeners
    listeners="$(ss -tln 2>/dev/null || true)"
    if [[ "${listeners}" != *":5000 "* || "${listeners}" != *":5443 "* || "${listeners}" != *":5444 "* ]]; then
        registry_start_all
    fi
}

export -f registry_generate_certs_and_auth registry_ensure_hosts registry_start_all registry_ensure_running registry_status

registry_status() {
    local c
    for c in ex188-reg-http ex188-reg-tls ex188-reg-auth; do
        local st
        st="$(run_privileged podman inspect --format '{{.State.Status}}' "${c}" 2>/dev/null || printf 'missing')"
        printf '  %-18s : %s\n' "${c}" "${st}"
    done
}
