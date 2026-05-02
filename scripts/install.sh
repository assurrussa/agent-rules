#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
target="${HOME}/.agents/skills/go-project-rules"

mkdir -p "$(dirname -- "$target")"
rm -rf "$target"
cp -R "$repo_root/skills/go-project-rules" "$target"

printf 'Installed go-project-rules to %s\n' "$target"
