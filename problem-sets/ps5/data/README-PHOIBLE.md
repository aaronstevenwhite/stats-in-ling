# PHOIBLE teaching data

Run the following command from the repository root:

```bash
Rscript problem-sets/ps5/scripts/prepare-phoible.R
```

The script retrieves the pinned PHOIBLE 2.0 CLDF archive from Zenodo, checks its MD5 and SHA 256 values, and writes `phoible-pilot.rds` in this directory. The archive and generated R object are ignored by Git.

The archived release is Moran and McCloy's (2019) PHOIBLE 2.0, DOI `10.5281/zenodo.2593234`. The PHOIBLE site licenses the data under Creative Commons Attribution ShareAlike 3.0 Unported.

The preparation retains consonant and vowel memberships but excludes tones and rows explicitly marked as marginal. It does not replace blank marginality values with `false` because a blank records that the source did not report marginal status.
