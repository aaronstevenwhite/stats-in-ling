"""Align the PS4 student notebook and answer key.

The public notebook supplies all explanatory prose. The answer key copies that
notebook and replaces only the response fields with worked solutions from the
previous key. This prevents the instructor version from restoring outdated
claims about thinning, convergence, and model comparison.
"""

from __future__ import annotations

import json
from copy import deepcopy
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
STUDENT = ROOT / "problem-sets" / "ps4" / "ps4.ipynb"
ANSWER = ROOT / "problem-sets" / "ps4" / "ps4_answer_key.ipynb"


def source_text(cell: dict) -> str:
    source = cell.get("source", "")
    return "".join(source) if isinstance(source, list) else source


def lines(text: str) -> list[str]:
    return text.splitlines(keepends=True)


def set_source(cell: dict, text: str) -> None:
    cell["source"] = lines(text.rstrip() + "\n")


def code_after(notebook: dict, marker: str) -> dict:
    cells = notebook["cells"]
    for index, cell in enumerate(cells):
        if marker in source_text(cell):
            for later in cells[index + 1 :]:
                if later["cell_type"] == "code":
                    return deepcopy(later)
                if later["cell_type"] == "markdown" and "## Exercise" in source_text(later):
                    break
    raise ValueError(f"No code cell found after {marker}")


def markdown_after(notebook: dict, marker: str) -> dict:
    cells = notebook["cells"]
    for index, cell in enumerate(cells):
        if marker in source_text(cell):
            for later in cells[index + 1 :]:
                if later["cell_type"] == "markdown":
                    return deepcopy(later)
    raise ValueError(f"No markdown cell found after {marker}")


with STUDENT.open(encoding="utf-8") as stream:
    student = json.load(stream)
with ANSWER.open(encoding="utf-8") as stream:
    old_answer = json.load(stream)

