#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
skills_dir="${repo_root}/skills"
catalog_file="${repo_root}/catalog/skills.tsv"
target_root="${AGENT_SKILLS_DIR:-}"

if [ -z "$target_root" ]; then
  if [ -z "${HOME:-}" ]; then
    printf 'HOME is not set; set AGENT_SKILLS_DIR explicitly.\n' >&2
    exit 1
  fi
  target_root="${HOME}/.agents/skills"
fi

if [ ! -d "$skills_dir" ]; then
  printf 'No skills directory found: %s\n' "$skills_dir" >&2
  exit 1
fi

if [ ! -f "$catalog_file" ]; then
  printf 'Missing catalog: %s\n' "$catalog_file" >&2
  exit 1
fi

catalog_names() {
  while IFS='	' read -r name category triggers description extra; do
    case "$name" in
      ''|'#'*|'name')
        continue
        ;;
    esac
    printf '%s\n' "$name"
  done < "$catalog_file"
}

catalog_has() {
  wanted="$1"
  for catalog_name in $(catalog_names); do
    if [ "$catalog_name" = "$wanted" ]; then
      return 0
    fi
  done
  return 1
}

if [ "$#" -eq 0 ]; then
  selected=$(catalog_names)
elif [ "$#" -eq 1 ] && [ "$1" = "--all" ]; then
  selected=$(catalog_names)
else
  selected=""
  for name in "$@"; do
    case "$name" in
      --all)
        printf 'Use either --all or explicit skill names, not both.\n' >&2
        exit 1
        ;;
    esac

    if ! catalog_has "$name"; then
      printf 'Unknown skill: %s\n' "$name" >&2
      printf 'Run: sh scripts/list.sh\n' >&2
      exit 1
    fi

    selected="${selected}
${name}"
  done
fi

mkdir -p "$target_root"

installed=0
for name in $selected; do
  skill="${skills_dir}/${name}"

  if [ ! -d "$skill" ] || [ ! -f "$skill/SKILL.md" ]; then
    printf 'Cataloged skill is missing SKILL.md: %s\n' "$name" >&2
    exit 1
  fi

  target="${target_root}/${name}"

  rm -rf "$target"
  cp -R "$skill" "$target"
  installed=$((installed + 1))

  printf 'Installed %s to %s\n' "$name" "$target"
done

if [ "$installed" -eq 0 ]; then
  printf 'No skills selected from %s\n' "$catalog_file" >&2
  exit 1
fi
