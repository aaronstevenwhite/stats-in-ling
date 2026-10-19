# Custom generative models for annotations

This transcript is generated from the speaker notes in the slide source. Slide identifiers, titles, note-page provenance, and order are identical.

## Slide 1: Custom generative models for annotations

Source note: `custom-models/index.qmd`

Welcome to Custom generative models for annotations. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.

## Slide 2: Custom model design

Source note: `custom-models/index.qmd`

We now turn to Custom model design. An annotation is an observed response produced by a measurement procedure. It is not the linguistic property that the procedure is meant to inform. The **annotation measurement chain (AMC)** connects a linguistic unit, a prompt, an annotator, a response scale, and the recorded answer. A custom likelihood should encode that chain without turning a response into direct access to the target property.

## Slide 3: UDS: the empirical object

Source note: `custom-models/index.qmd`

This is the first use of UDS in this module. The slide names the observation represented in the teaching table and links the original source. We will keep that unit fixed when we compute and interpret quantities from these data.

## Slide 4: Custom model design

Source note: `custom-models/index.qmd`

An annotation is an observed response produced by a measurement procedure. It is not the linguistic property that the procedure is meant to inform. The **annotation measurement chain (AMC)** connects a linguistic unit, a prompt, an annotator, a response scale, and the recorded answer. This module uses two annotation resources, one of them non-English. The natural-parts task in Universal Decompositional Semantics (UDS) records binary answers about predicate nodes in English dependency graphs; Gantt, Glass, and White (2022) describe the event-structure protocol. Keep the observational unit fixed while you interpret the result.

## Slide 5: From the protocol to a probability model

Source note: `custom-models/index.qmd`

A data-generating process first specifies the random steps that could produce the UDS gate responses. Writing a joint model then translates those steps into a joint probability distribution over the observed item--annotator pairs. Parameter recovery asks whether the complete procedure can recover known values under the released incidence design. The Turkish PropBank analysis next treats annotations as measurements, distinguishing agreement with adjudication from label validity or worker competence. Returning to UDS, annotator effects represent stable response-location differences among annotators. Now connect the notation back to the linguistic comparison.

## Slide 6: What the sequence supports

Source note: `custom-models/index.qmd`

The UDS item is a predicate node anchored in sentence context, not a context-free verb lemma. The Turkish PropBank item is one predicate-specific argument candidate, not an abstract thematic-role type. Keeping those units distinct fixes the product terms in the likelihood and the populations represented by the random effects. These joint models depend on previously introduced response distributions, grouped variation, posterior computation, and posterior predictive checks. The sequence contributes the protocol-specific joint distribution and the checks needed to interpret its latent quantities. That distinction will matter again on the next slide.

## Slide 7: Interpretation

Source note: `custom-models/index.qmd`

These joint models depend on previously introduced response distributions, grouped variation, posterior computation, and posterior predictive checks. The sequence contributes the protocol-specific joint distribution and the checks needed to interpret its latent quantities. Use the graph or equation to say the result in ordinary language.

## Slide 8: Data-generating processes

Source note: `custom-models/generative-stories.qmd`

We now turn to Data-generating processes. The event-structure annotations in Universal Decompositional Semantics (UDS) attach properties to predicate nodes anchored in sentence context. In the natural-parts task, an annotator first reports whether the situation described by a predicate has natural subparts. The response is evidence about event structure under this instrument; it is not event structure itself.

## Slide 9: Data-generating processes

Source note: `custom-models/generative-stories.qmd`

The event-structure annotations in Universal Decompositional Semantics (UDS) attach properties to predicate nodes anchored in sentence context. In the natural-parts task, an annotator first reports whether the situation described by a predicate has natural subparts. The response is evidence about event structure under this instrument; it is not event structure itself. A **data-generating process (DGP)** is an ordered account of the random choices and deterministic mappings that could produce an observation. We begin with the observed binary gate because the local extract contains its raw responses. The conditional follow-up responses and raw confidence judgments are not present in an audited form, so this analysis does not invent them. Use the graph or equation to say the result in ordinary language.

## Slide 10: Inspecting the observed response process

Source note: `custom-models/generative-stories.qmd`

The extract contains observed responses to observed predicate nodes from observed anonymized annotators. Of these responses, observed are yes and observed are no. The item identifier joins a graph identifier to a predicate-node identifier; it is not a verb lemma. The annotation design is sparse and crossed. The raw rates below describe the responses each annotator happened to give to the items they saw. They do not yet separate annotator response location from item composition. Keep the observational unit fixed while you interpret the result.

## Slide 11: Inspecting the observed response process

Source note: `custom-models/generative-stories.qmd`

Start with the axes and the observed values. Raw natural-parts response rates by anonymized annotator. Point size records the number of observed responses. Read the pattern before attaching a model interpretation to it.

## Slide 12: Stating one step at a time

Source note: `custom-models/generative-stories.qmd`

Let $i$ index predicate nodes and $j$ index annotators. A first DGP has four steps. 1. Draw an item deviation $u_i$ from an item population. 2. Draw an annotator deviation $a_j$ from an annotator population. 3. Map the population location and deviations to a yes probability $\pi_{ij}$. 4. Draw the recorded response $Y_{ij}$ from that probability. Notice what is observed and what is supplied by the model.

