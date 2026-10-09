#!/usr/bin/env bash
set -euo pipefail

script_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repository_root="$(cd "${script_directory}/.." && pwd)"
staging_directory="$(mktemp -d /tmp/stats-in-ling-packages.XXXXXX)"

cleanup() {
  rm -rf -- "${staging_directory}"
}
trap cleanup EXIT

mkdir -p \
  "${repository_root}/downloads" \
  "${staging_directory}/ps1-assignment/data" \
  "${staging_directory}/ps1-assignment/scripts" \
  "${staging_directory}/ps2-assignment/data" \
  "${staging_directory}/ps2-assignment/scripts"

cp \
  "${repository_root}/problem-sets/ps1/ps1.qmd" \
  "${repository_root}/problem-sets/ps1/README.md" \
  "${staging_directory}/ps1-assignment/"

cp \
  "${repository_root}/problem-sets/ps1/scripts/prepare_data.R" \
  "${repository_root}/problem-sets/ps1/scripts/fetch_unimorph_data.py" \
  "${repository_root}/problem-sets/ps1/scripts/prepare_unimorph_tables.R" \
  "${staging_directory}/ps1-assignment/scripts/"

cp \
  "${repository_root}/problem-sets/ps1/data/unimorph_genitive_lexemes.csv" \
  "${repository_root}/problem-sets/ps1/data/unimorph_genitive_lexeme_population.csv" \
  "${repository_root}/problem-sets/ps1/data/unimorph_plural_lexemes.csv" \
  "${staging_directory}/ps1-assignment/data/"

cp \
  "${repository_root}/problem-sets/ps2/ps2.qmd" \
  "${repository_root}/problem-sets/ps2/README.md" \
  "${staging_directory}/ps2-assignment/"

cp \
  "${repository_root}/problem-sets/ps2/scripts/prepare_data.R" \
  "${repository_root}/problem-sets/ps2/scripts/fetch_wh_data.py" \
  "${repository_root}/problem-sets/ps2/scripts/prepare_ud_wh_tables.R" \
  "${staging_directory}/ps2-assignment/scripts/"

cp \
  "${repository_root}/problem-sets/ps2/data/provo-content-word-positions.csv" \
  "${repository_root}/problem-sets/ps2/data/ud_wh_dependencies.csv" \
  "${staging_directory}/ps2-assignment/data/"

(
  cd "${staging_directory}"
  zip -X -q -r ps1-assignment.zip ps1-assignment
  zip -X -q -r ps2-assignment.zip ps2-assignment
)

mv \
  "${staging_directory}/ps1-assignment.zip" \
  "${repository_root}/downloads/ps1-assignment.zip"
mv \
  "${staging_directory}/ps2-assignment.zip" \
  "${repository_root}/downloads/ps2-assignment.zip"

printf 'Wrote %s\n' "${repository_root}/downloads/ps1-assignment.zip"
printf 'Wrote %s\n' "${repository_root}/downloads/ps2-assignment.zip"
