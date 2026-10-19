# Experimental design

This transcript is generated from the speaker notes in the slide source. Slide identifiers, titles, note-page provenance, and order are identical.

## Slide 1: Experimental design

Source note: `experimental-design/index.qmd`

Welcome to Experimental design. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.

## Slide 2: Experimental design

Source note: `experimental-design/index.qmd`

We now turn to Experimental design. The ManyBabies Consortium's infant-directed-speech study coordinated a shared preference experiment across laboratories. This unit uses the frozen trial table from the MIT-licensed official analysis repository. One row is a possible test trial for an infant, including rows completed by the release's exclusion code when no trial metadata or included looking time is available.

## Slide 3: ManyBabies: the empirical object

Source note: `experimental-design/index.qmd`

This is the first use of ManyBabies in this module. The slide names the observation represented in the teaching table and links the original source. We will keep that unit fixed when we compute and interpret quantities from these data.

## Slide 4: Experimental design

Source note: `experimental-design/index.qmd`

The ManyBabies Consortium's infant-directed-speech study coordinated a shared preference experiment across laboratories. This unit uses the frozen trial table from the MIT-licensed official analysis repository. Register varies within infant: the protocol presents infant-directed speech (IDS) and adult-directed speech (ADS) trials to the same infant. Trial order varies between infants. Infants are recruited within laboratories, and paired stimuli recur across infants. Thus the trial row, assignment unit, sampling unit, laboratory, and stimulus are distinct empirical objects. That distinction will matter again on the next slide.

## Slide 5: The design sequence

Source note: `experimental-design/index.qmd`

Units of assignment separates possible trials, infants, laboratories, and recurring stimuli. The assignment-mechanism page then compares the released order labels with a reproducible constrained allocation and distinguishes verification of a procedure from evidence that the historical implementation followed it. Within-participant designs construct the IDS-minus-ADS contrast from infants represented in both registers. Between-participant designs use the observed second-session grouping to show what a between-group comparison estimates when the grouping variable was not randomly assigned. The interpretation is conditional on the sampling and measurement design.

## Slide 6: Keep the claim aligned with the design

Source note: `experimental-design/index.qmd`

Looking time is a behavioral measure. An IDS--ADS difference may support a claim about preference under the tested stimuli and procedures, but it does not uniquely identify a perceptual or social mechanism. Likewise, method, laboratory, age, and community differences may describe this release without becoming randomized treatment effects. The module thus keeps four questions visible: (i) which unit could independently receive a condition, (ii) which measurements repeat within that unit, (iii) which allocation or exclusion rule produced the analyzed rows, and (iv) which population or future design the contrast is meant to represent. Keep the observational unit fixed while you interpret the result.

## Slide 7: Interpretation

Source note: `experimental-design/index.qmd`

The module thus keeps four questions visible: (i) which unit could independently receive a condition, (ii) which measurements repeat within that unit, (iii) which allocation or exclusion rule produced the analyzed rows, and (iv) which population or future design the contrast is meant to represent. The interpretation is conditional on the sampling and measurement design.

## Slide 8: Units of assignment

Source note: `experimental-design/units-of-assignment.qmd`

We now turn to Units of assignment. The ManyBabies Consortium tested infants' preference for infant-directed speech (IDS) over adult-directed speech (ADS) in a shared multi-laboratory experiment. The primary report describes the stimuli, protocol, exclusions, and analyses (The ManyBabies Consortium 2020); the frozen course table comes from the official analysis repository at commit `dc3eb5b`. We begin with that table rather than with a small constructed design.

## Slide 9: Units of assignment

Source note: `experimental-design/units-of-assignment.qmd`

