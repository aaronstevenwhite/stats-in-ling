# Finding unobserved groups in linguistic data

This transcript is generated from the speaker notes in the slide source. Slide identifiers, titles, note-page provenance, and order are identical.

## Slide 1: Finding unobserved groups in linguistic data

Source note: `latent-structure/index.qmd`

Welcome to Finding unobserved groups in linguistic data. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.

## Slide 2: Finding unobserved groups

Source note: `latent-structure/index.qmd`

We now turn to Finding unobserved groups. Peterson and Barney's vowel-production study recorded repeated /hVd/ productions and their acoustic measurements. This unit uses the table distributed as `phonTools::pb52` in package version 0.2.2.2. The package is BSD-licensed, though those package terms do not separately establish redistribution terms for the historical table. One row is one recorded vowel token; rows repeat speakers, elicitation words, and intended vowels.

## Slide 3: Peterson-Barney: the empirical object

Source note: `latent-structure/index.qmd`

This is the first use of Peterson-Barney in this module. The slide names the observation represented in the teaching table and links the original source. We will keep that unit fixed when we compute and interpret quantities from these data.

## Slide 4: Finding unobserved groups

Source note: `latent-structure/index.qmd`

Peterson and Barney's vowel-production study recorded repeated /hVd/ productions and their acoustic measurements. This unit uses the table distributed as `phonTools::pb52` in package version 0.2.2.2. The package is BSD-licensed, though those package terms do not separately establish redistribution terms for the historical table. The fitting representation contains F1 and F2 but not the elicitation word or intended-vowel label. The linguistic question is whether recurring regions appear in this acoustic representation and, if so, how they relate to categories supplied by the experimental design. That distinction will matter again on the next slide.

## Slide 5: Hard clustering

Source note: `latent-structure/index.qmd`

The analysis begins by representing each object as a row of measurements. Distance and scaling then determine which token pairs count as similar. Because F1 and F2 have different empirical spreads, the transformation affects the geometry supplied to the clustering algorithm. K-means assigns each token to one cluster and represents each cluster by a centroid. The assignment and centroid updates minimize within-cluster loss. Silhouette widths compare each token's distance to its assigned cluster with its distance to the nearest alternative. Validation without outcome labels then asks how centroids estimated from other speakers reconstruct a complete unseen-speaker panel. Now connect the notation back to the linguistic comparison.

## Slide 6: Finite mixture models

Source note: `latent-structure/index.qmd`

A **finite mixture model** represents a distribution as a weighted combination of component distributions. A Gaussian mixture uses Gaussian components for the acoustic measurements. Posterior membership probabilities quantify how much each component contributes to the density at an observed token, and expectation--maximization alternates between updating these responsibilities and the component parameters. Choosing a mixture with BIC compares fitted likelihoods after accounting for parameter count. BIC still treats token rows as likelihood contributions, so the repeated-speaker structure remains a limitation rather than disappearing into the criterion. Held-out mixture validation then evaluates fitted density for speakers absent during fitting and uses intended vowels only for a separate post-fit alignment check. Notice what is observed and what is supplied by the model.

## Slide 7: Validation and sequence

Source note: `latent-structure/index.qmd`

The CCD fixes the interpretation throughout the sequence. The pages thus specify (i) the represented object and geometry, (ii) the hard-clustering objective and its held-out target, and (iii) the probabilistic mixture objective and its held-out target. Peterson and Barney's vowel-production study recorded repeated /hVd/ productions and their acoustic measurements. This unit uses the table distributed as `phonTools::pb52` in package version 0.2.2.2. The package is BSD-licensed, though those package terms do not separately establish redistribution terms for the historical table. One row is one recorded vowel token; rows repeat speakers, elicitation words, and intended vowels. The interpretation is conditional on the sampling and measurement design.

## Slide 8: Representing objects for clustering

Source note: `latent-structure/representing-objects.qmd`

We now turn to Representing objects for clustering. Peterson and Barney recorded repeated productions of ten /hVd/ words from adult and child speakers, then measured the fundamental frequency and the first three formants in a steady-state vowel section. Their primary report describes the production and separate listener experiments (Peterson and Barney 1952); the course uses the production table distributed as `phonTools::pb52`. The Praat documentation records the table's subsequent provenance.

## Slide 9: Representing objects for clustering

Source note: `latent-structure/representing-objects.qmd`

Peterson and Barney recorded repeated productions of ten /hVd/ words from adult and child speakers, then measured the fundamental frequency and the first three formants in a steady-state vowel section. We use this table throughout the latent-structure notes. The label-separation rule (LSR) is fixed at the outset: intended-vowel labels may describe or evaluate a fitted representation, but they may not enter the feature matrix, initial values, component-count choice, or covariance-family choice. That distinction will matter again on the next slide.

## Slide 10: Loading and auditing the production table

Source note: `latent-structure/representing-objects.qmd`

The audited table has observed token rows from observed speakers. Each speaker contributes observed rows: two repetitions of each of ten elicitation words. One row is thus a recorded word token, not a speaker, vowel category, or listener judgment. Peterson and Barney recorded repeated productions of ten /hVd/ words from adult and child speakers, then measured the fundamental frequency and the first three formants in a steady-state vowel section. Their primary report describes the production and separate listener experiments (Peterson and Barney 1952); the course uses the production table distributed as `phonTools::pb52`. The Praat documentation records the table's subsequent provenance. Notice what is observed and what is supplied by the model.

## Slide 11: Defining the represented objects

Source note: `latent-structure/representing-objects.qmd`

Let $N$ linguistic objects be measured on $p$ numerical properties. Their representation is Row $i$ is the vector Use the graph or equation to say the result in ordinary language.

## Slide 12: Defining the represented objects: equation 1

Source note: `latent-structure/representing-objects.qmd`

The displayed expression formalizes defining the represented objects: equation 1. Let $N$ linguistic objects be measured on $p$ numerical properties. Their representation is Keep track of what each term refers to in the linguistic dataset.

## Slide 13: Defining the represented objects: equation 2

Source note: `latent-structure/representing-objects.qmd`

The displayed expression formalizes defining the represented objects: equation 2. Row $i$ is the vector Keep track of what each term refers to in the linguistic dataset.

## Slide 14: The observed acoustic geometry

Source note: `latent-structure/representing-objects.qmd`

The plot shows all observed F1-F2 vectors and retains speaker type only as a panel label. The broad differences across panels suggest why raw hertz can partly organize tokens by anatomy-related speaker groups. But the plot does not supply an intended-vowel label to a fitting algorithm. Peterson and Barney recorded repeated productions of ten /hVd/ words from adult and child speakers, then measured the fundamental frequency and the first three formants in a steady-state vowel section. Their primary report describes the production and separate listener experiments (Peterson and Barney 1952); the course uses the production table distributed as `phonTools::pb52`. The Praat documentation records the table's subsequent provenance. The interpretation is conditional on the sampling and measurement design.

## Slide 15: Repeated rows change the target

Source note: `latent-structure/representing-objects.qmd`

Treating the observed tokens as rows produces a grouping of productions. Averaging each speaker-vowel pair first would instead produce observed speaker-vowel means and remove repetition-level variation. Averaging all observed rows for each speaker would produce a grouping of speakers and remove the within-speaker vowel space almost entirely. These are different represented objects. The present analysis keeps token rows, preserves speaker identifiers for grouped validation, and describes the resulting clusters as regions of a production space. Notice what is observed and what is supplied by the model.

## Slide 16: What the representation omits

Source note: `latent-structure/representing-objects.qmd`

Peterson and Barney also measured F0 and F3. F3 is especially relevant to the rhotic vowel, while a steady-state section cannot capture every dynamic property of an /hVd/ word. Restricting the matrix to F1 and F2 is thus a teaching choice, not a claim that the other measurements are irrelevant. The paper used the measurements to examine experimental control, production variation, and the relation between acoustic patterns and listener classifications. It did not fit K-means or Gaussian mixtures. Our clustering is a descriptive reanalysis of the released production table. Use the graph or equation to say the result in ordinary language.

## Slide 17: Checking the represented object

Source note: `latent-structure/representing-objects.qmd`