replacements = {
    "## From Frequentist to Bayesian Regression": r'''## Bayesian regression begins with a likelihood

A regression model first says how an outcome could have been generated. For a Gaussian linear regression, that statement is the likelihood:

$$p(\mathbf{y} \mid \mathbf{X}, \beta_0, \beta_1, \ldots, \beta_p, \sigma) = \prod_{i=1}^N \operatorname{Normal}(y_i; \beta_0 + \beta_1 x_{i1} + \cdots + \beta_p x_{ip}, \sigma)$$

Each factor describes one outcome $y_i$. Its mean is a linear function of the predictors, and $\sigma$ describes residual variation around that mean. Maximum likelihood estimation asks which parameter values make the observed outcomes most probable under this model.

A Bayesian analysis keeps the same likelihood and adds prior distributions for its parameters. Bayes' rule combines those two parts:

$$p(\beta_0, \ldots, \beta_p, \sigma \mid \mathbf{y}, \mathbf{X}) \propto p(\mathbf{y} \mid \mathbf{X}, \beta_0, \ldots, \beta_p, \sigma) p(\beta_0, \ldots, \beta_p, \sigma).$$

The posterior is thus a distribution over regression parameters. A single coefficient is no longer represented only by one estimate. It is represented by the posterior values that remain plausible after the data update the prior.

For this model, we will approximate the posterior with Markov chain Monte Carlo (MCMC). Before using that approximation, we need to understand what the Markov chain is doing and how it can fail.''',
    "## The Metropolis Hastings sampler": r'''## A random walk Metropolis sampler

The earlier MCMC chapter constructed a Metropolis sampler for one Bernoulli parameter. At iteration $k$, the chain began at $\pi_{k-1}$ and proposed a nearby value $\pi'$ from $q(\pi' \mid \pi_{k-1})$. It accepted that proposal with probability based on the ratio of posterior densities and proposal densities:

$$\alpha = \min\left\{1, \frac{p(\pi' \mid \mathbf{x})q(\pi_{k-1} \mid \pi')}{p(\pi_{k-1} \mid \mathbf{x})q(\pi' \mid \pi_{k-1})}\right\}.$$

If the proposal was accepted, the next state was $\pi_k=\pi'$. If it was rejected, the chain remained at $\pi_k=\pi_{k-1}$. This repeated value is part of the Markov chain. Removing it would change the distribution represented by the draws.

The proposal width controlled a tradeoff. Very small proposals were often accepted but moved slowly. Very large proposals moved farther when accepted but were often rejected. The useful balance depended on the target and proposal, so an acceptance rate was a diagnostic for that sampler rather than a universal threshold.

The draws were also autocorrelated. Autocorrelation reduces the information in a fixed number of iterations. Thinning would discard draws without repairing the sampler, so we retained the post adaptation draws and summarized their effective sample size.

The one parameter example could be checked against an available conjugate posterior. That check tested the implementation on a case whose answer was known. A regression posterior has more parameters and no such convenient answer, which makes computational diagnostics part of the analysis.''',
    "## From Metropolis-Hastings to": r'''## Why move beyond random walk proposals?

A Gaussian regression with two predictors already has four unknown quantities: $\beta_0$, $\beta_1$, $\beta_2$, and $\sigma$. These quantities may also be correlated in the posterior. A random walk that changes one quantity at a time can then move slowly because a useful change in one coefficient may require a coordinated change in another.

A joint random walk proposal does not automatically solve the problem. Its scale must work across all four dimensions, and its shape must approximate their posterior dependence. A poor choice produces either short movements or frequent rejection.

Hamiltonian Monte Carlo (HMC) constructs a different proposal. It adds an auxiliary momentum to the parameter vector and uses gradients of the log posterior to trace a numerical trajectory. The gradient supplies local directional information. This may let a proposal travel farther than a random walk while remaining in a region of comparable posterior density.

The No U Turn Sampler chooses a trajectory length at each iteration and adapts a step size during warmup. Stan implements this sampler and computes the gradients with automatic differentiation. Adaptation reduces manual tuning, but it does not establish that the computation succeeded. We still need to examine chain agreement, effective sample size, divergences, and tree depth warnings.''',
    "## Why Convergence Diagnostics Matter": r'''## What a diagnostic can tell us

MCMC returns dependent draws from a Markov chain. After warmup, we want the retained part of each chain to behave as though it is exploring the same stationary distribution. We also want enough effective draws to estimate the posterior summaries we plan to report.

No single diagnostic proves that these conditions hold. Several chains can agree because they reached the same posterior region, or because they all missed another region. A trace plot can look stable while moving too slowly to estimate a tail quantity. A large effective sample size for one coefficient says nothing about a different coefficient.

We therefore use a diagnostic set. Chain comparisons ask whether independently initialized chains agree. Trace plots show drift, sticking, and slow movement. Effective sample size describes the information available for a particular marginal summary. Sampler warnings identify numerical problems specific to Hamiltonian trajectories.

The interpretation depends on the inferential target. Estimating a posterior mean to one decimal place may require fewer effective draws than estimating a small tail probability. Diagnostics are evidence about a computation, not a certificate attached to the model as a whole.''',
    "## What You Observed in Lecture 9 vs. What Stan Provides": r'''## From a one parameter chain to Stan

The one parameter sampler and Stan expose related checks at different levels:

| Question | One parameter sampler | Stan fit |
|:--|:--|:--|
| How did the chain move? | Proposal acceptance and a trace plot | Trace plots for several chains and sampler diagnostics |
| How dependent are adjacent draws? | An autocorrelation plot | Bulk and tail effective sample sizes |
| Did independent runs agree? | Separate runs inspected by hand | Rank normalized $\hat{R}$ |
| Did numerical integration fail? | Not applicable to the random walk | Divergences and energy diagnostics |
| Did trajectory construction stop at its limit? | Not applicable to the random walk | Tree depth warnings |

The additional summaries answer specific questions. They should be read together rather than collapsed into a single pass or fail label.''',
    "## Key Diagnostic Statistics": r'''## Four diagnostic questions

The first question is whether the chains agree. Rank normalized $\hat{R}$ compares within chain and between chain variation. Values near one are necessary evidence of agreement. A value above 1.01 is a warning under the current convention. A value below that threshold does not prove convergence because several chains may miss the same region.

The second question is whether the retained draws contain enough information. Effective sample size summarizes the precision lost to autocorrelation. Stan reports a bulk quantity for central summaries and a tail quantity for quantiles. The amount needed depends on the posterior summary and numerical precision required.

The third question is whether the Hamiltonian trajectory was integrated accurately. A divergence marks a draw for which the numerical trajectory could not follow part of the posterior geometry. Every divergence should be investigated. A smaller step size may help, but a reparameterization or revised model may be required.

The fourth question is whether trajectory construction repeatedly reached its configured tree depth. This is often an efficiency warning. Persistent warnings may leave relevant quantities with low effective sample sizes. Raising the limit permits longer trajectories, but it can also make a poor parameterization more expensive.

These four questions determine the order of inspection. Compare chains and trace behavior, determine whether the effective sample sizes support the summaries of interest, investigate divergences, and then inspect tree depth and energy warnings. If a check fails, name the affected quantity before changing the computation.''',
    "## What Are Posterior Predictive Checks?": r'''## Can the fitted model reproduce the observed pattern?

A posterior predictive check compares observed data with data generated by the fitted model. The comparison begins with a posterior draw $\theta^{(s)}$ and then draws a replicated outcome:

$$\theta^{(s)} \sim p(\theta \mid y), \qquad y^{\operatorname{rep}(s)} \sim p(y \mid \theta^{(s)}).$$

Repeating these two draws produces a posterior predictive distribution. We can compare a feature of the observed outcomes with the same feature in the replicated outcomes. The feature must be chosen because it bears on a possible model failure.

For lexical decision times, the overall mean is only one feature. We might also compare the standard deviation, the upper tail, or the relationship between residual spread and word frequency. A match on the mean does not imply a match on those other features.

A mismatch localizes a limitation of the model. It does not say which replacement model is correct. In Stan, the `generated quantities` block creates replicated outcomes from each retained parameter draw so that these comparisons use the fitted posterior.''',
}