The ManyBabies Consortium tested infants' preference for infant-directed speech (IDS) over adult-directed speech (ADS) in a shared multi-laboratory experiment. The primary report describes the stimuli, protocol, exclusions, and analyses (The ManyBabies Consortium 2020); the frozen course table comes from the official analysis repository at commit `dc3eb5b`. Each infant could encounter sixteen 18-second test stimuli: eight IDS stimuli and eight ADS stimuli. The official exclusion code then completed every retained infant's record to sixteen possible test-trial rows. A row may thus contain an included looking time, recorded trial metadata without an included looking time, or a completed measurement opportunity without recorded trial metadata. Use the graph or equation to say the result in ordinary language.

## Slide 10: Assignment and measurement are different maps

Source note: `experimental-design/units-of-assignment.qmd`

The **unit of assignment**, also called the experimental unit, is the smallest entity that can independently receive a condition under the actual procedure. Let $r$ index possible trial rows and let $g(r)$ map row $r$ to its infant. If $Z_i$ is infant $i$'s assigned trial order, then All sixteen possible rows from one infant share one order assignment. The rows do not represent sixteen independent assignments. Keep the observational unit fixed while you interpret the result.

## Slide 11: Assignment and measurement are different maps

Source note: `experimental-design/units-of-assignment.qmd`

The displayed expression formalizes assignment and measurement are different maps. The **unit of assignment**, also called the experimental unit, is the smallest entity that can independently receive a condition under the actual procedure. Let $r$ index possible trial rows and let $g(r)$ map row $r$ to its infant. If $Z_i$ is infant $i$'s assigned trial order, then Keep track of what each term refers to in the linguistic dataset.

## Slide 12: Unequal information within laboratories

Source note: `experimental-design/units-of-assignment.qmd`

Infants are nested within laboratories, but the number of included trials varies across infants. The gray points below are infants; the blue point is the laboratory median. Laboratory labels are suppressed because the figure concerns the dependence structure, not a ranking of sites. Additional trials may improve the measurement of a particular infant's looking behavior, and additional infants may improve the comparison across infants. They are not interchangeable. Likewise, eight recurring paired stimuli supply repeated material measurements, not eight additional infant assignments. Keep the observational unit fixed while you interpret the result.

## Slide 13: What this release can establish

Source note: `experimental-design/units-of-assignment.qmd`

The final table begins after participant- and laboratory-level exclusions. It can establish the units present in the released analysis table, but it cannot reconstruct the full recruitment process from the retained records alone. The unit of assignment is the smallest entity whose assigned condition could vary independently under the procedure. In ManyBabies 1, order varies between infants, register varies within infants, and looking-time measurements repeat within infants, laboratories, and paired stimuli. The next page asks what the public release can and cannot establish about the assignment mechanism. Notice what is observed and what is supplied by the model.

## Slide 14: Units of assignment

Source note: `experimental-design/units-of-assignment.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Units of assignment. Read the pattern before attaching a model interpretation to it.

## Slide 15: Units of assignment

Source note: `experimental-design/units-of-assignment.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Units of assignment. Read the pattern before attaching a model interpretation to it.

## Slide 16: Random assignment

Source note: `experimental-design/random-assignment.qmd`

We now turn to Random assignment. We continue with the ManyBabies 1 release introduced on the preceding page. Its design makes a useful distinction between a documented sequence and a documented allocation device. The paper reports four pseudorandom trial sequences, each containing four blocks with two IDS and two ADS trials. The release records the order attached to an infant.

## Slide 17: Random assignment

Source note: `experimental-design/random-assignment.qmd`

We continue with the ManyBabies 1 release introduced on the preceding page. Its design makes a useful distinction between a documented sequence and a documented allocation device. The paper reports four pseudorandom trial sequences, each containing four blocks with two IDS and two ADS trials. This is the allocation-verification boundary (AVB). We can verify realized order labels and balance in the release. We cannot use those labels alone to infer the probability rule used locally. Notice what is observed and what is supplied by the model.

## Slide 18: The assignment mechanism is a probability rule

Source note: `experimental-design/random-assignment.qmd`

