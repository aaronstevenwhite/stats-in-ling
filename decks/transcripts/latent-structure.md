# Finding unobserved groups in linguistic data

This transcript is generated from the speaker notes in the slide source. Slide identifiers, titles, note-page provenance, and order are identical.

## Slide 1: Finding unobserved groups in linguistic data

Source note: `latent-structure/index.qmd`

Welcome to Finding unobserved groups in linguistic data. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.

## Slide 2: Finding unobserved groups

Source note: `latent-structure/index.qmd`

Now we turn to Finding unobserved groups.

## Slide 3: Peterson-Barney: the empirical object

Source note: `latent-structure/index.qmd`

The data source is Peterson and Barney (1952). It provides 1,520 F1-F2 vowel-token vectors from 76 speakers.

## Slide 4: Finding unobserved groups

Source note: `latent-structure/index.qmd`

Peterson and Barney's vowel-production study recorded repeated /hVd/ productions and their acoustic measurements. This unit uses the table distributed as `phonTools::pb52` in package version 0.2.2.2. The package is BSD-licensed, though those package terms do not separately establish redistribution terms for the historical table. One row is one recorded vowel token; rows repeat speakers, elicitation words, and intended vowels.

## Slide 5: Finding unobserved groups

Source note: `latent-structure/index.qmd`

The fitting representation contains F1 and F2 but not the elicitation word or intended-vowel label. The linguistic question is whether recurring regions appear in this acoustic representation and, if so, how they relate to categories supplied by the experimental design.

## Slide 6: Finding unobserved groups

Source note: `latent-structure/index.qmd`

A group is unobserved only in the sense that no group label is supplied to the fitting procedure. A fitted cluster or mixture component is not automatically a phoneme, a vowel category, or a speaker type. That interpretation requires a separate comparison with linguistic metadata or held-out measurements.

## Slide 7: Hard clustering

Source note: `latent-structure/index.qmd`

The analysis begins by representing each object as a row of measurements. Distance and scaling then determine which token pairs count as similar. Because F1 and F2 have different empirical spreads, the transformation affects the geometry supplied to the clustering algorithm.

## Slide 8: Hard clustering

Source note: `latent-structure/index.qmd`

K-means assigns each token to one cluster and represents each cluster by a centroid. The assignment and centroid updates minimize within-cluster loss. Silhouette widths compare each token's distance to its assigned cluster with its distance to the nearest alternative. Validation without outcome labels then asks how centroids estimated from other speakers reconstruct a complete unseen-speaker panel.

## Slide 9: Finite mixture models

Source note: `latent-structure/index.qmd`

A **finite mixture model** represents a distribution as a weighted combination of component distributions. A Gaussian mixture uses Gaussian components for the acoustic measurements. Posterior membership probabilities quantify how much each component contributes to the density at an observed token, and expectation--maximization alternates between updating these responsibilities and the component parameters.

## Slide 10: Finite mixture models

Source note: `latent-structure/index.qmd`

Choosing a mixture with BIC compares fitted likelihoods after accounting for parameter count. BIC still treats token rows as likelihood contributions, so the repeated-speaker structure remains a limitation rather than disappearing into the criterion. Held-out mixture validation then evaluates fitted density for speakers absent during fitting and uses intended vowels only for a separate post-fit alignment check.

## Slide 11: Validation and sequence

Source note: `latent-structure/index.qmd`

This distinction between statistical components and linguistic categories fixes the interpretation throughout the sequence. The pages thus specify (i) the represented object and geometry, (ii) the hard-clustering objective and its held-out target, and (iii) the probabilistic mixture objective and its held-out target. The probability calculations rely on random variables and distributions, while both validation analyses reuse the separation between training and test data.

## Slide 12: Representing objects for clustering

Source note: `latent-structure/representing-objects.qmd`

Our next step is Representing objects for clustering.

## Slide 13: Representing objects for clustering

Source note: `latent-structure/representing-objects.qmd`

Peterson and Barney recorded repeated productions of ten /hVd/ words from adult and child speakers, then measured the fundamental frequency and the first three formants in a steady-state vowel section. Their primary report describes the production and separate listener experiments (Peterson and Barney 1952); the course uses the production table distributed as `phonTools::pb52`. The Praat documentation records the table's subsequent provenance.

## Slide 14: Representing objects for clustering

Source note: `latent-structure/representing-objects.qmd`

We use this table throughout the latent-structure notes. To prevent label leakage, intended-vowel labels may describe or evaluate a fitted representation, but they may not enter the feature matrix, initial values, component-count choice, or covariance-family choice.

## Slide 15: Loading and auditing the production table

Source note: `latent-structure/representing-objects.qmd`

The audited table has 1,520 token rows from 76 speakers. Each speaker contributes 20 rows: two repetitions of each of ten elicitation words. One row is thus a recorded word token, not a speaker, vowel category, or listener judgment. The package table contains no listener-level response, session, or seat variables from the paper’s perception experiment.

## Slide 16: Defining the represented objects

Source note: `latent-structure/representing-objects.qmd`

Let $N$ linguistic objects be measured on $p$ numerical properties. Their representation is

$$
\mathbf{X}
=
\begin{bmatrix}
\mathbf{x}_1^{\mathsf T}\\
\vdots\\
\mathbf{x}_N^{\mathsf T}
\end{bmatrix}
\in
\mathbb{R}^{N\times p}.
$$

## Slide 17: Defining the represented objects

Source note: `latent-structure/representing-objects.qmd`

Row $i$ is the vector

$$
\mathbf{x}_i
=
\begin{bmatrix}
x_{i1}&\cdots&x_{ip}
\end{bmatrix}.
$$

## Slide 18: Defining the represented objects

Source note: `latent-structure/representing-objects.qmd`

For the main analysis, row $i$ is one token and the two columns are F1 and F2. The sampling group remains the speaker because each person contributes 20 rows. Intended vowel, repetition, speaker type, and sex remain beside the matrix as external metadata.

## Slide 19: Defining the represented objects

Source note: `latent-structure/representing-objects.qmd`

This separation matters. Adding the integer `speaker` code to `X_raw` would treat record-number differences as measured acoustic distances. Adding `vowel` would instead make the intended answer part of the fitted representation. Neither operation answers the clustering question posed here.

## Slide 20: The observed acoustic geometry

Source note: `latent-structure/representing-objects.qmd`

This figure shows observed linguistic data for The observed acoustic geometry.

## Slide 21: The observed acoustic geometry

Source note: `latent-structure/representing-objects.qmd`

The plot shows all observed F1-F2 vectors and retains speaker type only as a panel label. The broad differences across panels suggest why raw hertz can partly organize tokens by anatomy-related speaker groups. But the plot does not supply an intended-vowel label to a fitting algorithm.

## Slide 22: Repeated rows change the target

Source note: `latent-structure/representing-objects.qmd`

Treating the 1,520 tokens as rows produces a grouping of productions. Averaging each speaker-vowel pair first would instead produce 760 speaker-vowel means and remove repetition-level variation. Averaging all 20 rows for each speaker would produce a grouping of speakers and remove the within-speaker vowel space almost entirely.

## Slide 23: Repeated rows change the target

Source note: `latent-structure/representing-objects.qmd`

These are different represented objects. The present analysis keeps token rows, preserves speaker identifiers for grouped validation, and describes the resulting clusters as regions of a production space.

## Slide 24: What the representation omits

Source note: `latent-structure/representing-objects.qmd`

Peterson and Barney also measured F0 and F3. F3 is especially relevant to the rhotic vowel, while a steady-state section cannot capture every dynamic property of an /hVd/ word. Restricting the matrix to F1 and F2 is thus a teaching choice, not a claim that the other measurements are irrelevant.

## Slide 25: What the representation omits

Source note: `latent-structure/representing-objects.qmd`

The paper used the measurements to examine experimental control, production variation, and the relation between acoustic patterns and listener classifications. It did not fit K-means or Gaussian mixtures. Our clustering is a descriptive reanalysis of the released production table.

## Slide 26: Checking the represented object

Source note: `latent-structure/representing-objects.qmd`

What does one row of `X_raw` represent?

## Slide 27: Checking the represented object

Source note: `latent-structure/representing-objects.qmd`

Why is `speaker` retained outside the feature matrix?

