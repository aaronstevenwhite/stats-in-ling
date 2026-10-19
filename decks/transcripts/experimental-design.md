# Experimental design

This transcript is generated from the speaker notes in the slide source. Slide identifiers, titles, note-page provenance, and order are identical.

## Slide 1: Experimental design

Source note: `experimental-design/index.qmd`

Welcome to Experimental design. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.

## Slide 2: Experimental design

Source note: `experimental-design/index.qmd`

Next, we take up Experimental design.

## Slide 3: ManyBabies: the empirical object

Source note: `experimental-design/index.qmd`

The data source is ManyBabies 1 Consortium (2020). It provides trial-level infant-directed and adult-directed speech responses.

## Slide 4: Experimental design

Source note: `experimental-design/index.qmd`

The ManyBabies Consortium's infant-directed-speech study coordinated a shared preference experiment across laboratories. This unit uses the frozen trial table from the MIT-licensed official analysis repository. One row is a possible test trial for an infant, including rows completed by the release's exclusion code when no trial metadata or included looking time is available.

## Slide 5: Experimental design

Source note: `experimental-design/index.qmd`

Register varies within infant: the protocol presents infant-directed speech (IDS) and adult-directed speech (ADS) trials to the same infant. Trial order varies between infants. Infants are recruited within laboratories, and paired stimuli recur across infants. Thus the trial row, assignment unit, sampling unit, laboratory, and stimulus are distinct empirical objects.

## Slide 6: Experimental design

Source note: `experimental-design/index.qmd`

The design determines which estimands are identified by the observed comparisons. A fitted model cannot recover a comparison that the design never made available. In this study, the within-infant IDS-minus-ADS contrast is available only for infants with included looking times in both registers; a laboratory or age association is observational because neither was assigned.

## Slide 7: The design sequence

Source note: `experimental-design/index.qmd`

Units of assignment separates possible trials, infants, laboratories, and recurring stimuli. The assignment-mechanism page then compares the released order labels with a reproducible constrained allocation and distinguishes verification of a procedure from evidence that the historical implementation followed it.

## Slide 8: The design sequence

Source note: `experimental-design/index.qmd`

Within-participant designs construct the IDS-minus-ADS contrast from infants represented in both registers. Between-participant designs use the observed second-session grouping to show what a between-group comparison estimates when the grouping variable was not randomly assigned.

## Slide 9: The design sequence

Source note: `experimental-design/index.qmd`

Counterbalancing audits the realized order and stimulus allocations rather than displaying an invented Latin square. Exclusion rules distinguish recorded metadata, included outcomes, and completed measurement opportunities. Finally, power by simulation generates new trials from an empirically fitted hierarchical model and repeats the complete planned analysis.

## Slide 10: Keep the claim aligned with the design

Source note: `experimental-design/index.qmd`

Looking time is a behavioral measure. An IDS--ADS difference may support a claim about preference under the tested stimuli and procedures, but it does not uniquely identify a perceptual or social mechanism. Likewise, method, laboratory, age, and community differences may describe this release without becoming randomized treatment effects.

## Slide 11: Keep the claim aligned with the design

Source note: `experimental-design/index.qmd`

The module thus keeps four questions visible: (i) which unit could independently receive a condition, (ii) which measurements repeat within that unit, (iii) which allocation or exclusion rule produced the analyzed rows, and (iv) which population or future design the contrast is meant to represent.

## Slide 12: Units of assignment

Source note: `experimental-design/units-of-assignment.qmd`

Our next step is Units of assignment.

## Slide 13: Units of assignment

Source note: `experimental-design/units-of-assignment.qmd`

The ManyBabies Consortium tested infants' preference for infant-directed speech (IDS) over adult-directed speech (ADS) in a shared multi-laboratory experiment. The primary report describes the stimuli, protocol, exclusions, and analyses (The ManyBabies Consortium 2020); the frozen course table comes from the official analysis repository at commit `dc3eb5b`. We begin with that table rather than with a small constructed design.

## Slide 14: Units of assignment

Source note: `experimental-design/units-of-assignment.qmd`

Each infant could encounter sixteen 18-second test stimuli: eight IDS stimuli and eight ADS stimuli. The official exclusion code then completed every retained infant's record to sixteen possible test-trial rows. A row may thus contain an included looking time, recorded trial metadata without an included looking time, or a completed measurement opportunity without recorded trial metadata. No missing looking time has been imputed.

## Slide 15: Assignment and measurement are different maps

Source note: `experimental-design/units-of-assignment.qmd`

The **unit of assignment**, also called the experimental unit, is the smallest entity that can independently receive a condition under the actual procedure. Let $r$ index possible trial rows and let $g(r)$ map row $r$ to its infant. If $Z_i$ is infant $i$'s assigned trial order, then

$$
Z_r=Z_{g(r)}.
$$

## Slide 16: Assignment and measurement are different maps

Source note: `experimental-design/units-of-assignment.qmd`

