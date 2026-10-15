#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
shared_root="${KERNEL_MODULE_CI_ROOT:-$repo_root/ci/kernel-module-ci}"
if [[ ! -x "$shared_root/scripts/test-qemu.sh" && -z "${KERNEL_MODULE_CI_ROOT:-}" ]]; then
  shared_root="$repo_root/../kernel-module-ci"
fi
[[ -x "$shared_root/scripts/test-qemu.sh" ]] || {
  echo "error: shared kernel-module-ci harness missing at $shared_root" >&2
  exit 1
}

export KMOD_CI_MODULE_NAME="xt-ts3init"
export KMOD_CI_ENV_NAME="ts3init-local"
export KMOD_CI_REPO_ROOT="$repo_root"
export KMOD_CI_HOST_BUILD_COMMAND="./scripts/test-install-dkms.sh"
exec "$shared_root/scripts/test-qemu.sh" "$@"