1. What does one row of `X_raw` represent? 2. Why is `speaker` retained outside the feature matrix? 3. Which variables are allowed to define similarity under the LSR? 4. How would averaging repetitions change the object represented by one row? 5. The matrix fixes which objects can be grouped and which measurements can make them similar. The next page compares geometries that use the same observed F1-F2 measurements but different scale definitions. That distinction will matter again on the next slide.

## Slide 18: Representing objects for clustering

Source note: `latent-structure/representing-objects.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Representing objects for clustering. Read the pattern before attaching a model interpretation to it.

## Slide 19: Distance and scaling

Source note: `latent-structure/distance-and-scaling.qmd`

We now turn to Distance and scaling. The Peterson-Barney table introduced on the preceding page gives F1 and F2 in hertz. A distance calculation must state how those two measurements become one comparison. Here we compare raw hertz, global standardization, and a speaker-relative representation before fixing the geometry used on later pages.

## Slide 20: Distance and scaling

Source note: `latent-structure/distance-and-scaling.qmd`

The Peterson-Barney table introduced on the preceding page gives F1 and F2 in hertz. A distance calculation must state how those two measurements become one comparison. Here we compare raw hertz, global standardization, and a speaker-relative representation before fixing the geometry used on later pages. Now connect the notation back to the linguistic comparison.

## Slide 21: Euclidean distance

Source note: `latent-structure/distance-and-scaling.qmd`

For two rows $\mathbf{x}_i$ and $\mathbf{x}_{i'}$ with $p$ features, **Euclidean distance** is Subtracting within columns keeps the comparison feature-specific. Squaring makes positive and negative differences contribute in the same direction, and adding gives an axis-aligned geometry. The units of that geometry come from the feature transformation. Keep the observational unit fixed while you interpret the result.

## Slide 22: Euclidean distance: equation 1

Source note: `latent-structure/distance-and-scaling.qmd`

The displayed expression formalizes euclidean distance: equation 1. For two rows $\mathbf{x}_i$ and $\mathbf{x}_{i'}$ with $p$ features, **Euclidean distance** is Keep track of what each term refers to in the linguistic dataset.

## Slide 23: Euclidean distance: equation 2

Source note: `latent-structure/distance-and-scaling.qmd`

The displayed expression formalizes euclidean distance: equation 2. Subtracting within columns keeps the comparison feature-specific. Squaring makes positive and negative differences contribute in the same direction, and adding gives an axis-aligned geometry. The units of that geometry come from the feature transformation. Keep track of what each term refers to in the linguistic dataset.

## Slide 24: Euclidean distance: equation 3

Source note: `latent-structure/distance-and-scaling.qmd`

The displayed expression formalizes euclidean distance: equation 3. For the main representation, we standardize within speaker: Keep track of what each term refers to in the linguistic dataset.

## Slide 25: One observed token under three scales

Source note: `latent-structure/distance-and-scaling.qmd`

We select the observed token nearest the center of the speaker-relative representation, then find its nearest other token independently in each geometry. Intended vowel and speaker type enter only after the neighbors have been found. The reference row is observed. Its nearest observed neighbor changes from row observed in raw hertz to row observed after within-speaker standardization. Scaling has changed the neighborhood without changing a token's measurements. Use the graph or equation to say the result in ordinary language.

## Slide 26: Comparing the induced neighborhoods

Source note: `latent-structure/distance-and-scaling.qmd`

Under raw hertz, observed of nearest neighbors share intended-vowel metadata and observed share speaker type. In the within-speaker geometry, those rates are observed and observed, respectively. This post hoc comparison suggests that the speaker-relative geometry reduces a salient speaker-type organization while increasing alignment with the elicitation labels. The Peterson-Barney table introduced on the preceding page gives F1 and F2 in hertz. A distance calculation must state how those two measurements become one comparison. Here we compare raw hertz, global standardization, and a speaker-relative representation before fixing the geometry used on later pages. That distinction will matter again on the next slide.

## Slide 27: The prediction information set

Source note: `latent-structure/distance-and-scaling.qmd`

Within-speaker standardization uses a speaker's complete unlabeled 20-token panel to determine that speaker's mean and standard deviation. The later speaker-blocked analyses thus target a new speaker whose complete calibration panel is available. No held-out token estimates a centroid or mixture component, but held-out measurements do determine their speaker's coordinate system. This distinction follows the prediction information set. The analysis does not predict one isolated token from a speaker with no calibration data. It also leaves dependence among the 20 transformed rows unmodeled. Keep the observational unit fixed while you interpret the result.

## Slide 28: Scaling does not establish relevance

Source note: `latent-structure/distance-and-scaling.qmd`

Standardization gives each chosen coordinate a comparable observed spread. It does not make F1 and F2 equally reliable, independent, or exhaustive. A duplicated feature would receive double influence, while an omitted dynamic or F3 measurement receives none. Thus, Euclidean distance remains conditional on the representation. A high-quality clustering under this geometry may summarize recurring F1-F2 regions, but it cannot establish that this geometry captures every linguistically relevant relation. Use the graph or equation to say the result in ordinary language.

## Slide 29: Checking the geometry

Source note: `latent-structure/distance-and-scaling.qmd`

1. Which observed token is nearest to row observed under each representation? 2. Why can the nearest neighbor change when the acoustic measurements do not? 3. What does one unit mean after within-speaker standardization? 4. Which information from a held-out speaker defines the validation coordinate system? 5. Euclidean distance combines feature differences under a declared coordinate system. The next page uses the speaker-relative geometry to estimate centroids without using the intended-vowel labels. That distinction will matter again on the next slide.

## Slide 30: Distance and scaling

Source note: `latent-structure/distance-and-scaling.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Distance and scaling. Read the pattern before attaching a model interpretation to it.

## Slide 31: K-means clustering

Source note: `latent-structure/k-means.qmd`

We now turn to K-means clustering. We now fit centroids to the speaker-relative Peterson-Barney representation. Intended-vowel labels do not enter the fit. We fix $K=10$ only to compare a ten-centroid acoustic partition with the experiment's ten elicitation categories after fitting; this is not a claim that K-means discovered the category count.

## Slide 32: K-means clustering

Source note: `latent-structure/k-means.qmd`

We now fit centroids to the speaker-relative Peterson-Barney representation. Intended-vowel labels do not enter the fit. We fix $K=10$ only to compare a ten-centroid acoustic partition with the experiment's ten elicitation categories after fitting; this is not a claim that K-means discovered the category count. Now connect the notation back to the linguistic comparison.

## Slide 33: Assignments, centroids, and loss

Source note: `latent-structure/k-means.qmd`

Let $\mathbf{x}_i\in\mathbb{R}^p$ be token $i$'s feature vector. For $K$ clusters, let be its hard assignment and let The interpretation is conditional on the sampling and measurement design.

## Slide 34: Assignments, centroids, and loss: equation 1

Source note: `latent-structure/k-means.qmd`

The displayed expression formalizes assignments, centroids, and loss: equation 1. Let $\mathbf{x}_i\in\mathbb{R}^p$ be token $i$'s feature vector. For $K$ clusters, let Keep track of what each term refers to in the linguistic dataset.

## Slide 35: Assignments, centroids, and loss: equation 2

Source note: `latent-structure/k-means.qmd`

The displayed expression formalizes assignments, centroids, and loss: equation 2. be its hard assignment and let Keep track of what each term refers to in the linguistic dataset.

## Slide 36: Assignments, centroids, and loss: equation 3

Source note: `latent-structure/k-means.qmd`

The displayed expression formalizes assignments, centroids, and loss: equation 3. be centroid $k$. **K-means clustering** minimizes the within-cluster sum of squares Keep track of what each term refers to in the linguistic dataset.

## Slide 37: Assignments, centroids, and loss: equation 4

Source note: `latent-structure/k-means.qmd`

The displayed expression formalizes assignments, centroids, and loss: equation 4. For fixed centroids, the assignment step chooses Keep track of what each term refers to in the linguistic dataset.

## Slide 38: Assignments, centroids, and loss: equation 5

Source note: `latent-structure/k-means.qmd`

The displayed expression formalizes assignments, centroids, and loss: equation 5. For fixed assignments, the update step replaces each centroid with the mean of its assigned rows: Keep track of what each term refers to in the linguistic dataset.

