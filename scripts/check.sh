#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
skills_dir="${repo_root}/skills"
catalog_file="${repo_root}/catalog/skills.tsv"

if [ ! -d "$skills_dir" ]; then
  printf 'No skills directory found: %s\n' "$skills_dir" >&2
  exit 1
fi

if [ ! -f "$repo_root/README.md" ]; then
  printf 'Missing README.md in %s\n' "$repo_root" >&2
  exit 1
fi

if [ ! -f "$repo_root/scripts/install.sh" ]; then
  printf 'Missing scripts/install.sh in %s\n' "$repo_root" >&2
  exit 1
fi

if [ ! -f "$repo_root/scripts/list.sh" ]; then
  printf 'Missing scripts/list.sh in %s\n' "$repo_root" >&2
  exit 1
fi

if [ ! -f "$catalog_file" ]; then
  printf 'Missing catalog: %s\n' "$catalog_file" >&2
  exit 1
fi

if ! awk 'NR == 1 { exit ($0 == "name\tcategory\ttriggers\tdescription" ? 0 : 1) }' "$catalog_file"; then
  printf 'Catalog header must be: name<TAB>category<TAB>triggers<TAB>description\n' >&2
  exit 1
fi

if ! awk -F '	' '
  NR == 1 { next }
  $1 == "" || $1 ~ /^#/ { next }
  seen[$1]++ { printf "Duplicate catalog skill: %s\n", $1 > "/dev/stderr"; exit 1 }
' "$catalog_file"; then
  exit 1
fi

checked=0
for skill in "$skills_dir"/*; do
  [ -d "$skill" ] || continue

  skill_name=$(basename -- "$skill")
  case "$skill_name" in
    ''|*[!a-z0-9_-]*)
      printf 'Invalid skill directory name: %s\n' "$skill_name" >&2
      exit 1
      ;;
  esac

  skill_file="$skill/SKILL.md"
  if [ ! -f "$skill_file" ]; then
    printf 'Missing SKILL.md for %s\n' "$skill_name" >&2
    exit 1
  fi

  if ! awk 'NR == 1 { exit ($0 == "---" ? 0 : 1) }' "$skill_file"; then
    printf 'SKILL.md must start with front matter: %s\n' "$skill_file" >&2
    exit 1
  fi

  if ! grep -q '^name: ' "$skill_file"; then
    printf 'SKILL.md is missing name: %s\n' "$skill_file" >&2
    exit 1
  fi

  front_name=$(sed -n 's/^name: //p' "$skill_file" | sed -n '1p')
  if [ "$front_name" != "$skill_name" ]; then
    printf 'SKILL.md name does not match directory: %s has name: %s\n' "$skill_name" "$front_name" >&2
    exit 1
  fi

  if ! grep -q '^description: ' "$skill_file"; then
    printf 'SKILL.md is missing description: %s\n' "$skill_file" >&2
    exit 1
  fi

  if ! awk -F '	' -v skill_name="$skill_name" '
    NR > 1 && $1 == skill_name { found = 1 }
    END { exit(found ? 0 : 1) }
  ' "$catalog_file"; then
    printf 'Skill is missing from catalog: %s\n' "$skill_name" >&2
    exit 1
  fi

  checked=$((checked + 1))
done

if [ "$checked" -eq 0 ]; then
  printf 'No skills with SKILL.md found under %s\n' "$skills_dir" >&2
  exit 1
fi

catalog_checked=0
while IFS='	' read -r name category triggers description extra; do
  case "$name" in
    ''|'#'*|'name')
      continue
      ;;
  esac

  case "$name" in
    *[!a-z0-9_-]*)
      printf 'Invalid catalog skill name: %s\n' "$name" >&2
      exit 1
      ;;
  esac

  if [ -z "$category" ] || [ -z "$triggers" ] || [ -z "$description" ]; then
    printf 'Catalog row has empty fields for skill: %s\n' "$name" >&2
    exit 1
  fi

  if [ -n "${extra:-}" ]; then
    printf 'Catalog row has too many columns for skill: %s\n' "$name" >&2
    exit 1
  fi

  if [ ! -f "$skills_dir/$name/SKILL.md" ]; then
    printf 'Catalog references missing skill: %s\n' "$name" >&2
    exit 1
  fi

  catalog_checked=$((catalog_checked + 1))
done < "$catalog_file"

if [ "$catalog_checked" -ne "$checked" ]; then
  printf 'Catalog count (%d) does not match skill count (%d)\n' "$catalog_checked" "$checked" >&2
  exit 1
fi

if ! grep -q 'catalog/skills.tsv' "$skills_dir/rules-selector/SKILL.md"; then
  printf 'rules-selector must reference catalog/skills.tsv\n' >&2
  exit 1
fi

printf 'Validated %d shared skill(s) under %s\n' "$checked" "$skills_dir"