The **assignment mechanism** specifies the probability with which each assignment unit receives each condition. Let $Z_i$ denote infant $i$'s order, and let $Y_i(z)$ denote an outcome the infant would supply under order $z$. Under a verified randomized allocation within laboratory, the assignment-identification link would be where $l(i)$ is the infant's laboratory. A balanced realized table does not establish this independence. The design record must also specify how order labels were generated, concealed, and assigned. Use the graph or equation to say the result in ordinary language.

## Slide 19: The assignment mechanism is a probability rule

Source note: `experimental-design/random-assignment.qmd`

The displayed expression formalizes the assignment mechanism is a probability rule. The **assignment mechanism** specifies the probability with which each assignment unit receives each condition. Let $Z_i$ denote infant $i$'s order, and let $Y_i(z)$ denote an outcome the infant would supply under order $z$. Under a verified randomized allocation within laboratory, the assignment-identification link would be Keep track of what each term refers to in the linguistic dataset.

## Slide 20: A relabeling diagnostic

Source note: `experimental-design/random-assignment.qmd`

We can still ask whether a measured pre-outcome characteristic is unusually imbalanced relative to a transparent reference operation. Infant age varies sharply by laboratory, so comparing raw order means would mix order balance with the laboratories that contributed each order. We first center age within laboratory. where $A_i^c=A_i-\overline A_{l(i)}$. We then relabel orders within each laboratory while preserving that laboratory's realized order counts. Now connect the notation back to the linguistic comparison.

## Slide 21: A relabeling diagnostic

Source note: `experimental-design/random-assignment.qmd`

The displayed expression formalizes a relabeling diagnostic. We can still ask whether a measured pre-outcome characteristic is unusually imbalanced relative to a transparent reference operation. Infant age varies sharply by laboratory, so comparing raw order means would mix order balance with the laboratories that contributed each order. We first center age within laboratory. Our statistic is the range of the four resulting order means, Keep track of what each term refers to in the linguistic dataset.

## Slide 22: Assignment is not sampling

Source note: `experimental-design/random-assignment.qmd`

Assignment governs how conditions are distributed among enrolled units. Sampling governs how infants, laboratories, and stimuli enter the study. Even a fully documented random allocation of orders would not make the laboratories a probability sample of laboratories or the North American English stimuli a probability sample of speech. The same distinction prevents a second error. Testing method was selected through each laboratory's established practice rather than assigned to infants. Method comparisons are thus observational and laboratory-linked. They should not be treated as if they arose from random assignment. Keep the observational unit fixed while you interpret the result.

## Slide 23: Random assignment