## Slide 13: Stating one step at a time: equation 1

Source note: `custom-models/generative-stories.qmd`

The displayed expression formalizes stating one step at a time: equation 1. Let $i$ index predicate nodes and $j$ index annotators. A first DGP has four steps. Keep track of what each term refers to in the linguistic dataset.

## Slide 14: Stating one step at a time: equation 2

Source note: `custom-models/generative-stories.qmd`

The displayed expression formalizes stating one step at a time: equation 2. 1. Draw an item deviation $u_i$ from an item population. 2. Draw an annotator deviation $a_j$ from an annotator population. 3. Map the population location and deviations to a yes probability $\pi_{ij}$. 4. Draw the recorded response $Y_{ij}$ from that probability. Keep track of what each term refers to in the linguistic dataset.

## Slide 15: Stating one step at a time: equation 3

Source note: `custom-models/generative-stories.qmd`

The displayed expression formalizes stating one step at a time: equation 3. The corresponding model is Keep track of what each term refers to in the linguistic dataset.

## Slide 16: Grounding the indices in an observed item

Source note: `custom-models/generative-stories.qmd`

The following code chooses the first predicate node in file order that received both response values and prints its recorded rows. Selection depends on response pattern here only to make disagreement visible; it is not part of the teaching extract's construction or any fitted model. These rows share one $u_i$ but have different annotator indices $j$. A joint model may attribute their disagreement to Bernoulli variation, annotator location, or both. The rows do not license assigning the predicate a categorical event type. Now connect the notation back to the linguistic comparison.

## Slide 17: Declaring what is outside the process

Source note: `custom-models/generative-stories.qmd`

The original protocol uses the natural-parts answer to determine which later questions appear. A yes reveals questions about part similarity and part duration; a no reveals questions about whole-event duration and dynamicity. This display logic matters, but the present extract does not contain audited raw responses to those branches. Thus this DGP is deliberately a model of the observed natural-parts gate. It is not a model of the complete event-structure instrument. The narrower claim keeps every recorded variable in the likelihood and every omitted variable outside it. Now connect the notation back to the linguistic comparison.

## Slide 18: Data-generating processes

Source note: `custom-models/generative-stories.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Data-generating processes. Read the pattern before attaching a model interpretation to it.

## Slide 19: Interpretation

Source note: `custom-models/generative-stories.qmd`

Previous: Custom models · Next: Writing a joint model That distinction will matter again on the next slide.

## Slide 20: Writing a joint model

Source note: `custom-models/writing-a-joint-model.qmd`

We now turn to Writing a joint model. The preceding page introduced the UDS natural-parts response and its item--annotator design. We now begin with a smaller item-only model so that every factor in the joint distribution has a visible empirical referent. Stable annotator location enters later.

## Slide 21: Writing a joint model

Source note: `custom-models/writing-a-joint-model.qmd`

The preceding page introduced the UDS natural-parts response and its item--annotator design. We now begin with a smaller item-only model so that every factor in the joint distribution has a visible empirical referent. Stable annotator location enters later. A **joint probability model** assigns one factor to every random step in a data-generating process. This is the product rule applied to the annotation process. The product states which quantities are conditionally independent and which observations share an unobserved item value. Keep the observational unit fixed while you interpret the result.

## Slide 22: Loading the observed-pair set

Source note: `custom-models/writing-a-joint-model.qmd`

Let $\mathcal O$ be the observed item--annotator pairs stored in `observed_pairs`. The likelihood has one response factor for each row in this set. It does not add factors for item--annotator combinations that were never observed. The preceding page introduced the UDS natural-parts response and its item--annotator design. We now begin with a smaller item-only model so that every factor in the joint distribution has a visible empirical referent. Stable annotator location enters later. Keep the observational unit fixed while you interpret the result.

## Slide 23: Translating steps into factors

Source note: `custom-models/writing-a-joint-model.qmd`

Let $\theta_i$ be the log odds of a yes response for predicate-node item $i$ in the item-only model. Then and the item values follow That distinction will matter again on the next slide.

## Slide 24: Translating steps into factors: equation 1

Source note: `custom-models/writing-a-joint-model.qmd`

The displayed expression formalizes translating steps into factors: equation 1. Let $\theta_i$ be the log odds of a yes response for predicate-node item $i$ in the item-only model. Then Keep track of what each term refers to in the linguistic dataset.

## Slide 25: Translating steps into factors: equation 2

Source note: `custom-models/writing-a-joint-model.qmd`

The displayed expression formalizes translating steps into factors: equation 2. and the item values follow Keep track of what each term refers to in the linguistic dataset.

## Slide 26: Translating steps into factors: equation 3

Source note: `custom-models/writing-a-joint-model.qmd`

The displayed expression formalizes translating steps into factors: equation 3. For observed responses $\mathbf y$ and item values $\boldsymbol\theta$, the joint distribution is Keep track of what each term refers to in the linguistic dataset.

## Slide 27: Fitting the item-only model

Source note: `custom-models/writing-a-joint-model.qmd`

The following fit evaluates the empirical item-only model. It uses every row in $\mathcal O$ and partially pools the observed item deviations. This is an intermediate analysis: omitting annotator effects is a declared simplification, not a claim that annotators have identical response locations. The integrated log likelihood combines the response factors with the item population rather than treating the fitted item deviations as independent observations. Its numerical value depends on the complete UDS response matrix and the stated item-only model. Use the graph or equation to say the result in ordinary language.

## Slide 28: Comparing raw summaries with fitted item probabilities

Source note: `custom-models/writing-a-joint-model.qmd`

The vertical bands arise because observed items have two responses and observed have three. The fitted values move raw endpoints toward the item population. This is partial pooling, not recovery of a context-free lexical category. The preceding page introduced the UDS natural-parts response and its item--annotator design. We now begin with a smaller item-only model so that every factor in the joint distribution has a visible empirical referent. Stable annotator location enters later. Keep the observational unit fixed while you interpret the result.

## Slide 29: Comparing raw summaries with fitted item probabilities

Source note: `custom-models/writing-a-joint-model.qmd`

Start with the axes and the observed values. Raw item response proportions and fitted probabilities from the item-only model. Read the pattern before attaching a model interpretation to it.

## Slide 30: Separating observations from summaries

Source note: `custom-models/writing-a-joint-model.qmd`

For item $i$ with $n_i$ responses, the raw mean is determined by response rows already in the likelihood. Multiplying the joint model by a second likelihood term for $\bar Y_i$ would count the same annotations twice. The mean may appear in a plot or predictive check, as it does above, but it is not another measurement. Use the graph or equation to say the result in ordinary language.

## Slide 31: Separating observations from summaries

Source note: `custom-models/writing-a-joint-model.qmd`

The displayed expression formalizes separating observations from summaries. For item $i$ with $n_i$ responses, the raw mean Keep track of what each term refers to in the linguistic dataset.

## Slide 32: Writing a joint model

Source note: `custom-models/writing-a-joint-model.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Writing a joint model. Read the pattern before attaching a model interpretation to it.

