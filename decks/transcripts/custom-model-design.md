# Custom generative models for annotations

This transcript is generated from the speaker notes in the slide source. Slide identifiers, titles, note-page provenance, and order are identical.

## Slide 1: Custom generative models for annotations

Source note: `custom-models/index.qmd`

Welcome to Custom generative models for annotations. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.

## Slide 2: Custom model design

Source note: `custom-models/index.qmd`

Our next step is Custom model design.

## Slide 3: UDS: the empirical object

Source note: `custom-models/index.qmd`

The data source is White et al. (2020), UDS. It provides predicate-node and annotator responses from Universal Decompositional Semantics.

## Slide 4: Custom model design

Source note: `custom-models/index.qmd`

An annotation is an observed response produced by a measurement procedure. It is not the linguistic property that the procedure is meant to inform. The measurement procedure connects a linguistic unit, a prompt, an annotator, a response scale, and the recorded answer. A custom likelihood should encode those parts without turning a response into direct access to the target property.

## Slide 5: Custom model design

Source note: `custom-models/index.qmd`

This module uses two annotation resources, one of them non-English. The natural-parts task in Universal Decompositional Semantics (UDS) records binary answers about predicate nodes in English dependency graphs; Gantt, Glass, and White (2022) describe the event-structure protocol. The course extract is pinned to the official `decomp` 0.3.2 release: the data are CC BY-SA 4.0, while the toolkit code is MIT-licensed. The ITU/IMST Turkish PropBank records worker selections among predicate-specific role descriptions, followed by aggregation and adjudication; the project release supplies the source data and guidelines.

## Slide 6: Custom model design

Source note: `custom-models/index.qmd`

The Turkish PropBank project site applies CC BY-NC-SA 4.0 to resources built in the project, while the repository's short license header names the Turkish frame files specifically. The course extract follows the project-wide noncommercial statement, but the narrower repository header should not be read as a separate license grant for every crowd export.

## Slide 7: Custom model design

Source note: `custom-models/index.qmd`

The two response variables answer different questions. UDS records whether an annotator answered yes to one natural-parts gate. Turkish PropBank records whether an individual role-description selection agrees with the project's adjudication. Neither response is an independently observed linguistic truth.

## Slide 8: From the protocol to a probability model

Source note: `custom-models/index.qmd`

A data-generating process first specifies the random steps that could produce the UDS gate responses. Writing a joint model then translates those steps into a joint probability distribution over the observed item--annotator pairs. Parameter recovery asks whether the complete procedure can recover known values under the released incidence design.

## Slide 9: From the protocol to a probability model

Source note: `custom-models/index.qmd`

The Turkish PropBank analysis next treats annotations as measurements, distinguishing agreement with adjudication from label validity or worker competence. Returning to UDS, annotator effects represent stable response-location differences among annotators.

## Slide 10: From the protocol to a probability model

Source note: `custom-models/index.qmd`

The UDS measurement-model capstone combines the likelihood, priors, parameter-recovery study, partial pooling, posterior summaries, and posterior predictive checks. Finally, gated annotations retains the protocol's symbolic gate-and-branch factorization while using only the observed natural-parts gate numerically. The raw confidence field and conditional follow-up branches remain outside the empirical model because their representation could not be verified against the paper and release.

## Slide 11: What the sequence supports

Source note: `custom-models/index.qmd`

The UDS item is a predicate node anchored in sentence context, not a context-free verb lemma. The Turkish PropBank item is one predicate-specific argument candidate, not an abstract thematic-role type. Keeping those units distinct fixes the product terms in the likelihood and the populations represented by the random effects.

## Slide 12: What the sequence supports

Source note: `custom-models/index.qmd`

These joint models depend on previously introduced response distributions, grouped variation, posterior computation, and posterior predictive checks. The sequence contributes the protocol-specific joint distribution and the checks needed to interpret its latent quantities.

## Slide 13: Data-generating processes

Source note: `custom-models/generative-stories.qmd`

Next, we take up Data-generating processes.

## Slide 14: Data-generating processes

Source note: `custom-models/generative-stories.qmd`

The event-structure annotations in Universal Decompositional Semantics (UDS) attach properties to predicate nodes anchored in sentence context. In the natural-parts task, an annotator first reports whether the situation described by a predicate has natural subparts. The response is evidence about event structure under this instrument; it is not event structure itself. Gantt, Glass, and White (2022) describe the event protocol and its conditional branches, while the Decomp documentation describes the released semantic graph attributes.

## Slide 15: Data-generating processes

Source note: `custom-models/generative-stories.qmd`

A **data-generating process (DGP)** is an ordered account of the random choices and deterministic mappings that could produce an observation. We begin with the observed binary gate because the local extract contains its raw responses. The conditional follow-up responses and raw confidence judgments are not present in an audited form, so this analysis does not invent them.

## Slide 16: Inspecting the observed response process

Source note: `custom-models/generative-stories.qmd`

The extract contains 2,955 responses to 1,000 predicate nodes from 12 anonymized annotators. Of these responses, 659 are yes and 2296 are no. The item identifier joins a graph identifier to a predicate-node identifier; it is not a verb lemma.

## Slide 17: Inspecting the observed response process

Source note: `custom-models/generative-stories.qmd`

The annotation design is sparse and crossed. The raw rates below describe the responses each annotator happened to give to the items they saw. They do not yet separate annotator response location from item composition.

## Slide 18: Inspecting the observed response process