All sixteen possible rows from one infant share one order assignment. The rows do not represent sixteen independent assignments.

## Slide 17: Assignment and measurement are different maps (1 of 2)

Source note: `experimental-design/units-of-assignment.qmd`

Other maps are needed as well. Let $l(r)$ identify the laboratory, $p(r)$ the paired stimulus when its metadata were recorded, and $R_r$ indicate whether an included looking time is present. The recorded outcome is then available only when $R_r=1$. These maps keep five roles apart: a possible trial row is a measurement opportunity. an infant is the sampling unit and the order-assignment unit. a laboratory is a cluster within which infants were recruited and tested. a paired stimulus recurs across infants.

## Slide 18: Assignment and measurement are different maps (2 of 2)

Source note: `experimental-design/units-of-assignment.qmd`

Other maps are needed as well. Let $l(r)$ identify the laboratory, $p(r)$ the paired stimulus when its metadata were recorded, and $R_r$ indicate whether an included looking time is present. The recorded outcome is then available only when $R_r=1$. These maps keep five roles apart: a nonmissing looking time is an observed outcome.

## Slide 19: Assignment and measurement are different maps

Source note: `experimental-design/units-of-assignment.qmd`

The distinction is empirical in this release. The following code reconstructs the infant table and every count from the RDS file.

## Slide 20: Assignment and measurement are different maps

Source note: `experimental-design/units-of-assignment.qmd`

The table contains 37,264 possible trial rows but only 2,329 infant assignment units. Looking time is included on 26,895 rows. And only 2,226 infants can enter the paired IDS-minus-ADS summary developed on the within-participant page.

## Slide 21: Unequal information within laboratories

Source note: `experimental-design/units-of-assignment.qmd`

Infants are nested within laboratories, but the number of included trials varies across infants. The gray points below are infants; the blue point is the laboratory median. Laboratory labels are suppressed because the figure concerns the dependence structure, not a ranking of sites.

## Slide 22: Unequal information within laboratories

Source note: `experimental-design/units-of-assignment.qmd`

This figure shows observed linguistic data for Unequal information within laboratories.

## Slide 23: Unequal information within laboratories

Source note: `experimental-design/units-of-assignment.qmd`

Additional trials may improve the measurement of a particular infant's looking behavior, and additional infants may improve the comparison across infants. They are not interchangeable. Likewise, eight recurring paired stimuli supply repeated material measurements, not eight additional infant assignments.

## Slide 24: What this release can establish (1 of 2)

Source note: `experimental-design/units-of-assignment.qmd`

The final table begins after participant- and laboratory-level exclusions. It can establish the units present in the released analysis table, but it cannot reconstruct the full recruitment process from the retained records alone. This limit is why a design audit should name the unit at each stage rather than infer recruitment from the number of rows. Why do sixteen possible rows for one infant still represent one order assignment? Which map identifies dependence induced by testing infants in the same laboratory?

## Slide 25: What this release can establish (2 of 2)

Source note: `experimental-design/units-of-assignment.qmd`

The final table begins after participant- and laboratory-level exclusions. It can establish the units present in the released analysis table, but it cannot reconstruct the full recruitment process from the retained records alone. This limit is why a design audit should name the unit at each stage rather than infer recruitment from the number of rows. Why do additional trials and additional infants provide different kinds of information? Which infants can enter an infant-weighted IDS-minus-ADS comparison?

## Slide 26: What this release can establish

Source note: `experimental-design/units-of-assignment.qmd`

The unit of assignment is the smallest entity whose assigned condition could vary independently under the procedure. In ManyBabies 1, order varies between infants, register varies within infants, and looking-time measurements repeat within infants, laboratories, and paired stimuli. The next page asks what the public release can and cannot establish about the assignment mechanism.

## Slide 27: Random assignment

Source note: `experimental-design/random-assignment.qmd`

Next, we take up Random assignment.

## Slide 28: Random assignment

Source note: `experimental-design/random-assignment.qmd`

We continue with the ManyBabies 1 release introduced on the preceding page. Its design makes a useful distinction between a documented sequence and a documented allocation device. The paper reports four pseudorandom trial sequences, each containing four blocks with two IDS and two ADS trials. The release records the order attached to an infant. It does not document the local algorithm by which every laboratory mapped a particular infant to one of those orders.

## Slide 29: Random assignment

Source note: `experimental-design/random-assignment.qmd`

We can verify the realized order labels and their balance in the release. We cannot use those labels alone to infer the probability rule used locally.

## Slide 30: The assignment mechanism is a probability rule

Source note: `experimental-design/random-assignment.qmd`

The **assignment mechanism** specifies the probability with which each assignment unit receives each condition. Let $Z_i$ denote infant $i$'s order, and let $Y_i(z)$ denote an outcome the infant would supply under order $z$. Under a verified randomized allocation within laboratory, the assignment-identification link would be

$$
Z_i \mathrel{\perp} \{Y_i(1),\ldots,Y_i(4)\}\mid l(i),
$$