## Slide 33: Interpretation

Source note: `custom-models/writing-a-joint-model.qmd`

Previous: Data-generating processes · Next: Parameter recovery Notice what is observed and what is supplied by the model.

## Slide 34: Parameter recovery

Source note: `custom-models/parameter-recovery.qmd`

We now turn to Parameter recovery. A model may fit without warnings even when the observed design contains too little information to separate its quantities. **Parameter recovery** tests the complete inference procedure on simulated responses whose generating values are known. Here the simulation preserves the exact item--annotator incidence pattern of the UDS natural-parts extract introduced on the first page.

## Slide 35: Parameter recovery

Source note: `custom-models/parameter-recovery.qmd`

A model may fit without warnings even when the observed design contains too little information to separate its quantities. **Parameter recovery** tests the complete inference procedure on simulated responses whose generating values are known. This is an audited model simulation, not a substitute for linguistic data. Its rows, item identities, annotator identities, and imbalance come from the released annotation design. The generating values and success thresholds were fixed before the released responses were fit. The interpretation is conditional on the sampling and measurement design.

## Slide 36: Loading the released design and audited cache

Source note: `custom-models/parameter-recovery.qmd`

The compact cache contains observed completed recovery fits and observed deterministic draws from the later released-data fit. Rendering uses the cache; it does not silently refit Stan. A model may fit without warnings even when the observed design contains too little information to separate its quantities. **Parameter recovery** tests the complete inference procedure on simulated responses whose generating values are known. Here the simulation preserves the exact item--annotator incidence pattern of the UDS natural-parts extract introduced on the first page. That distinction will matter again on the next slide.

## Slide 37: The complete Stan program

Source note: `custom-models/parameter-recovery.qmd`

The crossed response model constructs item and annotator deviations by centering non-centered standard-normal vectors. Centering the realized vectors fixes their finite-sample sums at zero. A model may fit without warnings even when the observed design contains too little information to separate its quantities. **Parameter recovery** tests the complete inference procedure on simulated responses whose generating values are known. Here the simulation preserves the exact item--annotator incidence pattern of the UDS natural-parts extract introduced on the first page. Use the graph or equation to say the result in ordinary language.

## Slide 38: The exact recovery generator and fitting call

Source note: `custom-models/parameter-recovery.qmd`

The code below is the executable core of one audited replicate. It uses the observed row indices without changing which annotator saw which item. The full audit ran replicates 1 through 12; simulation seed $7300+s$ generated replicate $s$, and the two fitting chains used seeds $740000+100s+c$ for chain $c$. The archived run combined the two chain files after each call. Every reported result below comes from that chain-specific run stored in the tracked compact cache. The interpretation is conditional on the sampling and measurement design.

## Slide 39: Declaring the recovery gate

Source note: `custom-models/parameter-recovery.qmd`

For replicate $s$, an error is $\widehat\theta_s-\theta_s$. Across $S$ replicates, estimated bias and root mean squared error are The audit used medians and recovery correlations because the target includes population scales and high-dimensional latent orderings. The interpretation is conditional on the sampling and measurement design.

## Slide 40: Declaring the recovery gate: equation 1

Source note: `custom-models/parameter-recovery.qmd`

The displayed expression formalizes declaring the recovery gate: equation 1. For replicate $s$, an error is $\widehat\theta_s-\theta_s$. Across $S$ replicates, estimated bias and root mean squared error are Keep track of what each term refers to in the linguistic dataset.

