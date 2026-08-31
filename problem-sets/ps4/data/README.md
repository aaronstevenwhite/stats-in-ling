# CommitmentBank data preparation

Run the preparation script from the repository root:

```sh
Rscript problem-sets/ps4/scripts/prepare-commitmentbank.R
```

The script retrieves the official participant-level CSV, checks its frozen SHA-256
checksum, and creates `commitmentbank-model.csv`. The prepared table contains only
the response and analysis variables. It omits the corpus passages and prompts.

The article is distributed under CC BY 4.0. The data repository does not state a
separate license, and the source CSV contains passages drawn from BNC, Switchboard,
and the Wall Street Journal. Thus neither the source CSV nor the prepared table is
committed to this repository.

`commitmentbank-grouped-cv.csv` is a course-generated model output. It contains one
row per anonymous held-out case, with the fixed fold, factivity class, embedding
environment, rating count, and two joint log predictive densities. It contains no
source discourse identifier or corpus text. Students use this small table to audit
the grouped comparison without refitting ten computationally expensive models.