## Slide 39: Why the update is a mean

Source note: `latent-structure/k-means.qmd`

For one coordinate of one fixed cluster, the squared loss around a proposed center $\mu$ is Its derivative is Keep the observational unit fixed while you interpret the result.

## Slide 40: Why the update is a mean: equation 1

Source note: `latent-structure/k-means.qmd`

The displayed expression formalizes why the update is a mean: equation 1. For one coordinate of one fixed cluster, the squared loss around a proposed center $\mu$ is Keep track of what each term refers to in the linguistic dataset.

## Slide 41: Why the update is a mean: equation 2

Source note: `latent-structure/k-means.qmd`

The displayed expression formalizes why the update is a mean: equation 2. Its derivative is Keep track of what each term refers to in the linguistic dataset.

## Slide 42: Why the update is a mean: equation 3

Source note: `latent-structure/k-means.qmd`

The displayed expression formalizes why the update is a mean: equation 3. Setting this derivative to zero gives Keep track of what each term refers to in the linguistic dataset.

## Slide 43: Why the update is a mean: equation 4

Source note: `latent-structure/k-means.qmd`

The displayed expression formalizes why the update is a mean: equation 4. and thus Keep track of what each term refers to in the linguistic dataset.

## Slide 44: Fitting ten centroids

Source note: `latent-structure/k-means.qmd`

The fitted loss is observed. The seed and 100 starts make this calculation reproducible and reduce sensitivity to one initialization. They do not establish a global optimum. We now fit centroids to the speaker-relative Peterson-Barney representation. Intended-vowel labels do not enter the fit. We fix $K=10$ only to compare a ten-centroid acoustic partition with the experiment's ten elicitation categories after fitting; this is not a claim that K-means discovered the category count. Use the graph or equation to say the result in ordinary language.

## Slide 45: Inspecting one observed assignment

Source note: `latent-structure/k-means.qmd`

The token used on the scaling page is row observed. We calculate its squared distance to every fitted centroid rather than inserting a constructed coordinate pair. The nearest fitted centroid is cluster observed, with squared distance observed. The integer label is arbitrary; its location and assigned observations define the fitted region. Notice what is observed and what is supplied by the model.

## Slide 46: Verifying the update step on the fitted data

Source note: `latent-structure/k-means.qmd`

The fitted centroids equal the coordinatewise means of their assigned Peterson-Barney tokens to numerical tolerance. This observed check instantiates the update equation above. We now fit centroids to the speaker-relative Peterson-Barney representation. Intended-vowel labels do not enter the fit. We fix $K=10$ only to compare a ten-centroid acoustic partition with the experiment's ten elicitation categories after fitting; this is not a claim that K-means discovered the category count. Notice what is observed and what is supplied by the model.

## Slide 47: Comparing with labels only after fitting

Source note: `latent-structure/k-means.qmd`

The adjusted Rand index (ARI) against the withheld intended-vowel metadata is observed. This number measures alignment between two partitions after the acoustic fit. It does not turn a centroid into a vowel, establish perceptual validity, or make the analysis supervised. We now fit centroids to the speaker-relative Peterson-Barney representation. Intended-vowel labels do not enter the fit. We fix $K=10$ only to compare a ten-centroid acoustic partition with the experiment's ten elicitation categories after fitting; this is not a claim that K-means discovered the category count. The interpretation is conditional on the sampling and measurement design.

## Slide 48: Alternation and local solutions

Source note: `latent-structure/k-means.qmd`

Each assignment step cannot increase $W$ because every token chooses its nearest current centroid. Each update step cannot increase $W$ because each centroid becomes the mean of its assigned rows. The procedure thus decreases or preserves the objective until it reaches a local solution. K-means favors compact regions under squared Euclidean distance and assigns every token to exactly one region. Overlapping productions may not have that structure. A poor fit would diagnose this representation and objective, not the absence of organization in the production data. Keep the observational unit fixed while you interpret the result.

## Slide 49: Checking the alternating updates

Source note: `latent-structure/k-means.qmd`

1. Which centroid receives the reference token, and what squared distance supports that assignment? 2. How does `centroid_check` verify the update equation? 3. Why can several starts improve the fitted loss without guaranteeing a global minimum? 4. Why was $K=10$ fixed before the intended-vowel comparison? 5. K-means alternates nearest-centroid assignments with mean updates in the declared acoustic geometry. The next page shows how the fitted compactness changes when the number of centroids changes. Notice what is observed and what is supplied by the model.

## Slide 50: K-means clustering

Source note: `latent-structure/k-means.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for K-means clustering. Read the pattern before attaching a model interpretation to it.

## Slide 51: Within-cluster loss

Source note: `latent-structure/within-cluster-loss.qmd`

We now turn to Within-cluster loss. K-means requires a centroid count before fitting. We now trace the training loss across a declared grid using the same speaker-relative Peterson-Barney representation, seed policy, and multi-start fitting rule at every count.

## Slide 52: Within-cluster loss

Source note: `latent-structure/within-cluster-loss.qmd`

K-means requires a centroid count before fitting. We now trace the training loss across a declared grid using the same speaker-relative Peterson-Barney representation, seed policy, and multi-start fitting rule at every count. The interpretation is conditional on the sampling and measurement design.

## Slide 53: Loss at a declared centroid count

Source note: `latent-structure/within-cluster-loss.qmd`

For the K-means fit with $K$ centroids, write The subscript records that both assignments and centroids were estimated under candidate count $K$. The reduction obtained by adding centroid $K$ is Now connect the notation back to the linguistic comparison.

## Slide 54: Loss at a declared centroid count: equation 1

Source note: `latent-structure/within-cluster-loss.qmd`

The displayed expression formalizes loss at a declared centroid count: equation 1. For the K-means fit with $K$ centroids, write Keep track of what each term refers to in the linguistic dataset.

## Slide 55: Loss at a declared centroid count: equation 2

Source note: `latent-structure/within-cluster-loss.qmd`

The displayed expression formalizes loss at a declared centroid count: equation 2. The subscript records that both assignments and centroids were estimated under candidate count $K$. The reduction obtained by adding centroid $K$ is Keep track of what each term refers to in the linguistic dataset.

## Slide 56: Why the optimal curve cannot rise

Source note: `latent-structure/within-cluster-loss.qmd`

A model with $K+1$ centroids can reproduce a $K$-centroid solution by duplicating one existing center and retaining the assignments. Since the larger model can do at least this well, Thus, the globally minimized training loss reaches its smallest value at the largest permitted $K$. A computed curve can still rise if an algorithm reaches a poorer local solution for one candidate; several starts reduce that computational failure without changing the mathematical relation. The interpretation is conditional on the sampling and measurement design.

## Slide 57: Why the optimal curve cannot rise

Source note: `latent-structure/within-cluster-loss.qmd`

The displayed expression formalizes why the optimal curve cannot rise. A model with $K+1$ centroids can reproduce a $K$-centroid solution by duplicating one existing center and retaining the assignments. Since the larger model can do at least this well, Keep track of what each term refers to in the linguistic dataset.

## Slide 58: Fitting the observed loss curve

Source note: `latent-structure/within-cluster-loss.qmd`

The observed curve falls from observed at the smallest candidate to observed at the largest. The ten-centroid fit has loss observed, and adding the eleventh centroid reduces the loss by observed. K-means requires a centroid count before fitting. We now trace the training loss across a declared grid using the same speaker-relative Peterson-Barney representation, seed policy, and multi-start fitting rule at every count. The interpretation is conditional on the sampling and measurement design.

## Slide 59: The elbow is a visual judgment

Source note: `latent-structure/within-cluster-loss.qmd`

An **elbow plot** displays $W_K$ against $K$. The **elbow method** looks for a count after which additional centroids produce much smaller reductions. The Peterson-Barney curve supplies real reductions, but it does not supply a universal cutoff for what counts as small. The curve drops quickly at low counts and then flattens. More than one bend remains visually defensible, however. Reporting the complete curve keeps this judgment visible. Keep the observational unit fixed while you interpret the result.

## Slide 60: Loss remains tied to the representation

Source note: `latent-structure/within-cluster-loss.qmd`

Within-cluster loss depends on feature units, columns, and row count. Replacing speaker-relative scores with raw hertz would change the vertical scale and could change the fitted partitions. Duplicating F2 would give it twice the influence. Training compactness also does not establish a vowel inventory. Every additional centroid increases representational capacity on the same observations used to estimate it. The monotone loss curve cannot decide that one count is linguistically correct merely by reaching a minimum. That distinction will matter again on the next slide.

## Slide 61: Checking the loss curve

Source note: `latent-structure/within-cluster-loss.qmd`

1. Why must an optimal $W_{K+1}$ be no greater than $W_K$? 2. Which additions produce the largest empirical reductions in this table? 3. Why can two readers locate different elbows on the same curve? 4. Why is the loss scale not comparable with a raw-hertz analysis? 5. The loss curve shows how training compactness changes with capacity. The next page asks whether each observed token is closer on average to its assigned cluster than to its nearest alternative cluster. The interpretation is conditional on the sampling and measurement design.

## Slide 62: Within-cluster loss

Source note: `latent-structure/within-cluster-loss.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Within-cluster loss. Read the pattern before attaching a model interpretation to it.