## Slide 41: Declaring the recovery gate: equation 2

Source note: `custom-models/parameter-recovery.qmd`

The displayed expression formalizes declaring the recovery gate: equation 2. The audit used medians and recovery correlations because the target includes population scales and high-dimensional latent orderings. Keep track of what each term refers to in the linguistic dataset.

## Slide 42: Seeing variation across complete fits

Source note: `custom-models/parameter-recovery.qmd`

The gate passed. But item recovery remains the weakest part of the result: with two or three responses per item, recovery supports a regularized ordering in aggregate, not a precise lexical interpretation for every predicate node. Successful recovery shows that the fitter can retrieve the declared targets when data arise from this model under this incidence design. It does not establish that real annotators follow the generator. The released-data analysis still requires posterior predictive checks and measurement limitations. Keep the observational unit fixed while you interpret the result.

## Slide 43: Seeing variation across complete fits

Source note: `custom-models/parameter-recovery.qmd`

Start with the axes and the observed values. Posterior medians from twelve complete recovery fits. Horizontal lines mark the generating values. Read the pattern before attaching a model interpretation to it.

## Slide 44: Parameter recovery

Source note: `custom-models/parameter-recovery.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Parameter recovery. Read the pattern before attaching a model interpretation to it.

## Slide 45: Interpretation

Source note: `custom-models/parameter-recovery.qmd`

Previous: Writing a joint model · Next: Annotations are measurements That distinction will matter again on the next slide.

## Slide 46: Annotations are measurements

Source note: `custom-models/annotations-as-measurements.qmd`

We now turn to Annotations are measurements. Şahin and Adalı (2018) describe the ITU/IMST Turkish PropBank: predicate-specific frames were paired with argument candidates from the IMST dependency treebank, Turkish-speaking crowd workers selected plain-language role descriptions, and unresolved cases were adjudicated. The official project release provides the frames, crowd layers, and final annotations.

## Slide 47: Turkish PropBank: the empirical object

Source note: `custom-models/annotations-as-measurements.qmd`

This is the first use of Turkish PropBank in this module. The slide names the observation represented in the teaching table and links the original source. We will keep that unit fixed when we compute and interpret quantities from these data.

## Slide 48: Annotations are measurements

Source note: `custom-models/annotations-as-measurements.qmd`

Şahin and Adalı (2018) describe the ITU/IMST Turkish PropBank: predicate-specific frames were paired with argument candidates from the IMST dependency treebank, Turkish-speaking crowd workers selected plain-language role descriptions, and unresolved cases were adjudicated. The official project release provides the frames, crowd layers, and final annotations. The project site states that resources built in the project are distributed under CC BY-NC-SA 4.0, while the repository's short license header names the Turkish frame files specifically. We use the derived table for this noncommercial course under the project-wide statement and retain that scope qualification. That distinction will matter again on the next slide.

## Slide 49: Loading individual judgments

Source note: `custom-models/annotations-as-measurements.qmd`

The binary response is A zero is a recorded disagreement, not a missing response. It also does not establish that the worker is wrong in an independent linguistic sense, because the comparison target is the project's adjudication. Keep the observational unit fixed while you interpret the result.

## Slide 50: Loading individual judgments

Source note: `custom-models/annotations-as-measurements.qmd`

The displayed expression formalizes loading individual judgments. The binary response is Keep track of what each term refers to in the linguistic dataset.

## Slide 51: Keeping three agreement quantities distinct

Source note: `custom-models/annotations-as-measurements.qmd`

The paper reports Cohen's $\kappa=.936$ for an expert versus trust-weighted aggregate answers on 2,000 deliberately unambiguous test questions. It reports Fleiss' $\kappa=.65$ across varying workers on roughly 18,000 ordinary multi-category questions. The response above is a third quantity: an individual worker's binary match with the later adjudicated description. This lesson asks whether individual agreement differs between predicate-specific core descriptions and general adjunct-like descriptions. The **adjudication-agreement target (AAT)** is thus a property of this released task, not a worker-competence score and not a replication of either $\kappa$ statistic. Now connect the notation back to the linguistic comparison.

## Slide 52: Raw agreement by adjudicated role class

Source note: `custom-models/annotations-as-measurements.qmd`

The raw proportions retain every individual judgment but do not account for repeated items or workers. Items may differ in difficulty, and workers may differ in response behavior. Şahin and Adalı (2018) describe the ITU/IMST Turkish PropBank: predicate-specific frames were paired with argument candidates from the IMST dependency treebank, Turkish-speaking crowd workers selected plain-language role descriptions, and unresolved cases were adjudicated. The official project release provides the frames, crowd layers, and final annotations. The interpretation is conditional on the sampling and measurement design.

## Slide 53: Fitting a crossed measurement model

Source note: `custom-models/annotations-as-measurements.qmd`

Let $u_i$ be an item intercept and $v_j$ a worker intercept. The model is The fixed contrast compares adjudicated role classes at zero-valued item and worker intercepts. The crossed terms retain the repeated-measurement structure. Use the graph or equation to say the result in ordinary language.

## Slide 54: Fitting a crossed measurement model: equation 1

Source note: `custom-models/annotations-as-measurements.qmd`

The displayed expression formalizes fitting a crossed measurement model: equation 1. Let $u_i$ be an item intercept and $v_j$ a worker intercept. The model is Keep track of what each term refers to in the linguistic dataset.

## Slide 55: Fitting a crossed measurement model: equation 2

Source note: `custom-models/annotations-as-measurements.qmd`

The displayed expression formalizes fitting a crossed measurement model: equation 2. The fixed contrast compares adjudicated role classes at zero-valued item and worker intercepts. The crossed terms retain the repeated-measurement structure. Keep track of what each term refers to in the linguistic dataset.

## Slide 56: Fitting a crossed measurement model: equation 3

Source note: `custom-models/annotations-as-measurements.qmd`

The displayed expression formalizes fitting a crossed measurement model: equation 3. The fixed contrast compares adjudicated role classes at zero-valued item and worker intercepts. The crossed terms retain the repeated-measurement structure. Keep track of what each term refers to in the linguistic dataset.

## Slide 57: Showing raw and fitted agreement together

Source note: `custom-models/annotations-as-measurements.qmd`

Individual judgments agree with adjudicated core descriptions more often than with adjunct-like descriptions in this extract. The teaching contrast collapses the paper's multi-category role inventory into two release-based groups. It does not reproduce the paper's agreement calculations, estimate worker competence, or validate the final label. Previous: Parameter recovery · Next: Annotator effects Keep the observational unit fixed while you interpret the result.

## Slide 58: Showing raw and fitted agreement together

Source note: `custom-models/annotations-as-measurements.qmd`

Start with the axes and the observed values. Individual agreement with adjudication. Raw proportions use exact binomial intervals; fitted probabilities condition on zero item and worker intercepts. Read the pattern before attaching a model interpretation to it.

## Slide 59: Annotations are measurements

Source note: `custom-models/annotations-as-measurements.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Annotations are measurements. Read the pattern before attaching a model interpretation to it.

