#!/usr/bin/env bash
set -euo pipefail
repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
work_dir=$(mktemp -d /tmp/xt-ts3init-dkms-test.XXXXXX)
trap 'rm -rf "$work_dir"' EXIT
module_name=xt-ts3init
module_version=$(cd "$repo_root" && ./version.sh)
target_kernel=6.12.109-x4b+zen2
active_kernel=6.12.109-x4bparse+zen2
run_case() {
  local name=$1 initial_kernel=$2 hide_status=$3 expect_add=$4
  local case_dir="$work_dir/$name"
  local source_root="$case_dir/usr-src" source_dir="$case_dir/usr-src/$module_name-$module_version"
  local state_root="$case_dir/var-lib-dkms" state_dir="$case_dir/var-lib-dkms/$module_name/$module_version"
  local log_file="$case_dir/dkms.log"
  mkdir -p "$case_dir"
  if [[ -n "$initial_kernel" ]]; then mkdir -p "$source_dir" "$state_dir/kernels"; touch "$source_dir/old-source" "$state_dir/kernels/$initial_kernel"; fi
  (cd "$repo_root"; PATH="$repo_root/scripts/test-fixtures/install-dkms:$PATH" DKMS_SOURCE_ROOT="$source_root" DKMS_STATE_ROOT="$state_root" KVERSION="$target_kernel" \
    MOCK_DKMS_LOG="$log_file" MOCK_DKMS_STATE="$state_dir" MOCK_HIDE_STATUS="$hide_status" MOCK_MODULE_NAME="$module_name" MOCK_MODULE_VERSION="$module_version" MOCK_SOURCE_DIR="$source_dir" ./install-dkms.sh --install)
  test -f "$state_dir/kernels/$target_kernel"; test -f "$source_dir/dkms.conf"; test ! -e "$source_dir/old-source"
  grep -Fq "build $module_name/$module_version -k $target_kernel" "$log_file"
  if [[ "$expect_add" == true ]]; then grep -Fq "add $module_name/$module_version" "$log_file"; else ! grep -Fq "add $module_name/$module_version" "$log_file"; fi
}
run_case new-tree "" false true
run_case hidden-existing-tree "$active_kernel" true false
run_case last-kernel "$target_kernel" false true
echo "install-dkms tests passed"