## Slide 63: Silhouette widths

Source note: `latent-structure/silhouette-scores.qmd`

We now turn to Silhouette widths. The within-cluster loss measures distance from each token to its assigned centroid. It does not ask whether the token is nearly as close to another fitted group. A **silhouette width**90125-7) compares within-cluster cohesion with the nearest alternative.

## Slide 64: Silhouette widths

Source note: `latent-structure/silhouette-scores.qmd`

The within-cluster loss measures distance from each token to its assigned centroid. It does not ask whether the token is nearly as close to another fitted group. A **silhouette width**90125-7) compares within-cluster cohesion with the nearest alternative. The interpretation is conditional on the sampling and measurement design.

## Slide 65: Cohesion and the nearest alternative

Source note: `latent-structure/silhouette-scores.qmd`

Let $C(i)$ be the cluster containing token $i$. Its average distance to the other rows in that cluster is For another cluster $C$, define Notice what is observed and what is supplied by the model.

## Slide 66: Cohesion and the nearest alternative: equation 1

Source note: `latent-structure/silhouette-scores.qmd`

The displayed expression formalizes cohesion and the nearest alternative: equation 1. Let $C(i)$ be the cluster containing token $i$. Its average distance to the other rows in that cluster is Keep track of what each term refers to in the linguistic dataset.

## Slide 67: Cohesion and the nearest alternative: equation 2

Source note: `latent-structure/silhouette-scores.qmd`

The displayed expression formalizes cohesion and the nearest alternative: equation 2. For another cluster $C$, define Keep track of what each term refers to in the linguistic dataset.

## Slide 68: Cohesion and the nearest alternative: equation 3

Source note: `latent-structure/silhouette-scores.qmd`

The displayed expression formalizes cohesion and the nearest alternative: equation 3. The nearest alternative-cluster distance is Keep track of what each term refers to in the linguistic dataset.

## Slide 69: Cohesion and the nearest alternative: equation 4

Source note: `latent-structure/silhouette-scores.qmd`

The displayed expression formalizes cohesion and the nearest alternative: equation 4. The silhouette width is Keep track of what each term refers to in the linguistic dataset.

## Slide 70: Cohesion and the nearest alternative: equation 5

Source note: `latent-structure/silhouette-scores.qmd`

The displayed expression formalizes cohesion and the nearest alternative: equation 5. If $b(i)\geq a(i)$, then Keep track of what each term refers to in the linguistic dataset.

## Slide 71: Cohesion and the nearest alternative: equation 6

Source note: `latent-structure/silhouette-scores.qmd`

The displayed expression formalizes cohesion and the nearest alternative: equation 6. which lies between zero and one. If $a(i)>b(i)$, then Keep track of what each term refers to in the linguistic dataset.

## Slide 72: Reconstructing one observed silhouette

Source note: `latent-structure/silhouette-scores.qmd`

The most negative token in the ten-centroid fit supplies a worked calculation from the production table. For row observed, $a(i)$ is observed and $b(i)$ is observed. Substituting those observed distances gives The interpretation is conditional on the sampling and measurement design.

## Slide 73: Reconstructing one observed silhouette

Source note: `latent-structure/silhouette-scores.qmd`

The displayed expression formalizes reconstructing one observed silhouette. The most negative token in the ten-centroid fit supplies a worked calculation from the production table. Keep track of what each term refers to in the linguistic dataset.

## Slide 74: Comparing candidate counts

Source note: `latent-structure/silhouette-scores.qmd`

The mean silhouette is largest at $K=observed$, where it equals observed. The ten-centroid partition has mean silhouette observed, while its post-fit ARI against intended vowels is observed, the largest in this fitted grid at $K=observed$. This disagreement is the empirical lesson. Silhouette rewards cohesion and separation under the fitted geometry; intended-vowel ARI evaluates agreement with external experimental metadata. The two criteria answer different questions. That distinction will matter again on the next slide.

## Slide 75: Limits of the score

Source note: `latent-structure/silhouette-scores.qmd`

Silhouettes inherit the distance, scaling, and fitted partition. Compact groups separated by gaps tend to score well, while systematically overlapping categories may not. A singleton cluster conventionally receives silhouette zero because within-cluster cohesion cannot be estimated from a pair. Thus, the candidate with the largest mean silhouette is best only among the fitted partitions under this score. It does not establish the number of phonological categories. The interpretation is conditional on the sampling and measurement design.

## Slide 76: Checking cohesion and separation

Source note: `latent-structure/silhouette-scores.qmd`

1. Which observed averages produce the reference token's negative silhouette? 2. Why does $b(i)$ use the nearest alternative cluster? 3. Which $K$ maximizes the intrinsic silhouette criterion? 4. Which $K$ maximizes alignment with withheld intended-vowel metadata? 5. Why can both answers be correct for their respective targets? A silhouette diagnoses a fitted partition under the same geometry used to form it. The speaker-blocked validation page instead asks how centroids estimated from other speakers reconstruct a complete unseen speaker panel. Notice what is observed and what is supplied by the model.

## Slide 77: Silhouette widths