## Slide 60: Interpretation

Source note: `custom-models/annotations-as-measurements.qmd`

Previous: Parameter recovery · Next: Annotator effects The interpretation is conditional on the sampling and measurement design.

## Slide 61: Annotator effects

Source note: `custom-models/annotator-effects.qmd`

We now turn to Annotator effects. The Turkish PropBank analysis separated agreement from adjudication. We now return to the UDS natural-parts responses, where each predicate node was judged by two or three annotators. A stable annotator term may separate an annotator's response location from the item propensities estimated from overlapping judgments.

## Slide 62: Annotator effects

Source note: `custom-models/annotator-effects.qmd`

The Turkish PropBank analysis separated agreement from adjudication. We now return to the UDS natural-parts responses, where each predicate node was judged by two or three annotators. A stable annotator term may separate an annotator's response location from the item propensities estimated from overlapping judgments. We use **annotator location effect** for this term. It describes a stable upward or downward shift in log odds under this instrument. It is not a measure of annotator quality or proof of a context-independent bias. Keep the observational unit fixed while you interpret the result.

## Slide 63: Loading raw responses and fitted summaries

Source note: `custom-models/annotator-effects.qmd`

The raw rate for annotator $j$ is This rate mixes annotator behavior with the particular items assigned to that annotator. The crossed model instead represents item and annotator locations simultaneously. That distinction will matter again on the next slide.

## Slide 64: Loading raw responses and fitted summaries

Source note: `custom-models/annotator-effects.qmd`

The displayed expression formalizes loading raw responses and fitted summaries. The raw rate for annotator $j$ is Keep track of what each term refers to in the linguistic dataset.

## Slide 65: Adding one location term

Source note: `custom-models/annotator-effects.qmd`

Let $u_i$ be item $i$'s deviation and $a_j$ annotator $j$'s location effect. The response model is The fitted model constructs its deviations from centered standard-normal vectors: Notice what is observed and what is supplied by the model.

## Slide 66: Adding one location term: equation 1

Source note: `custom-models/annotator-effects.qmd`

The displayed expression formalizes adding one location term: equation 1. Let $u_i$ be item $i$'s deviation and $a_j$ annotator $j$'s location effect. The response model is Keep track of what each term refers to in the linguistic dataset.

## Slide 67: Adding one location term: equation 2

Source note: `custom-models/annotator-effects.qmd`

The displayed expression formalizes adding one location term: equation 2. The fitted model constructs its deviations from centered standard-normal vectors: Keep track of what each term refers to in the linguistic dataset.

## Slide 68: Adding one location term: equation 3

Source note: `custom-models/annotator-effects.qmd`

The displayed expression formalizes adding one location term: equation 3. A positive $a_j$ raises the log odds of a yes response for every item judged by annotator $j$; a negative value lowers them. The effect is shared across responses, so it is not trial noise. Keep track of what each term refers to in the linguistic dataset.

## Slide 69: Adding one location term: equation 4

Source note: `custom-models/annotator-effects.qmd`

The displayed expression formalizes adding one location term: equation 4. A positive $a_j$ raises the log odds of a yes response for every item judged by annotator $j$; a negative value lowers them. The effect is shared across responses, so it is not trial noise. Keep track of what each term refers to in the linguistic dataset.

## Slide 70: Fixing the coordinate system

