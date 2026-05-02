#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
skills_dir="${repo_root}/skills"
target_root="${HOME}/.agents/skills"

if [ ! -d "$skills_dir" ]; then
  printf 'No skills directory found: %s\n' "$skills_dir" >&2
  exit 1
fi

mkdir -p "$target_root"

installed=0
for skill in "$skills_dir"/*; do
  [ -d "$skill" ] || continue
  [ -f "$skill/SKILL.md" ] || continue

  name=$(basename -- "$skill")
  target="${target_root}/${name}"

  rm -rf "$target"
  cp -R "$skill" "$target"
  installed=$((installed + 1))

  printf 'Installed %s to %s\n' "$name" "$target"
done

if [ "$installed" -eq 0 ]; then
  printf 'No skills with SKILL.md found under %s\n' "$skills_dir" >&2
  exit 1
fi