Source note: `experimental-design/random-assignment.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Random assignment. Read the pattern before attaching a model interpretation to it.

## Slide 24: Interpretation

Source note: `experimental-design/random-assignment.qmd`

Random assignment is a probability rule, not a property inferred from balanced labels. The ManyBabies study documents four order sequences and their realized use. The AVB requires us to stop there. Keep the observational unit fixed while you interpret the result.

## Slide 25: Within-participant designs

Source note: `experimental-design/within-participant-designs.qmd`

We now turn to Within-participant designs. In the ManyBabies 1 design, speech register varies within infant. Each infant could hear both infant-directed speech (IDS) and adult-directed speech (ADS), and each register was represented by eight stimuli. Looking time is the measured behavior: it may index attention to the two kinds of speech, but it is not a direct measure of a particular linguistic representation.

## Slide 26: Within-participant designs

Source note: `experimental-design/within-participant-designs.qmd`

In the ManyBabies 1 design, speech register varies within infant. Each infant could hear both infant-directed speech (IDS) and adult-directed speech (ADS), and each register was represented by eight stimuli. In a **within-participant design**, each participant contributes observations to more than one condition. The participant can thus supply the condition comparison before comparisons are averaged across participants. That distinction will matter again on the next slide.

## Slide 27: Each infant supplies a register contrast

Source note: `experimental-design/within-participant-designs.qmd`

Let $Y_{ir}$ be infant $i$'s mean included looking time in register $r$. The infant-level difference is and the infant-weighted mean difference among infants observed in both registers is Now connect the notation back to the linguistic comparison.

## Slide 28: Each infant supplies a register contrast: equation 1

Source note: `experimental-design/within-participant-designs.qmd`

The displayed expression formalizes each infant supplies a register contrast: equation 1. Let $Y_{ir}$ be infant $i$'s mean included looking time in register $r$. The infant-level difference is Keep track of what each term refers to in the linguistic dataset.

## Slide 29: Each infant supplies a register contrast: equation 2

Source note: `experimental-design/within-participant-designs.qmd`

The displayed expression formalizes each infant supplies a register contrast: equation 2. and the infant-weighted mean difference among infants observed in both registers is Keep track of what each term refers to in the linguistic dataset.

## Slide 30: Each infant supplies a register contrast: equation 3

Source note: `experimental-design/within-participant-designs.qmd`

The displayed expression formalizes each infant supplies a register contrast: equation 3. The unit entering the final average is the infant, not the trial. If an infant-specific tendency $a_i$ adds the same amount in both registers, it cancels within that infant: Keep track of what each term refers to in the linguistic dataset.

## Slide 31: Reconstructing the paired summary

Source note: `experimental-design/within-participant-designs.qmd`

We first average the included looking times within infant and register. We then reshape to one row per infant and retain infants with both means. The paired analysis contains observed infants. Their mean IDS-minus-ADS difference is observed seconds, with a standard deviation of observed seconds and a standard error of observed seconds. The estimate describes included looking time under the released pipeline. It does not imply that every infant preferred IDS. The interpretation is conditional on the sampling and measurement design.

## Slide 32: Unequal trial counts remain part of the target

Source note: `experimental-design/within-participant-designs.qmd`

An infant need not contribute the same number of included trials in the two registers. The following calculation recovers those counts before averaging. The unweighted mean of $D_i$ gives each complete infant one contribution, even when their register means rest on different numbers of trials. A row-weighted register difference would instead give more influence to infants with more included trials. Neither target is automatically preferable; the unit used in the average must match the question. Notice what is observed and what is supplied by the model.

## Slide 33: Order can modify a within-infant contrast

Source note: `experimental-design/within-participant-designs.qmd`

A **carryover effect** occurs when an earlier condition changes a later response. Attention may decline over the session, and earlier speech may change what an infant attends to later. ManyBabies used four pseudorandom sequences that alternated register within four-trial blocks. A within-participant design makes the infant the source of the IDS-minus-ADS comparison. Stable additive infant differences may cancel, while stimulus, order, and condition-specific variation remain. The next page contrasts this structure with the between-infant order groups. That distinction will matter again on the next slide.

## Slide 34: Within-participant designs

Source note: `experimental-design/within-participant-designs.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Within-participant designs. Read the pattern before attaching a model interpretation to it.

## Slide 35: Between-participant designs

Source note: `experimental-design/between-participant-designs.qmd`

We now turn to Between-participant designs. ManyBabies 1 combines two condition structures. Speech register varies within infant, while the four pseudorandom trial orders vary between infants. One infant is associated with one order across all sixteen possible test-trial rows.

## Slide 36: Between-participant designs

Source note: `experimental-design/between-participant-designs.qmd`

ManyBabies 1 combines two condition structures. Speech register varies within infant, while the four pseudorandom trial orders vary between infants. One infant is associated with one order across all sixteen possible test-trial rows. In a **between-participant design**, each participant contributes observations to only one level of a factor. The factor comparison is across groups rather than within the same participant. That distinction will matter again on the next slide.

## Slide 37: A group contrast over assigned order

Source note: `experimental-design/between-participant-designs.qmd`