Source note: `custom-models/generative-stories.qmd`

This figure shows raw natural-parts response rates by anonymized annotator. Point size records the number of observed responses.

## Slide 19: Stating one step at a time (1 of 2)

Source note: `custom-models/generative-stories.qmd`

Let $i$ index predicate nodes and $j$ index annotators. A first DGP has four steps. Draw an item deviation $u_i$ from an item population. Draw an annotator deviation $a_j$ from an annotator population. Map the population location and deviations to a yes probability $\pi_{ij}$.

## Slide 20: Stating one step at a time (2 of 2)

Source note: `custom-models/generative-stories.qmd`

Let $i$ index predicate nodes and $j$ index annotators. A first DGP has four steps. Draw the recorded response $Y_{ij}$ from that probability.

## Slide 21: Stating one step at a time

Source note: `custom-models/generative-stories.qmd`

The corresponding model is

$$
u_i\sim\mathcal N(0,\sigma_{\text{item}}^2),
\qquad
a_j\sim\mathcal N(0,\sigma_{\text{annotator}}^2),
$$

$$
\operatorname{logit}(\pi_{ij})=\alpha+u_i+a_j,
\qquad
Y_{ij}\sim\operatorname{Bernoulli}(\pi_{ij}).
$$

## Slide 22: Stating one step at a time

Source note: `custom-models/generative-stories.qmd`

The dependence sequence is

$$
(\alpha,u_i,a_j)\longrightarrow\pi_{ij}\longrightarrow Y_{ij}.
$$

## Slide 23: Stating one step at a time

Source note: `custom-models/generative-stories.qmd`

The arrows describe an order of generation, not a chronology in the annotator's mind. The response is the only observed quantity in this sequence. The probability and both deviations are model quantities.

## Slide 24: Grounding the indices in an observed item

Source note: `custom-models/generative-stories.qmd`

The following code chooses the first predicate node in file order that received both response values and prints its recorded rows. Selection depends on response pattern here only to make disagreement visible; it is not part of the teaching extract's construction or any fitted model.

## Slide 25: Grounding the indices in an observed item

Source note: `custom-models/generative-stories.qmd`

These rows share one $u_i$ but have different annotator indices $j$. A joint model may attribute their disagreement to Bernoulli variation, annotator location, or both. The rows do not license assigning the predicate a categorical event type.

## Slide 26: Declaring what is outside the process

Source note: `custom-models/generative-stories.qmd`

The original protocol uses the natural-parts answer to determine which later questions appear. A yes reveals questions about part similarity and part duration; a no reveals questions about whole-event duration and dynamicity. This display logic matters, but the present extract does not contain audited raw responses to those branches. Raw confidence is also blocked: the paper describes a one-to-five scale, the package metadata describes a zero-to-four scale, and the inspected raw serialization repeats a duration response in the confidence position. The released normalized confidence field is thus not treated as an additional raw judgment.

## Slide 27: Declaring what is outside the process (1 of 2)

Source note: `custom-models/generative-stories.qmd`

Thus this DGP is deliberately a model of the observed natural-parts gate. It is not a model of the complete event-structure instrument. The narrower claim keeps every recorded variable in the likelihood and every omitted variable outside it. Which quantity in the model is recorded directly? Why do the rows for one item share $u_i$ but not $a_j$? Why is an item identifier not a verb-lemma identifier?

## Slide 28: Declaring what is outside the process (2 of 2)

Source note: `custom-models/generative-stories.qmd`

Thus this DGP is deliberately a model of the observed natural-parts gate. It is not a model of the complete event-structure instrument. The narrower claim keeps every recorded variable in the likelihood and every omitted variable outside it. Which response branches remain outside this model?

## Slide 29: Declaring what is outside the process

Source note: `custom-models/generative-stories.qmd`

A DGP orders the random choices and mappings that connect a linguistic target to an annotation. The next page translates this sequence into one joint distribution.

## Slide 30: Declaring what is outside the process

Source note: `custom-models/generative-stories.qmd`

Previous: Custom models · Next: Writing a joint model.

## Slide 31: Writing a joint model

Source note: `custom-models/writing-a-joint-model.qmd`

Next, we take up Writing a joint model.

## Slide 32: Writing a joint model

Source note: `custom-models/writing-a-joint-model.qmd`

The preceding page introduced the UDS natural-parts response and its item--annotator design. We now begin with a smaller item-only model so that every factor in the joint distribution has a visible empirical referent. Stable annotator location enters later.

## Slide 33: Writing a joint model

Source note: `custom-models/writing-a-joint-model.qmd`

A **joint probability model** assigns one factor to every random step in a data-generating process. This is the product rule applied to the annotation process. The product states which quantities are conditionally independent and which observations share an unobserved item value.

## Slide 34: Loading the observed-pair set

Source note: `custom-models/writing-a-joint-model.qmd`

Let $\mathcal O$ be the 2,955 item-annotator pairs stored in `observed_pairs`. The likelihood has one response factor for each row in this set. It does not add factors for item-annotator combinations that were never observed.

## Slide 35: Translating steps into factors

Source note: `custom-models/writing-a-joint-model.qmd`

Let $\theta_i$ be the log odds of a yes response for predicate-node item $i$ in the item-only model. Then

$$
\pi_i=\operatorname{logit}^{-1}(\theta_i),
\qquad
Y_{ij}\sim\operatorname{Bernoulli}(\pi_i),
$$

and the item values follow

$$
\theta_i\sim\mathcal N(\mu_\theta,\tau_\theta^2).
$$

