#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
catalog_file="${repo_root}/catalog/skills.tsv"

if [ ! -f "$catalog_file" ]; then
  printf 'Missing catalog: %s\n' "$catalog_file" >&2
  exit 1
fi

query="${*:-}"

printf '%-28s %-16s %s\n' "name" "category" "description"
printf '%-28s %-16s %s\n' "----------------------------" "----------------" "-----------"

found=0
while IFS='	' read -r name category triggers description extra; do
  case "$name" in
    ''|'#'*|'name')
      continue
      ;;
  esac

  row="${name} ${category} ${triggers} ${description}"
  if [ -n "$query" ] && ! printf '%s\n' "$row" | grep -i -e "$query" >/dev/null 2>&1; then
    continue
  fi

  printf '%-28s %-16s %s\n' "$name" "$category" "$description"
  found=$((found + 1))
done < "$catalog_file"

if [ "$found" -eq 0 ]; then
  if [ -n "$query" ]; then
    printf 'No skills matched query: %s\n' "$query" >&2
  else
    printf 'No skills found in catalog: %s\n' "$catalog_file" >&2
  fi
  exit 1
fi