Let $Y_i$ be infant $i$'s mean log looking time over included trials, and let $Z_i$ identify the infant's assigned order. The mean in order group $z$ is Each infant contributes to one and only one $overline Y_z$. Stable infant differences do not cancel through within-infant subtraction. This is the defining contrast with the IDS-minus-ADS summary on the preceding page. Keep the observational unit fixed while you interpret the result.

## Slide 38: A group contrast over assigned order

Source note: `experimental-design/between-participant-designs.qmd`

The displayed expression formalizes a group contrast over assigned order. Let $Y_i$ be infant $i$'s mean log looking time over included trials, and let $Z_i$ identify the infant's assigned order. The mean in order group $z$ is Keep track of what each term refers to in the linguistic dataset.

## Slide 39: Order is a nuisance assignment

Source note: `experimental-design/between-participant-designs.qmd`

This plot does not estimate a linguistic treatment effect. Trial order was used to distribute register and paired stimulus identity over session position. It is a between-infant factor, but it is not the speech-register contrast that motivated the experiment. The allocation-verification boundary also limits interpretation. Because the public source does not specify each laboratory's infant-to-order allocation device, differences among these four realized groups are descriptive. They should not be labeled causal effects of order. The interpretation is conditional on the sampling and measurement design.

## Slide 40: Trials improve an infant summary, not group replication

Source note: `experimental-design/between-participant-designs.qmd`

The release contains observed included trial outcomes from observed infants. More included trials may make an infant's $Y_i$ less sensitive to a particular stimulus. They do not increase $n_z$, because order was attached once to the infant. A trial-weighted group mean would give more influence to infants with more included trials. The displayed analysis instead gives every infant with an outcome one group-level contribution. This choice matches the between-infant comparison in the equation, though the figure remains descriptive. The interpretation is conditional on the sampling and measurement design.

## Slide 41: An observed laboratory attribute is not an assigned factor

Source note: `experimental-design/between-participant-designs.qmd`

Testing method also differs across infants, but laboratories used their established head-turn preference, single-screen, or eye-tracking procedures. Method is partly tied to laboratory and was not assigned to infants. It is thus not interchangeable with the assigned order factor. A between-participant design compares groups whose members occupy only one factor level. In ManyBabies 1, order has this structure, whereas register does not. The next page checks how the four orders counterbalance register and paired stimuli. Use the graph or equation to say the result in ordinary language.

## Slide 42: Between-participant designs

