# Problem Set 4: Mixed effects models

Extract the complete package and open ps4.ipynb with the R kernel. Run it from the extracted ps4-assignment directory. Complete all six exercises, including equations, code, and interpretation.

Exercises 1–3 fit frequentist logistic mixed models to written binary inference judgments with lme4. Exercises 4–6 develop and fit a Bayesian ordered beta mixed model of certainty slider ratings with brms, ordbetareg, and CmdStan. Install these R packages:

    install.packages(c("lme4", "brms", "ordbetareg", "posterior", "dplyr", "ggplot2", "IRkernel"))
    install.packages("cmdstanr", repos = c("https://stan-dev.r-universe.dev", getOption("repos")))
    cmdstanr::install_cmdstan()
    IRkernel::installspec()

CmdStan requires a C++ toolchain. On macOS, install the Xcode command line tools; on Windows, install the Rtools version appropriate for R. See https://mc-stan.org/cmdstanr/articles/cmdstanr.html.

The frequentist section focuses on six predicates from the complete binary table and includes two full data fits, a Wald confidence interval, and five participant fold fits. The Bayesian section fits one ordered beta mixed model with four chains, 1,500 warmup iterations and 3,000 retained iterations per chain. Allow time for compilation, sampling, and prediction; runtime depends on the machine. The Bayesian fit is saved under stan_cache and reused when its specification and data match. Keep that directory while working. If you change sampling iterations, set file_refit = "always" for that run: "on_change" does not detect iteration changes. Do not interpret a model that fails the stated diagnostics.

The binary responses are recorded choices, not thresholded slider ratings. The slider table retains exact zeros and ones. high_c codes the experiment's prior probability condition, not a participant's measured prior belief. See data/README.md for measurements and provenance.

The package contains the handout, clean student notebook, teaching tables, data documentation, and preparation script. Fitted models and the answer key are excluded.

The tables are ready to use. To reproduce them from the authors' pinned repository revision, run Rscript scripts/prepare_data.R from the assignment directory. This optional step requires digest and internet access. You can instead pass a local source repository path as the first argument.