Source note: `custom-models/annotator-effects.qmd`

The decomposition is not identified without a reference. For any constant $c$, The response probabilities do not change. Centering the realized effects imposes The interpretation is conditional on the sampling and measurement design.

## Slide 71: Fixing the coordinate system: equation 1

Source note: `custom-models/annotator-effects.qmd`

The displayed expression formalizes fixing the coordinate system: equation 1. The decomposition is not identified without a reference. For any constant $c$, Keep track of what each term refers to in the linguistic dataset.

## Slide 72: Fixing the coordinate system: equation 2

Source note: `custom-models/annotator-effects.qmd`

The displayed expression formalizes fixing the coordinate system: equation 2. The response probabilities do not change. Centering the realized effects imposes Keep track of what each term refers to in the linguistic dataset.

## Slide 73: Raw rates and posterior effects

Source note: `custom-models/annotator-effects.qmd`

The plot keeps raw measurements and fitted model quantities in separate panels because they use different scales. Exact binomial intervals summarize each raw rate; posterior intervals summarize each annotator location effect. The plot shows why the location term matters: the raw rates span a broad range, and the fitted effects retain broad separation after item variation is represented. But the two panels are not interchangeable. Raw rates average over assigned items; fitted effects condition on the crossed model and its zero-sum coordinate convention. Use the graph or equation to say the result in ordinary language.

## Slide 74: Raw rates and posterior effects

Source note: `custom-models/annotator-effects.qmd`

Start with the axes and the observed values. Raw natural-parts response rates and posterior annotator location effects. Panels have distinct horizontal scales. Read the pattern before attaching a model interpretation to it.

## Slide 75: Location is not every annotator difference

Source note: `custom-models/annotator-effects.qmd`

Annotators may differ in response consistency, interpretation, or use of an ordered scale. A location effect cannot represent those patterns. It shifts every predicted log odds in the same direction. Item and annotator effects would be perfectly confounded if each item were judged by only one annotator. The UDS teaching extract instead forms one connected bipartite graph across observed items and observed annotators. Connectivity supplies paths of shared judgments, though sparse responses still limit the precision of individual item effects. That distinction will matter again on the next slide.

## Slide 76: Annotator effects