Source note: `experimental-design/between-participant-designs.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Between-participant designs. Read the pattern before attaching a model interpretation to it.

## Slide 43: Counterbalancing

Source note: `experimental-design/counterbalancing.qmd`

We now turn to Counterbalancing. ManyBabies 1 used four pseudorandom trial orders to distribute register and paired stimulus identity over the sixteen test positions. Each order contained four alternating blocks, each with two infant-directed-speech (IDS) and two adult-directed-speech (ADS) trials. The same IDS and ADS stimulus numbers formed pairs. We can recover the realized order templates from the released trial table.

## Slide 44: Counterbalancing

Source note: `experimental-design/counterbalancing.qmd`

ManyBabies 1 used four pseudorandom trial orders to distribute register and paired stimulus identity over the sixteen test positions. Each order contained four alternating blocks, each with two infant-directed-speech (IDS) and two adult-directed-speech (ADS) trials. The same IDS and ADS stimulus numbers formed pairs. **Counterbalancing** constrains how conditions and materials are distributed across orders. It does not create independent trials. In this study, the constraint makes register available within infant while distributing register and paired stimulus identity over trial position. Now connect the notation back to the linguistic comparison.

## Slide 45: Reconstructing the order templates

Source note: `experimental-design/counterbalancing.qmd`

Protocol deviations mean that the released rows need not agree perfectly within every order-by-position cell. We recover the modal register and stimulus number for each cell, then check the resulting template. Let $R_{ot}$ and $P_{ot}$ denote the modal register and paired stimulus at position $t$ in order $o$. The checks above establish the empirical margins That distinction will matter again on the next slide.

## Slide 46: Reconstructing the order templates: equation 1

Source note: `experimental-design/counterbalancing.qmd`

The displayed expression formalizes reconstructing the order templates: equation 1. Protocol deviations mean that the released rows need not agree perfectly within every order-by-position cell. We recover the modal register and stimulus number for each cell, then check the resulting template. Keep track of what each term refers to in the linguistic dataset.

## Slide 47: Reconstructing the order templates: equation 2

Source note: `experimental-design/counterbalancing.qmd`

The displayed expression formalizes reconstructing the order templates: equation 2. Let $R_{ot}$ and $P_{ot}$ denote the modal register and paired stimulus at position $t$ in order $o$. The checks above establish the empirical margins Keep track of what each term refers to in the linguistic dataset.

## Slide 48: A restrained order map

Source note: `experimental-design/counterbalancing.qmd`

The tile plot shows the register margin without placing a label in every cell. Pair identity remains checked in the code and table rather than added as sixty-four annotations. Each order contains both registers across the session rather than placing all IDS trials before all ADS trials. The four orders use different position patterns, which distributes a register contrast over earlier and later positions across infants. Notice what is observed and what is supplied by the model.

## Slide 49: Planned template and released records

Source note: `experimental-design/counterbalancing.qmd`

The modal template is a reconstruction from the release. We can compare every recorded metadata row with the relevant modal cell. The modal register template agrees with observed of recorded metadata rows, and the modal stimulus template agrees with observed. These are agreement rates with the modal released pattern after documented protocol deviations. They are not coder-accuracy estimates. That distinction will matter again on the next slide.

## Slide 50: What counterbalancing does not do

Source note: `experimental-design/counterbalancing.qmd`

Counterbalancing separates register from a fixed position and paired stimulus in the planned sequence. It does not remove dependence: trials still repeat within infants, stimuli recur across infants, and infants remain nested within laboratories. Nor does balance verify how infants were allocated to sequences. That claim remains subject to the allocation-verification boundary. Counterbalancing distributes register and paired stimulus identity over order and position. The released template satisfies the intended margins, while a small share of metadata rows departs from the modal pattern. The next page distinguishes these recorded rows from rows removed or completed by the exclusion pipeline. Now connect the notation back to the linguistic comparison.

## Slide 51: Counterbalancing

Source note: `experimental-design/counterbalancing.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Counterbalancing. Read the pattern before attaching a model interpretation to it.

## Slide 52: Exclusion rules

Source note: `experimental-design/exclusion-rules.qmd`

We now turn to Exclusion rules. The ManyBabies 1 release is the output of a sequential exclusion pipeline. The paper describes participant rules, session-level errors, trial-level errors, a minimum included looking time, and a laboratory inclusion rule. The official script then completes every retained infant to sixteen possible test-trial rows. Consequently, a row without an included looking time need not represent one single event.

## Slide 53: Exclusion rules

Source note: `experimental-design/exclusion-rules.qmd`

The ManyBabies 1 release is the output of a sequential exclusion pipeline. The paper describes participant rules, session-level errors, trial-level errors, a minimum included looking time, and a laboratory inclusion rule. The official script then completes every retained infant to sixteen possible test-trial rows. The ManyBabies 1 release is the output of a sequential exclusion pipeline. The paper describes participant rules, session-level errors, trial-level errors, a minimum included looking time, and a laboratory inclusion rule. The official script then completes every retained infant to sixteen possible test-trial rows. Consequently, a row without an included looking time need not represent one single event. Now connect the notation back to the linguistic comparison.

## Slide 54: Retention enters the estimand

Source note: `experimental-design/exclusion-rules.qmd`