for cell in student["cells"]:
    text = source_text(cell)
    for marker, replacement in replacements.items():
        if marker in text:
            set_source(cell, replacement)
            break

# Exercise 3.1 needs a response cell for compiling the revised Stan program.
for index, cell in enumerate(student["cells"]):
    if source_text(cell).startswith("**Updated Stan code"):
        compile_cell = {
            "cell_type": "code",
            "execution_count": None,
            "metadata": {},
            "outputs": [],
            "source": lines(
                "# YOUR CODE HERE\n"
                "# 1. Compile models/simple_regression_pp_check.stan\n"
                "# 2. Sample with the same data list and sampling settings\n"
                "# 3. Store the fit as fit_pp for the next exercise\n"
            ),
        }
        if index + 1 >= len(student["cells"]) or student["cells"][index + 1]["cell_type"] != "code":
            student["cells"].insert(index + 1, compile_cell)
        break

with STUDENT.open("w", encoding="utf-8") as stream:
    json.dump(student, stream, indent=1, ensure_ascii=False)
    stream.write("\n")

# Capture the worked response cells before replacing the old answer key.
worked_code = {
    marker: code_after(old_answer, marker)
    for marker in [
        "Exercise 1.1", "Exercise 1.3", "Exercise 1.4",
        "Exercise 2.1", "Exercise 2.2", "Exercise 2.3",
        "Exercise 2.4", "Exercise 2.5", "Exercise 2.6",
        "Exercise 3.1", "Exercise 3.2", "Exercise 3.3",
        "Exercise 4.2", "Exercise 4.3", "Exercise 4.4", "Exercise 4.5",
    ]
}
worked_markdown = {
    marker: markdown_after(old_answer, marker)
    for marker in ["Exercise 1.2", "Exercise 3.1", "Exercise 4.1"]
}

answer = deepcopy(student)
answer_title = source_text(answer["cells"][0]).replace(
    "Problem Set 4", "Problem Set 4 Answer Key", 1
)
set_source(answer["cells"][0], answer_title)

for index, cell in enumerate(answer["cells"]):
    text = source_text(cell)
    if cell["cell_type"] == "markdown":
        for marker, worked in worked_markdown.items():
            if marker in text:
                for later_index in range(index + 1, len(answer["cells"])):
                    later = answer["cells"][later_index]
                    if later["cell_type"] == "markdown":
                        answer["cells"][later_index] = deepcopy(worked)
                        break
                break

for index, cell in enumerate(answer["cells"]):
    text = source_text(cell)
    if cell["cell_type"] != "markdown":
        continue
    for marker, worked in worked_code.items():
        if marker in text:
            for later_index in range(index + 1, len(answer["cells"])):
                later = answer["cells"][later_index]
                if later["cell_type"] == "code":
                    answer["cells"][later_index] = deepcopy(worked)
                    break
                if later["cell_type"] == "markdown" and "## Exercise" in source_text(later):
                    break
            break

with ANSWER.open("w", encoding="utf-8") as stream:
    json.dump(answer, stream, indent=1, ensure_ascii=False)
    stream.write("\n")