Source note: `latent-structure/silhouette-scores.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Silhouette widths. Read the pattern before attaching a model interpretation to it.

## Slide 78: Interpretation

Source note: `latent-structure/silhouette-scores.qmd`

A silhouette diagnoses a fitted partition under the same geometry used to form it. The speaker-blocked validation page instead asks how centroids estimated from other speakers reconstruct a complete unseen speaker panel. The interpretation is conditional on the sampling and measurement design.

## Slide 79: Validation without outcome labels

Source note: `latent-structure/unsupervised-validation.qmd`

We now turn to Validation without outcome labels. A clustering has no observed cluster label that the fitting procedure is meant to predict. For K-means, we can instead ask whether centroids estimated from training speakers place tokens from held-out speakers near a learned center. The validation target here is a new speaker's complete 20-token calibration panel, not one isolated token.

## Slide 80: Validation without outcome labels

Source note: `latent-structure/unsupervised-validation.qmd`

A clustering has no observed cluster label that the fitting procedure is meant to predict. For K-means, we can instead ask whether centroids estimated from training speakers place tokens from held-out speakers near a learned center. The validation target here is a new speaker's complete 20-token calibration panel, not one isolated token. Now connect the notation back to the linguistic comparison.

## Slide 81: Reconstructing the rows and speaker folds

Source note: `latent-structure/unsupervised-validation.qmd`

The folds are balanced within the paper's men, women, and children speaker groups. All rows from one speaker stay in one fold. A clustering has no observed cluster label that the fitting procedure is meant to predict. For K-means, we can instead ask whether centroids estimated from training speakers place tokens from held-out speakers near a learned center. The validation target here is a new speaker's complete 20-token calibration panel, not one isolated token. Now connect the notation back to the linguistic comparison.

## Slide 82: Predicting a held-out token

Source note: `latent-structure/unsupervised-validation.qmd`

Let be centroids estimated without the held-out speaker. Token $i$ receives the nearest fixed center: Now connect the notation back to the linguistic comparison.

## Slide 83: Predicting a held-out token: equation 1

Source note: `latent-structure/unsupervised-validation.qmd`

The displayed expression formalizes predicting a held-out token: equation 1. Let Keep track of what each term refers to in the linguistic dataset.

## Slide 84: Predicting a held-out token: equation 2

Source note: `latent-structure/unsupervised-validation.qmd`

The displayed expression formalizes predicting a held-out token: equation 2. be centroids estimated without the held-out speaker. Token $i$ receives the nearest fixed center: Keep track of what each term refers to in the linguistic dataset.

## Slide 85: Predicting a held-out token: equation 3

Source note: `latent-structure/unsupervised-validation.qmd`

The displayed expression formalizes predicting a held-out token: equation 3. Its squared reconstruction loss is Keep track of what each term refers to in the linguistic dataset.

## Slide 86: Keeping the new unit new

Source note: `latent-structure/unsupervised-validation.qmd`

The relevant separation rule comes from grouped cross-validation: a test speaker cannot contribute another token to training. The following helper computes each held-out token's nearest training centroid. Each speaker contributes one mean loss at each $K$, so speakers receive equal weight in the displayed uncertainty summary. That distinction will matter again on the next slide.

## Slide 87: Why reconstruction loss does not select a category count

Source note: `latent-structure/unsupervised-validation.qmd`

A codebook with $K+1$ centers can reproduce a $K$-center codebook by duplicating one center. Its population reconstruction loss can thus decrease or remain constant as capacity increases. Finite training samples and local optimization may make a validation curve wiggle, but the target still rewards added representational capacity. Held-out loss can compare how efficiently declared codebook sizes represent new panels, or it can be paired with a separately declared complexity budget. It does not estimate a phonological inventory by itself. The interpretation is conditional on the sampling and measurement design.

## Slide 88: The calibration-panel target

Source note: `latent-structure/unsupervised-validation.qmd`

The within-speaker scores were computed from each speaker's complete unlabeled panel before the split. Thus, held-out speakers influence their own normalization but do not influence the fitted centroids. This prediction information set may be appropriate when a complete acoustic calibration panel is available. It is unavailable for a first isolated token. This use of test-panel measurements is deliberate rather than hidden preprocessing leakage. The claim must name the adapted target. Notice what is observed and what is supplied by the model.

## Slide 89: Checking the held-out target

Source note: `latent-structure/unsupervised-validation.qmd`

1. Why do all rows from a speaker move together? 2. Which fitted objects exclude the held-out speaker entirely? 3. What information from the held-out speaker is used for normalization? 4. Why does lower held-out reconstruction loss favor larger codebooks? 5. What new-speaker claim does this design not support? Speaker-blocked reconstruction loss evaluates transfer of a centroid representation to complete unseen-speaker panels. The next page replaces hard nearest-centroid geometry with a probability model that retains component spread and overlap. The interpretation is conditional on the sampling and measurement design.

## Slide 90: Validation without outcome labels

Source note: `latent-structure/unsupervised-validation.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Validation without outcome labels. Read the pattern before attaching a model interpretation to it.

## Slide 91: Gaussian mixtures

Source note: `latent-structure/gaussian-mixtures.qmd`

We now turn to Gaussian mixtures. The Peterson-Barney production space contains overlapping F1-F2 regions. K-means represents each region by one point and assigns every token to exactly one centroid. A **Gaussian mixture model (GMM)** instead represents regions by weighted probability distributions, each with an estimated location and spread.

## Slide 92: Gaussian mixtures

Source note: `latent-structure/gaussian-mixtures.qmd`

The Peterson-Barney production space contains overlapping F1-F2 regions. K-means represents each region by one point and assigns every token to exactly one centroid. A **Gaussian mixture model (GMM)** instead represents regions by weighted probability distributions, each with an estimated location and spread. The interpretation is conditional on the sampling and measurement design.

## Slide 93: One Gaussian component

Source note: `latent-structure/gaussian-mixtures.qmd`

Let $\mathbf{x}_i\in\mathbb{R}^p$ be token $i$'s measurements. Component $k$ has mean and covariance Notice what is observed and what is supplied by the model.

## Slide 94: One Gaussian component: equation 1

Source note: `latent-structure/gaussian-mixtures.qmd`

The displayed expression formalizes one gaussian component: equation 1. Let $\mathbf{x}_i\in\mathbb{R}^p$ be token $i$'s measurements. Component $k$ has mean Keep track of what each term refers to in the linguistic dataset.

## Slide 95: One Gaussian component: equation 2

Source note: `latent-structure/gaussian-mixtures.qmd`

The displayed expression formalizes one gaussian component: equation 2. and covariance Keep track of what each term refers to in the linguistic dataset.

## Slide 96: One Gaussian component: equation 3

Source note: `latent-structure/gaussian-mixtures.qmd`

The displayed expression formalizes one gaussian component: equation 3. Its density is Keep track of what each term refers to in the linguistic dataset.

## Slide 97: One Gaussian component: equation 4

Source note: `latent-structure/gaussian-mixtures.qmd`

The displayed expression formalizes one gaussian component: equation 4. For F1 and F2, Keep track of what each term refers to in the linguistic dataset.

## Slide 98: Combining components

Source note: `latent-structure/gaussian-mixtures.qmd`

Component $k$ receives weight with That distinction will matter again on the next slide.

## Slide 99: Combining components: equation 1

Source note: `latent-structure/gaussian-mixtures.qmd`

The displayed expression formalizes combining components: equation 1. Component $k$ receives weight Keep track of what each term refers to in the linguistic dataset.

## Slide 100: Combining components: equation 2

Source note: `latent-structure/gaussian-mixtures.qmd`

The displayed expression formalizes combining components: equation 2. with Keep track of what each term refers to in the linguistic dataset.

## Slide 101: Combining components: equation 3

Source note: `latent-structure/gaussian-mixtures.qmd`

The displayed expression formalizes combining components: equation 3. The mixture density is Keep track of what each term refers to in the linguistic dataset.

## Slide 102: Fitting the declared ten-component model

Source note: `latent-structure/gaussian-mixtures.qmd`

We fix a ten-component `EVI` covariance family before fitting. In `mclust`, `EVI` is diagonal with equal volume and varying shape. Thus, covariance ellipses are axis-aligned, share a determinant, and may allocate their spread differently between the two formant dimensions. The fitted weights sum to observed, and every covariance matrix is positive definite. These are model checks, not linguistic interpretations of the component numbers. The interpretation is conditional on the sampling and measurement design.

## Slide 103: Plotting the fitted distributions with the data

Source note: `latent-structure/gaussian-mixtures.qmd`

The ellipses show 90% contours under each fitted Gaussian component. They are model summaries laid over the raw transformed points; they are not boundaries inferred from intended-vowel labels. The Peterson-Barney production space contains overlapping F1-F2 regions. K-means represents each region by one point and assigns every token to exactly one centroid. A **Gaussian mixture model (GMM)** instead represents regions by weighted probability distributions, each with an estimated location and spread. The interpretation is conditional on the sampling and measurement design.

## Slide 104: Post-fit alignment and uncertainty

Source note: `latent-structure/gaussian-mixtures.qmd`

The hard component assignments have ARI observed against the withheld intended-vowel metadata, while mean classification uncertainty is observed. The former describes post-fit alignment. The latter summarizes how much posterior mass remains outside the most probable component. The Peterson-Barney production space contains overlapping F1-F2 regions. K-means represents each region by one point and assigns every token to exactly one centroid. A **Gaussian mixture model (GMM)** instead represents regions by weighted probability distributions, each with an estimated location and spread. Notice what is observed and what is supplied by the model.

## Slide 105: Components are not phonemes

Source note: `latent-structure/gaussian-mixtures.qmd`

A fitted Gaussian component is a distributional object under the chosen measurements, transformation, component count, and covariance restriction. Several components may cover productions from one elicitation category, and one component may cover overlapping productions from several categories. The speaker-relative transformation may reduce anatomy-related differences, but it can also remove sociolinguistically relevant variation. Moreover, F3 and dynamic information remain outside the model. A potential worry is thus that a sharp component reflects an incomplete acoustic representation. Post-fit alignment cannot eliminate that limitation. Notice what is observed and what is supplied by the model.