Source note: `custom-models/annotator-effects.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Annotator effects. Read the pattern before attaching a model interpretation to it.

## Slide 77: Interpretation

Source note: `custom-models/annotator-effects.qmd`

Previous: Annotations are measurements · Next: Measuring natural-parts judgments That distinction will matter again on the next slide.

## Slide 78: Measuring natural-parts judgments

Source note: `custom-models/uds-measurement-model.qmd`

We now turn to Measuring natural-parts judgments. We can now combine the UDS response process, its joint factorization, the recovery gate, and annotator locations. The target is the **natural-parts response target (NPRT)**: separation of predicate-node variation from annotator variation in binary natural-parts responses.

## Slide 79: Measuring natural-parts judgments

Source note: `custom-models/uds-measurement-model.qmd`

We can now combine the UDS response process, its joint factorization, the recovery gate, and annotator locations. The target is the **natural-parts response target (NPRT)**: separation of predicate-node variation from annotator variation in binary natural-parts responses. The model is narrower than the event-structure representation in Gantt, Glass, and White (2022). It does not model conditional follow-up questions or confidence. And it treats an item as one predicate node in sentence context, not as a verb lemma or context-free event type. Keep the observational unit fixed while you interpret the result.

## Slide 80: Loading measurements and posterior draws

Source note: `custom-models/uds-measurement-model.qmd`

Only the raw binary responses enter the likelihood. The released normalized value is retained for an external comparison after fitting. We can now combine the UDS response process, its joint factorization, the recovery gate, and annotator locations. The target is the **natural-parts response target (NPRT)**: separation of predicate-node variation from annotator variation in binary natural-parts responses. Now connect the notation back to the linguistic comparison.

## Slide 81: Writing the complete model

Source note: `custom-models/uds-measurement-model.qmd`

For each observed pair $(i,j)\in\mathcal O$, The fitted deviations are effects constructed by centering non-centered standard-normal vectors, Notice what is observed and what is supplied by the model.

## Slide 82: Writing the complete model: equation 1

Source note: `custom-models/uds-measurement-model.qmd`

The displayed expression formalizes writing the complete model: equation 1. For each observed pair $(i,j)\in\mathcal O$, Keep track of what each term refers to in the linguistic dataset.

## Slide 83: Writing the complete model: equation 2

Source note: `custom-models/uds-measurement-model.qmd`

The displayed expression formalizes writing the complete model: equation 2. The fitted deviations are effects constructed by centering non-centered standard-normal vectors, Keep track of what each term refers to in the linguistic dataset.

## Slide 84: Writing the complete model: equation 3

Source note: `custom-models/uds-measurement-model.qmd`

The displayed expression formalizes writing the complete model: equation 3. The priors are Keep track of what each term refers to in the linguistic dataset.

## Slide 85: Writing the complete model: equation 4

Source note: `custom-models/uds-measurement-model.qmd`

The displayed expression formalizes writing the complete model: equation 4. Since the scale parameters are constrained positive in Stan, the normal statements for them induce half-normal priors. Centering fixes both realized effect sums at zero. Thus $\alpha$ is the log odds for an item and annotator at their respective origins, and Keep track of what each term refers to in the linguistic dataset.

## Slide 86: Writing the complete model: equation 5

Source note: `custom-models/uds-measurement-model.qmd`

The displayed expression formalizes writing the complete model: equation 5. is item $i$'s yes probability with the annotator effect fixed at zero. It is not the probability obtained by integrating over an annotator population. Keep track of what each term refers to in the linguistic dataset.

## Slide 87: Writing the complete model: equation 6

Source note: `custom-models/uds-measurement-model.qmd`

The displayed expression formalizes writing the complete model: equation 6. is item $i$'s yes probability with the annotator effect fixed at zero. It is not the probability obtained by integrating over an annotator population. Keep track of what each term refers to in the linguistic dataset.

## Slide 88: Writing the complete model: equation 7

Source note: `custom-models/uds-measurement-model.qmd`

The displayed expression formalizes writing the complete model: equation 7. is item $i$'s yes probability with the annotator effect fixed at zero. It is not the probability obtained by integrating over an annotator population. Keep track of what each term refers to in the linguistic dataset.

## Slide 89: Fitting the released responses

Source note: `custom-models/uds-measurement-model.qmd`

The parameter-recovery page prints the complete Stan program and the exact simulation loop. After that gate passed, the audit fitted the released responses with four separately seeded chains. The fitting call was equivalent to the visible code below; `run_one_chain()` records one chain per seed before the results are combined. Rendering reads 400 evenly spaced draws from the audited 3,200-draw posterior. The compact cache is a teaching artifact from the full fit, not an independent refit. Keep the observational unit fixed while you interpret the result.

## Slide 90: Population summaries

Source note: `custom-models/uds-measurement-model.qmd`

Both scale intervals lie away from zero in this model and extract. Predicate nodes vary in their response propensities, and annotators vary in response location after item variation is represented. This is evidence about the annotation process, not a partition of predicates into event-structural categories. The intercept should not be read as the logit of the raw yes proportion. The raw average mixes different item and annotator effects through a nonlinear link, while $\alpha$ locates an item and annotator whose deviations are both zero. Now connect the notation back to the linguistic comparison.

## Slide 91: Seeing partial pooling

Source note: `custom-models/uds-measurement-model.qmd`

Most raw item proportions occur at a few fractions because each item has two or three responses. Posterior probabilities occupy a continuous range and move raw endpoints toward the fitted population. This shrinkage reflects both sparse item measurement and the annotator composition of each item. We can now combine the UDS response process, its joint factorization, the recovery gate, and annotator locations. The target is the **natural-parts response target (NPRT)**: separation of predicate-node variation from annotator variation in binary natural-parts responses. Keep the observational unit fixed while you interpret the result.

## Slide 92: Seeing partial pooling

Source note: `custom-models/uds-measurement-model.qmd`

Start with the axes and the observed values. Raw item proportions and posterior median probabilities with the annotator effect fixed at zero. Read the pattern before attaching a model interpretation to it.

## Slide 93: Checking replicated response matrices

Source note: `custom-models/uds-measurement-model.qmd`

A fitted ordering is not enough. We generate one replicated response for every observed item--annotator pair in each cached posterior draw. Two summaries target distinct features: the overall yes rate and the proportion of items containing both response values. Both observed summaries fall inside their predictive intervals. The second check matters because a model might reproduce the overall rate while predicting too little or too much within-item disagreement. The interpretation is conditional on the sampling and measurement design.

## Slide 94: Checking replicated response matrices

Source note: `custom-models/uds-measurement-model.qmd`

Start with the axes and the observed values. Posterior predictive distributions. Vertical lines mark the observed statistics. Read the pattern before attaching a model interpretation to it.

## Slide 95: Comparing with the released normalized values

Source note: `custom-models/uds-measurement-model.qmd`

The release also supplies one normalized natural-parts value per item. Those values were not likelihood inputs. The following association compares the fitted and released measurement procedures after fitting. The Spearman correlation is observed. This association suggests that the compact binary model captures much of the released ordering. It is not a likelihood contribution or a test in which one measurement procedure must defeat the other. The interpretation is conditional on the sampling and measurement design.

## Slide 96: Limits of the measurement claim

Source note: `custom-models/uds-measurement-model.qmd`

The recovery and predictive gates support one narrow analysis. Six limits remain. 1. The deterministic teaching extract contains 1,000 multiply annotated development and test items; it is not a random sample of every UDS predicate. 2. Most items have three responses, so item probabilities remain strongly regularized. 3. The annotator term represents location only, not discrimination, consistency, or interpretation. 4. The raw confidence serialization conflicts with the documented scale, so confidence is excluded. Notice what is observed and what is supplied by the model.

## Slide 97: Measuring natural-parts judgments

Source note: `custom-models/uds-measurement-model.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Measuring natural-parts judgments. Read the pattern before attaching a model interpretation to it.

## Slide 98: Measuring natural-parts judgments