## Slide 36: Translating steps into factors

Source note: `custom-models/writing-a-joint-model.qmd`

For observed responses $\mathbf y$ and item values $\boldsymbol\theta$, the joint distribution is

$$
f(\mathbf y,\boldsymbol\theta\mid\mu_\theta,\tau_\theta)
=
\prod_i f(\theta_i\mid\mu_\theta,\tau_\theta)
\prod_{(i,j)\in\mathcal O}p(y_{ij}\mid\theta_i).
$$

## Slide 37: Translating steps into factors

Source note: `custom-models/writing-a-joint-model.qmd`

The first product generates one item value per predicate node. The second generates each recorded response conditional on the item value named by that row. Repeated occurrences of $\theta_i$ record the fact that responses to one predicate node share information.

## Slide 38: Translating steps into factors

Source note: `custom-models/writing-a-joint-model.qmd`

The order of multiplication does not describe temporal order. Multiplication is commutative; the conditional arguments carry the dependency claim.

## Slide 39: Fitting the item-only model

Source note: `custom-models/writing-a-joint-model.qmd`

The following fit evaluates the empirical item-only model. It uses every row in $\mathcal O$ and partially pools the 1000 item deviations. This is an intermediate analysis: omitting annotator effects is a declared simplification, not a claim that annotators have identical response locations.

## Slide 40: Fitting the item-only model

Source note: `custom-models/writing-a-joint-model.qmd`

The integrated log likelihood combines the response factors with the item population rather than treating the fitted item deviations as independent observations. Its numerical value depends on the complete UDS response matrix and the stated item-only model.

## Slide 41: Comparing raw summaries with fitted item probabilities

Source note: `custom-models/writing-a-joint-model.qmd`

This figure shows raw item response proportions and fitted probabilities from the item-only model.

## Slide 42: Comparing raw summaries with fitted item probabilities

Source note: `custom-models/writing-a-joint-model.qmd`

The vertical bands arise because 45 items have two responses and 955 have three. The fitted values move raw endpoints toward the item population. This is partial pooling, not recovery of a context-free lexical category.

## Slide 43: Separating observations from summaries

Source note: `custom-models/writing-a-joint-model.qmd`

For item $i$ with $n_i$ responses, the raw mean

$$
\bar Y_i=\frac{1}{n_i}\sum_{j:(i,j)\in\mathcal O}Y_{ij}
$$

is determined by response rows already in the likelihood.

## Slide 44: Separating observations from summaries

Source note: `custom-models/writing-a-joint-model.qmd`

Multiplying the joint model by a second likelihood term for $\bar Y_i$ would count the same annotations twice. The mean may appear in a plot or predictive check, as it does above, but it is not another measurement.

## Slide 45: Separating observations from summaries (1 of 2)

Source note: `custom-models/writing-a-joint-model.qmd`

Each probability factor must correspond to a distinct random quantity in the recorded measurement process. If two likelihood factors point to the same recorded responses without a second measurement process, one factor is duplicated. Which product generates the latent item values? Why is the response product indexed by $\mathcal O$? Why does multiplication order not state the dependency structure?

## Slide 46: Separating observations from summaries (2 of 2)

Source note: `custom-models/writing-a-joint-model.qmd`

Each probability factor must correspond to a distinct random quantity in the recorded measurement process. If two likelihood factors point to the same recorded responses without a second measurement process, one factor is duplicated. Why is an item mean not an additional response? Which simplification does the item-only fit make?

## Slide 47: Separating observations from summaries

Source note: `custom-models/writing-a-joint-model.qmd`

A joint model translates each random step into one probability factor. Before fitting the larger crossed model to released responses, we test whether its parameters can be recovered under the observed incidence design.

## Slide 48: Separating observations from summaries

Source note: `custom-models/writing-a-joint-model.qmd`

Previous: Data-generating processes · Next: Parameter recovery.

## Slide 49: Parameter recovery

Source note: `custom-models/parameter-recovery.qmd`

Our next step is Parameter recovery.

## Slide 50: Parameter recovery

Source note: `custom-models/parameter-recovery.qmd`

A model may fit without warnings even when the observed design contains too little information to separate its quantities. **Parameter recovery** tests the complete inference procedure on simulated responses whose generating values are known. Here the simulation preserves the exact item--annotator incidence pattern of the UDS natural-parts extract introduced on the first page.

## Slide 51: Parameter recovery

Source note: `custom-models/parameter-recovery.qmd`

This is an audited model simulation, not a substitute for linguistic data. Its rows, item identities, annotator identities, and imbalance come from the released annotation design. The generating values and success thresholds were fixed before the released responses were fit.

## Slide 52: Loading the released design and audited cache

Source note: `custom-models/parameter-recovery.qmd`

The compact cache contains 12 completed recovery fits and 400 deterministic draws from the later released-data fit. Rendering uses the cache; it does not silently refit Stan.

## Slide 53: The complete Stan program

Source note: `custom-models/parameter-recovery.qmd`

The crossed response model constructs item and annotator deviations by centering non-centered standard-normal vectors. Centering the realized vectors fixes their finite-sample sums at zero.

## Slide 54: The exact recovery generator and fitting call

Source note: `custom-models/parameter-recovery.qmd`

the calculation is the executable core of one audited replicate. It uses the observed row indices without changing which annotator saw which item. The full audit ran replicates 1 through 12; simulation seed $7300+s$ generated replicate $s$, and the two fitting chains used seeds $740000+100s+c$ for chain $c$.

