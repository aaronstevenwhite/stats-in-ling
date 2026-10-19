# Storme liaison input

The negative-binomial run uses Storme's ([2024](https://doi.org/10.1007/s11525-024-09429-8))
French liaison data from [Zenodo](https://doi.org/10.5281/zenodo.12733801).
The observational row in the prepared table is a final-morpheme, consonant, and
liaison-status combination. The count is reconstructed exactly as in the released
analysis: sum `freqfilms2`, multiply by 100, and truncate to an integer.

The article is CC BY 4.0, but the Zenodo record does not state separate terms for
the dataset. Thus the prepared table remains local and ignored by Git:

```bash
Rscript scripts/data-grounding/prepare_storme.R
```

The script checks the released MD5, source dimensions, response construction,
group counts, and derived SHA-256 checksum.