where $l(i)$ is the infant's laboratory.

## Slide 31: The assignment mechanism is a probability rule

Source note: `experimental-design/random-assignment.qmd`

A balanced realized table does not establish this independence. The design record must also specify how order labels were generated, concealed, and assigned.

## Slide 32: The assignment mechanism is a probability rule

Source note: `experimental-design/random-assignment.qmd`

The release yields the following realized infant counts.

## Slide 33: The assignment mechanism is a probability rule

Source note: `experimental-design/random-assignment.qmd`

Orders 1 through 4 contain 596, 589, 588, 556 infants, respectively. These counts describe the retained release. They neither prove nor refute a particular random allocation mechanism.

## Slide 34: A relabeling diagnostic

Source note: `experimental-design/random-assignment.qmd`

We can still ask whether a measured pre-outcome characteristic is unusually imbalanced relative to a transparent reference operation. Infant age varies sharply by laboratory, so comparing raw order means would mix order balance with the laboratories that contributed each order. We first center age within laboratory. Our statistic is the range of the four resulting order means,

$$
T(Z)=\max_z \overline{A}^{,c}_z-\min_z \overline{A}^{,c}_z,
$$

where $A_i^c=A_i-\overline A_{l(i)}$.

## Slide 35: A relabeling diagnostic

Source note: `experimental-design/random-assignment.qmd`

We then relabel orders within each laboratory while preserving that laboratory's realized order counts.

## Slide 36: A relabeling diagnostic

Source note: `experimental-design/random-assignment.qmd`

This figure shows observed linguistic data for A relabeling diagnostic.

## Slide 37: A relabeling diagnostic

Source note: `experimental-design/random-assignment.qmd`

The observed range is 0.173 months, and 0.576 of the 5,000 relabelings are at least that large. This result is a design diagnostic under the displayed relabeling rule. It is not a randomization $p$-value: the paper does not say that this rule generated the infant-to-order assignments.

## Slide 38: Assignment is not sampling

Source note: `experimental-design/random-assignment.qmd`

Assignment governs how conditions are distributed among enrolled units. Sampling governs how infants, laboratories, and stimuli enter the study. Random allocation does not make laboratories or English stimuli probability samples of their respective populations.

## Slide 39: Assignment is not sampling (1 of 2)

Source note: `experimental-design/random-assignment.qmd`

The same distinction prevents a second error. Testing method was selected through each laboratory's established practice rather than assigned to infants. Method comparisons are thus observational and laboratory-linked. They should not be treated as if they arose from random assignment. Which part of the design is directly recorded in the release? What additional record would be needed to verify the assignment mechanism? Why is age centered within laboratory before relabeling orders?

## Slide 40: Assignment is not sampling (2 of 2)

Source note: `experimental-design/random-assignment.qmd`

The same distinction prevents a second error. Testing method was selected through each laboratory's established practice rather than assigned to infants. Method comparisons are thus observational and laboratory-linked. They should not be treated as if they arose from random assignment. Why is the upper-tail share a diagnostic rather than a randomization $p$-value?

## Slide 41: Assignment is not sampling

Source note: `experimental-design/random-assignment.qmd`

Random assignment is a probability rule, not a property inferred from balanced labels. The ManyBabies study documents four order sequences and their realized use, so the evidence supports no stronger claim about the allocation mechanism. We can next use the release to contrast a genuine within-infant factor with the between-infant order factor.

## Slide 42: Within-participant designs

Source note: `experimental-design/within-participant-designs.qmd`

Next, we take up Within-participant designs.

## Slide 43: Within-participant designs

Source note: `experimental-design/within-participant-designs.qmd`

In the ManyBabies 1 design, speech register varies within infant. Each infant could hear both infant-directed speech (IDS) and adult-directed speech (ADS), and each register was represented by eight stimuli. Looking time is the measured behavior: it may index attention to the two kinds of speech, but it is not a direct measure of a particular linguistic representation.

## Slide 44: Within-participant designs

Source note: `experimental-design/within-participant-designs.qmd`

In a **within-participant design**, each participant contributes observations to more than one condition. The participant can thus supply the condition comparison before comparisons are averaged across participants.

## Slide 45: Each infant supplies a register contrast

Source note: `experimental-design/within-participant-designs.qmd`

Let $Y_{ir}$ be infant $i$'s mean included looking time in register $r$. The infant-level difference is

$$
D_i=Y_{i,\mathrm{IDS}}-Y_{i,\mathrm{ADS}},
$$

and the infant-weighted mean difference among infants observed in both registers is

$$
\overline D=\frac{1}{n}\sum_{i=1}^{n}D_i.
$$

## Slide 46: Each infant supplies a register contrast

Source note: `experimental-design/within-participant-designs.qmd`

The unit entering the final average is the infant, not the trial. If an infant-specific tendency $a_i$ adds the same amount in both registers, it cancels within that infant:

$$
(\mu_{\mathrm{IDS}}+a_i)-(\mu_{\mathrm{ADS}}+a_i)
=\mu_{\mathrm{IDS}}-\mu_{\mathrm{ADS}}.
$$

## Slide 47: Each infant supplies a register contrast

Source note: `experimental-design/within-participant-designs.qmd`

This cancellation does not remove stimulus variation, condition-specific infant responses, trial order, or laboratory differences.

## Slide 48: Reconstructing the paired summary

Source note: `experimental-design/within-participant-designs.qmd`

We first average the included looking times within infant and register. We then reshape to one row per infant and retain infants with both means.

## Slide 49: Reconstructing the paired summary

Source note: `experimental-design/within-participant-designs.qmd`

The paired analysis contains 2,226 infants. Their mean IDS-minus-ADS difference is 0.834 seconds, with a standard deviation of 2.522 seconds and a standard error of 0.0534 seconds. The estimate describes included looking time under the released pipeline. It does not imply that every infant preferred IDS.

## Slide 50: Reconstructing the paired summary

Source note: `experimental-design/within-participant-designs.qmd`

The raw infant means make that heterogeneity visible. The gray diagonal marks equal means in the two registers; points above it have a positive infant-level difference.

## Slide 51: Reconstructing the paired summary

Source note: `experimental-design/within-participant-designs.qmd`

This figure shows observed linguistic data for Reconstructing the paired summary.

## Slide 52: Unequal trial counts remain part of the target

Source note: `experimental-design/within-participant-designs.qmd`

An infant need not contribute the same number of included trials in the two registers. The following calculation recovers those counts before averaging.

## Slide 53: Unequal trial counts remain part of the target

Source note: `experimental-design/within-participant-designs.qmd`

The unweighted mean of $D_i$ gives each complete infant one contribution, even when their register means rest on different numbers of trials. A row-weighted register difference would instead give more influence to infants with more included trials. Neither target is automatically preferable; the unit used in the average must match the question.

## Slide 54: Unequal trial counts remain part of the target

Source note: `experimental-design/within-participant-designs.qmd`

The teaching summary also differs from the paper's meta-analysis. The paper first paired IDS and ADS stimuli by stimulus number, computed an infant preference across complete pairs, and then formed laboratory and age-group effect sizes. Our simpler aggregate is designed to expose the within-infant unit. It should not be described as a reproduction of the published confirmatory analysis.

## Slide 55: Order can modify a within-infant contrast (1 of 2)

Source note: `experimental-design/within-participant-designs.qmd`

A **carryover effect** occurs when an earlier condition changes a later response. Attention may decline over the session, and earlier speech may change what an infant attends to later. ManyBabies used four pseudorandom sequences that alternated register within four-trial blocks. This counterbalancing distributes register over position, but it does not make carryover impossible. Why must the IDS and ADS means be joined by infant before subtraction? Which infant-specific component cancels under the additive expression above? How would trial weighting change the target of the mean difference?

## Slide 56: Order can modify a within-infant contrast (2 of 2)

Source note: `experimental-design/within-participant-designs.qmd`

A **carryover effect** occurs when an earlier condition changes a later response. Attention may decline over the session, and earlier speech may change what an infant attends to later. ManyBabies used four pseudorandom sequences that alternated register within four-trial blocks. This counterbalancing distributes register over position, but it does not make carryover impossible. Why does order remain relevant after both registers occur within infant?

## Slide 57: Order can modify a within-infant contrast

Source note: `experimental-design/within-participant-designs.qmd`

A within-participant design makes the infant the source of the IDS-minus-ADS comparison. Stable additive infant differences may cancel, while stimulus, order, and condition-specific variation remain. The next page contrasts this structure with the between-infant order groups.

## Slide 58: Between-participant designs

Source note: `experimental-design/between-participant-designs.qmd`

Our next step is Between-participant designs.

## Slide 59: Between-participant designs

Source note: `experimental-design/between-participant-designs.qmd`

ManyBabies 1 combines two condition structures. Speech register varies within infant, while the four pseudorandom trial orders vary between infants. One infant is associated with one order across all sixteen possible test-trial rows.

## Slide 60: Between-participant designs

Source note: `experimental-design/between-participant-designs.qmd`

In a **between-participant design**, each participant contributes observations to only one level of a factor. The factor comparison is across groups rather than within the same participant.

## Slide 61: A group contrast over assigned order

Source note: `experimental-design/between-participant-designs.qmd`

Let $Y_i$ be infant $i$'s mean log looking time over included trials, and let $Z_i$ identify the infant's assigned order. The mean in order group $z$ is

$$
\overline Y_z=\frac{1}{n_z}\sum_{i:Z_i=z}Y_i.
$$

## Slide 62: A group contrast over assigned order

Source note: `experimental-design/between-participant-designs.qmd`

Each infant contributes to one and only one $overline Y_z$. Stable infant differences do not cancel through within-infant subtraction. This is the defining contrast with the IDS-minus-ADS summary on the preceding page.

