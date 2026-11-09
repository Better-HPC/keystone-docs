#!/usr/bin/env bash
# Restrict submodule checkouts to the files used by the documentation.
set -euo pipefail

root="$(git rev-parse --show-toplevel)"
target="docs/assets/submodules"

# Usage: include <submodule> [path...]
# Paths are relative to the submodule root. A trailing slash includes a whole
# directory and globs are supported. With no paths, nothing is checked out.
include() {
  local name="$1"; shift
  local dir="$root/$target/$name"

  git -C "$root" submodule update --init -- "$target/$name"

  # A leading slash anchors each pattern to the submodule root.
  # An empty pattern list leaves root files in place, so exclude everything explicitly.
  local patterns=("!/*")
  (( $# )) && patterns=("${@/#//}")

  git -C "$dir" sparse-checkout set --no-cone "${patterns[@]}"

  local path
  for path in "$@"; do
    compgen -G "$dir/${path%/}" > /dev/null || { echo "Not found in $name: $path" >&2; exit 1; }
  done
}

include keystone-api \
  openapi.yml \
  keystone_api/templates/

include keystone-demo \
  demo/docker-compose.yml \
  demo/api.env \
  demo/db.env \
  demo/prometheus/ \
  demo/grafana/dashboards/