## Slide 28: Checking the represented object

Source note: `latent-structure/representing-objects.qmd`

Which variables are allowed to define similarity during fitting?

## Slide 29: Checking the represented object

Source note: `latent-structure/representing-objects.qmd`

How would averaging repetitions change the object represented by one row?

## Slide 30: Checking the represented object

Source note: `latent-structure/representing-objects.qmd`

Which part of the original listener experiment cannot be reconstructed from `pb52`?

## Slide 31: Checking the represented object

Source note: `latent-structure/representing-objects.qmd`

The matrix fixes which objects can be grouped and which measurements can make them similar. The next page compares geometries that use the same observed F1-F2 measurements but different scale definitions.

## Slide 32: Distance and scaling

Source note: `latent-structure/distance-and-scaling.qmd`

The next topic is Distance and scaling.

## Slide 33: Distance and scaling

Source note: `latent-structure/distance-and-scaling.qmd`

The Peterson-Barney table introduced on the preceding page gives F1 and F2 in hertz. A distance calculation must state how those two measurements become one comparison. Here we compare raw hertz, global standardization, and a speaker-relative representation before fixing the geometry used on later pages.

## Slide 34: Euclidean distance

Source note: `latent-structure/distance-and-scaling.qmd`

For two rows $\mathbf{x}_i$ and $\mathbf{x}_{i'}$ with $p$ features, **Euclidean distance** is

$$
d(\mathbf{x}_i,\mathbf{x}_{i'})
=
\sqrt{
\sum_{m=1}^{p}
(x_{im}-x_{i'm})^2
}.
$$

## Slide 35: Euclidean distance

Source note: `latent-structure/distance-and-scaling.qmd`

Subtracting within columns keeps the comparison feature-specific. Squaring makes positive and negative differences contribute in the same direction, and adding gives an axis-aligned geometry. The units of that geometry come from the feature transformation.

## Slide 36: Euclidean distance

Source note: `latent-structure/distance-and-scaling.qmd`

For the main representation, we standardize within speaker:

$$
z_{isj}
=
\frac{F_{isj}-\bar F_{sj}}{s_{sj}},
\qquad j\in\{1,2\},
$$

where $\bar F_{sj}$ and $s_{sj}$ are the mean and sample standard deviation across speaker $s$’s 20 tokens.

## Slide 37: Euclidean distance

Source note: `latent-structure/distance-and-scaling.qmd`

Distance becomes

$$
d(i,i')
=
\sqrt{
(z_{i1}-z_{i'1})^2+(z_{i2}-z_{i'2})^2
}.
$$

## Slide 38: Euclidean distance

Source note: `latent-structure/distance-and-scaling.qmd`

The transformation asks about relative position inside each observed speaker's vowel space. It is a teaching choice, not a preprocessing step used by Peterson and Barney.

## Slide 39: One observed token under three scales

Source note: `latent-structure/distance-and-scaling.qmd`

We select the observed token nearest the center of the speaker-relative representation, then find its nearest other token independently in each geometry. Intended vowel and speaker type enter only after the neighbors have been found.

## Slide 40: One observed token under three scales

Source note: `latent-structure/distance-and-scaling.qmd`

The reference row is 860. Its nearest observed neighbor changes from row 567 in raw hertz to row 300 after within-speaker standardization. Scaling has changed the neighborhood without changing a token’s measurements.

## Slide 41: Comparing the induced neighborhoods

Source note: `latent-structure/distance-and-scaling.qmd`

Under raw hertz, 70.5% of nearest neighbors share intended-vowel metadata and 63.3% share speaker type. In the within-speaker geometry, those rates are 89.7% and 41.2%, respectively. This post hoc comparison suggests that the speaker-relative geometry reduces a salient speaker-type organization while increasing alignment with the elicitation labels.

## Slide 42: Comparing the induced neighborhoods

Source note: `latent-structure/distance-and-scaling.qmd`

This figure shows observed linguistic data for Comparing the induced neighborhoods.

## Slide 43: The prediction information set

Source note: `latent-structure/distance-and-scaling.qmd`

Within-speaker standardization uses a speaker's complete unlabeled 20-token panel to determine that speaker's mean and standard deviation. The later speaker-blocked analyses thus target a new speaker whose complete calibration panel is available. No held-out token estimates a centroid or mixture component, but held-out measurements do determine their speaker's coordinate system.

## Slide 44: The prediction information set

Source note: `latent-structure/distance-and-scaling.qmd`

This distinction follows the prediction information set. The analysis does not predict one isolated token from a speaker with no calibration data. It also leaves dependence among the 20 transformed rows unmodeled.

## Slide 45: Scaling does not establish relevance

Source note: `latent-structure/distance-and-scaling.qmd`

Standardization gives each chosen coordinate a comparable observed spread. It does not make F1 and F2 equally reliable, independent, or exhaustive. A duplicated feature would receive double influence, while an omitted dynamic or F3 measurement receives none.

## Slide 46: Scaling does not establish relevance

Source note: `latent-structure/distance-and-scaling.qmd`

Thus, Euclidean distance remains conditional on the representation. A high-quality clustering under this geometry may summarize recurring F1-F2 regions, but it cannot establish that this geometry captures every linguistically relevant relation.

## Slide 47: Checking the geometry

Source note: `latent-structure/distance-and-scaling.qmd`

Which observed token is nearest to row 860 under each representation?

## Slide 48: Checking the geometry

Source note: `latent-structure/distance-and-scaling.qmd`

Why can the nearest neighbor change when the acoustic measurements do not?

## Slide 49: Checking the geometry

Source note: `latent-structure/distance-and-scaling.qmd`

What does one unit mean after within-speaker standardization?

## Slide 50: Checking the geometry

Source note: `latent-structure/distance-and-scaling.qmd`

Which information from a held-out speaker defines the validation coordinate system?

## Slide 51: Checking the geometry

Source note: `latent-structure/distance-and-scaling.qmd`

Why do post-fit intended-vowel matches not constitute label leakage?

## Slide 52: Checking the geometry

Source note: `latent-structure/distance-and-scaling.qmd`

Euclidean distance combines feature differences under a declared coordinate system. The next page uses the speaker-relative geometry to estimate centroids without using the intended-vowel labels.

## Slide 53: K-means clustering

Source note: `latent-structure/k-means.qmd`

The next topic is K-means clustering.

## Slide 54: K-means clustering

Source note: `latent-structure/k-means.qmd`

We now fit centroids to the speaker-relative Peterson-Barney representation. Intended-vowel labels do not enter the fit. We fix $K=10$ only to compare a ten-centroid acoustic partition with the experiment's ten elicitation categories after fitting; this is not a claim that K-means discovered the category count.

## Slide 55: Assignments, centroids, and loss

Source note: `latent-structure/k-means.qmd`

Let $\mathbf{x}_i\in\mathbb{R}^p$ be token $i$'s feature vector. For $K$ clusters, let

$$
z_i\in\{1,\ldots,K\}
$$

be its hard assignment and let

$$
\boldsymbol{\mu}_k\in\mathbb{R}^p
$$

be centroid $k$.

## Slide 56: Assignments, centroids, and loss

Source note: `latent-structure/k-means.qmd`

**K-means clustering** minimizes the within-cluster sum of squares

$$
W
=
\sum_{i=1}^{N}
\left\lVert
\mathbf{x}_i-\boldsymbol{\mu}_{z_i}
\right\rVert^2.
$$

## Slide 57: Assignments, centroids, and loss

Source note: `latent-structure/k-means.qmd`

For fixed centroids, the assignment step chooses

$$
z_i
=
\underset{k\in\{1,\ldots,K\}}{\operatorname{argmin}}
\left\lVert
\mathbf{x}_i-\boldsymbol{\mu}_k
\right\rVert^2.
$$

## Slide 58: Assignments, centroids, and loss

Source note: `latent-structure/k-means.qmd`

For fixed assignments, the update step replaces each centroid with the mean of its assigned rows:

$$
\boldsymbol{\mu}_k
=
\frac{1}{|C_k|}
\sum_{i\in C_k}\mathbf{x}_i.
$$

## Slide 59: Why the update is a mean

Source note: `latent-structure/k-means.qmd`

For one coordinate of one fixed cluster, the squared loss around a proposed center $\mu$ is

$$
Q(\mu)
=
\sum_{i=1}^{n}(x_i-\mu)^2.
$$

## Slide 60: Why the update is a mean

Source note: `latent-structure/k-means.qmd`

Its derivative is

$$
\frac{\mathrm{d}Q}{\mathrm{d}\mu}
=
-2\sum_{i=1}^{n}(x_i-\mu).
$$

## Slide 61: Why the update is a mean

Source note: `latent-structure/k-means.qmd`

Setting this derivative to zero gives

$$
\sum_{i=1}^{n}x_i-n\mu=0,
$$

and thus

$$
\mu
=
\frac{1}{n}\sum_{i=1}^{n}x_i.
$$

## Slide 62: Why the update is a mean

Source note: `latent-structure/k-means.qmd`

The coordinatewise mean thus minimizes squared distance for fixed assignments.

## Slide 63: Fitting ten centroids

Source note: `latent-structure/k-means.qmd`

The fitted loss is 142.223. The seed and 100 starts make this calculation reproducible and reduce sensitivity to one initialization. They do not establish a global optimum.

## Slide 64: Inspecting one observed assignment

Source note: `latent-structure/k-means.qmd`

The token used on the scaling page is row 860. We calculate its squared distance to every fitted centroid rather than inserting a constructed coordinate pair.

## Slide 65: Inspecting one observed assignment

Source note: `latent-structure/k-means.qmd`

The nearest fitted centroid is cluster 1, with squared distance 0.089. The integer label is arbitrary; its location and assigned observations define the fitted region.

## Slide 66: Verifying the update step on the fitted data

Source note: `latent-structure/k-means.qmd`

The fitted centroids equal the coordinatewise means of their assigned Peterson-Barney tokens to numerical tolerance. This observed check instantiates the update equation above.

## Slide 67: Verifying the update step on the fitted data

Source note: `latent-structure/k-means.qmd`

This figure shows observed linguistic data for Verifying the update step on the fitted data.

## Slide 68: Comparing with labels only after fitting

Source note: `latent-structure/k-means.qmd`

The adjusted Rand index (ARI) against the withheld intended-vowel metadata is 0.755. This number measures alignment between two partitions after the acoustic fit. It does not turn a centroid into a vowel, establish perceptual validity, or make the analysis supervised.

## Slide 69: Alternation and local solutions

Source note: `latent-structure/k-means.qmd`

Each assignment step cannot increase $W$ because every token chooses its nearest current centroid. Each update step cannot increase $W$ because each centroid becomes the mean of its assigned rows. The procedure thus decreases or preserves the objective until it reaches a local solution.

## Slide 70: Alternation and local solutions

Source note: `latent-structure/k-means.qmd`

K-means favors compact regions under squared Euclidean distance and assigns every token to exactly one region. Overlapping productions may not have that structure. A poor fit would diagnose this representation and objective, not the absence of organization in the production data.

## Slide 71: Checking the alternating updates

Source note: `latent-structure/k-means.qmd`

Which centroid receives the reference token, and what squared distance supports that assignment?

## Slide 72: Checking the alternating updates

Source note: `latent-structure/k-means.qmd`

How does `centroid_check` verify the update equation?

## Slide 73: Checking the alternating updates

Source note: `latent-structure/k-means.qmd`

Why can several starts improve the fitted loss without guaranteeing a global minimum?

## Slide 74: Checking the alternating updates

Source note: `latent-structure/k-means.qmd`

Why was $K=10$ fixed before the intended-vowel comparison?

## Slide 75: Checking the alternating updates

Source note: `latent-structure/k-means.qmd`

What does the post-fit ARI establish, and what does it leave open?

## Slide 76: Checking the alternating updates

Source note: `latent-structure/k-means.qmd`

K-means alternates nearest-centroid assignments with mean updates in the declared acoustic geometry. The next page shows how the fitted compactness changes when the number of centroids changes.

## Slide 77: Within-cluster loss

Source note: `latent-structure/within-cluster-loss.qmd`

Next, we take up Within-cluster loss.

## Slide 78: Within-cluster loss

Source note: `latent-structure/within-cluster-loss.qmd`

K-means requires a centroid count before fitting. We now trace the training loss across a declared grid using the same speaker-relative Peterson-Barney representation, seed policy, and multi-start fitting rule at every count.

## Slide 79: Loss at a declared centroid count

Source note: `latent-structure/within-cluster-loss.qmd`

For the K-means fit with $K$ centroids, write

$$
W_K
=
\sum_{i=1}^{N}
\left\lVert
\mathbf{x}_i-\boldsymbol{\mu}_{z_i,K}
\right\rVert^2.
$$

## Slide 80: Loss at a declared centroid count

Source note: `latent-structure/within-cluster-loss.qmd`

The subscript records that both assignments and centroids were estimated under candidate count $K$. The reduction obtained by adding centroid $K$ is

$$
\Delta_K
=
W_{K-1}-W_K,
\qquad K\geq2.
$$

## Slide 81: Loss at a declared centroid count

Source note: `latent-structure/within-cluster-loss.qmd`

A larger $\Delta_K$ means that the additional centroid removes more squared reconstruction error from the fitted rows.

## Slide 82: Why the optimal curve cannot rise

Source note: `latent-structure/within-cluster-loss.qmd`

A model with $K+1$ centroids can reproduce a $K$-centroid solution by duplicating one existing center and retaining the assignments. Since the larger model can do at least this well,

$$
W_{K+1}\leq W_K.
$$

## Slide 83: Why the optimal curve cannot rise

Source note: `latent-structure/within-cluster-loss.qmd`

Thus, the globally minimized training loss reaches its smallest value at the largest permitted $K$. A computed curve can rise after a poor local solution; multiple starts reduce this algorithmic failure without changing the mathematical relation.

## Slide 84: Fitting the observed loss curve

Source note: `latent-structure/within-cluster-loss.qmd`

The observed curve falls from 2888 at the smallest candidate to 96.792 at the largest. The ten-centroid fit has loss 142.223, and adding the eleventh centroid reduces the loss by 11.08.

## Slide 85: Fitting the observed loss curve

Source note: `latent-structure/within-cluster-loss.qmd`

This figure shows observed linguistic data for Fitting the observed loss curve.

## Slide 86: The elbow is a visual judgment

Source note: `latent-structure/within-cluster-loss.qmd`

An **elbow plot** displays $W_K$ against $K$. The **elbow method** looks for a count after which additional centroids produce much smaller reductions. The Peterson-Barney curve supplies real reductions, but it does not supply a universal cutoff for what counts as small.

## Slide 87: The elbow is a visual judgment

Source note: `latent-structure/within-cluster-loss.qmd`

The curve drops quickly at low counts and then flattens. More than one bend remains visually defensible, however. Reporting the complete curve keeps this judgment visible.

## Slide 88: Loss remains tied to the representation

Source note: `latent-structure/within-cluster-loss.qmd`

Within-cluster loss depends on feature units, columns, and row count. Replacing speaker-relative scores with raw hertz would change the vertical scale and could change the fitted partitions. Duplicating F2 would give it twice the influence.

## Slide 89: Loss remains tied to the representation

Source note: `latent-structure/within-cluster-loss.qmd`

Training compactness also does not establish a vowel inventory. Every additional centroid increases representational capacity on the same observations used to estimate it. The monotone loss curve cannot decide that one count is linguistically correct merely by reaching a minimum.

## Slide 90: Checking the loss curve

Source note: `latent-structure/within-cluster-loss.qmd`

Why must an optimal $W_{K+1}$ be no greater than $W_K$?

## Slide 91: Checking the loss curve

Source note: `latent-structure/within-cluster-loss.qmd`

Which additions produce the largest empirical reductions in this table?

## Slide 92: Checking the loss curve

Source note: `latent-structure/within-cluster-loss.qmd`

Why can two readers locate different elbows on the same curve?

## Slide 93: Checking the loss curve

Source note: `latent-structure/within-cluster-loss.qmd`

Why is the loss scale not comparable with a raw-hertz analysis?

## Slide 94: Checking the loss curve

Source note: `latent-structure/within-cluster-loss.qmd`

What linguistic claim is not licensed by the smallest displayed loss?

## Slide 95: Checking the loss curve

Source note: `latent-structure/within-cluster-loss.qmd`

The loss curve shows how training compactness changes with capacity. The next page asks whether each observed token is closer on average to its assigned cluster than to its nearest alternative cluster.

## Slide 96: Silhouette widths

Source note: `latent-structure/silhouette-scores.qmd`

Now we turn to Silhouette widths.

## Slide 97: Silhouette widths

Source note: `latent-structure/silhouette-scores.qmd`

The within-cluster loss measures distance from each token to its assigned centroid. It does not ask whether the token is nearly as close to another fitted group. A **silhouette width**90125-7) compares within-cluster cohesion with the nearest alternative.

## Slide 98: Cohesion and the nearest alternative

Source note: `latent-structure/silhouette-scores.qmd`

Let $C(i)$ be the cluster containing token $i$. Its average distance to the other rows in that cluster is

$$
a(i)
=
\frac{1}{|C(i)|-1}
\sum_{j\in C(i),\ j\neq i}
d(\mathbf{x}_i,\mathbf{x}_j).
$$

## Slide 99: Cohesion and the nearest alternative

Source note: `latent-structure/silhouette-scores.qmd`

For another cluster $C$, define

$$
d(i,C)
=
\frac{1}{|C|}
\sum_{j\in C}
d(\mathbf{x}_i,\mathbf{x}_j).
$$

## Slide 100: Cohesion and the nearest alternative

Source note: `latent-structure/silhouette-scores.qmd`

The nearest alternative-cluster distance is

$$
b(i)
=
\min_{C\neq C(i)}d(i,C).
$$

## Slide 101: Cohesion and the nearest alternative

Source note: `latent-structure/silhouette-scores.qmd`

The silhouette width is

$$
s(i)
=
\frac{b(i)-a(i)}{\max\{a(i),b(i)\}}.
$$

## Slide 102: Cohesion and the nearest alternative

Source note: `latent-structure/silhouette-scores.qmd`

If $b(i)\geq a(i)$, then

$$
s(i)=1-\frac{a(i)}{b(i)},
$$

which lies between zero and one.

## Slide 103: Cohesion and the nearest alternative

Source note: `latent-structure/silhouette-scores.qmd`

If $a(i)>b(i)$, then

$$
s(i)=\frac{b(i)}{a(i)}-1,
$$

which lies between minus one and zero.

## Slide 104: Cohesion and the nearest alternative

Source note: `latent-structure/silhouette-scores.qmd`

Negative values indicate that another fitted cluster is closer on average under the declared geometry.

## Slide 105: Reconstructing one observed silhouette

Source note: `latent-structure/silhouette-scores.qmd`

The most negative token in the ten-centroid fit supplies a worked calculation from the production table.

## Slide 106: Reconstructing one observed silhouette

Source note: `latent-structure/silhouette-scores.qmd`

For row 669, $a(i)$ is 0.59 and $b(i)$ is 0.573. Substituting those observed distances gives

$$
s(i)
=
\frac{0.573-0.590}
{\max\{0.590,0.573\}}
=
-0.028.
$$

## Slide 107: Reconstructing one observed silhouette

Source note: `latent-structure/silhouette-scores.qmd`

The negative value says that this acoustic vector lies slightly closer on average to the nearest competing cluster than to its assigned cluster. It does not say that the speaker or token has an ambiguous linguistic identity.

## Slide 108: Comparing candidate counts

Source note: `latent-structure/silhouette-scores.qmd`

This figure shows observed linguistic data for Comparing candidate counts.

## Slide 109: Comparing candidate counts

Source note: `latent-structure/silhouette-scores.qmd`

The mean silhouette is largest at $K=4$, where it equals 0.506. The ten-centroid partition has mean silhouette 0.496, while its post-fit ARI against intended vowels is 0.755, the largest in this fitted grid at $K=10$.

## Slide 110: Comparing candidate counts

Source note: `latent-structure/silhouette-scores.qmd`

This disagreement is the empirical lesson. Silhouette rewards cohesion and separation under the fitted geometry; intended-vowel ARI evaluates agreement with external experimental metadata. The two criteria answer different questions.

## Slide 111: Limits of the score

Source note: `latent-structure/silhouette-scores.qmd`

Silhouettes inherit the distance, scaling, and fitted partition. Compact groups separated by gaps tend to score well, while systematically overlapping categories may not. A singleton cluster conventionally receives silhouette zero because within-cluster cohesion cannot be estimated from a pair.

## Slide 112: Limits of the score

Source note: `latent-structure/silhouette-scores.qmd`

Thus, the candidate with the largest mean silhouette is best only among the fitted partitions under this score. It does not establish the number of phonological categories.

## Slide 113: Checking cohesion and separation

Source note: `latent-structure/silhouette-scores.qmd`

Which observed averages produce the reference token's negative silhouette?

## Slide 114: Checking cohesion and separation

Source note: `latent-structure/silhouette-scores.qmd`

Why does $b(i)$ use the nearest alternative cluster?

## Slide 115: Checking cohesion and separation

Source note: `latent-structure/silhouette-scores.qmd`

Which $K$ maximizes the intrinsic silhouette criterion?

## Slide 116: Checking cohesion and separation

Source note: `latent-structure/silhouette-scores.qmd`

Which $K$ maximizes alignment with withheld intended-vowel metadata?

## Slide 117: Checking cohesion and separation

Source note: `latent-structure/silhouette-scores.qmd`

Why can both answers be correct for their respective targets?

## Slide 118: Checking cohesion and separation

Source note: `latent-structure/silhouette-scores.qmd`

A silhouette diagnoses a fitted partition under the same geometry used to form it. The speaker-blocked validation page instead asks how centroids estimated from other speakers reconstruct a complete unseen speaker panel.

## Slide 119: Validation without outcome labels

Source note: `latent-structure/unsupervised-validation.qmd`

Now we turn to Validation without outcome labels.

## Slide 120: Validation without outcome labels

Source note: `latent-structure/unsupervised-validation.qmd`

A clustering has no observed cluster label that the fitting procedure is meant to predict. For K-means, we can instead ask whether centroids estimated from training speakers place tokens from held-out speakers near a learned center. The validation target here is a new speaker's complete 20-token calibration panel, not one isolated token.

## Slide 121: Reconstructing the rows and speaker folds

Source note: `latent-structure/unsupervised-validation.qmd`

The folds are balanced within the paper's men, women, and children speaker groups. All rows from one speaker stay in one fold.

## Slide 122: Predicting a held-out token

Source note: `latent-structure/unsupervised-validation.qmd`

Let

$$
\widehat{\boldsymbol{\mu}}^{\mathrm{train}}_1,
\ldots,
\widehat{\boldsymbol{\mu}}^{\mathrm{train}}_K
$$

be centroids estimated without the held-out speaker.

## Slide 123: Predicting a held-out token

Source note: `latent-structure/unsupervised-validation.qmd`

Token $i$ receives the nearest fixed center:

$$
\widehat z_i
=
\underset{k\in\{1,\ldots,K\}}{\operatorname{argmin}}
\left\lVert
\mathbf{x}_i-
\widehat{\boldsymbol{\mu}}^{\mathrm{train}}_k
\right\rVert^2.
$$

## Slide 124: Predicting a held-out token

Source note: `latent-structure/unsupervised-validation.qmd`

Its squared reconstruction loss is

$$
L_i
=
\min_k
\left\lVert
\mathbf{x}_i-
\widehat{\boldsymbol{\mu}}^{\mathrm{train}}_k
\right\rVert^2.
$$

## Slide 125: Predicting a held-out token

Source note: `latent-structure/unsupervised-validation.qmd`

The held-out row does not update a centroid before it is scored.

## Slide 126: Keeping the new unit new

Source note: `latent-structure/unsupervised-validation.qmd`

The relevant separation rule comes from grouped cross-validation: a test speaker cannot contribute another token to training. The following helper computes each held-out token's nearest training centroid.

## Slide 127: Keeping the new unit new

Source note: `latent-structure/unsupervised-validation.qmd`

Each speaker contributes one mean loss at each $K$, so speakers receive equal weight in the displayed uncertainty summary.

## Slide 128: Keeping the new unit new

Source note: `latent-structure/unsupervised-validation.qmd`

This figure shows observed linguistic data for Keeping the new unit new.

## Slide 129: Keeping the new unit new

Source note: `latent-structure/unsupervised-validation.qmd`

Held-out mean loss is 0.096 for ten centroids and 0.067 for fifteen. The decline shows that more centers represent the complete held-out panels more compactly under this loss.

## Slide 130: Why reconstruction loss does not select a category count

Source note: `latent-structure/unsupervised-validation.qmd`

A codebook with $K+1$ centers can reproduce a $K$-center codebook by duplicating one center. Its population reconstruction loss can thus decrease or remain constant as capacity increases. Finite training samples and local optimization may make a validation curve wiggle, but the target still rewards added representational capacity.

## Slide 131: Why reconstruction loss does not select a category count

Source note: `latent-structure/unsupervised-validation.qmd`

Held-out loss can compare how efficiently declared codebook sizes represent new panels, or it can be paired with a separately declared complexity budget. It does not estimate a phonological inventory by itself.

## Slide 132: The calibration-panel target

Source note: `latent-structure/unsupervised-validation.qmd`

The within-speaker scores were computed from each speaker's complete unlabeled panel before the split. Thus, held-out speakers influence their own normalization but do not influence the fitted centroids. This prediction information set may be appropriate when a complete acoustic calibration panel is available. It is unavailable for a first isolated token.

## Slide 133: The calibration-panel target

Source note: `latent-structure/unsupervised-validation.qmd`

This use of test-panel measurements is deliberate rather than hidden preprocessing leakage. The claim must name the adapted target.

## Slide 134: Checking the held-out target

Source note: `latent-structure/unsupervised-validation.qmd`

Why do all rows from a speaker move together?

## Slide 135: Checking the held-out target

Source note: `latent-structure/unsupervised-validation.qmd`

Which fitted objects exclude the held-out speaker entirely?

## Slide 136: Checking the held-out target

Source note: `latent-structure/unsupervised-validation.qmd`

What information from the held-out speaker is used for normalization?

## Slide 137: Checking the held-out target

Source note: `latent-structure/unsupervised-validation.qmd`

Why does lower held-out reconstruction loss favor larger codebooks?

## Slide 138: Checking the held-out target

Source note: `latent-structure/unsupervised-validation.qmd`

What new-speaker claim does this design not support?

## Slide 139: Checking the held-out target

Source note: `latent-structure/unsupervised-validation.qmd`

Speaker-blocked reconstruction loss evaluates transfer of a centroid representation to complete unseen-speaker panels. The next page replaces hard nearest-centroid geometry with a probability model that retains component spread and overlap.

## Slide 140: Gaussian mixtures

Source note: `latent-structure/gaussian-mixtures.qmd`

Our next step is Gaussian mixtures.

## Slide 141: Gaussian mixtures

Source note: `latent-structure/gaussian-mixtures.qmd`

The Peterson-Barney production space contains overlapping F1-F2 regions. K-means represents each region by one point and assigns every token to exactly one centroid. A **Gaussian mixture model (GMM)** instead represents regions by weighted probability distributions, each with an estimated location and spread.

## Slide 142: One Gaussian component

Source note: `latent-structure/gaussian-mixtures.qmd`

Let $\mathbf{x}_i\in\mathbb{R}^p$ be token $i$'s measurements. Component $k$ has mean

$$
\boldsymbol{\mu}_k\in\mathbb{R}^p
$$

and covariance

$$
\boldsymbol{\Sigma}_k\in\mathbb{R}^{p\times p}.
$$

## Slide 143: One Gaussian component

Source note: `latent-structure/gaussian-mixtures.qmd`

Its density is

$$
\mathcal{N}
(\mathbf{x}_i;\boldsymbol{\mu}_k,\boldsymbol{\Sigma}_k)
=
\frac{
\exp\left[
-\frac{1}{2}
(\mathbf{x}_i-\boldsymbol{\mu}_k)^{\mathsf T}
\boldsymbol{\Sigma}_k^{-1}
(\mathbf{x}_i-\boldsymbol{\mu}_k)
\right]
}{
(2\pi)^{p/2}|\boldsymbol{\Sigma}_k|^{1/2}
}.
$$

## Slide 144: One Gaussian component

Source note: `latent-structure/gaussian-mixtures.qmd`

For F1 and F2,

$$
\boldsymbol{\Sigma}_k
=
\begin{bmatrix}
\sigma^2_{F1,k}&\sigma_{F1,F2,k}\\
\sigma_{F1,F2,k}&\sigma^2_{F2,k}
\end{bmatrix}.
$$

## Slide 145: One Gaussian component

Source note: `latent-structure/gaussian-mixtures.qmd`

The mean locates the component, while the covariance controls the scale and orientation of its equal-density ellipses.

## Slide 146: Combining components

Source note: `latent-structure/gaussian-mixtures.qmd`

Component $k$ receives weight

$$
\pi_k\geq0,
$$

with

$$
\sum_{k=1}^{K}\pi_k=1.
$$

## Slide 147: Combining components

Source note: `latent-structure/gaussian-mixtures.qmd`

The mixture density is

$$
f(\mathbf{x}_i)
=
\sum_{k=1}^{K}
\pi_k
\mathcal{N}
(\mathbf{x}_i;\boldsymbol{\mu}_k,\boldsymbol{\Sigma}_k).
$$

## Slide 148: Combining components

Source note: `latent-structure/gaussian-mixtures.qmd`

Every component contributes density to every token, even when one contribution is much larger than the others.

## Slide 149: Fitting the declared ten-component model

Source note: `latent-structure/gaussian-mixtures.qmd`

We fix a ten-component `EVI` covariance family before fitting. In `mclust`, `EVI` is diagonal with equal volume and varying shape. Thus, covariance ellipses are axis-aligned, share a determinant, and may allocate their spread differently between the two formant dimensions.

## Slide 150: Fitting the declared ten-component model

Source note: `latent-structure/gaussian-mixtures.qmd`

The fitted weights sum to 1, and every covariance matrix is positive definite. These are model checks, not linguistic interpretations of the component numbers.

## Slide 151: Plotting the fitted distributions with the data

Source note: `latent-structure/gaussian-mixtures.qmd`

This figure shows observed linguistic data for Plotting the fitted distributions with the data.

## Slide 152: Plotting the fitted distributions with the data

Source note: `latent-structure/gaussian-mixtures.qmd`

The ellipses show 90% contours under each fitted Gaussian component. They are model summaries laid over the raw transformed points; they are not boundaries inferred from intended-vowel labels.

## Slide 153: Post-fit alignment and uncertainty

Source note: `latent-structure/gaussian-mixtures.qmd`

The hard component assignments have ARI 0.801 against the withheld intended-vowel metadata, while mean classification uncertainty is 0.071. The former describes post-fit alignment. The latter summarizes how much posterior mass remains outside the most probable component.

## Slide 154: Components are not phonemes

Source note: `latent-structure/gaussian-mixtures.qmd`

A fitted Gaussian component is a distributional object under the chosen measurements, transformation, component count, and covariance restriction. Several components may cover productions from one elicitation category, and one component may cover overlapping productions from several categories.

## Slide 155: Components are not phonemes

Source note: `latent-structure/gaussian-mixtures.qmd`

The speaker-relative transformation may reduce anatomy-related differences, but it can also remove sociolinguistically relevant variation. Moreover, F3 and dynamic information remain outside the model. A potential worry is thus that a sharp component reflects an incomplete acoustic representation. Post-fit alignment cannot eliminate that limitation.

## Slide 156: Covariance collapse

Source note: `latent-structure/gaussian-mixtures.qmd`

An unrestricted Gaussian component can concentrate around very few rows while its covariance approaches singularity. The likelihood may then grow without representing a recurring acoustic region. Positive-definiteness checks, covariance restrictions, and fitting diagnostics must precede interpretation.

## Slide 157: Covariance collapse

Source note: `latent-structure/gaussian-mixtures.qmd`

The `EVI` restriction used here limits the fitted geometry. It does not establish that every acoustic region truly has diagonal covariance.

## Slide 158: Checking the observation model

Source note: `latent-structure/gaussian-mixtures.qmd`

What do the fitted means and covariance matrices represent?

## Slide 159: Checking the observation model

Source note: `latent-structure/gaussian-mixtures.qmd`

Why must the fitted weights sum to one?

## Slide 160: Checking the observation model

Source note: `latent-structure/gaussian-mixtures.qmd`

Which covariance properties does `EVI` hold equal or allow to vary?

## Slide 161: Checking the observation model

Source note: `latent-structure/gaussian-mixtures.qmd`

Why are the intended-vowel labels unnecessary for the displayed ellipses?

## Slide 162: Checking the observation model

Source note: `latent-structure/gaussian-mixtures.qmd`

What does the post-fit ARI establish, and why does it not identify components with phonemes?

## Slide 163: Checking the observation model

Source note: `latent-structure/gaussian-mixtures.qmd`

A Gaussian mixture assigns every token the sum of weighted component densities. The next page normalizes those observed contributions into conditional membership probabilities.

## Slide 164: Posterior membership

Source note: `latent-structure/posterior-membership.qmd`

Next, we take up Posterior membership.

## Slide 165: Posterior membership

Source note: `latent-structure/posterior-membership.qmd`

A Gaussian mixture assigns density to every observed acoustic vector. We now ask how the weighted component contributions divide for one Peterson-Barney token. The **posterior probability of component membership**, often expressed as **responsibilities**, applies Bayes' rule inside the fitted mixture.

## Slide 166: Loading and fitting the fixed mixture

Source note: `latent-structure/posterior-membership.qmd`

The intended-vowel column is retained in `vowels` but is not passed to `Mclust()`.

## Slide 167: Conditioning on an unobserved component

Source note: `latent-structure/posterior-membership.qmd`

Let

$$
Z_i\in\{1,\ldots,K\}
$$

be the unobserved component label.

## Slide 168: Conditioning on an unobserved component

Source note: `latent-structure/posterior-membership.qmd`

Before observing $\mathbf{x}_i$,

$$
\mathbb{P}(Z_i=k)=\pi_k.
$$

## Slide 169: Conditioning on an unobserved component

Source note: `latent-structure/posterior-membership.qmd`

Conditional on component $k$,

$$
f(\mathbf{x}_i\mid Z_i=k)
=
\mathcal{N}
(\mathbf{x}_i;\boldsymbol{\mu}_k,\boldsymbol{\Sigma}_k).
$$

## Slide 170: Conditioning on an unobserved component

Source note: `latent-structure/posterior-membership.qmd`

Bayes' rule gives

$$
\mathbb{P}(Z_i=k\mid\mathbf{x}_i)
=
\frac{
\mathbb{P}(Z_i=k)f(\mathbf{x}_i\mid Z_i=k)
}{
f(\mathbf{x}_i)
}.
$$

## Slide 171: Conditioning on an unobserved component

Source note: `latent-structure/posterior-membership.qmd`

Substituting the mixture density yields

$$
r_{ik}
=
\mathbb{P}(Z_i=k\mid\mathbf{x}_i)
=
\frac{
\pi_k\mathcal{N}
(\mathbf{x}_i;\boldsymbol{\mu}_k,\boldsymbol{\Sigma}_k)
}{
\sum_{j=1}^{K}
\pi_j\mathcal{N}
(\mathbf{x}_i;\boldsymbol{\mu}_j,\boldsymbol{\Sigma}_j)
}.
$$

## Slide 172: Conditioning on an unobserved component

Source note: `latent-structure/posterior-membership.qmd`

The denominator normalizes the weighted contributions, so

$$
\sum_{k=1}^{K}r_{ik}=1.
$$

## Slide 173: Calculating every responsibility directly

Source note: `latent-structure/posterior-membership.qmd`

The direct calculation agrees with `mclust`'s expectation step to numerical tolerance. We use the observed token with the greatest fitted uncertainty as the worked case.

## Slide 174: Calculating every responsibility directly

Source note: `latent-structure/posterior-membership.qmd`

For row 1493, the three largest responsibilities are 0.396, 0.379, 0.225. They sum to 1, while the remaining components receive negligible mass. The hard assignment keeps only component 8 and discards this overlap.

## Slide 175: Hard assignments and uncertainty

Source note: `latent-structure/posterior-membership.qmd`

A hard assignment is

$$
\widehat z_i
=
\underset{k}{\operatorname{argmax}}
r_{ik}.
$$

## Slide 176: Hard assignments and uncertainty

Source note: `latent-structure/posterior-membership.qmd`

Define fitted uncertainty as

$$
u_i
=
1-\max_k r_{ik}.
$$

## Slide 177: Hard assignments and uncertainty

Source note: `latent-structure/posterior-membership.qmd`

This quantity is zero when one component receives all posterior mass and grows as the mass is distributed across competitors. It remains conditional on the fitted mixture.

## Slide 178: Hard assignments and uncertainty

Source note: `latent-structure/posterior-membership.qmd`

Mean fitted uncertainty is 0.071, and 13.0% of observed tokens have uncertainty above the declared descriptive threshold.

## Slide 179: Inspecting intended-vowel metadata after fitting

Source note: `latent-structure/posterior-membership.qmd`

This figure shows observed linguistic data for Inspecting intended-vowel metadata after fitting.

## Slide 180: Inspecting intended-vowel metadata after fitting

Source note: `latent-structure/posterior-membership.qmd`

The x-axis uses intended-vowel metadata only after every responsibility has been calculated. Differences across labels describe where the fixed F1-F2 mixture is more or less decisive. They do not estimate listener accuracy.

## Slide 181: Component numbers and conditioning

Source note: `latent-structure/posterior-membership.qmd`

Exchanging all parameters for two components leaves the mixture density unchanged and merely exchanges responsibility columns. This **label switching** means that the integer attached to a component has no stable phonological meaning across separate fits.

## Slide 182: Component numbers and conditioning

Source note: `latent-structure/posterior-membership.qmd`

Moreover, a responsibility is not the probability that an intended label is correct. It is conditional on the observed F1-F2 vector, fixed component count, `EVI` covariance family, speaker-relative transformation, and estimated parameters. It does not integrate uncertainty about any of those choices.

## Slide 183: Checking the normalized contributions

Source note: `latent-structure/posterior-membership.qmd`

Which weighted contributions produce the three largest memberships for row 1493?

## Slide 184: Checking the normalized contributions

Source note: `latent-structure/posterior-membership.qmd`

Why does each responsibility row sum to one?

## Slide 185: Checking the normalized contributions

Source note: `latent-structure/posterior-membership.qmd`

What information does the hard component label discard for this token?

## Slide 186: Checking the normalized contributions

Source note: `latent-structure/posterior-membership.qmd`

Why can component numbers change across equivalent fits?

## Slide 187: Checking the normalized contributions

Source note: `latent-structure/posterior-membership.qmd`

Why is membership uncertainty not a measure of intended-vowel correctness?

## Slide 188: Checking the normalized contributions

Source note: `latent-structure/posterior-membership.qmd`

Posterior membership normalizes observed weighted component densities and retains fitted overlap. The next page uses these responsibilities as weights in iterative parameter updates.

## Slide 189: Expectation-maximization

Source note: `latent-structure/expectation-maximization.qmd`

Our next step is Expectation-maximization.

## Slide 190: Expectation-maximization

Source note: `latent-structure/expectation-maximization.qmd`

If component labels were observed, we could estimate a Gaussian from its assigned Peterson-Barney tokens. If component parameters were known, we could calculate each token's responsibilities. The **expectation-maximization (EM) algorithm** alternates those two calculations when neither side is known.

## Slide 191: Complete and observed data

Source note: `latent-structure/expectation-maximization.qmd`

Let the current parameters be

$$
\boldsymbol{\theta}^{(t)}
=
\left\{
\pi_k^{(t)},
\boldsymbol{\mu}_k^{(t)},
\boldsymbol{\Sigma}_k^{(t)}
\right\}_{k=1}^{K}.
$$

## Slide 192: Complete and observed data

Source note: `latent-structure/expectation-maximization.qmd`

If component label $Z_i$ were observed, define

$$
I_{ik}=\mathbf{1}[Z_i=k].
$$

## Slide 193: Complete and observed data

Source note: `latent-structure/expectation-maximization.qmd`

The complete-data log likelihood would be

$$
\ell_{\mathrm{complete}}(\boldsymbol{\theta})
=
\sum_{i=1}^{N}\sum_{k=1}^{K}
I_{ik}
\left[
\log\pi_k+
\log\mathcal{N}
(\mathbf{x}_i;\boldsymbol{\mu}_k,\boldsymbol{\Sigma}_k)
\right].
$$

## Slide 194: Complete and observed data

Source note: `latent-structure/expectation-maximization.qmd`

The indicator retains the term for the token's component and zeros the others. But $I_{ik}$ is unobserved.

## Slide 195: The expectation step

Source note: `latent-structure/expectation-maximization.qmd`

Given $\boldsymbol{\theta}^{(t)}$, calculate

$$
r_{ik}^{(t)}
=
\mathbb{P}(Z_i=k\mid\mathbf{x}_i,\boldsymbol{\theta}^{(t)})
=
\frac{
\pi_k^{(t)}
\mathcal{N}
(\mathbf{x}_i;\boldsymbol{\mu}_k^{(t)},\boldsymbol{\Sigma}_k^{(t)})
}{
\sum_{j=1}^{K}
\pi_j^{(t)}
\mathcal{N}
(\mathbf{x}_i;\boldsymbol{\mu}_j^{(t)},\boldsymbol{\Sigma}_j^{(t)})
}.
$$

## Slide 196: The expectation step

Source note: `latent-structure/expectation-maximization.qmd`

Since

$$
\mathbb{E}[I_{ik}\mid\mathbf{x}_i,\boldsymbol{\theta}^{(t)}]
=r_{ik}^{(t)},
$$

the EM auxiliary objective is

$$
Q(\boldsymbol{\theta}\mid\boldsymbol{\theta}^{(t)})
=
\sum_{i=1}^{N}\sum_{k=1}^{K}
r_{ik}^{(t)}
\left[
\log\pi_k+
\log\mathcal{N}
(\mathbf{x}_i;\boldsymbol{\mu}_k,\boldsymbol{\Sigma}_k)
\right].
$$

## Slide 197: The expectation step

Source note: `latent-structure/expectation-maximization.qmd`

The expectation step replaces each missing hard label with a probability vector under the current fit.

## Slide 198: The maximization step

Source note: `latent-structure/expectation-maximization.qmd`

The effective token count for component $k$ is

$$
N_k^{(t)}
=
\sum_{i=1}^{N}r_{ik}^{(t)}.
$$

## Slide 199: The maximization step

Source note: `latent-structure/expectation-maximization.qmd`

The updated weight and mean are

$$
\pi_k^{(t+1)}
=
\frac{N_k^{(t)}}{N}
$$

and

$$
\boldsymbol{\mu}_k^{(t+1)}
=
\frac{1}{N_k^{(t)}}
\sum_{i=1}^{N}r_{ik}^{(t)}\mathbf{x}_i.
$$

## Slide 200: The maximization step

Source note: `latent-structure/expectation-maximization.qmd`

For an unrestricted Gaussian component, the covariance update is

$$
\boldsymbol{\Sigma}_k^{(t+1)}
=
\frac{1}{N_k^{(t)}}
\sum_{i=1}^{N}
r_{ik}^{(t)}
\left(\mathbf{x}_i-\boldsymbol{\mu}_k^{(t+1)}\right)
\left(\mathbf{x}_i-\boldsymbol{\mu}_k^{(t+1)}\right)^{\mathsf T}.
$$

## Slide 201: The maximization step

Source note: `latent-structure/expectation-maximization.qmd`

The transparent implementation below uses diagonal, component-specific covariance matrices, the `VVI` family in `mclust` terminology. It is intentionally distinct from the central ten-component `EVI` fit: the page exposes each update rather than reproducing that restricted optimizer.

## Slide 202: Implementing EM on the observed vectors

Source note: `latent-structure/expectation-maximization.qmd`

All six observed-data traces are non-decreasing within numerical tolerance, but their final log likelihoods differ. The best three starts finish at -2874.576, while the weakest finishes at -2961.939. This is direct evidence of local-solution sensitivity in the PB52 fit.

## Slide 203: Verifying one component update

Source note: `latent-structure/expectation-maximization.qmd`

For component 8, the effective count is 176.279, and the responsibility-weighted mean is (1.394, -0.667). These values come from all observed token vectors, weighted by their fitted responsibilities.

## Slide 204: Likelihood monotonicity

Source note: `latent-structure/expectation-maximization.qmd`

The observed-data log likelihood is

$$
\ell(\boldsymbol{\theta})
=
\sum_{i=1}^{N}
\log\left[
\sum_{k=1}^{K}
\pi_k
\mathcal{N}
(\mathbf{x}_i;\boldsymbol{\mu}_k,\boldsymbol{\Sigma}_k)
\right].
$$

## Slide 205: Likelihood monotonicity

Source note: `latent-structure/expectation-maximization.qmd`

Exact EM updates do not decrease this quantity. That guarantee concerns progress from one starting point; it does not guarantee the largest attainable likelihood.

## Slide 206: Likelihood monotonicity

Source note: `latent-structure/expectation-maximization.qmd`

This figure shows observed linguistic data for Likelihood monotonicity.

## Slide 207: Local solutions and variance constraints

Source note: `latent-structure/expectation-maximization.qmd`

The variance floor prevents an estimated diagonal variance from approaching zero. It is a declared computational constraint, not an observed linguistic variance. Without such protection, a component may collapse around very few tokens and yield a misleadingly large likelihood.

## Slide 208: Local solutions and variance constraints

Source note: `latent-structure/expectation-maximization.qmd`

Several starts remain necessary because monotonic ascent can lead to distinct local optima. A fixed seed reproduces the collection of starts; it does not make the first solution globally best.

## Slide 209: Checking the alternating algorithm

Source note: `latent-structure/expectation-maximization.qmd`

Which quantities are calculated in the expectation step?

## Slide 210: Checking the alternating algorithm

Source note: `latent-structure/expectation-maximization.qmd`

How does the empirical effective count instantiate $N_k$?

## Slide 211: Checking the alternating algorithm

Source note: `latent-structure/expectation-maximization.qmd`

How are the displayed component means reconstructed from responsibilities?

## Slide 212: Checking the alternating algorithm

Source note: `latent-structure/expectation-maximization.qmd`

What does monotonic observed-data likelihood guarantee?

## Slide 213: Checking the alternating algorithm

Source note: `latent-structure/expectation-maximization.qmd`

What do the distinct final likelihoods show?

## Slide 214: Checking the alternating algorithm

Source note: `latent-structure/expectation-maximization.qmd`

Why is the variance floor computational rather than linguistic evidence?

## Slide 215: Checking the alternating algorithm

Source note: `latent-structure/expectation-maximization.qmd`

EM alternates conditional membership calculation with responsibility-weighted parameter updates. The next page compares declared component counts and covariance families while keeping the feature representation fixed.

## Slide 216: Choosing a mixture with BIC

Source note: `latent-structure/choosing-a-mixture.qmd`

Our next step is Choosing a mixture with BIC.

## Slide 217: Choosing a mixture with BIC

Source note: `latent-structure/choosing-a-mixture.qmd`

A Gaussian mixture requires both a component count and a covariance family. We use the **Bayesian information criterion (BIC)** to compare a declared grid on the speaker-relative Peterson-Barney representation, then distinguish the selected distributional model from the ten-component model used to teach membership and external alignment.

## Slide 218: Reconstructing the candidate data

Source note: `latent-structure/choosing-a-mixture.qmd`

The covariance families and component range are fixed before intended-vowel agreement is inspected. A candidate specification contains the component count $K$, covariance family $\mathcal C$, and remaining procedure $\mathcal R$:

$$
M=\langle K,\mathcal C,\mathcal R\rangle.
$$

## Slide 219: Reconstructing the candidate data

Source note: `latent-structure/choosing-a-mixture.qmd`

Changing the scaling or start policy during the comparison would change $\mathcal R$ and thus the candidate being ranked.

## Slide 220: BIC and its sign convention

Source note: `latent-structure/choosing-a-mixture.qmd`

For maximized likelihood $L$, $q$ estimated parameters, and $n$ likelihood contributions, define

$$
\operatorname{BIC}
=
-2\log L+q\log n.
$$

## Slide 221: BIC and its sign convention

Source note: `latent-structure/choosing-a-mixture.qmd`

Smaller values are preferred under this convention. `mclust` reports the negative quantity,

$$
\operatorname{BIC}_{\texttt{mclust}}
=
2\log L-q\log n,
$$

so its larger value is better.

## Slide 222: BIC and its sign convention

Source note: `latent-structure/choosing-a-mixture.qmd`

We convert the sign before plotting.

## Slide 223: Fitting the declared grid

Source note: `latent-structure/choosing-a-mixture.qmd`

The grid selects the 14-component EEI model with BIC 6070.892. The fixed ten-component `EVI` model has BIC 6090.392. These values are obtained from the fitted likelihoods, parameter counts, and observed token count shown in the table.

## Slide 224: Fitting the declared grid

Source note: `latent-structure/choosing-a-mixture.qmd`

This figure shows observed linguistic data for Fitting the declared grid.

## Slide 225: Distributional fit and label alignment differ

Source note: `latent-structure/choosing-a-mixture.qmd`

The BIC-selected model has post-fit ARI 0.736, while the ten-component `EVI` model has ARI 0.801. BIC prefers the first density specification; the external intended-vowel partition aligns more closely with the second hard classification.

## Slide 226: Distributional fit and label alignment differ

Source note: `latent-structure/choosing-a-mixture.qmd`

This K10/G14 distinction should remain explicit. A particular mixture can be useful for teaching category-aligned uncertainty without being the BIC-selected density model.

## Slide 227: Interpreting the sample size

Source note: `latent-structure/choosing-a-mixture.qmd`

The criterion uses $n=1520$ token contributions because that is the likelihood fitted by the software. It does not imply that the study sampled that many independent speakers. The rows come from 76 speakers with repeated productions.

## Slide 228: Interpreting the sample size

Source note: `latent-structure/choosing-a-mixture.qmd`

The usual BIC approximation presumes an appropriate independence structure. A token-level mixture that omits repeated-speaker dependence does not gain that structure from the penalty. Thus, the values can rank these declared software fits, while their asymptotic evidence interpretation remains limited.

## Slide 229: Candidate-set and fit limits

Source note: `latent-structure/choosing-a-mixture.qmd`

BIC compares only the supplied component counts, covariance families, representation, and fitting controls. It cannot repair omitted F3 information, within-speaker dependence, or an unsuitable Gaussian family. Mixture label permutations and weakly represented components also complicate the regularity assumptions behind simple information-criterion arguments.

## Slide 230: Candidate-set and fit limits

Source note: `latent-structure/choosing-a-mixture.qmd`

The selected component count need not equal a phonological inventory. A vowel's productions may occupy several Gaussian regions, while overlapping intended vowels may share one region.

## Slide 231: Checking the BIC comparison

Source note: `latent-structure/choosing-a-mixture.qmd`

How is each displayed BIC reconstructed from log likelihood and parameter count?

## Slide 232: Checking the BIC comparison

Source note: `latent-structure/choosing-a-mixture.qmd`

Why is the `mclust` sign reversed before plotting?

## Slide 233: Checking the BIC comparison

Source note: `latent-structure/choosing-a-mixture.qmd`

Which declared model minimizes conventional BIC?

## Slide 234: Checking the BIC comparison

Source note: `latent-structure/choosing-a-mixture.qmd`

Which fixed model aligns more closely with intended-vowel metadata?

## Slide 235: Checking the BIC comparison

Source note: `latent-structure/choosing-a-mixture.qmd`

Why does the token count not represent independent speakers?

## Slide 236: Checking the BIC comparison

Source note: `latent-structure/choosing-a-mixture.qmd`

What does the selected component count leave unresolved linguistically?

## Slide 237: Checking the BIC comparison

Source note: `latent-structure/choosing-a-mixture.qmd`

BIC ranks a declared candidate grid under a token-level likelihood and penalty. The next page compares the fixed K10 and G14 candidates by predictive density on complete held-out speakers.

## Slide 238: Validating a mixture on held-out speakers

Source note: `latent-structure/validating-a-mixture.qmd`

Now we turn to Validating a mixture on held-out speakers.

## Slide 239: Validating a mixture on held-out speakers

Source note: `latent-structure/validating-a-mixture.qmd`

BIC penalizes likelihood on the rows used for fitting. We now compare the fixed ten-component `EVI` model and the BIC-selected fourteen-component `EEI` model by predictive density on complete held-out speakers. This comparison retains the K10/G14 distinction and uses the same folds as the centroid validation.

## Slide 240: Reconstructing the data and speaker folds

Source note: `latent-structure/validating-a-mixture.qmd`

The folds exclude every one of a held-out speaker’s 20 rows from mixture estimation. Each held-out speaker supplies an unlabeled panel for within-speaker standardization. The target is thus an adapted complete panel, not a first isolated token.

## Slide 241: Held-out log loss

Source note: `latent-structure/validating-a-mixture.qmd`

For a mixture fit to training speakers, the log loss of token $i$ is

$$
L_i(M)
=
-\log p_M
(\mathbf{x}_i\mid D_{\mathrm{train}}).
$$

## Slide 242: Held-out log loss

Source note: `latent-structure/validating-a-mixture.qmd`

Smaller loss means that the fitted model assigns greater density to the held-out acoustic vector. For two candidates $A$ and $B$, the paired token difference is

$$
d_i=L_i(B)-L_i(A).
$$

## Slide 243: Held-out log loss

Source note: `latent-structure/validating-a-mixture.qmd`

A negative value favors candidate $B$ for that token. Because speakers are the held-out groups, we first average token losses within speaker and compare the resulting paired speaker means.

## Slide 244: Fitting and scoring both candidates

Source note: `latent-structure/validating-a-mixture.qmd`

Mean speaker log loss is 1.938 for K10 and 1.932 for G14. The paired mean difference, G14 minus K10, is -0.0066, and G14 has lower loss for 57.9% of speakers.

## Slide 245: Fitting and scoring both candidates

Source note: `latent-structure/validating-a-mixture.qmd`

This figure shows observed linguistic data for Fitting and scoring both candidates.

## Slide 246: Fitting and scoring both candidates

Source note: `latent-structure/validating-a-mixture.qmd`

The figure keeps the 76 paired speaker comparisons visible. Points left of zero favor G14 under predictive density; points right of zero favor K10.

## Slide 247: External alignment after prediction

Source note: `latent-structure/validating-a-mixture.qmd`

K10 has the larger post-fit ARI in all 5 folds. Thus, the model with slightly better mean held-out density aligns less closely with intended-vowel metadata. Predictive density and experimental-label alignment remain separate validation targets.

## Slide 248: Information-set and dependence limits

Source note: `latent-structure/validating-a-mixture.qmd`

The coordinate system includes each held-out speaker's unlabeled calibration panel, though no held-out token enters mixture estimation. This is the same explicit prediction information set used for centroid validation.

## Slide 249: Information-set and dependence limits

Source note: `latent-structure/validating-a-mixture.qmd`

The mixture likelihood still treats transformed token rows as conditionally independent and does not model their shared speaker normalization. Fold averages are computational summaries, not independent samples. Speaker-level paired values describe the variation relevant to the claim without pretending that repeated folds create new speakers.

## Slide 250: Checking the validation design

Source note: `latent-structure/validating-a-mixture.qmd`

Why must all rows from one speaker stay in one test fold?

## Slide 251: Checking the validation design

Source note: `latent-structure/validating-a-mixture.qmd`

What does a negative G14-minus-K10 difference mean?

## Slide 252: Checking the validation design

Source note: `latent-structure/validating-a-mixture.qmd`

Which candidate has the lower mean held-out log loss?

## Slide 253: Checking the validation design

Source note: `latent-structure/validating-a-mixture.qmd`

Which candidate has the higher external ARI in every fold?

## Slide 254: Checking the validation design

Source note: `latent-structure/validating-a-mixture.qmd`

Why can predictive density, BIC, and intended-vowel alignment favor different candidates?

## Slide 255: Checking the validation design

Source note: `latent-structure/validating-a-mixture.qmd`

Which first-token prediction is not evaluated here?

## Slide 256: Checking the validation design

Source note: `latent-structure/validating-a-mixture.qmd`

Speaker-blocked log loss slightly favors G14 on average, while external alignment favors K10 in every fold. This disagreement is informative because the criteria evaluate different consequences of the same label-blind acoustic fits.