## Slide 63: A group contrast over assigned order

Source note: `experimental-design/between-participant-designs.qmd`

We construct $Y_i$ from the included looking times and then join the infant's single order label.

## Slide 64: A group contrast over assigned order

Source note: `experimental-design/between-participant-designs.qmd`

Among infants with an included outcome, the four groups contain 591, 583, 578, 550 infants. Their mean log looking times are 1.821, 1.810, 1.814, 1.797. The raw infant summaries and group means show the scale of between-infant variation.

## Slide 65: A group contrast over assigned order

Source note: `experimental-design/between-participant-designs.qmd`

This figure shows observed linguistic data for A group contrast over assigned order.

## Slide 66: Order is a nuisance assignment

Source note: `experimental-design/between-participant-designs.qmd`

This plot does not estimate a linguistic treatment effect. Trial order was used to distribute register and paired stimulus identity over session position. It is a between-infant factor, but it is not the speech-register contrast that motivated the experiment.

## Slide 67: Order is a nuisance assignment

Source note: `experimental-design/between-participant-designs.qmd`

The documented evidence about allocation also limits interpretation. Because the public source does not specify each laboratory's infant-to-order allocation device, differences among these four realized groups are descriptive. They should not be labeled causal effects of order.

## Slide 68: Trials improve an infant summary, not group replication

Source note: `experimental-design/between-participant-designs.qmd`

The release contains 26,895 included trial outcomes from 2,302 infants. More included trials may make an infant’s $Y_i$ less sensitive to a particular stimulus. They do not increase $n_z$, because order was attached once to the infant.

## Slide 69: Trials improve an infant summary, not group replication

Source note: `experimental-design/between-participant-designs.qmd`

A trial-weighted group mean would give more influence to infants with more included trials. The displayed analysis instead gives every infant with an outcome one group-level contribution. This choice matches the between-infant comparison in the equation, though the figure remains descriptive.

## Slide 70: An observed laboratory attribute is not an assigned factor (1 of 2)

Source note: `experimental-design/between-participant-designs.qmd`

Testing method also differs across infants, but laboratories used their established head-turn preference, single-screen, or eye-tracking procedures. Method is partly tied to laboratory and was not assigned to infants. It is thus not interchangeable with the assigned order factor. A difference among method groups may combine method, laboratory, infant population, age coverage, and local implementation. Why does each infant enter only one order-group mean? What does averaging trials within infant preserve about the assignment unit? Why is assigned order a nuisance factor rather than the linguistic treatment?

## Slide 71: An observed laboratory attribute is not an assigned factor (2 of 2)

Source note: `experimental-design/between-participant-designs.qmd`

Testing method also differs across infants, but laboratories used their established head-turn preference, single-screen, or eye-tracking procedures. Method is partly tied to laboratory and was not assigned to infants. It is thus not interchangeable with the assigned order factor. A difference among method groups may combine method, laboratory, infant population, age coverage, and local implementation. Why can testing method not be analyzed as if it had been randomly assigned?

## Slide 72: An observed laboratory attribute is not an assigned factor

Source note: `experimental-design/between-participant-designs.qmd`

A between-participant design compares groups whose members occupy only one factor level. In ManyBabies 1, order has this structure, whereas register does not. The next page checks how the four orders counterbalance register and paired stimuli.

## Slide 73: Counterbalancing

Source note: `experimental-design/counterbalancing.qmd`

Now we turn to Counterbalancing.

## Slide 74: Counterbalancing

Source note: `experimental-design/counterbalancing.qmd`

ManyBabies 1 used four pseudorandom trial orders to distribute register and paired stimulus identity over the sixteen test positions. Each order contained four alternating blocks, each with two infant-directed-speech (IDS) and two adult-directed-speech (ADS) trials. The same IDS and ADS stimulus numbers formed pairs. We can recover the realized order templates from the released trial table.

## Slide 75: Counterbalancing

Source note: `experimental-design/counterbalancing.qmd`

**Counterbalancing** constrains how conditions and materials are distributed across orders. It does not create independent trials. In this study, the constraint makes register available within infant while distributing register and paired stimulus identity over trial position.

## Slide 76: Reconstructing the order templates

Source note: `experimental-design/counterbalancing.qmd`

Protocol deviations mean that the released rows need not agree perfectly within every order-by-position cell. We recover the modal register and stimulus number for each cell, then check the resulting template.

## Slide 77: Reconstructing the order templates

Source note: `experimental-design/counterbalancing.qmd`

Let $R_{ot}$ and $P_{ot}$ denote the modal register and paired stimulus at position $t$ in order $o$. The checks above establish the empirical margins

$$
\sum_t I(R_{ot}=\mathrm{IDS})
=\sum_t I(R_{ot}=\mathrm{ADS})=8,
$$

and, for every pair $p$ in every order $o$,

$$
\sum_t I(P_{ot}=p)=2,
\qquad
\sum_t I(P_{ot}=p,R_{ot}=r)=1
$$