## Slide 55: The exact recovery generator and fitting call

Source note: `custom-models/parameter-recovery.qmd`

The archived run combined the two chain files after each call. Every reported result below comes from that chain-specific run stored in the tracked compact cache.

## Slide 56: Evaluating parameter recovery

Source note: `custom-models/parameter-recovery.qmd`

For replicate $s$, an error is $\widehat\theta_s-\theta_s$. Across $S$ replicates, estimated bias and root mean squared error are

$$
\widehat{\operatorname{Bias}}
=\frac{1}{S}\sum_{s=1}^S(\widehat\theta_s-\theta_s),
$$

$$
\operatorname{RMSE}
=\sqrt{\frac{1}{S}\sum_{s=1}^S
(\widehat\theta_s-\theta_s)^2}.
$$

## Slide 57: Evaluating parameter recovery

Source note: `custom-models/parameter-recovery.qmd`

The audit used medians and recovery correlations because the target includes population scales and high-dimensional latent orderings. Its prespecified thresholds were: median absolute intercept error at most $.25$; median absolute relative errors at most $.15$ for the item scale and $.25$ for the annotator scale; median correlations at least $.60$ for item effects, $.90$ for annotator effects, and $.65$ for conditional item probabilities; maximum key-parameter $\widehat R$ at most $1.05$; and no divergent transitions.

## Slide 58: Seeing variation across complete fits

Source note: `custom-models/parameter-recovery.qmd`

Posterior medians from twelve complete recovery fits. Horizontal lines mark the generating values.

## Slide 59: Seeing variation across complete fits

Source note: `custom-models/parameter-recovery.qmd`

The prespecified recovery criteria are met. But with two or three responses per item, recovery supports aggregate regularized ordering, not precise lexical interpretation of every predicate node.

## Slide 60: Seeing variation across complete fits

Source note: `custom-models/parameter-recovery.qmd`

Successful recovery shows that the fitter can retrieve the declared targets when data arise from this model under this incidence design. It does not establish that real annotators follow the generator. The released-data analysis still requires posterior predictive checks and measurement limitations. Why is the observed incidence pattern held fixed? Why must fitting occur inside every replicate? Which recovery target is weakest in this design? What does successful recovery fail to establish?

## Slide 61: Seeing variation across complete fits

Source note: `custom-models/parameter-recovery.qmd`

Previous: Writing a joint model · Next: Annotations are measurements.

## Slide 62: Annotations are measurements

Source note: `custom-models/annotations-as-measurements.qmd`

Now we turn to Annotations are measurements.

## Slide 63: Turkish PropBank: the empirical object

Source note: `custom-models/annotations-as-measurements.qmd`

The data source is Kara et al. (2020), Turkish PropBank. It provides individual role judgments aligned with adjudicated Turkish roles.

## Slide 64: Annotations are measurements

Source note: `custom-models/annotations-as-measurements.qmd`

Şahin and Adalı (2018) describe the ITU/IMST Turkish PropBank: predicate-specific frames were paired with argument candidates from the IMST dependency treebank, Turkish-speaking crowd workers selected plain-language role descriptions, and unresolved cases were adjudicated. The official project release provides the frames, crowd layers, and final annotations. The course extract is privacy-sanitized from the pinned project repository; it removes platform identifiers, locations, timestamps, and free text.

## Slide 65: Annotations are measurements

Source note: `custom-models/annotations-as-measurements.qmd`

The project site states that resources built in the project are distributed under CC BY-NC-SA 4.0, while the repository's short license header names the Turkish frame files specifically. We use the derived table for this noncommercial course under the project-wide statement and retain that scope qualification.

## Slide 66: Annotations are measurements

Source note: `custom-models/annotations-as-measurements.qmd`

This release lets us analyze annotations as measurements. One row records whether one worker's selected description matches the final adjudicated description. Agreement with adjudication is observed. The validity of the adjudicated description is not.

## Slide 67: Loading individual judgments

Source note: `custom-models/annotations-as-measurements.qmd`

The binary response is