Source note: `custom-models/uds-measurement-model.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Measuring natural-parts judgments. Read the pattern before attaching a model interpretation to it.

## Slide 99: Interpretation

Source note: `custom-models/uds-measurement-model.qmd`

Previous: Annotator effects · Next: Gated annotations Use the graph or equation to say the result in ordinary language.

## Slide 100: Gated annotations

Source note: `custom-models/gated-annotations.qmd`

We now turn to Gated annotations. The UDS event protocol uses the natural-parts response as a gate. A yes displays questions about part similarity and average part duration; a no displays questions about whole-situation duration and dynamicity. An undisplayed response is thus a **by-design absence**. It is not a low value on that branch and not a failed attempt to answer a displayed question.

## Slide 101: Gated annotations

Source note: `custom-models/gated-annotations.qmd`

The UDS event protocol uses the natural-parts response as a gate. A yes displays questions about part similarity and average part duration; a no displays questions about whole-situation duration and dynamicity. An undisplayed response is thus a **by-design absence**. The local extract supports numerical analysis of the observed natural-parts gate only. It does not contain audited raw conditional-branch responses, and the available raw confidence serialization conflicts with the documented response scale. This page thus analyzes the gate empirically and keeps the branch model symbolic. Notice what is observed and what is supplied by the model.

## Slide 102: Reproducing the observed gate

Source note: `custom-models/gated-annotations.qmd`

These are recorded gate responses. The no count is not a count of zero-valued part-similarity judgments, because the part-similarity question was never displayed after those responses. The UDS event protocol uses the natural-parts response as a gate. A yes displays questions about part similarity and average part duration; a no displays questions about whole-situation duration and dynamicity. An undisplayed response is thus a **by-design absence**. It is not a low value on that branch and not a failed attempt to answer a displayed question. The interpretation is conditional on the sampling and measurement design.

## Slide 103: Factoring the gate and follow-up response

Source note: `custom-models/gated-annotations.qmd`

Let $G_{ij}=1$ when annotator $j$ reports that predicate-node item $i$ has natural parts, and let $G_{ij}=0$ otherwise. Let $Y_{ij}$ denote a response on the yes branch, such as part similarity. Write $\pi_{ij}$ for the gate probability and $f_Y(y_{ij}\mid\phi_{ij})$ for the conditional follow-up probability or density. The observed response contribution is Keep the observational unit fixed while you interpret the result.

## Slide 104: Factoring the gate and follow-up response: equation 1

Source note: `custom-models/gated-annotations.qmd`

The displayed expression formalizes factoring the gate and follow-up response: equation 1. Let $G_{ij}=1$ when annotator $j$ reports that predicate-node item $i$ has natural parts, and let $G_{ij}=0$ otherwise. Let $Y_{ij}$ denote a response on the yes branch, such as part similarity. Write $\pi_{ij}$ for the gate probability and $f_Y(y_{ij}\mid\phi_{ij})$ for the conditional follow-up probability or density. Keep track of what each term refers to in the linguistic dataset.

## Slide 105: Factoring the gate and follow-up response: equation 2

Source note: `custom-models/gated-annotations.qmd`

The displayed expression formalizes factoring the gate and follow-up response: equation 2. The observed response contribution is Keep track of what each term refers to in the linguistic dataset.

## Slide 106: Checking only the fitted gate

Source note: `custom-models/gated-annotations.qmd`

The following posterior predictive calculation uses the audited binary gate model. It simulates no follow-up values. This check supports the gate component at the overall-rate level. It supplies no evidence about the conditional branches because no branch response was simulated or scored. That distinction will matter again on the next slide.

## Slide 107: Checking only the fitted gate

Source note: `custom-models/gated-annotations.qmd`

Start with the axes and the observed values. Posterior predictive distribution of the observed natural-parts gate rate. The vertical line marks the released rate. Read the pattern before attaching a model interpretation to it.

## Slide 108: The follow-up target is conditional

Source note: `custom-models/gated-annotations.qmd`

An average of observed yes-branch responses would describe cases that passed the gate: It would not estimate an unconditional property over all predicate nodes unless the model defined what the follow-up means when an annotator rejects the premise that natural parts exist. Replacing an undisplayed part-similarity response with zero would merge two events: rejecting the gate and passing the gate while selecting the scale's lowest response. Now connect the notation back to the linguistic comparison.

## Slide 109: The follow-up target is conditional

Source note: `custom-models/gated-annotations.qmd`

The displayed expression formalizes the follow-up target is conditional. An average of observed yes-branch responses would describe cases that passed the gate: Keep track of what each term refers to in the linguistic dataset.

## Slide 110: Separating protocol absence from stochastic missingness

Source note: `custom-models/gated-annotations.qmd`

A rectangular data table may store `NA` for an undisplayed follow-up. The joint model, not the storage symbol, determines what that `NA` means. Protocol absence differs from the missing intended measurements discussed in missingness mechanisms: here the instrument defines no follow-up response after the incompatible gate value. The blocked measurements are part similarity, part duration, whole-situation duration, dynamicity, and raw confidence. No numerical claim about their distributions, associations, or fitted values follows from this page. Notice what is observed and what is supplied by the model.

## Slide 111: Gated annotations

Source note: `custom-models/gated-annotations.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Gated annotations. Read the pattern before attaching a model interpretation to it.

## Slide 112: Interpretation

Source note: `custom-models/gated-annotations.qmd`

Previous: Measuring natural-parts judgments Keep the observational unit fixed while you interpret the result.