for each register $r$.

## Slide 78: Reconstructing the order templates

Source note: `experimental-design/counterbalancing.qmd`

Thus every paired stimulus occurs once as IDS and once as ADS within an order.

## Slide 79: A restrained order map

Source note: `experimental-design/counterbalancing.qmd`

The tile plot shows the register margin without placing a label in every cell. Pair identity remains checked in the calculation and table rather than added as sixty-four annotations.

## Slide 80: A restrained order map

Source note: `experimental-design/counterbalancing.qmd`

This figure shows observed linguistic data for A restrained order map.

## Slide 81: A restrained order map

Source note: `experimental-design/counterbalancing.qmd`

Each order contains both registers across the session rather than placing all IDS trials before all ADS trials. The four orders use different position patterns, which distributes a register contrast over earlier and later positions across infants.

## Slide 82: Planned template and released records

Source note: `experimental-design/counterbalancing.qmd`

The modal template is a reconstruction from the release. We can compare every recorded metadata row with the relevant modal cell.

## Slide 83: Planned template and released records

Source note: `experimental-design/counterbalancing.qmd`

The modal register template agrees with 97.31% of recorded metadata rows, and the modal stimulus template agrees with 97.64%. These are agreement rates with the modal released pattern after documented protocol deviations. They are not coder-accuracy estimates.

## Slide 84: What counterbalancing does not do (1 of 2)

Source note: `experimental-design/counterbalancing.qmd`

Counterbalancing separates register from a fixed position and paired stimulus in the planned sequence. It does not remove dependence: trials still repeat within infants, stimuli recur across infants, and infants remain nested within laboratories. Nor does balance verify how infants were allocated to sequences; the random-assignment page explains what the released records support. Which margin verifies equal IDS and ADS counts within an order? Which margin verifies one IDS and one ADS occurrence for each paired stimulus?

## Slide 85: What counterbalancing does not do (2 of 2)

Source note: `experimental-design/counterbalancing.qmd`

Counterbalancing separates register from a fixed position and paired stimulus in the planned sequence. It does not remove dependence: trials still repeat within infants, stimuli recur across infants, and infants remain nested within laboratories. Nor does balance verify how infants were allocated to sequences; the random-assignment page explains what the released records support. Why is a modal template needed for this release? Why does balanced sequencing not make trial rows independent?

## Slide 86: What counterbalancing does not do

Source note: `experimental-design/counterbalancing.qmd`

Counterbalancing distributes register and paired stimulus identity over order and position. The released template satisfies the intended margins, while a small share of metadata rows departs from the modal pattern. The next page distinguishes these recorded rows from rows removed or completed by the exclusion pipeline.

## Slide 87: Exclusion rules

Source note: `experimental-design/exclusion-rules.qmd`

Next, we take up Exclusion rules.

## Slide 88: Exclusion rules

Source note: `experimental-design/exclusion-rules.qmd`

The ManyBabies 1 release is the output of a sequential exclusion pipeline. The paper describes participant rules, session-level errors, trial-level errors, a minimum included looking time, and a laboratory inclusion rule. The official script then completes every retained infant to sixteen possible test-trial rows. Consequently, a row without an included looking time need not represent one single event.

## Slide 89: Retention enters the estimand

Source note: `experimental-design/exclusion-rules.qmd`

Let $R_r=1$ when possible trial row $r$ contains a looking time retained by the released pipeline and let $R_r=0$ otherwise. A row-weighted register contrast among retained outcomes is

$$
\Delta_{R=1}
=\mathbb{E}[Y_r\mid Z_r=\mathrm{IDS},R_r=1]
-\mathbb{E}[Y_r\mid Z_r=\mathrm{ADS},R_r=1].
$$

## Slide 90: Retention enters the estimand

Source note: `experimental-design/exclusion-rules.qmd`

This quantity conditions on retention. It differs from an equally weighted within-infant contrast, a contrast over all planned trials, and a contrast over outcomes made missing by later events.

## Slide 91: Retention enters the estimand

Source note: `experimental-design/exclusion-rules.qmd`

Exclusion is thus not merely table cleaning. It helps define the population of responses represented by an analysis.

## Slide 92: Three row states in the teaching table

Source note: `experimental-design/exclusion-rules.qmd`

The two released indicators separate rows with included looking time, rows with trial metadata but no included looking time, and completed rows without trial metadata.

## Slide 93: Three row states in the teaching table

Source note: `experimental-design/exclusion-rules.qmd`

Across all 37,264 possible rows, 72.17% retain an included looking time. Restricting the denominator to the 32,881 rows with recorded trial metadata raises the retained share to 81.79%.

## Slide 94: Three row states in the teaching table

Source note: `experimental-design/exclusion-rules.qmd`

These states should not be collapsed into a causal explanation. A missing included outcome may follow an error-marked trial, the minimum-looking-time rule, or termination before a later trial. A completed row without metadata records a possible opportunity added by the official completion step. The final RDS does not retain a unique original reason for every missing row.