## Slide 106: Covariance collapse

Source note: `latent-structure/gaussian-mixtures.qmd`

An unrestricted Gaussian component can concentrate around very few rows while its covariance approaches singularity. The likelihood may then grow without representing a recurring acoustic region. Positive-definiteness checks, covariance restrictions, and fitting diagnostics must precede interpretation. The `EVI` restriction used here limits the fitted geometry. It does not establish that every acoustic region truly has diagonal covariance. Use the graph or equation to say the result in ordinary language.

## Slide 107: Checking the observation model

Source note: `latent-structure/gaussian-mixtures.qmd`

1. What do the fitted means and covariance matrices represent? 2. Why must the fitted weights sum to one? 3. Which covariance properties does `EVI` hold equal or allow to vary? 4. Why are the intended-vowel labels unnecessary for the displayed ellipses? 5. A Gaussian mixture assigns every token the sum of weighted component densities. The next page normalizes those observed contributions into conditional membership probabilities. That distinction will matter again on the next slide.

## Slide 108: Gaussian mixtures

Source note: `latent-structure/gaussian-mixtures.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Gaussian mixtures. Read the pattern before attaching a model interpretation to it.

## Slide 109: Posterior membership

Source note: `latent-structure/posterior-membership.qmd`

We now turn to Posterior membership. A Gaussian mixture assigns density to every observed acoustic vector. We now ask how the weighted component contributions divide for one Peterson-Barney token. The **posterior probability of component membership**, often expressed as **responsibilities**, applies Bayes' rule inside the fitted mixture.

## Slide 110: Posterior membership

Source note: `latent-structure/posterior-membership.qmd`

A Gaussian mixture assigns density to every observed acoustic vector. We now ask how the weighted component contributions divide for one Peterson-Barney token. The **posterior probability of component membership**, often expressed as **responsibilities**, applies Bayes' rule inside the fitted mixture. Now connect the notation back to the linguistic comparison.

## Slide 111: Loading and fitting the fixed mixture

Source note: `latent-structure/posterior-membership.qmd`

The intended-vowel column is retained in `vowels` but is not passed to `Mclust()`. A Gaussian mixture assigns density to every observed acoustic vector. We now ask how the weighted component contributions divide for one Peterson-Barney token. The **posterior probability of component membership**, often expressed as **responsibilities**, applies Bayes' rule inside the fitted mixture. Keep the observational unit fixed while you interpret the result.

## Slide 112: Conditioning on an unobserved component

Source note: `latent-structure/posterior-membership.qmd`

Let be the unobserved component label. Before observing $\mathbf{x}_i$, Notice what is observed and what is supplied by the model.

## Slide 113: Conditioning on an unobserved component: equation 1

Source note: `latent-structure/posterior-membership.qmd`

The displayed expression formalizes conditioning on an unobserved component: equation 1. Let Keep track of what each term refers to in the linguistic dataset.

## Slide 114: Conditioning on an unobserved component: equation 2

Source note: `latent-structure/posterior-membership.qmd`

The displayed expression formalizes conditioning on an unobserved component: equation 2. be the unobserved component label. Before observing $\mathbf{x}_i$, Keep track of what each term refers to in the linguistic dataset.

## Slide 115: Conditioning on an unobserved component: equation 3

Source note: `latent-structure/posterior-membership.qmd`

The displayed expression formalizes conditioning on an unobserved component: equation 3. Conditional on component $k$, Keep track of what each term refers to in the linguistic dataset.

## Slide 116: Conditioning on an unobserved component: equation 4

Source note: `latent-structure/posterior-membership.qmd`

The displayed expression formalizes conditioning on an unobserved component: equation 4. Bayes' rule gives Keep track of what each term refers to in the linguistic dataset.

## Slide 117: Conditioning on an unobserved component: equation 5

Source note: `latent-structure/posterior-membership.qmd`

The displayed expression formalizes conditioning on an unobserved component: equation 5. Substituting the mixture density yields Keep track of what each term refers to in the linguistic dataset.

## Slide 118: Conditioning on an unobserved component: equation 6

Source note: `latent-structure/posterior-membership.qmd`

The displayed expression formalizes conditioning on an unobserved component: equation 6. The denominator normalizes the weighted contributions, so Keep track of what each term refers to in the linguistic dataset.

## Slide 119: Calculating every responsibility directly

Source note: `latent-structure/posterior-membership.qmd`

The direct calculation agrees with `mclust`'s expectation step to numerical tolerance. We use the observed token with the greatest fitted uncertainty as the worked case. For row observed, the three largest responsibilities are observed. They sum to observed, while the remaining components receive negligible mass. The hard assignment keeps only component observed and discards this overlap. Keep the observational unit fixed while you interpret the result.

## Slide 120: Hard assignments and uncertainty

Source note: `latent-structure/posterior-membership.qmd`

A hard assignment is Define fitted uncertainty as Now connect the notation back to the linguistic comparison.

## Slide 121: Hard assignments and uncertainty: equation 1

Source note: `latent-structure/posterior-membership.qmd`

The displayed expression formalizes hard assignments and uncertainty: equation 1. A hard assignment is Keep track of what each term refers to in the linguistic dataset.

## Slide 122: Hard assignments and uncertainty: equation 2

Source note: `latent-structure/posterior-membership.qmd`

The displayed expression formalizes hard assignments and uncertainty: equation 2. Define fitted uncertainty as Keep track of what each term refers to in the linguistic dataset.

## Slide 123: Inspecting intended-vowel metadata after fitting

Source note: `latent-structure/posterior-membership.qmd`

The x-axis uses intended-vowel metadata only after every responsibility has been calculated. Differences across labels describe where the fixed F1-F2 mixture is more or less decisive. They do not estimate listener accuracy. A Gaussian mixture assigns density to every observed acoustic vector. We now ask how the weighted component contributions divide for one Peterson-Barney token. The **posterior probability of component membership**, often expressed as **responsibilities**, applies Bayes' rule inside the fitted mixture. Notice what is observed and what is supplied by the model.

## Slide 124: Component numbers and conditioning

Source note: `latent-structure/posterior-membership.qmd`

Exchanging all parameters for two components leaves the mixture density unchanged and merely exchanges responsibility columns. This **label switching** means that the integer attached to a component has no stable phonological meaning across separate fits. Moreover, a responsibility is not the probability that an intended label is correct. It is conditional on the observed F1-F2 vector, fixed component count, `EVI` covariance family, speaker-relative transformation, and estimated parameters. It does not integrate uncertainty about any of those choices. Keep the observational unit fixed while you interpret the result.

## Slide 125: Checking the normalized contributions

Source note: `latent-structure/posterior-membership.qmd`

1. Which weighted contributions produce the three largest memberships for row observed? 2. Why does each responsibility row sum to one? 3. What information does the hard component label discard for this token? 4. Why can component numbers change across equivalent fits? 5. Posterior membership normalizes observed weighted component densities and retains fitted overlap. The next page uses these responsibilities as weights in iterative parameter updates. Use the graph or equation to say the result in ordinary language.

## Slide 126: Posterior membership

Source note: `latent-structure/posterior-membership.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Posterior membership. Read the pattern before attaching a model interpretation to it.

## Slide 127: Expectation-maximization

Source note: `latent-structure/expectation-maximization.qmd`

We now turn to Expectation-maximization. If component labels were observed, we could estimate a Gaussian from its assigned Peterson-Barney tokens. If component parameters were known, we could calculate each token's responsibilities. The **expectation-maximization (EM) algorithm** alternates those two calculations when neither side is known.

## Slide 128: Expectation-maximization

Source note: `latent-structure/expectation-maximization.qmd`

If component labels were observed, we could estimate a Gaussian from its assigned Peterson-Barney tokens. If component parameters were known, we could calculate each token's responsibilities. The **expectation-maximization (EM) algorithm** alternates those two calculations when neither side is known. The interpretation is conditional on the sampling and measurement design.

## Slide 129: Complete and observed data

Source note: `latent-structure/expectation-maximization.qmd`