Let $R_r=1$ when possible trial row $r$ contains a looking time retained by the released pipeline and let $R_r=0$ otherwise. A row-weighted register contrast among retained outcomes is This quantity conditions on retention. It differs from the equally weighted within-infant contrast, from a contrast over every planned trial, and from a contrast over responses that would have been observed without the events leading to missing outcomes. Keep the observational unit fixed while you interpret the result.

## Slide 55: Retention enters the estimand

Source note: `experimental-design/exclusion-rules.qmd`

The displayed expression formalizes retention enters the estimand. Let $R_r=1$ when possible trial row $r$ contains a looking time retained by the released pipeline and let $R_r=0$ otherwise. A row-weighted register contrast among retained outcomes is Keep track of what each term refers to in the linguistic dataset.

## Slide 56: Three row states in the teaching table

Source note: `experimental-design/exclusion-rules.qmd`

The two released indicators separate rows with included looking time, rows with trial metadata but no included looking time, and completed rows without trial metadata. Across all observed possible rows, observed retain an included looking time. Restricting the denominator to the observed rows with recorded trial metadata raises the retained share to observed. Notice what is observed and what is supplied by the model.

## Slide 57: Register and analysis-set margins

Source note: `experimental-design/exclusion-rules.qmd`

For rows whose trial metadata were recorded, the missing proportion can be computed by register. The observed-metadata missing proportions are observed for ADS and observed for IDS. This difference is descriptive. It does not identify why an outcome is missing. Use the graph or equation to say the result in ordinary language.

## Slide 58: Missing outcomes over the session

Source note: `experimental-design/exclusion-rules.qmd`

The released missing indicator can be summarized over trial position and observed testing method. The three lines are descriptive because method is tied to laboratory practices, populations, age coverage, and implementation. The rise over position may reflect termination, attention, procedure, or their combination. The plot alone cannot separate these mechanisms. It also cannot estimate an effect of assigning a testing method because method was not assigned. Notice what is observed and what is supplied by the model.

## Slide 59: Reporting the flow without overreconstruction

Source note: `experimental-design/exclusion-rules.qmd`

A reconstructible design report should distinguish (i) original participant exclusions, (ii) session- or trial-level error decisions, (iii) the minimum-looking-time rule, and (iv) rows created to represent later possible trials. The primary paper and official scripts document the first three stages. The release cannot be run backward to recover the original cause of every absent outcome. Sensitivity analyses may vary a defensible minimum-trial rule, but they should not relabel the resulting selection as if it were the original recruitment flow. Keep the observational unit fixed while you interpret the result.

## Slide 60: Exclusion rules

