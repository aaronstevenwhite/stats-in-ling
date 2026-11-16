#!/usr/bin/env bash
set -euo pipefail

script_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repository_root="$(cd "${script_directory}/.." && pwd)"
staging_directory="$(mktemp -d /tmp/stats-in-ling-packages.XXXXXX)"

cleanup() {
  rm -rf -- "${staging_directory}"
}
trap cleanup EXIT

# With no arguments, rebuild every supported package. Pass ps3 to rebuild only PS3.
if [[ $# -eq 0 ]]; then
  set -- ps1 ps2 ps3
fi
# Validate all selections before writing any outputs.
for problem_set in "$@"; do
  case "${problem_set}" in
    ps1|ps2|ps3) ;;
    *) printf 'Unknown problem set: %s\n' "${problem_set}" >&2; exit 1 ;;
  esac
done

mkdir -p "${repository_root}/downloads"
for problem_set in "$@"; do
  source_directory="${repository_root}/problem-sets/${problem_set}"
  package_name="${problem_set}-assignment"
  package_directory="${staging_directory}/${package_name}"
  source_name="${problem_set}.qmd"
  if [[ "${problem_set}" == ps3 ]]; then
    source_name="ps3-dative-alternation.qmd"
  fi

  python3 "${script_directory}/qmd_to_r_notebook.py" \
    "${source_directory}/${source_name}" \
    "${source_directory}/${problem_set}.ipynb"
  mkdir -p "${package_directory}/data" "${package_directory}/scripts"
  cp \
    "${source_directory}/${source_name}" \
    "${source_directory}/${problem_set}.ipynb" \
    "${source_directory}/README.md" \
    "${package_directory}/"

  # Explicit allowlists exclude keys, grades, submissions, and historical packages.
  case "${problem_set}" in
    ps1)
      cp \
        "${source_directory}/scripts/prepare_data.R" \
        "${source_directory}/scripts/fetch_unimorph_data.py" \
        "${source_directory}/scripts/prepare_unimorph_tables.R" \
        "${package_directory}/scripts/"
      cp \
        "${source_directory}/data/unimorph_genitive_lexemes.csv" \
        "${source_directory}/data/unimorph_genitive_lexeme_population.csv" \
        "${source_directory}/data/unimorph_plural_lexemes.csv" \
        "${package_directory}/data/"
      ;;
    ps2)
      cp \
        "${source_directory}/scripts/prepare_data.R" \
        "${source_directory}/scripts/fetch_wh_data.py" \
        "${source_directory}/scripts/prepare_ud_wh_tables.R" \
        "${package_directory}/scripts/"
      cp \
        "${source_directory}/data/provo-content-word-positions.csv" \
        "${source_directory}/data/ud_wh_dependencies.csv" \
        "${package_directory}/data/"
      ;;
    ps3)
      cp "${source_directory}/scripts/prepare_data.R" "${package_directory}/scripts/"
      cp \
        "${source_directory}/data/mald-items.csv" \
        "${source_directory}/data/mald-provenance.json" \
        "${source_directory}/data/dative-alternation.csv" \
        "${package_directory}/data/"
      ;;
  esac

  (cd "${staging_directory}" && zip -X -q -r "${package_name}.zip" "${package_name}")
  mv "${staging_directory}/${package_name}.zip" "${repository_root}/downloads/${package_name}.zip"
  printf 'Wrote %s\n' "${repository_root}/downloads/${package_name}.zip"
done