Let the current parameters be If component label $Z_i$ were observed, define Now connect the notation back to the linguistic comparison.

## Slide 130: Complete and observed data: equation 1

Source note: `latent-structure/expectation-maximization.qmd`

The displayed expression formalizes complete and observed data: equation 1. Let the current parameters be Keep track of what each term refers to in the linguistic dataset.

## Slide 131: Complete and observed data: equation 2

Source note: `latent-structure/expectation-maximization.qmd`

The displayed expression formalizes complete and observed data: equation 2. If component label $Z_i$ were observed, define Keep track of what each term refers to in the linguistic dataset.

## Slide 132: Complete and observed data: equation 3

Source note: `latent-structure/expectation-maximization.qmd`

The displayed expression formalizes complete and observed data: equation 3. The complete-data log likelihood would be Keep track of what each term refers to in the linguistic dataset.

## Slide 133: The expectation step

Source note: `latent-structure/expectation-maximization.qmd`

Given $\boldsymbol{\theta}^{(t)}$, calculate Since The interpretation is conditional on the sampling and measurement design.

## Slide 134: The expectation step: equation 1

Source note: `latent-structure/expectation-maximization.qmd`

The displayed expression formalizes the expectation step: equation 1. Given $\boldsymbol{\theta}^{(t)}$, calculate Keep track of what each term refers to in the linguistic dataset.

## Slide 135: The expectation step: equation 2

Source note: `latent-structure/expectation-maximization.qmd`

The displayed expression formalizes the expectation step: equation 2. Since Keep track of what each term refers to in the linguistic dataset.

## Slide 136: The expectation step: equation 3

Source note: `latent-structure/expectation-maximization.qmd`

The displayed expression formalizes the expectation step: equation 3. the EM auxiliary objective is Keep track of what each term refers to in the linguistic dataset.

## Slide 137: The maximization step

Source note: `latent-structure/expectation-maximization.qmd`

The effective token count for component $k$ is The updated weight and mean are Use the graph or equation to say the result in ordinary language.

## Slide 138: The maximization step: equation 1

Source note: `latent-structure/expectation-maximization.qmd`

The displayed expression formalizes the maximization step: equation 1. The effective token count for component $k$ is Keep track of what each term refers to in the linguistic dataset.

## Slide 139: The maximization step: equation 2

Source note: `latent-structure/expectation-maximization.qmd`

The displayed expression formalizes the maximization step: equation 2. The updated weight and mean are Keep track of what each term refers to in the linguistic dataset.

## Slide 140: The maximization step: equation 3

Source note: `latent-structure/expectation-maximization.qmd`

The displayed expression formalizes the maximization step: equation 3. and Keep track of what each term refers to in the linguistic dataset.

## Slide 141: The maximization step: equation 4

Source note: `latent-structure/expectation-maximization.qmd`

The displayed expression formalizes the maximization step: equation 4. For an unrestricted Gaussian component, the covariance update is Keep track of what each term refers to in the linguistic dataset.

## Slide 142: Implementing EM on the observed vectors

Source note: `latent-structure/expectation-maximization.qmd`

All six observed-data traces are non-decreasing within numerical tolerance, but their final log likelihoods differ. The best three starts finish at observed, while the weakest finishes at observed. This is direct evidence of local-solution sensitivity in the PB52 fit. If component labels were observed, we could estimate a Gaussian from its assigned Peterson-Barney tokens. If component parameters were known, we could calculate each token's responsibilities. The **expectation-maximization (EM) algorithm** alternates those two calculations when neither side is known. That distinction will matter again on the next slide.

## Slide 143: Verifying one component update

Source note: `latent-structure/expectation-maximization.qmd`

For component observed, the effective count is observed, and the responsibility-weighted mean is (observed, observed). These values come from all observed token vectors, weighted by their fitted responsibilities. If component labels were observed, we could estimate a Gaussian from its assigned Peterson-Barney tokens. If component parameters were known, we could calculate each token's responsibilities. The **expectation-maximization (EM) algorithm** alternates those two calculations when neither side is known. Notice what is observed and what is supplied by the model.

## Slide 144: Likelihood monotonicity

Source note: `latent-structure/expectation-maximization.qmd`

The observed-data log likelihood is Exact EM updates do not decrease this quantity. That guarantee concerns progress from one starting point; it does not guarantee the largest attainable likelihood. The interpretation is conditional on the sampling and measurement design.

## Slide 145: Likelihood monotonicity

Source note: `latent-structure/expectation-maximization.qmd`

The displayed expression formalizes likelihood monotonicity. The observed-data log likelihood is Keep track of what each term refers to in the linguistic dataset.

## Slide 146: Local solutions and variance constraints

Source note: `latent-structure/expectation-maximization.qmd`

The variance floor prevents an estimated diagonal variance from approaching zero. It is a declared computational constraint, not an observed linguistic variance. Without such protection, a component may collapse around very few tokens and yield a misleadingly large likelihood. Several starts remain necessary because monotonic ascent can lead to distinct local optima. A fixed seed reproduces the collection of starts; it does not make the first solution globally best. That distinction will matter again on the next slide.

## Slide 147: Checking the alternating algorithm

Source note: `latent-structure/expectation-maximization.qmd`

1. Which quantities are calculated in the expectation step? 2. How does the empirical effective count instantiate $N_k$? 3. How are the displayed component means reconstructed from responsibilities? 4. What does monotonic observed-data likelihood guarantee? 5. What do the distinct final likelihoods show? 6. EM alternates conditional membership calculation with responsibility-weighted parameter updates. The next page compares declared component counts and covariance families while keeping the feature representation fixed. Now connect the notation back to the linguistic comparison.

## Slide 148: Expectation-maximization