Source note: `experimental-design/exclusion-rules.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Exclusion rules. Read the pattern before attaching a model interpretation to it.

## Slide 61: Interpretation

Source note: `experimental-design/exclusion-rules.qmd`

The inclusion and exclusion pipeline defines which infant-trial outcomes enter the comparison. The final page carries this design forward by fitting an empirical model and using its effect and variance estimates to calibrate power by simulation. That distinction will matter again on the next slide.

## Slide 62: Power by simulation

Source note: `experimental-design/power-by-simulation.qmd`

We now turn to Power by simulation. The preceding pages established the ManyBabies 1 design: register varies within infant, orders vary between infants, paired stimuli recur across infants, and infants are nested within laboratories. A design simulation should reproduce those units. Drawing independent looking times would answer a different question, no matter how many draws were used.

## Slide 63: Power by simulation

Source note: `experimental-design/power-by-simulation.qmd`

The preceding pages established the ManyBabies 1 design: register varies within infant, orders vary between infants, paired stimuli recur across infants, and infants are nested within laboratories. A design simulation should reproduce those units. Drawing independent looking times would answer a different question, no matter how many draws were used. We begin again from the released ManyBabies trial table. Nothing on this page is imported from a reference output or a preceding page. Use the graph or equation to say the result in ordinary language.

## Slide 64: Calibrating a data-generating process

Source note: `experimental-design/power-by-simulation.qmd`

Power is conditional on a data-generating process. We first fit a compact model to the observed included looking times: where $l$ indexes laboratory, $i$ infant, $p$ paired stimulus, and $t$ trial position. The random intercepts and residual are normally distributed with their own variances. That distinction will matter again on the next slide.

## Slide 65: Calibrating a data-generating process

Source note: `experimental-design/power-by-simulation.qmd`

The displayed expression formalizes calibrating a data-generating process. Power is conditional on a data-generating process. We first fit a compact model to the observed included looking times: Keep track of what each term refers to in the linguistic dataset.

## Slide 66: Raw summaries and the fitted model

Source note: `experimental-design/power-by-simulation.qmd`

Before simulating, we compare raw register-by-position means with the model's fitted marginal lines. The points are computed from observed trials. The blue lines set all random intercepts to zero and vary only register and trial position. The raw summaries show both the register difference and the decline over trial position. The fitted lines provide a direct visual check on the two fixed effects used by the generator. That distinction will matter again on the next slide.

## Slide 67: Power and Monte Carlo error

Source note: `experimental-design/power-by-simulation.qmd`

Let $G$ be the complete generating process and let $A(Y)$ be the decision returned by the planned analysis for simulated data $Y$. If $A(Y)=1$ when the two-sided Wald interval for the IDS coefficient excludes zero, then With $S$ simulated studies and detection proportion $\widehat p$, the estimated Monte Carlo standard error is Keep the observational unit fixed while you interpret the result.

## Slide 68: Power and Monte Carlo error: equation 1

Source note: `experimental-design/power-by-simulation.qmd`

The displayed expression formalizes power and monte carlo error: equation 1. Let $G$ be the complete generating process and let $A(Y)$ be the decision returned by the planned analysis for simulated data $Y$. If $A(Y)=1$ when the two-sided Wald interval for the IDS coefficient excludes zero, then Keep track of what each term refers to in the linguistic dataset.

## Slide 69: Power and Monte Carlo error: equation 2

Source note: `experimental-design/power-by-simulation.qmd`

The displayed expression formalizes power and monte carlo error: equation 2. With $S$ simulated studies and detection proportion $\widehat p$, the estimated Monte Carlo standard error is Keep track of what each term refers to in the linguistic dataset.

## Slide 70: Simulating the ManyBabies structure

Source note: `experimental-design/power-by-simulation.qmd`

The generator assigns each simulated infant one empirical order template, samples complete IDS-ADS stimulus pairs, draws laboratory, infant, stimulus-pair, and residual terms from the fitted standard deviations, and fits the same model. The design grid varies one dimension at a time around a baseline. The baseline uses observed laboratories, observed infants per laboratory, and observed usable trials per infant. The effect and variance values come from the empirical fit; the grid values are planning choices. Use the graph or equation to say the result in ordinary language.

## Slide 71: What the simulation supports

Source note: `experimental-design/power-by-simulation.qmd`

The fitted effect is an estimate from the same release used for calibration. It is not a smallest effect of linguistic interest. The generator also omits age, method, language community, condition slopes, nonnormal tails, and the observed missingness process. A production design analysis should vary the target IDS effect and the omitted assumptions. It should also decide whether inference concerns these eight stimuli or a broader population of speech materials. Adding infants cannot substitute indefinitely for broadening a stimulus sample when the scientific claim concerns new materials. Keep the observational unit fixed while you interpret the result.

## Slide 72: Power by simulation

Source note: `experimental-design/power-by-simulation.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Power by simulation. Read the pattern before attaching a model interpretation to it.

## Slide 73: Interpretation

Source note: `experimental-design/power-by-simulation.qmd`

Simulation-based design analysis evaluates a complete procedure under stated assumptions. Here the procedure preserves laboratories, infants, paired stimuli, order templates, and trial position, then fits the same model used for calibration. Now connect the notation back to the linguistic comparison.