## Slide 95: Register and analysis-set margins

Source note: `experimental-design/exclusion-rules.qmd`

For rows whose trial metadata were recorded, the missing proportion can be computed by register.

## Slide 96: Register and analysis-set margins

Source note: `experimental-design/exclusion-rules.qmd`

The observed-metadata missing proportions are 18.89% for ADS and 17.52% for IDS. This difference is descriptive. It does not identify why an outcome is missing.

## Slide 97: Register and analysis-set margins

Source note: `experimental-design/exclusion-rules.qmd`

An exclusion rule can also operate at the infant level by requiring a minimum number of included trials. We can examine the thresholds considered in the paper's sensitivity analysis without reversing the official pipeline.

## Slide 98: Register and analysis-set margins

Source note: `experimental-design/exclusion-rules.qmd`

Requiring at least 2, 4, 8 included trials retains 2,252, 2,111, 1,827 infant identifiers, respectively. Changing the threshold changes the analysis set and may change the population of infants represented by the estimate.

## Slide 99: Missing outcomes over the session

Source note: `experimental-design/exclusion-rules.qmd`

The released missing indicator can be summarized over trial position and observed testing method. The three lines are descriptive because method is tied to laboratory practices, populations, age coverage, and implementation.

## Slide 100: Missing outcomes over the session

Source note: `experimental-design/exclusion-rules.qmd`

This figure shows observed linguistic data for Missing outcomes over the session.

## Slide 101: Missing outcomes over the session

Source note: `experimental-design/exclusion-rules.qmd`

The rise over position may reflect termination, attention, procedure, or their combination. The plot alone cannot separate these mechanisms. It also cannot estimate an effect of assigning a testing method because method was not assigned.

## Slide 102: Reporting the flow without overreconstruction

Source note: `experimental-design/exclusion-rules.qmd`

A reconstructible design report should distinguish (i) original participant exclusions, (ii) session- or trial-level error decisions, (iii) the minimum-looking-time rule, and (iv) rows created to represent later possible trials. The primary paper and official scripts document the first three stages. The teaching RDS records their final consequences through `trial_missing` and preserves the completion distinction through `trial_metadata_observed`.

## Slide 103: Reporting the flow without overreconstruction (1 of 2)

Source note: `experimental-design/exclusion-rules.qmd`

The release cannot be run backward to recover the original cause of every absent outcome. Sensitivity analyses may vary a defensible minimum-trial rule, but they should not relabel the resulting selection as if it were the original recruitment flow. What population of rows is described by $\Delta_{R=1}$? Why are a recorded trial without an included outcome and a completed row without metadata distinct?

## Slide 104: Reporting the flow without overreconstruction (2 of 2)

Source note: `experimental-design/exclusion-rules.qmd`

The release cannot be run backward to recover the original cause of every absent outcome. Sensitivity analyses may vary a defensible minimum-trial rule, but they should not relabel the resulting selection as if it were the original recruitment flow. What changes when the minimum usable-trial threshold increases? Why can the method-specific curves not be interpreted causally?

## Slide 105: Reporting the flow without overreconstruction

Source note: `experimental-design/exclusion-rules.qmd`

The inclusion and exclusion pipeline defines which infant-trial outcomes enter the comparison. The final page carries this design forward by fitting an empirical model and using its effect and variance estimates to calibrate power by simulation.

## Slide 106: Power by simulation

Source note: `experimental-design/power-by-simulation.qmd`

Now we turn to Power by simulation.

## Slide 107: Power by simulation

Source note: `experimental-design/power-by-simulation.qmd`

The preceding pages established the ManyBabies 1 design: register varies within infant, orders vary between infants, paired stimuli recur across infants, and infants are nested within laboratories. A design simulation should reproduce those units. Drawing independent looking times would answer a different question, no matter how many draws were used.

## Slide 108: Power by simulation

Source note: `experimental-design/power-by-simulation.qmd`

We begin again from the released ManyBabies trial table. Nothing on this page is imported from a reference output or a preceding page.

## Slide 109: Calibrating a data-generating process

Source note: `experimental-design/power-by-simulation.qmd`

Power is conditional on a data-generating process. We first fit a compact model to the 26,895 included looking times:

$$
\log Y_{lsip}
=\beta_0+\beta_{\mathrm{IDS}}I_{\mathrm{IDS}}
+\beta_t(t-\overline t)+b_l+b_{i(l)}+b_p+\epsilon,
$$

where $l$ indexes laboratory, $i$ infant, $p$ paired stimulus, and $t$ trial position.

## Slide 110: Calibrating a data-generating process

Source note: `experimental-design/power-by-simulation.qmd`

The random intercepts and residual are normally distributed with their own variances.

## Slide 111: Calibrating a data-generating process

Source note: `experimental-design/power-by-simulation.qmd`

