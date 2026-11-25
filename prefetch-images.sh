#!/usr/bin/env bash
# Offline image pre-fetcher and loader generator for EX188 Practice Lab Suite.
# Pulls all allowed public images via Podman and exports tarballs for air-gapped practice.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

CACHE_DIR="${1:-${SCRIPT_DIR}/offline-images}"
mkdir -p "${CACHE_DIR}"

IMAGES=(
    "registry.access.redhat.com/ubi10/ubi:latest"
    "registry.access.redhat.com/ubi10/ubi-minimal:latest"
    "registry.access.redhat.com/ubi10/ubi-init:latest"
    "docker.io/library/registry:2"
    "quay.io/nginx/nginx-unprivileged:1.26-alpine"
    "docker.io/library/httpd:2.4"
    "docker.io/library/python:3.12-slim"
    "docker.io/library/node:20-slim"
    "docker.io/library/golang:1.22"
    "quay.io/sclorg/postgresql-16-c10s:latest"
    "docker.io/library/redis:7-alpine"
)

MANIFEST_FILE="${CACHE_DIR}/manifest.txt"
LOADER_SCRIPT="${CACHE_DIR}/load-images.sh"
: > "${MANIFEST_FILE}"

log_header "Pre-fetching EX188 Lab Images into ${CACHE_DIR}"

for img in "${IMAGES[@]}"; do
    safe_name="$(printf '%s' "${img}" | tr '/:@' '___').tar"
    out_tar="${CACHE_DIR}/${safe_name}"
    log_info "Pulling ${img}..."
    podman pull "${img}"
    log_info "Saving ${img} -> ${out_tar}"
    rm -f "${out_tar}"
    podman save --format docker-archive -o "${out_tar}" "${img}"
    printf '%s %s\n' "${safe_name}" "${img}" >> "${MANIFEST_FILE}"
done

cat > "${LOADER_SCRIPT}" <<'EOF'
#!/usr/bin/env bash
# Offline image loader for EX188 Practice Lab Suite.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST="${DIR}/manifest.txt"

if [[ ! -f "${MANIFEST}" ]]; then
    printf '[FAIL] manifest.txt not found in %s\n' "${DIR}" >&2
    exit 1
fi

while read -r tarfile img; do
    [[ -z "${tarfile}" ]] && continue
    printf '[INFO] Loading %s (%s)...\n' "${img}" "${tarfile}"
    podman load -i "${DIR}/${tarfile}"
done < "${MANIFEST}"

printf '[PASS] All offline images loaded into local Podman storage.\n'
EOF
chmod +x "${LOADER_SCRIPT}"

hr
log_ok "Saved ${#IMAGES[@]} images to ${CACHE_DIR}"
log_info "On an offline VM, copy '${CACHE_DIR}' and run: ${LOADER_SCRIPT}"