$$
Y_{ij}=
\begin{cases}
1 & \text{worker }j\text{ selected item }i\text{'s adjudicated description},\\
0 & \text{otherwise}.
\end{cases}
$$

## Slide 68: Loading individual judgments

Source note: `custom-models/annotations-as-measurements.qmd`

A zero is a recorded disagreement, not a missing response. It also does not establish that the worker is wrong in an independent linguistic sense, because the comparison target is the project's adjudication.

## Slide 69: Keeping three agreement quantities distinct

Source note: `custom-models/annotations-as-measurements.qmd`

The paper reports Cohen's $\kappa=.936$ for an expert versus trust-weighted aggregate answers on 2,000 deliberately unambiguous test questions. It reports Fleiss' $\kappa=.65$ across varying workers on roughly 18,000 ordinary multi-category questions. The response above is a third quantity: an individual worker's binary match with the later adjudicated description. The three quantities have different observational units and denominators.

## Slide 70: Keeping three agreement quantities distinct

Source note: `custom-models/annotations-as-measurements.qmd`

This lesson asks whether individual agreement with adjudication differs between predicate-specific core descriptions and general adjunct-like descriptions. The resulting probability is a property of this released task, not a worker-competence score and not a replication of either $\kappa$ statistic.

## Slide 71: Raw agreement by adjudicated role class

Source note: `custom-models/annotations-as-measurements.qmd`

The raw proportions retain every individual judgment but do not account for repeated items or workers. Items may differ in difficulty, and workers may differ in response behavior.

## Slide 72: Fitting a crossed measurement model

Source note: `custom-models/annotations-as-measurements.qmd`

Let $u_i$ be an item intercept and $v_j$ a worker intercept. The model is

$$
Y_{ij}\sim\operatorname{Bernoulli}(\pi_{ij}),
$$

$$
\operatorname{logit}(\pi_{ij})
=\beta_0+\beta_1\operatorname{Adjunct}_i+u_i+v_j,
$$

$$
u_i\sim\mathcal N(0,\sigma_{\text{item}}^2),
\qquad
v_j\sim\mathcal N(0,\sigma_{\text{worker}}^2).
$$

## Slide 73: Fitting a crossed measurement model

Source note: `custom-models/annotations-as-measurements.qmd`

The fixed contrast compares adjudicated role classes at zero-valued item and worker intercepts. The crossed terms retain the repeated-measurement structure.

## Slide 74: Showing raw and fitted agreement together

Source note: `custom-models/annotations-as-measurements.qmd`

This figure shows individual agreement with adjudication. Raw proportions use exact binomial intervals; fitted probabilities condition on zero item and worker intercepts.

## Slide 75: Showing raw and fitted agreement together

Source note: `custom-models/annotations-as-measurements.qmd`

Individual judgments agree with adjudicated core descriptions more often than with adjunct-like descriptions in this extract. The teaching contrast collapses the paper's multi-category role inventory into two release-based groups. It does not reproduce the paper's agreement calculations, estimate worker competence, or validate the final label. Numbered core roles also remain predicate-specific rather than universal thematic categories. What event makes `correct` equal to one? Why is this response not the paper's Cohen or Fleiss $\kappa$? Which repeated units enter the crossed model? Why is the fitted probability not a worker-competence estimate?

## Slide 76: Showing raw and fitted agreement together

Source note: `custom-models/annotations-as-measurements.qmd`

Previous: Parameter recovery · Next: Annotator effects.

## Slide 77: Annotator effects

Source note: `custom-models/annotator-effects.qmd`

The next topic is Annotator effects.

## Slide 78: Annotator effects

Source note: `custom-models/annotator-effects.qmd`

The Turkish PropBank analysis separated agreement from adjudication. We now return to the UDS natural-parts responses, where each predicate node was judged by two or three annotators. A stable annotator term may separate an annotator's response location from the item propensities estimated from overlapping judgments.

## Slide 79: Annotator effects

Source note: `custom-models/annotator-effects.qmd`

We represent this pattern with an annotator-specific intercept. It describes a stable upward or downward shift in log odds under this instrument. It is not a measure of annotator quality or proof of a context-independent bias.

## Slide 80: Loading raw responses and fitted summaries

Source note: `custom-models/annotator-effects.qmd`

The raw rate for annotator $j$ is

$$
\bar Y_{\cdot j}
=\frac{1}{n_j}\sum_{i:(i,j)\in\mathcal O}Y_{ij}.
$$

## Slide 81: Loading raw responses and fitted summaries

Source note: `custom-models/annotator-effects.qmd`

This rate mixes annotator behavior with the particular items assigned to that annotator. The crossed model instead represents item and annotator locations simultaneously.

## Slide 82: Adding one location term

Source note: `custom-models/annotator-effects.qmd`

Let $u_i$ be item $i$'s deviation and $a_j$ annotator $j$'s location effect. The response model is

$$
Y_{ij}\sim\operatorname{Bernoulli}(\pi_{ij}),
$$

$$
\operatorname{logit}(\pi_{ij})=\alpha+u_i+a_j.
$$

## Slide 83: Adding one location term

Source note: `custom-models/annotator-effects.qmd`

The fitted model constructs its deviations from centered standard-normal vectors:

$$
u_i=\sigma_{\text{item}}
\left(z_i^{\text{item}}-\bar z^{\text{item}}\right),
\qquad
z_i^{\text{item}}\sim\mathcal N(0,1),
$$

$$
a_j=\sigma_{\text{annotator}}
\left(z_j^{\text{annotator}}-\bar z^{\text{annotator}}\right),
\qquad
z_j^{\text{annotator}}\sim\mathcal N(0,1).
$$

## Slide 84: Adding one location term

Source note: `custom-models/annotator-effects.qmd`

A positive $a_j$ raises the log odds of a yes response for every item judged by annotator $j$; a negative value lowers them. The effect is shared across responses, so it is not trial noise.

## Slide 85: Fixing the coordinate system

Source note: `custom-models/annotator-effects.qmd`

The decomposition is not identified without a reference. For any constant $c$,

$$
(\alpha+u_i+c)+(a_j-c)=\alpha+u_i+a_j.
$$

## Slide 86: Fixing the coordinate system

Source note: `custom-models/annotator-effects.qmd`

The response probabilities do not change. Centering the realized effects imposes

$$
\sum_i u_i=0,
\qquad
\sum_j a_j=0.
$$

## Slide 87: Fixing the coordinate system

Source note: `custom-models/annotator-effects.qmd`

This convention fixes the latent origin. It does not assert that an annotator with effect zero has no response behavior. Under the convention, $\operatorname{logit}^{-1}(\alpha+u_i)$ is the item probability with the annotator effect fixed at zero.

## Slide 88: Raw rates and posterior effects

Source note: `custom-models/annotator-effects.qmd`

The plot keeps raw measurements and fitted model quantities in separate panels because they use different scales. Exact binomial intervals summarize each raw rate; posterior intervals summarize each annotator-specific intercept.

## Slide 89: Raw rates and posterior effects

Source note: `custom-models/annotator-effects.qmd`

This figure shows raw natural-parts response rates and posterior annotator-specific intercepts. Panels have distinct horizontal scales.

## Slide 90: Raw rates and posterior effects

Source note: `custom-models/annotator-effects.qmd`

The plot shows why the location term matters: the raw rates span a broad range, and the fitted effects retain broad separation after item variation is represented. But the two panels are not interchangeable. Raw rates average over assigned items; fitted effects condition on the crossed model and its zero-sum coordinate convention.

## Slide 91: Location is not every annotator difference

Source note: `custom-models/annotator-effects.qmd`

Annotators may differ in response consistency, interpretation, or use of an ordered scale. A location effect cannot represent those patterns. It shifts every predicted log odds in the same direction. The current binary data and recovery study support this smaller term; they do not support adding discrimination or threshold parameters without a new design check.

## Slide 92: Location is not every annotator difference (1 of 2)

Source note: `custom-models/annotator-effects.qmd`

Item and annotator effects would be perfectly confounded if each item were judged by only one annotator. The UDS teaching extract instead forms one connected bipartite graph across 1000 items and 12 annotators. Connectivity supplies paths of shared judgments, though sparse responses still limit the precision of individual item effects. What response pattern does a positive $a_j$ represent? Why do raw annotator rates mix response behavior with item composition? What do the zero-sum constraints identify?

## Slide 93: Location is not every annotator difference (2 of 2)

Source note: `custom-models/annotator-effects.qmd`

Item and annotator effects would be perfectly confounded if each item were judged by only one annotator. The UDS teaching extract instead forms one connected bipartite graph across 1000 items and 12 annotators. Connectivity supplies paths of shared judgments, though sparse responses still limit the precision of individual item effects. Which annotator differences remain outside this model?

## Slide 94: Location is not every annotator difference

Source note: `custom-models/annotator-effects.qmd`

Previous: Annotations are measurements · Next: Measuring natural-parts judgments.

## Slide 95: Measuring natural-parts judgments

Source note: `custom-models/uds-measurement-model.qmd`

The next topic is Measuring natural-parts judgments.

## Slide 96: Measuring natural-parts judgments

Source note: `custom-models/uds-measurement-model.qmd`

We can now combine the UDS response process, its joint factorization, the recovery analysis, and annotator-specific intercepts. The model separates predicate-node variation from annotator variation in binary natural-parts responses.

## Slide 97: Measuring natural-parts judgments

Source note: `custom-models/uds-measurement-model.qmd`

The model is narrower than the event-structure representation in Gantt, Glass, and White (2022). It does not model conditional follow-up questions or confidence. And it treats an item as one predicate node in sentence context, not as a verb lemma or context-free event type.

## Slide 98: Loading measurements and posterior draws

Source note: `custom-models/uds-measurement-model.qmd`

Only the raw binary responses enter the likelihood. The released normalized value is retained for an external comparison after fitting.

## Slide 99: Writing the complete model

Source note: `custom-models/uds-measurement-model.qmd`

For each observed pair $(i,j)\in\mathcal O$,

$$
Y_{ij}\sim\operatorname{Bernoulli}(\pi_{ij}),
$$

$$
\operatorname{logit}(\pi_{ij})
=\alpha+u_i+a_j.
$$

## Slide 100: Writing the complete model

Source note: `custom-models/uds-measurement-model.qmd`

The fitted deviations are effects constructed by centering non-centered standard-normal vectors,

$$
u_i=\sigma_{\text{item}}
\left(z_i^{\text{item}}-\bar z^{\text{item}}\right),
\qquad
z_i^{\text{item}}\sim\mathcal N(0,1),
$$

$$
a_j=\sigma_{\text{annotator}}
\left(z_j^{\text{annotator}}-\bar z^{\text{annotator}}\right),
\qquad
z_j^{\text{annotator}}\sim\mathcal N(0,1).
$$

## Slide 101: Writing the complete model

Source note: `custom-models/uds-measurement-model.qmd`

The priors are

$$
\alpha\sim\mathcal N(0,2.5^2),
$$

$$
\sigma_{\text{item}}\sim\operatorname{HalfNormal}(2),
\qquad
\sigma_{\text{annotator}}\sim\operatorname{HalfNormal}(2).
$$

## Slide 102: Writing the complete model

Source note: `custom-models/uds-measurement-model.qmd`

Since the scale parameters are constrained positive in Stan, the normal statements for them induce half-normal priors. Centering fixes both realized effect sums at zero. Thus $\alpha$ is the log odds for an item and annotator at their respective origins, and

$$
\operatorname{logit}^{-1}(\alpha+u_i)
$$

is item $i$'s yes probability with the annotator effect fixed at zero.

## Slide 103: Writing the complete model

Source note: `custom-models/uds-measurement-model.qmd`

It is not the probability obtained by integrating over an annotator population.

## Slide 104: Fitting the released responses

Source note: `custom-models/uds-measurement-model.qmd`

The parameter-recovery page prints the complete Stan program and the exact simulation loop. After the prespecified recovery criteria were met, the released responses were fitted with four separately seeded chains. The fitting call was equivalent to the empirical calculation; `run_one_chain()` records one chain per seed before the results are combined.

## Slide 105: Fitting the released responses

Source note: `custom-models/uds-measurement-model.qmd`

Rendering reads 400 evenly spaced draws from the audited 3,200-draw posterior. The compact cache is a teaching artifact from the full fit, not an independent refit.

## Slide 106: Population summaries

Source note: `custom-models/uds-measurement-model.qmd`

Both scale intervals lie away from zero in this model and extract. Predicate nodes vary in their response propensities, and annotators vary in response location after item variation is represented. This is evidence about the annotation process, not a partition of predicates into event-structural categories.

## Slide 107: Population summaries

Source note: `custom-models/uds-measurement-model.qmd`

The intercept should not be read as the logit of the raw yes proportion. The raw average mixes different item and annotator effects through a nonlinear link, while $\alpha$ locates an item and annotator whose deviations are both zero.

## Slide 108: Seeing partial pooling

Source note: `custom-models/uds-measurement-model.qmd`

This figure shows raw item proportions and posterior median probabilities with the annotator effect fixed at zero.

## Slide 109: Seeing partial pooling

Source note: `custom-models/uds-measurement-model.qmd`

Most raw item proportions occur at a few fractions because each item has two or three responses. Posterior probabilities occupy a continuous range and move raw endpoints toward the fitted population. This shrinkage reflects both sparse item measurement and the annotator composition of each item.

## Slide 110: Checking replicated response matrices

Source note: `custom-models/uds-measurement-model.qmd`

A fitted ordering is not enough. We generate one replicated response for every observed item--annotator pair in each cached posterior draw. Two summaries target distinct features: the overall yes rate and the proportion of items containing both response values.

## Slide 111: Checking replicated response matrices

Source note: `custom-models/uds-measurement-model.qmd`

Posterior predictive distributions. Vertical lines mark the observed statistics.

## Slide 112: Checking replicated response matrices

Source note: `custom-models/uds-measurement-model.qmd`

Both observed summaries fall inside their predictive intervals. The second check matters because a model might reproduce the overall rate while predicting too little or too much within-item disagreement.

## Slide 113: Comparing with the released normalized values

Source note: `custom-models/uds-measurement-model.qmd`

The release also supplies one normalized natural-parts value per item. Those values were not likelihood inputs. The following association compares the fitted and released measurement procedures after fitting.

## Slide 114: Comparing with the released normalized values

Source note: `custom-models/uds-measurement-model.qmd`

The Spearman correlation is 0.818. This association suggests that the compact binary model captures much of the released ordering. It is not a likelihood contribution or a test in which one measurement procedure must defeat the other.

## Slide 115: Limits of the measurement claim (1 of 3)

Source note: `custom-models/uds-measurement-model.qmd`

The recovery and predictive gates support one narrow analysis. Six limits remain. The deterministic teaching extract contains 1,000 multiply annotated development and test items; it is not a random sample of every UDS predicate. Most items have three responses, so item probabilities remain strongly regularized.

## Slide 116: Limits of the measurement claim (2 of 3)

Source note: `custom-models/uds-measurement-model.qmd`

The recovery and predictive gates support one narrow analysis. Six limits remain. The annotator term represents location only, not discrimination, consistency, or interpretation. The raw confidence serialization conflicts with the documented scale, so confidence is excluded.

## Slide 117: Limits of the measurement claim (3 of 3)

Source note: `custom-models/uds-measurement-model.qmd`

The recovery and predictive gates support one narrow analysis. Six limits remain. The data do not include audited raw responses for part similarity, duration, or dynamicity; those conditional branches are not fitted. An item is a PredPatt predicate node in sentence context, not a context-free verb lemma.

## Slide 118: Limits of the measurement claim (1 of 2)

Source note: `custom-models/uds-measurement-model.qmd`

A potential worry is that passing two posterior predictive checks makes the model adequate for every purpose. While the checks target the rate and within-item disagreement that motivated this model, they cannot validate unmodeled branches or a lexical interpretation of item effects. New targets require new response data and new recovery checks. Why is the released normalized value absent from the likelihood? What does the connected item--annotator design make possible? Why can a unanimous item have a posterior probability below one? Which response features do the two predictive checks target?

## Slide 119: Limits of the measurement claim (2 of 2)

Source note: `custom-models/uds-measurement-model.qmd`

A potential worry is that passing two posterior predictive checks makes the model adequate for every purpose. While the checks target the rate and within-item disagreement that motivated this model, they cannot validate unmodeled branches or a lexical interpretation of item effects. New targets require new response data and new recovery checks. Which measurements remain blocked?

## Slide 120: Limits of the measurement claim

Source note: `custom-models/uds-measurement-model.qmd`

Previous: Annotator effects · Next: Gated annotations.

## Slide 121: Gated annotations

Source note: `custom-models/gated-annotations.qmd`

Now we turn to Gated annotations.

## Slide 122: Gated annotations

Source note: `custom-models/gated-annotations.qmd`

The UDS event protocol uses the natural-parts response as a gate. A yes displays questions about part similarity and average part duration; a no displays questions about whole-situation duration and dynamicity. An undisplayed response is thus **structurally missing**. It is not a low value on that branch and not a failed attempt to answer a displayed question.

## Slide 123: Gated annotations

Source note: `custom-models/gated-annotations.qmd`

The local extract supports numerical analysis of the observed natural-parts gate only. It does not contain audited raw conditional-branch responses, and the available raw confidence serialization conflicts with the documented response scale. This page thus analyzes the gate empirically and keeps the branch model symbolic.

## Slide 124: Reproducing the observed gate

Source note: `custom-models/gated-annotations.qmd`

These are recorded gate responses. The no count is not a count of zero-valued part-similarity judgments, because the part-similarity question was never displayed after those responses.

## Slide 125: Factoring the gate and follow-up response

Source note: `custom-models/gated-annotations.qmd`

Let $G_{ij}=1$ when annotator $j$ reports that predicate-node item $i$ has natural parts, and let $G_{ij}=0$ otherwise. Let $Y_{ij}$ denote a response on the yes branch, such as part similarity. Write $\pi_{ij}$ for the gate probability and $f_Y(y_{ij}\mid\phi_{ij})$ for the conditional follow-up probability or density.

## Slide 126: Factoring the gate and follow-up response

Source note: `custom-models/gated-annotations.qmd`

The observed response contribution is

$$
f_{G,Y}(g_{ij},y_{ij}^{\mathrm{obs}})
=
\begin{cases}
\pi_{ij}f_Y(y_{ij}\mid\phi_{ij}), & g_{ij}=1,\\
1-\pi_{ij}, & g_{ij}=0.
\end{cases}
$$

When $g_{ij}=1$, the record contributes a gate factor and a follow-up factor.

## Slide 127: Factoring the gate and follow-up response

Source note: `custom-models/gated-annotations.qmd`

When $g_{ij}=0$, it contributes only the negative-gate probability. The second case never evaluates a density at an unrecorded follow-up value.

## Slide 128: Factoring the gate and follow-up response

Source note: `custom-models/gated-annotations.qmd`

The same factorization can be written as

$$
f_{G,Y}(g_{ij},y_{ij}^{\mathrm{obs}})
=
\left[\pi_{ij}f_Y(y_{ij}\mid\phi_{ij})\right]^{g_{ij}}
(1-\pi_{ij})^{1-g_{ij}},
$$

where the follow-up term is meaningful only for records on which the branch is observed.

## Slide 129: Factoring the gate and follow-up response

Source note: `custom-models/gated-annotations.qmd`

This expression describes a future branch-bearing analysis; it is not evaluated on the present extract.

## Slide 130: Checking only the fitted gate

Source note: `custom-models/gated-annotations.qmd`

The following posterior predictive calculation uses the audited binary gate model. It simulates no follow-up values.

## Slide 131: Checking only the fitted gate

Source note: `custom-models/gated-annotations.qmd`

Posterior predictive distribution of the observed natural-parts gate rate. The vertical line marks the released rate.

## Slide 132: Checking only the fitted gate

Source note: `custom-models/gated-annotations.qmd`

This check supports the gate component at the overall-rate level. It supplies no evidence about the conditional branches because no branch response was simulated or scored.

## Slide 133: The follow-up target is conditional

Source note: `custom-models/gated-annotations.qmd`

An average of observed yes-branch responses would describe cases that passed the gate:

$$
\mathbb{E}[Y_{ij}\mid G_{ij}=1].
$$

## Slide 134: The follow-up target is conditional

Source note: `custom-models/gated-annotations.qmd`

It would not estimate an unconditional property over all predicate nodes unless the model defined what the follow-up means when an annotator rejects the premise that natural parts exist. Replacing an undisplayed part-similarity response with zero would merge two events: rejecting the gate and passing the gate while selecting the scale's lowest response.

## Slide 135: The follow-up target is conditional

Source note: `custom-models/gated-annotations.qmd`

The gate and a future follow-up model might share item or annotator quantities. For instance, an item that often passes the gate might also tend to receive a particular conditional response. But such dependence requires raw branch-bearing records, enough passed gates, a reconciled response scale, and a new recovery study. The present gate fit cannot identify it.

## Slide 136: Separating protocol absence from stochastic missingness

Source note: `custom-models/gated-annotations.qmd`

A rectangular data table may store `NA` for an undisplayed follow-up. The joint model, not the storage symbol, determines what that `NA` means. Protocol absence differs from the missing intended measurements discussed in missingness mechanisms: here the instrument defines no follow-up response after the incompatible gate value.

## Slide 137: Separating protocol absence from stochastic missingness (1 of 2)

Source note: `custom-models/gated-annotations.qmd`

The blocked measurements are part similarity, part duration, whole-situation duration, dynamicity, and raw confidence. No numerical claim about their distributions, associations, or fitted values follows from this page. Which factor contributes when $g_{ij}=0$? What population does $\mathbb{E}[Y_{ij}\mid G_{ij}=1]$ describe? Why is a protocol-generated blank different from a recorded zero? What does the gate-rate predictive check leave untested?

## Slide 138: Separating protocol absence from stochastic missingness (2 of 2)

Source note: `custom-models/gated-annotations.qmd`

The blocked measurements are part similarity, part duration, whole-situation duration, dynamicity, and raw confidence. No numerical claim about their distributions, associations, or fitted values follows from this page. What evidence would a branch model require?

## Slide 139: Separating protocol absence from stochastic missingness

Source note: `custom-models/gated-annotations.qmd`

A gated likelihood gives negative gates one gate factor and affirmative gates both a gate factor and a conditional follow-up factor. The observed UDS extract supports the first component only. Keeping the second component symbolic preserves the logic of the instrument without inventing data.

## Slide 140: Separating protocol absence from stochastic missingness

Source note: `custom-models/gated-annotations.qmd`

Previous: Measuring natural-parts judgments.