Source note: `latent-structure/expectation-maximization.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Expectation-maximization. Read the pattern before attaching a model interpretation to it.

## Slide 149: Choosing a mixture with BIC

Source note: `latent-structure/choosing-a-mixture.qmd`

We now turn to Choosing a mixture with BIC. A Gaussian mixture requires both a component count and a covariance family. We use the **Bayesian information criterion (BIC)** to compare a declared grid on the speaker-relative Peterson-Barney representation, then distinguish the selected distributional model from the ten-component model used to teach membership and external alignment.

## Slide 150: Choosing a mixture with BIC

Source note: `latent-structure/choosing-a-mixture.qmd`

A Gaussian mixture requires both a component count and a covariance family. We use the **Bayesian information criterion (BIC)** to compare a declared grid on the speaker-relative Peterson-Barney representation, then distinguish the selected distributional model from the ten-component model used to teach membership and external alignment. Keep the observational unit fixed while you interpret the result.

## Slide 151: Reconstructing the candidate data

Source note: `latent-structure/choosing-a-mixture.qmd`

The covariance families and component range are fixed before intended-vowel agreement is inspected. A candidate specification contains the component count $K$, covariance family $\mathcal C$, and remaining procedure $\mathcal R$: Changing the scaling or start policy during the comparison would change $\mathcal R$ and thus the candidate being ranked. Notice what is observed and what is supplied by the model.

## Slide 152: Reconstructing the candidate data

Source note: `latent-structure/choosing-a-mixture.qmd`

The displayed expression formalizes reconstructing the candidate data. The covariance families and component range are fixed before intended-vowel agreement is inspected. A candidate specification contains the component count $K$, covariance family $\mathcal C$, and remaining procedure $\mathcal R$: Keep track of what each term refers to in the linguistic dataset.

## Slide 153: BIC and its sign convention

Source note: `latent-structure/choosing-a-mixture.qmd`

For maximized likelihood $L$, $q$ estimated parameters, and $n$ likelihood contributions, define Smaller values are preferred under this convention. `mclust` reports the negative quantity, That distinction will matter again on the next slide.

## Slide 154: BIC and its sign convention: equation 1

Source note: `latent-structure/choosing-a-mixture.qmd`

The displayed expression formalizes bic and its sign convention: equation 1. For maximized likelihood $L$, $q$ estimated parameters, and $n$ likelihood contributions, define Keep track of what each term refers to in the linguistic dataset.

## Slide 155: BIC and its sign convention: equation 2

Source note: `latent-structure/choosing-a-mixture.qmd`

The displayed expression formalizes bic and its sign convention: equation 2. Smaller values are preferred under this convention. `mclust` reports the negative quantity, Keep track of what each term refers to in the linguistic dataset.

## Slide 156: Fitting the declared grid

Source note: `latent-structure/choosing-a-mixture.qmd`

The grid selects the observed-component observed model with BIC observed. The fixed ten-component `EVI` model has BIC observed. These values are obtained from the fitted likelihoods, parameter counts, and observed token count shown in the table. A Gaussian mixture requires both a component count and a covariance family. We use the **Bayesian information criterion (BIC)** to compare a declared grid on the speaker-relative Peterson-Barney representation, then distinguish the selected distributional model from the ten-component model used to teach membership and external alignment. That distinction will matter again on the next slide.

## Slide 157: Distributional fit and label alignment differ

Source note: `latent-structure/choosing-a-mixture.qmd`

The BIC-selected model has post-fit ARI observed, while the ten-component `EVI` model has ARI observed. BIC prefers the first density specification; the external intended-vowel partition aligns more closely with the second hard classification. This K10/G14 distinction should remain explicit. A particular mixture can be useful for teaching category-aligned uncertainty without being the BIC-selected density model. That distinction will matter again on the next slide.

## Slide 158: Interpreting the sample size

Source note: `latent-structure/choosing-a-mixture.qmd`

The criterion uses $n=observed$ token contributions because that is the likelihood fitted by the software. It does not imply that the study sampled that many independent speakers. The rows come from observed speakers with repeated productions. The usual BIC approximation presumes an appropriate independence structure. A token-level mixture that omits repeated-speaker dependence does not gain that structure from the penalty. Thus, the values can rank these declared software fits, while their asymptotic evidence interpretation remains limited. Use the graph or equation to say the result in ordinary language.

## Slide 159: Candidate-set and fit limits

Source note: `latent-structure/choosing-a-mixture.qmd`

BIC compares only the supplied component counts, covariance families, representation, and fitting controls. It cannot repair omitted F3 information, within-speaker dependence, or an unsuitable Gaussian family. Mixture label permutations and weakly represented components also complicate the regularity assumptions behind simple information-criterion arguments. The selected component count need not equal a phonological inventory. A vowel's productions may occupy several Gaussian regions, while overlapping intended vowels may share one region. That distinction will matter again on the next slide.

## Slide 160: Checking the BIC comparison

Source note: `latent-structure/choosing-a-mixture.qmd`

1. How is each displayed BIC reconstructed from log likelihood and parameter count? 2. Why is the `mclust` sign reversed before plotting? 3. Which declared model minimizes conventional BIC? 4. Which fixed model aligns more closely with intended-vowel metadata? 5. Why does the token count not represent independent speakers? 6. BIC ranks a declared candidate grid under a token-level likelihood and penalty. The next page compares the fixed K10 and G14 candidates by predictive density on complete held-out speakers. Keep the observational unit fixed while you interpret the result.

## Slide 161: Choosing a mixture with BIC

Source note: `latent-structure/choosing-a-mixture.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Choosing a mixture with BIC. Read the pattern before attaching a model interpretation to it.

## Slide 162: Validating a mixture on held-out speakers

Source note: `latent-structure/validating-a-mixture.qmd`

We now turn to Validating a mixture on held-out speakers. BIC penalizes likelihood on the rows used for fitting. We now compare the fixed ten-component `EVI` model and the BIC-selected fourteen-component `EEI` model by predictive density on complete held-out speakers. This comparison retains the K10/G14 distinction and uses the same folds as the centroid validation.

## Slide 163: Validating a mixture on held-out speakers

Source note: `latent-structure/validating-a-mixture.qmd`

BIC penalizes likelihood on the rows used for fitting. We now compare the fixed ten-component `EVI` model and the BIC-selected fourteen-component `EEI` model by predictive density on complete held-out speakers. This comparison retains the K10/G14 distinction and uses the same folds as the centroid validation. The interpretation is conditional on the sampling and measurement design.

## Slide 164: Reconstructing the data and speaker folds

Source note: `latent-structure/validating-a-mixture.qmd`

The folds exclude every one of a held-out speaker's observed rows from mixture estimation. The held-out speaker's unlabeled panel still determines that speaker's within-speaker standardization, so the analysis predicts density for an adapted complete panel rather than a first isolated token. BIC penalizes likelihood on the rows used for fitting. We now compare the fixed ten-component `EVI` model and the BIC-selected fourteen-component `EEI` model by predictive density on complete held-out speakers. This comparison retains the K10/G14 distinction and uses the same folds as the centroid validation. Use the graph or equation to say the result in ordinary language.

## Slide 165: Held-out log loss

Source note: `latent-structure/validating-a-mixture.qmd`

For a mixture fit to training speakers, the log loss of token $i$ is Smaller loss means that the fitted model assigns greater density to the held-out acoustic vector. For two candidates $A$ and $B$, the paired token difference is Notice what is observed and what is supplied by the model.

## Slide 166: Held-out log loss: equation 1

Source note: `latent-structure/validating-a-mixture.qmd`

The displayed expression formalizes held-out log loss: equation 1. For a mixture fit to training speakers, the log loss of token $i$ is Keep track of what each term refers to in the linguistic dataset.

## Slide 167: Held-out log loss: equation 2

Source note: `latent-structure/validating-a-mixture.qmd`

The displayed expression formalizes held-out log loss: equation 2. Smaller loss means that the fitted model assigns greater density to the held-out acoustic vector. For two candidates $A$ and $B$, the paired token difference is Keep track of what each term refers to in the linguistic dataset.

## Slide 168: Fitting and scoring both candidates

Source note: `latent-structure/validating-a-mixture.qmd`

Mean speaker log loss is observed for K10 and observed for G14. The paired mean difference, G14 minus K10, is observed, and G14 has lower loss for observed of speakers. The figure keeps the 76 paired speaker comparisons visible. Points left of zero favor G14 under predictive density; points right of zero favor K10. That distinction will matter again on the next slide.

## Slide 169: External alignment after prediction

Source note: `latent-structure/validating-a-mixture.qmd`

K10 has the larger post-fit ARI in all observed folds. Thus, the model with slightly better mean held-out density aligns less closely with intended-vowel metadata. Predictive density and experimental-label alignment remain separate validation targets. BIC penalizes likelihood on the rows used for fitting. We now compare the fixed ten-component `EVI` model and the BIC-selected fourteen-component `EEI` model by predictive density on complete held-out speakers. This comparison retains the K10/G14 distinction and uses the same folds as the centroid validation. Notice what is observed and what is supplied by the model.

## Slide 170: Information-set and dependence limits

Source note: `latent-structure/validating-a-mixture.qmd`

The coordinate system includes each held-out speaker's unlabeled calibration panel, though no held-out token enters mixture estimation. This is the same explicit prediction information set used for centroid validation. The mixture likelihood still treats transformed token rows as conditionally independent and does not model their shared speaker normalization. Fold averages are computational summaries, not independent samples. Speaker-level paired values describe the variation relevant to the claim without pretending that repeated folds create new speakers. Use the graph or equation to say the result in ordinary language.

## Slide 171: Checking the validation design

Source note: `latent-structure/validating-a-mixture.qmd`

1. Why must all rows from one speaker stay in one test fold? 2. What does a negative G14-minus-K10 difference mean? 3. Which candidate has the lower mean held-out log loss? 4. Which candidate has the higher external ARI in every fold? 5. Speaker-blocked log loss slightly favors G14 on average, while external alignment favors K10 in every fold. This disagreement is informative because the criteria evaluate different consequences of the same label-blind acoustic fits. Use the graph or equation to say the result in ordinary language.

## Slide 172: Validating a mixture on held-out speakers

Source note: `latent-structure/validating-a-mixture.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Validating a mixture on held-out speakers. Read the pattern before attaching a model interpretation to it.

## Slide 173: Interpretation

Source note: `latent-structure/validating-a-mixture.qmd`

Speaker-blocked log loss slightly favors G14 on average, while external alignment favors K10 in every fold. This disagreement is informative because the criteria evaluate different consequences of the same label-blind acoustic fits. Notice what is observed and what is supplied by the model.
