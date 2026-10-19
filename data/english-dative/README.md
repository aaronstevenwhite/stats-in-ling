# English dative-alternation teaching table

`dative-alternation.csv` is a renamed, value-preserving extract of the 3,263-row
`languageR::dative` dataset used by Bresnan et al. (2007). The observations are
tokens from the spoken Switchboard corpus and the written Wall Street Journal
portion of the Penn Treebank. The response `recipient_realization` distinguishes
NP and PP realizations of the recipient.

The table contains 2,360 spoken and 903 written observations. `speaker_id` is
available only for the spoken observations, so all 903 written observations
have structurally absent speaker identifiers. No other column is missing. This
protocol-defined pattern makes the table suitable for distinguishing stored
missing values from an unspecified response process. It does not establish how
a hypothetical written-text speaker identifier would have been distributed.

The count variable `recipient_length_words` ranges from 1 to 31, while
`theme_length_words` ranges from 1 to 46. The table contains 75 verb types and
849 PP responses.

Bresnan et al. use these corpus tokens to model how lexical, semantic,
discourse, and structural predictors jointly condition dative realization.
The source paper and the `languageR` data documentation supply the variable
interpretations. Tokens repeat verbs, and Switchboard tokens also repeat
speakers, so row-wise independence is not licensed. The teaching extract
renames columns without changing values; its first missing-data use concerns
the structurally absent written-source speaker IDs, not a reanalysis of the
paper's full multivariable claim. No original paper analysis script is bundled
with the archived `languageR` object.

Revalidate and copy the table with:

```sh
Rscript scripts/data-grounding/prepare_dative.R
```

To reconstruct it from the archived `languageR` 1.5.0 source package, use
`problem-sets/ps3/scripts/prepare_data.R`. The canonical CSV is retained because
the installed package version may change.

Primary paper: <https://web.stanford.edu/~bresnan/qs-submit.pdf>. Exact package
archive: <https://cran.r-project.org/src/contrib/Archive/languageR/>.

## Checksum

`02a49e0ef2da7df73a7ef622ddf31a55ba13c52a9b66bcfdf2fef3def7932bea`

