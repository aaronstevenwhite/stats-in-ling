# CommitmentBank local preparation

CommitmentBank contains participant-level ratings from -3 to 3 for 1,200
discourses. The study and variables are described by de Marneffe, Simons, and
Tonhauser ([2019](https://doi.org/10.18148/sub/2019.v23i2.601)); the source table
is in the [CommitmentBank repository](https://github.com/mcdm/CommitmentBank).

The article is CC BY 4.0, but the repository states no license for the data and
the source includes passages from BNC, Switchboard, and the Wall Street Journal.
The course must not redistribute either the source or a derivative until those
terms are resolved. The local preparation removes `Context`, `Target`, and
`Prompt`, but the output remains ignored by Git:

```bash
Rscript scripts/data-grounding/prepare_commitmentbank.R
```

The script pins the local source checksum and verifies the full rating,
discourse, annotator, and repeated-rating structure.
