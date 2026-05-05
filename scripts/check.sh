#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
skills_dir="${repo_root}/skills"
catalog_file="${repo_root}/catalog/skills.tsv"
adding_skill_doc="${repo_root}/docs/adding-skill.md"
skill_template="${repo_root}/templates/SKILL.md"

if [ ! -d "$skills_dir" ]; then
  printf 'No skills directory found: %s\n' "$skills_dir" >&2
  exit 1
fi

if [ ! -f "$repo_root/README.md" ]; then
  printf 'Missing README.md in %s\n' "$repo_root" >&2
  exit 1
fi

if [ ! -f "$repo_root/AGENTS.md" ]; then
  printf 'Missing AGENTS.md in %s\n' "$repo_root" >&2
  exit 1
fi

if [ ! -f "$adding_skill_doc" ]; then
  printf 'Missing adding-skill guide: %s\n' "$adding_skill_doc" >&2
  exit 1
fi

if [ ! -f "$skill_template" ]; then
  printf 'Missing skill template: %s\n' "$skill_template" >&2
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

if ! awk -F '	' '
  NR == 1 { next }
  $1 == "" || $1 ~ /^#/ { next }
  {
    key = $2 "\t" $1
    if (previous != "" && key < previous) {
      printf "Catalog must be sorted by category, then name: %s\n", $1 > "/dev/stderr"
      exit 1
    }
    previous = key
  }
' "$catalog_file"; then
  exit 1
fi

leaks=$(find "$repo_root" \
  \( -path "$repo_root/.git" -o -path "$repo_root/.idea" -o -path "$repo_root/tmp" \) -prune -o \
  -type f ! -name '.DS_Store' ! -path "$repo_root/scripts/check.sh" -print |
  xargs grep -nE 'my/site|goauth|goadmin|godi|cmd/bff|APP_ADMIN|platform:check|goauth:check|goadmin:check|/Users/' 2>/dev/null || true)
if [ -n "$leaks" ]; then
  printf '%s\n' "$leaks" >&2
  printf 'Project-specific term leaked into shared rules repository.\n' >&2
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

  if ! grep -q '^# ' "$skill_file"; then
    printf 'SKILL.md is missing top-level heading: %s\n' "$skill_file" >&2
    exit 1
  fi

  if ! grep -q '^## ' "$skill_file"; then
    printf 'SKILL.md should have at least one section heading: %s\n' "$skill_file" >&2
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

  case "$category" in
    architecture|backend|data|documentation|frontend|go|security|testing|tooling|workflow)
      ;;
    *)
      printf 'Unsupported catalog category for %s: %s\n' "$name" "$category" >&2
      exit 1
      ;;
  esac

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

if ! grep -q 'skillhub' "$skills_dir/rules-selector/SKILL.md"; then
  printf 'rules-selector must point installation to skillhub\n' >&2
  exit 1
fi

printf 'Validated %d shared skill(s) under %s\n' "$checked" "$skills_dir"
