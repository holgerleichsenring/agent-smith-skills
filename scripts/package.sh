#!/usr/bin/env bash
#
# Builds a deterministic tarball of the skill catalog.
# Output: agentsmith-skills-${VERSION}.tar.gz + .sha256 sidecar
#
# Determinism contract:
#  - sorted file order
#  - fixed mtime (epoch 0)
#  - fixed uid/gid/owner/group
#  - no extended attributes / xattrs / acls
#
# Any rebuild of the same source tree must produce a byte-equal archive.

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "${SCRIPT_DIR}/.." && pwd )"
cd "${REPO_ROOT}"

VERSION="${1:-${GITHUB_REF_NAME:-edge}}"
OUTPUT_DIR="${OUTPUT_DIR:-${REPO_ROOT}/dist}"
mkdir -p "${OUTPUT_DIR}"

ARCHIVE_NAME="agentsmith-skills-${VERSION}.tar.gz"
ARCHIVE_PATH="${OUTPUT_DIR}/${ARCHIVE_NAME}"

# Source directories included in the release. Sorted so the manifest is stable.
SOURCES=(skills patterns)

# Filter the manifest deterministically.
MANIFEST_FILE="$(mktemp)"
trap 'rm -f "${MANIFEST_FILE}"' EXIT

for src in "${SOURCES[@]}"; do
  if [[ -d "${src}" ]]; then
    find "${src}" -type f -print0 | LC_ALL=C sort -z >> "${MANIFEST_FILE}"
  fi
done

if [[ ! -s "${MANIFEST_FILE}" ]]; then
  echo "package.sh: no source files found in ${SOURCES[*]}" >&2
  exit 2
fi

# GNU tar has --mtime, --owner, --group, --numeric-owner; BSD tar via libarchive
# also accepts --uid/--gid. We use the GNU-flavored options that gtar (Linux)
# and bsdtar (macOS via Homebrew) both honor.
if tar --version 2>&1 | grep -qi "gnu tar"; then
  TAR=tar
elif command -v gtar >/dev/null 2>&1; then
  TAR=gtar
else
  echo "package.sh: GNU tar required (install via 'brew install gnu-tar' on macOS)" >&2
  exit 3
fi

"${TAR}" \
  --create \
  --gzip \
  --file="${ARCHIVE_PATH}" \
  --files-from="${MANIFEST_FILE}" \
  --no-recursion \
  --sort=name \
  --owner=0 \
  --group=0 \
  --numeric-owner \
  --mtime='@0' \
  --format=gnu

# SHA256 sidecar (bsdsum and coreutils sha256sum both produce the same content).
if command -v sha256sum >/dev/null 2>&1; then
  ( cd "${OUTPUT_DIR}" && sha256sum "${ARCHIVE_NAME}" ) > "${ARCHIVE_PATH}.sha256"
elif command -v shasum >/dev/null 2>&1; then
  ( cd "${OUTPUT_DIR}" && shasum -a 256 "${ARCHIVE_NAME}" ) > "${ARCHIVE_PATH}.sha256"
else
  echo "package.sh: neither sha256sum nor shasum available" >&2
  exit 4
fi

echo "${ARCHIVE_PATH}"
echo "${ARCHIVE_PATH}.sha256"
