#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

if [[ -r "$script_dir/.module-version" ]]; then
    sed -n '1p' "$script_dir/.module-version"
elif git -C "$script_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git -C "$script_dir" rev-parse HEAD
else
    echo "0.1"
fi