The estimated IDS coefficient is 0.106804 on the log-looking-time scale. This compact model is not the paper’s confirmatory model. The published analyses included a cross-laboratory meta-analysis and richer trial-level predictors; the planned random-effects structure was pruned when it did not converge. Here the model has one job: calibrate an explicit teaching simulation.

## Slide 112: Raw summaries and the fitted model

Source note: `experimental-design/power-by-simulation.qmd`

Before simulating, we compare raw register-by-position means with the model's fitted marginal lines. The points are computed from observed trials. The blue lines set all random intercepts to zero and vary only register and trial position.

## Slide 113: Raw summaries and the fitted model

Source note: `experimental-design/power-by-simulation.qmd`

This figure shows observed linguistic data for Raw summaries and the fitted model.

## Slide 114: Raw summaries and the fitted model

Source note: `experimental-design/power-by-simulation.qmd`

The raw summaries show both the register difference and the decline over trial position. The fitted lines provide a direct visual check on the two fixed effects used by the generator.

## Slide 115: Power and Monte Carlo error

Source note: `experimental-design/power-by-simulation.qmd`

Let $G$ be the complete generating process and let $A(Y)$ be the decision returned by the planned analysis for simulated data $Y$. If $A(Y)=1$ when the two-sided Wald interval for the IDS coefficient excludes zero, then

$$
\operatorname{Power}(G)=\mathbb{P}_G\{A(Y)=1\}.
$$

With $S$ simulated studies and detection proportion $\widehat p$, the estimated Monte Carlo standard error is

$$
\operatorname{MCSE}
=\sqrt{\frac{\widehat p(1-\widehat p)}{S}}.
$$

## Slide 116: Power and Monte Carlo error

Source note: `experimental-design/power-by-simulation.qmd`

Increasing $S$ reduces numerical uncertainty about the simulation result. It does not add infants or laboratories to the planned experiment.

## Slide 117: Simulating the ManyBabies structure

Source note: `experimental-design/power-by-simulation.qmd`

The generator assigns each simulated infant one empirical order template, samples complete IDS-ADS stimulus pairs, draws laboratory, infant, stimulus-pair, and residual terms from the fitted standard deviations, and fits the same model. The design grid varies one dimension at a time around a baseline.

## Slide 118: Simulating the ManyBabies structure

Source note: `experimental-design/power-by-simulation.qmd`

The baseline uses 8 laboratories, 24 infants per laboratory, and 8 usable trials per infant. The effect and variance values come from the empirical fit; the grid values are planning choices.

## Slide 119: Simulating the ManyBabies structure

Source note: `experimental-design/power-by-simulation.qmd`

The table reports 200 simulations per scenario at seed 20261018. The same simulated noise is evaluated with a zero IDS coefficient to estimate Type I error and with the fitted coefficient to estimate detection and coverage. Singular fits remain in the summary as a design diagnostic rather than being silently discarded.

## Slide 120: Simulating the ManyBabies structure

Source note: `experimental-design/power-by-simulation.qmd`

The **power curve** shows how detection changes when one design dimension changes. The error bars are twice the estimated Monte Carlo standard error.

## Slide 121: Simulating the ManyBabies structure

Source note: `experimental-design/power-by-simulation.qmd`

This figure shows observed linguistic data for Simulating the ManyBabies structure.

## Slide 122: What the simulation supports

Source note: `experimental-design/power-by-simulation.qmd`

The fitted effect is an estimate from the same release used for calibration. It is not a smallest effect of linguistic interest. The generator also omits age, method, language community, condition slopes, nonnormal tails, and the observed missingness process. Thus the plotted values are conditional results for this generator and analysis, not guarantees for a future study.

## Slide 123: What the simulation supports (1 of 2)

Source note: `experimental-design/power-by-simulation.qmd`

A production design analysis should vary the target IDS effect and the omitted assumptions. It should also decide whether inference concerns these eight stimuli or a broader population of speech materials. Adding infants cannot substitute indefinitely for broadening a stimulus sample when the scientific claim concerns new materials. Which fitted quantities calibrate the data-generating process? Why are complete IDS-ADS stimulus pairs sampled together? What uncertainty is measured by the Monte Carlo standard error?

## Slide 124: What the simulation supports (2 of 2)

Source note: `experimental-design/power-by-simulation.qmd`

A production design analysis should vary the target IDS effect and the omitted assumptions. It should also decide whether inference concerns these eight stimuli or a broader population of speech materials. Adding infants cannot substitute indefinitely for broadening a stimulus sample when the scientific claim concerns new materials. Why are the empirical-effect detection rates not new evidence about IDS preference? Which omitted process would you vary first for a planned replication?

## Slide 125: What the simulation supports

Source note: `experimental-design/power-by-simulation.qmd`

Simulation-based design analysis evaluates a complete procedure under stated assumptions. Here the procedure preserves laboratories, infants, paired stimuli, order templates, and trial position, then fits the same model used for calibration. The result is useful because every numerical assumption is either estimated from ManyBabies 1 or identified as a planning choice.
