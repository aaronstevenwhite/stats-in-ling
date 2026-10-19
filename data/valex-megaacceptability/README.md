# VALEX and MegaAcceptability teaching bundle

The final factorization application uses the tracked, audited bundle under
`data/valex-megaacceptability/audited/`. It contains the two course inputs and
five frozen products of the registered nested held-out-verb analysis. The page
shows the complete R implementation of participant normalization, ridge fitting,
PCA fitting, inner selection, outer evaluation, and the verb bootstrap. During a
normal render it reads the frozen predictions so that rebuilding the website does
not repeat the full nested analysis.

The bundle contains 958 shared verbs, 109 VALEX dimensions, 50
MegaAcceptability frames, and 238,917 retained native-speaker responses. VALEX
is distributed under GPL 3.0 or later. MegaAcceptability is distributed under CC
BY-SA 4.0. The source pins, extraction decisions, file hashes, registered seeds,
and output hashes are recorded in `bundle-provenance.json`.

Validate the prepared files with:

```bash
Rscript scripts/data-grounding/validate_later_course.R
```

No note page depends on ignored audit artifacts under `research/`.
