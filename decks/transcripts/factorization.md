# Factorizing linguistic data

This transcript is generated from the speaker notes in the slide source. Slide identifiers, titles, note-page provenance, and order are identical.

## Slide 1: Factorizing linguistic data

Source note: `factorization/index.qmd`

Welcome to Factorizing linguistic data. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.

## Slide 2: Factorization

Source note: `factorization/index.qmd`

The next topic is Factorization.

## Slide 3: PHOIBLE: the empirical object

Source note: `factorization/index.qmd`

The data source is PHOIBLE 2.0. It provides one selected phoneme inventory per Glottocode.

## Slide 4: Factorization

Source note: `factorization/index.qmd`

Moran and McCloy's PHOIBLE 2.0 release collects phonological inventory records contributed by many descriptive sources. The download and license page distributes the release as a CLDF StructureDataset under CC BY-SA 3.0. An inventory record generally describes a doculect, but multiple records may share a Glottocode and some source collections aggregate several varieties. Thus one row in the course matrix is an inventory record selected within a Glottocode, not an unqualified language.

## Slide 5: Factorization

Source note: `factorization/index.qmd`

The prepared memberships exclude tone entries and rows explicitly marked as marginal. A matrix cell equal to one means that a retained PHOIBLE value row links an inventory record to a segment. A zero means that no such row is listed under this preparation; it is not direct evidence that a language lacks the segment.

## Slide 6: Factorization

Source note: `factorization/index.qmd`

The first eight pages study a matrix-completion task: whether structure learned from training records helps reconstruct a small set of hidden database cells in a held-out record whose other cells remain visible. The target is database completion under a declared preparation rule, not recovery of a complete phonological system from no observations.

## Slide 7: Constructing and decomposing the matrix

Source note: `factorization/index.qmd`

Linguistic data matrices define the row, column, and cell units, reproduce the Glottocode-level row selection, and retain segment columns using training records only. Centering and scaling then compare two transformations of the empirical binary columns. The primary analysis centers without variance standardization because standardization would give relatively greater weight to rare listings.

## Slide 8: Constructing and decomposing the matrix

Source note: `factorization/index.qmd`

Rank-one structure fits the first singular triplet and places the observed centered cells beside their rank-one reconstruction. Singular value decomposition extends that fit to ordered orthogonal terms. Principal component analysis derives the covariance identity from the same decomposition and adds macroarea only after fitting for descriptive interpretation.

## Slide 9: Interpreting and evaluating components

Source note: `factorization/index.qmd`

Scores and loadings distinguish coordinates for inventory rows from directions over segment columns. A loading pattern may suggest a linguistic hypothesis, but the decomposition does not turn a component into a natural class, universal, or causal mechanism.

## Slide 10: Interpreting and evaluating components

Source note: `factorization/index.qmd`

Reconstruction hides listed and not-listed cells in each held-out record, estimates scores from the remaining cells, and returns predictions to the original cell scale. Choosing components selects rank on validation inventories with balanced reconstruction loss and reserves test inventories for one final comparison. Because families are not the split unit, the result does not establish transfer to unseen language families.

## Slide 11: From decomposition to supervised prediction

Source note: `factorization/index.qmd`

The final application changes both the dataset and the target. VALEX contains GPL-licensed, automatically acquired English verb subcategorization counts described by Korhonen, Krymolowski, and Briscoe (2006). The official MegaAcceptability archive is CC BY-SA 4.0; its internal README identifies the release as v1.2. It contains ordinal judgments of English clause-embedding verbs in experimentally controlled frames, and White and Rawlins (2020) analyze how corpus distributions relate to those profiles.

## Slide 12: From decomposition to supervised prediction

Source note: `factorization/index.qmd`

The VALEX--MegaAcceptability page predicts MegaAcceptability profiles from VALEX subcategorization-frame proportions and compares the direct proportions with a PCA-compressed representation for verbs absent during fitting. Participant normalization, response aggregation, predictor centering, PCA, and tuning all occur inside their training splits. The application asks whether this shallow compression helps the held-out-verb target. It does not treat automatically acquired counts as grammatical labels or test abstract linguistic representations in general.

## Slide 13: From decomposition to supervised prediction

Source note: `factorization/index.qmd`

The sequence thus moves from a declared empirical matrix, through its exact algebra, to two held-out targets on the original data scales. Begin with linguistic data matrices.

## Slide 14: Linguistic data matrices

Source note: `factorization/data-matrices.qmd`

The next topic is Linguistic data matrices.

## Slide 15: Linguistic data matrices

Source note: `factorization/data-matrices.qmd`

PHOIBLE 2.0 is a curated collection of phonological inventory records assembled from descriptive sources. Its documentation stresses that an inventory usually describes a doculect, that multiple inventories may share a Glottocode, and that some inherited inventories combine sources. We will thus call one row an **inventory record**, not a language.

## Slide 16: Linguistic data matrices

Source note: `factorization/data-matrices.qmd`

The course copy is pinned to PHOIBLE 2.0 and follows the release's download and citation guidance. It excludes tone entries and rows explicitly marked as marginal, then samples one inventory within each Glottocode. A cell equal to one means that a retained PHOIBLE value row links the inventory to the segment. A zero means **not listed under this preparation rule**. It does not establish that speakers never produce the corresponding phone.

## Slide 17: Defining the array and its indices

Source note: `factorization/data-matrices.qmd`

Let there be $n$ linguistic objects and $p$ measured variables. A data matrix is

$$
\mathbf X\in\mathbb R^{n\times p}.
$$

## Slide 18: Defining the array and its indices

Source note: `factorization/data-matrices.qmd`

Its entries are

$$
x_{ij}=\text{the value of variable }j\text{ for object }i.
$$

## Slide 19: Defining the array and its indices

Source note: `factorization/data-matrices.qmd`

The complete row for object $i$ is

$$
\mathbf x_i^{\mathsf T}
=
\begin{bmatrix}
x_{i1}&x_{i2}&\cdots&x_{ip} \quad\text{(symbolic indices)} % dqr-allow: symbolic-derivation
\end{bmatrix},
$$

and the complete column for variable $j$ is

$$
\mathbf x_{\cdot j}
=
\begin{bmatrix}
x_{1j}&x_{2j}&\cdots&x_{nj} \quad\text{(symbolic indices)} % dqr-allow: symbolic-derivation
\end{bmatrix}^{\mathsf T}.
$$

## Slide 20: Defining the array and its indices

Source note: `factorization/data-matrices.qmd`

A row asks how one inventory record is represented across segments. A column asks how one segment listing varies across inventory records. This is the earlier unit-of-analysis decision written in matrix form.

## Slide 21: Constructing the PHOIBLE matrix

Source note: `factorization/data-matrices.qmd`

the calculation reproduces the row sample, the macroarea-stratified split, and the training-only column filter. The random seeds identify reproducible procedural choices; they are not linguistic measurements.

## Slide 22: Constructing the PHOIBLE matrix

Source note: `factorization/data-matrices.qmd`

The resulting matrix has 2186 inventory records and 254 segment columns. Of its 555,244 cells, 11.9% are listed. This sparsity is a property of the prepared database matrix, not an estimate of how often phones occur in speech.

## Slide 23: Seeing rows and columns

Source note: `factorization/data-matrices.qmd`

The full matrix is too large to label. The following plot thus displays four training inventories from each classified macroarea and the twenty most common training segments. Every plotted cell is read directly from `X`.

## Slide 24: Seeing rows and columns

Source note: `factorization/data-matrices.qmd`

This figure shows observed linguistic data for Seeing rows and columns.

## Slide 25: Seeing rows and columns

Source note: `factorization/data-matrices.qmd`

The cell in a particular row and column can now be interpreted only by using both index maps. The first displayed row, for instance, can be recovered without copying its values into the notes.

## Slide 26: Information retained by the matrix

Source note: `factorization/data-matrices.qmd`

Changing a row from an inventory record to a Glottocode-level average would change the observational unit. Changing the columns would change which segment contrasts are available. Repeating a column would give the corresponding listing pattern extra numerical weight. Matrix methods cannot infer that an omitted distinction was theoretically intended, nor can they recover within-source detail removed before construction.

## Slide 27: Information retained by the matrix

Source note: `factorization/data-matrices.qmd`

Before factorization, record (i) the row unit, (ii) the row-selection rule, (iii) the column-retention rule, (iv) the cell coding, and (v) the collection to which those records belong. These choices fix the information available to every later operation.

## Slide 28: Checking the representation

Source note: `factorization/data-matrices.qmd`

What does $x_{ij}=1$ mean in this matrix?

## Slide 29: Checking the representation

Source note: `factorization/data-matrices.qmd`

Why is “not listed” safer than “absent” for $x_{ij}=0$?

## Slide 30: Checking the representation

Source note: `factorization/data-matrices.qmd`

Why is one sampled inventory record not necessarily one language?

## Slide 31: Checking the representation

Source note: `factorization/data-matrices.qmd`

Which part of the calculation prevents validation and test inventories from selecting columns?

## Slide 32: Checking the representation

Source note: `factorization/data-matrices.qmd`

What would change if the rows were individual PHOIBLE value records?

## Slide 33: Checking the representation

Source note: `factorization/data-matrices.qmd`

The next page changes the origin and possible unit of each segment column while keeping these row and column definitions fixed.

## Slide 34: Centering and scaling

Source note: `factorization/centering-and-scaling.qmd`

The next topic is Centering and scaling.

## Slide 35: Centering and scaling

Source note: `factorization/centering-and-scaling.qmd`

The PHOIBLE matrix represents inventory records in rows and retained segment listings in columns. Every column uses the same binary database-listing unit, but the columns differ in how often a segment is listed. Centering changes each column's origin. Standardization would additionally change its unit and, for binary data, its weight in the factorization.

## Slide 36: Centering changes the origin

Source note: `factorization/centering-and-scaling.qmd`

For column $j$, the training mean is

$$
\widehat\mu_j
=
\frac{1}{n_{\mathcal T}}
\sum_{i\in\mathcal T}x_{ij}.
$$

Because $x_{ij}$ is binary here, $\widehat\mu_j$ is the training proportion of inventory records that list segment $j$.

## Slide 37: Centering changes the origin

Source note: `factorization/centering-and-scaling.qmd`

The centered entry is

$$
z_{ij}=x_{ij}-\widehat\mu_j,
$$

and the complete centered training matrix is

$$
\mathbf Z_{\mathcal T}
=
\mathbf X_{\mathcal T}
-
\mathbf 1_{n_{\mathcal T}}\widehat{\boldsymbol\mu}^{\mathsf T}.
$$

## Slide 38: Centering changes the origin

Source note: `factorization/centering-and-scaling.qmd`

Every column of $\mathbf Z_{\mathcal T}$ has mean zero. Centering does not alter differences between inventory records. It changes the reference point from “not listed” to the observed training prevalence.

## Slide 39: Scaling changes the unit

Source note: `factorization/centering-and-scaling.qmd`

The sample standard deviation of column $j$ is

$$
s_j
=
\sqrt{
\frac{1}{n_{\mathcal T}-1}
\sum_{i\in\mathcal T}
(x_{ij}-\widehat\mu_j)^2
}.
$$

## Slide 40: Scaling changes the unit

Source note: `factorization/centering-and-scaling.qmd`

Collecting these values on the diagonal of $\mathbf S$, the standardized matrix is

$$
\widetilde{\mathbf Z}_{\mathcal T}
=
\mathbf Z_{\mathcal T}\mathbf S^{-1},
$$

or, cell by cell,

$$
\widetilde z_{ij}
=
\frac{x_{ij}-\widehat\mu_j}{s_j}.
$$

## Slide 41: Scaling changes the unit

Source note: `factorization/centering-and-scaling.qmd`

The transformation makes each nonconstant training column have mean zero and sample standard deviation one. Thus it gives every segment column the same variance before factorization.

## Slide 42: Computing the PHOIBLE coordinate systems

Source note: `factorization/centering-and-scaling.qmd`

This page independently reconstructs the row selection, split, and training-only column set introduced on the previous page.

## Slide 43: Computing the PHOIBLE coordinate systems

Source note: `factorization/centering-and-scaling.qmd`

The training set contains 1538 inventory records and 254 retained segments. No retained column is constant because the training-frequency rule removes segments with too few listings.

## Slide 44: The empirical weighting decision

Source note: `factorization/centering-and-scaling.qmd`

This figure shows observed linguistic data for The empirical weighting decision.

## Slide 45: The empirical weighting decision

Source note: `factorization/centering-and-scaling.qmd`

The least variable retained column would be multiplied by 8.82, whereas the most variable would be multiplied by 2.01. Standardization would thus assign relatively greater weight to rare segment listings. That weighting may be useful for some questions, but it is not neutral.

## Slide 46: The empirical weighting decision

Source note: `factorization/centering-and-scaling.qmd`

The primary PHOIBLE analysis centers without variance standardization. Every column already shares the same listing unit, and the analysis lets common patterns contribute their observed variance. This choice does not claim that common segments are linguistically more important. It defines the numerical target of this factorization.

## Slide 47: Applying a fitted transformation

Source note: `factorization/centering-and-scaling.qmd`

Means and scales used for evaluation must come from training data. For a new matrix $\mathbf X_{\mathrm{new}}$, the fixed transformation is

$$
\mathbf Z_{\mathrm{new}}
=
(\mathbf X_{\mathrm{new}}-
\mathbf 1\widehat{\boldsymbol\mu}^{\mathsf T})
\mathbf S^{-1}.
$$

## Slide 48: Applying a fitted transformation

Source note: `factorization/centering-and-scaling.qmd`

In R, that operation is: Recomputing the means or standard deviations on validation rows would let held-out records change their own coordinate system. That is leakage through preprocessing.

## Slide 49: Checking the coordinate system

Source note: `factorization/centering-and-scaling.qmd`

What does zero mean in a centered PHOIBLE column?

## Slide 50: Checking the coordinate system

Source note: `factorization/centering-and-scaling.qmd`

Why does centering preserve differences between rows?

## Slide 51: Checking the coordinate system

Source note: `factorization/centering-and-scaling.qmd`

Why does standardization weight rare binary columns more heavily?

## Slide 52: Checking the coordinate system

Source note: `factorization/centering-and-scaling.qmd`

Which data determine `training_mean` and `training_sd`?

## Slide 53: Checking the coordinate system

Source note: `factorization/centering-and-scaling.qmd`

Why does the primary analysis retain `Z` rather than `Z_standardized`?

## Slide 54: Checking the coordinate system

Source note: `factorization/centering-and-scaling.qmd`

The next page asks how much of this centered empirical matrix can be represented by a single shared row-by-column pattern.

## Slide 55: Rank-one structure

Source note: `factorization/rank-one-structure.qmd`

Our next step is Rank-one structure.

## Slide 56: Rank-one structure

Source note: `factorization/rank-one-structure.qmd`

The centered PHOIBLE inventory matrix contains many linked listing patterns. A rank-one approximation asks what can be represented by one row pattern and one column pattern before adding further components.

## Slide 57: Constructing one outer product

Source note: `factorization/rank-one-structure.qmd`

For a matrix with $n$ rows and $p$ columns, let

$$
\mathbf a
=
\begin{bmatrix}
a_1&\cdots&a_n
\end{bmatrix}^{\mathsf T}
\quad\text{and}\quad
\mathbf b
=
\begin{bmatrix}
b_1&\cdots&b_p
\end{bmatrix}^{\mathsf T}.
$$

## Slide 58: Constructing one outer product

Source note: `factorization/rank-one-structure.qmd`

Their outer product is

$$
\mathbf a\mathbf b^{\mathsf T}
=
\begin{bmatrix}
a_1b_1&\cdots&a_1b_p\\
\vdots&\ddots&\vdots\\
a_nb_1&\cdots&a_nb_p
\end{bmatrix}.
$$

## Slide 59: Constructing one outer product

Source note: `factorization/rank-one-structure.qmd`

Every cell obeys the same rule,

$$
x_{ij}=a_i b_j.
$$

## Slide 60: Constructing one outer product

Source note: `factorization/rank-one-structure.qmd`

Thus all columns are scalar multiples of $\mathbf a$, and all rows are scalar multiples of $\mathbf b^{\mathsf T}$. Any nonzero matrix with this form has rank one.

## Slide 61: Constructing one outer product

Source note: `factorization/rank-one-structure.qmd`

The individual vector scales are not identified by the product. For any nonzero constant $c$,

$$
(c\mathbf a)
\left(\frac{1}{c}\mathbf b\right)^{\mathsf T}
=
\mathbf a\mathbf b^{\mathsf T}.
$$

## Slide 62: Constructing one outer product

Source note: `factorization/rank-one-structure.qmd`

The singular value decomposition resolves this scale convention by using unit-length vectors and a separate nonnegative strength $d_1$:

$$
\widehat{\mathbf Z}^{(1)}
=
d_1\mathbf u_1\mathbf v_1^{\mathsf T},
\qquad
\mathbf u_1^{\mathsf T}\mathbf u_1
=
\mathbf v_1^{\mathsf T}\mathbf v_1
=1.
$$

## Slide 63: Fitting the empirical rank-one pattern

Source note: `factorization/rank-one-structure.qmd`

The following code reconstructs the PHOIBLE training matrix from the release object. Segment retention and centering depend only on training inventory records.

## Slide 64: Fitting the empirical rank-one pattern

Source note: `factorization/rank-one-structure.qmd`

The first fitted pattern accounts for 10.8% of the centered sum of squares. That empirical proportion is far from complete reconstruction, so the rank-one matrix is an approximation rather than an exact representation of the inventory data.

## Slide 65: Comparing observed and fitted cells

Source note: `factorization/rank-one-structure.qmd`

To make the cell pattern legible, the plot uses the same training inventory rows and segment columns selected for the matrix display on the first page. Both panels use one diverging scale, centered at zero.

## Slide 66: Comparing observed and fitted cells

Source note: `factorization/rank-one-structure.qmd`

This figure shows observed linguistic data for Comparing observed and fitted cells.

## Slide 67: Comparing observed and fitted cells

Source note: `factorization/rank-one-structure.qmd`

The fitted panel is smoother because all its cells share one outer-product rule. Positive and negative values indicate deviations above and below training prevalence. They are not probabilities.

## Slide 68: Compression and interpretation

Source note: `factorization/rank-one-structure.qmd`

An unrestricted $n\times p$ matrix contains $np$ cells. A rank-one representation stores $n+p+1$ fitted quantities before accounting for the unit-length and sign conventions. The reduction can be substantial, but it is useful only when the residual matrix

$$
\mathbf E^{(1)}
=
\mathbf Z-\widehat{\mathbf Z}^{(1)}
$$

is small enough for the target at hand.

## Slide 69: Compression and interpretation

Source note: `factorization/rank-one-structure.qmd`

The component is a numerical direction. PHOIBLE family and macroarea metadata do not enter this fit, and a high loading does not by itself identify a phonological natural class. Rank is an algebraic property before it is a linguistic hypothesis.

## Slide 70: Checking the common pattern

Source note: `factorization/rank-one-structure.qmd`

Why are all rows of an exact rank-one matrix proportional?

## Slide 71: Checking the common pattern

Source note: `factorization/rank-one-structure.qmd`

What roles do $d_1$, $\mathbf u_1$, and $\mathbf v_1$ play?

## Slide 72: Checking the common pattern

Source note: `factorization/rank-one-structure.qmd`

What does a positive centered cell mean in the PHOIBLE matrix?

## Slide 73: Checking the common pattern

Source note: `factorization/rank-one-structure.qmd`

Why is the fitted rank-one matrix not a probability matrix?

## Slide 74: Checking the common pattern

Source note: `factorization/rank-one-structure.qmd`

Why does an interpretable loading pattern not establish a natural class?

## Slide 75: Checking the common pattern

Source note: `factorization/rank-one-structure.qmd`

The next page adds orthogonal rank-one terms in order of their empirical strength.

## Slide 76: Singular value decomposition

Source note: `factorization/singular-value-decomposition.qmd`

The next topic is Singular value decomposition.

## Slide 77: Singular value decomposition

Source note: `factorization/singular-value-decomposition.qmd`

One rank-one pattern leaves substantial structure in the centered PHOIBLE matrix. The singular value decomposition (SVD) expresses that matrix as a sequence of mutually orthogonal rank-one terms, ordered by the centered sum of squares each term represents.

## Slide 78: Stating the reduced decomposition

Source note: `factorization/singular-value-decomposition.qmd`

For $\mathbf Z\in\mathbb R^{n\times p}$ with rank $r$, the reduced SVD is

$$
\mathbf Z
=
\mathbf U\mathbf D\mathbf V^{\mathsf T},
$$

where

$$
\mathbf U\in\mathbb R^{n\times r},
\qquad
\mathbf D\in\mathbb R^{r\times r},
\qquad
\mathbf V\in\mathbb R^{p\times r}.
$$

## Slide 79: Stating the reduced decomposition

Source note: `factorization/singular-value-decomposition.qmd`

The columns are orthonormal,

$$
\mathbf U^{\mathsf T}\mathbf U=\mathbf I_r,
\qquad
\mathbf V^{\mathsf T}\mathbf V=\mathbf I_r,
$$

and $\mathbf D$ is diagonal with ordered nonnegative entries,

$$
d_1\ge d_2\ge\cdots\ge d_r>0.
$$

## Slide 80: Stating the reduced decomposition

Source note: `factorization/singular-value-decomposition.qmd`

The vectors $\mathbf u_k$ locate the row objects along component $k$, the vectors $\mathbf v_k$ define the corresponding column directions, and $d_k$ gives the component's strength.

## Slide 81: From a matrix product to rank-one terms

Source note: `factorization/singular-value-decomposition.qmd`

Multiplying by the diagonal matrix scales matched columns of $\mathbf U$ and $\mathbf V$. Thus

$$
\mathbf Z
=
\sum_{k=1}^{r}
d_k\mathbf u_k\mathbf v_k^{\mathsf T}.
$$

## Slide 82: From a matrix product to rank-one terms

Source note: `factorization/singular-value-decomposition.qmd`

Every summand is rank one. The rank-$K$ approximation keeps the first $K$ terms:

$$
\widehat{\mathbf Z}^{(K)}
=
\sum_{k=1}^{K}
d_k\mathbf u_k\mathbf v_k^{\mathsf T}
=
\mathbf U_K\mathbf D_K\mathbf V_K^{\mathsf T}.
$$

## Slide 83: From a matrix product to rank-one terms

Source note: `factorization/singular-value-decomposition.qmd`

Among all rank-$K$ matrices, this approximation minimizes squared reconstruction error:

$$
\widehat{\mathbf Z}^{(K)}
=
\arg\min_{\operatorname{rank}(\mathbf A)\le K}
\|\mathbf Z-\mathbf A\|_F^2.
$$

## Slide 84: From a matrix product to rank-one terms

Source note: `factorization/singular-value-decomposition.qmd`

The Frobenius norm is the sum of squared cells,

$$
\|\mathbf A\|_F^2
=
\sum_i\sum_j a_{ij}^2.
$$

## Slide 85: From a matrix product to rank-one terms

Source note: `factorization/singular-value-decomposition.qmd`

Orthogonality yields

$$
\|\mathbf Z\|_F^2
=
\sum_{k=1}^{r}d_k^2,
\qquad
\|\mathbf Z-\widehat{\mathbf Z}^{(K)}\|_F^2
=
\sum_{k=K+1}^{r}d_k^2.
$$

## Slide 86: From a matrix product to rank-one terms

Source note: `factorization/singular-value-decomposition.qmd`

Thus the singular values order components by their contribution to the observed centered matrix.

## Slide 87: Computing the PHOIBLE decomposition

Source note: `factorization/singular-value-decomposition.qmd`

The empirical training matrix is 1538 by 254. The largest absolute departures from the two orthogonality identities are 5.11e-15 under this numerical fit.

## Slide 88: Reading the empirical spectrum

Source note: `factorization/singular-value-decomposition.qmd`

This figure shows observed linguistic data for Reading the empirical spectrum.

## Slide 89: Reading the empirical spectrum

Source note: `factorization/singular-value-decomposition.qmd`

The first component accounts for 10.8% of centered sum of squares. The first forty account for 74.0%. These are descriptive properties of the training matrix. They do not select a predictive rank and do not turn the components into linguistic categories.

## Slide 90: Sign and directional limits

Source note: `factorization/singular-value-decomposition.qmd`

For any component,

$$
d_k\mathbf u_k\mathbf v_k^{\mathsf T}
=
d_k(-\mathbf u_k)(-\mathbf v_k)^{\mathsf T}.
$$

## Slide 91: Sign and directional limits

Source note: `factorization/singular-value-decomposition.qmd`

Software may thus reverse both signs without changing the fitted matrix. Interpretation should concern contrasts among loadings or scores, not a privileged positive orientation.

## Slide 92: Sign and directional limits

Source note: `factorization/singular-value-decomposition.qmd`

If singular values are equal or nearly equal, rotations within the corresponding subspace can also leave the fit unchanged or nearly unchanged. The subspace may then be more stable than any one plotted axis. This is a stronger limitation than sign indeterminacy.

## Slide 93: Checking the ordered patterns

Source note: `factorization/singular-value-decomposition.qmd`

What are the dimensions of $\mathbf U$, $\mathbf D$, and $\mathbf V$?

## Slide 94: Checking the ordered patterns

Source note: `factorization/singular-value-decomposition.qmd`

Why is each term $d_k\mathbf u_k\mathbf v_k^{\mathsf T}$ rank one?

## Slide 95: Checking the ordered patterns

Source note: `factorization/singular-value-decomposition.qmd`

Why do squared singular values add to centered sum of squares?

## Slide 96: Checking the ordered patterns

Source note: `factorization/singular-value-decomposition.qmd`

What does the scree plot summarize, and what does it not select?

## Slide 97: Checking the ordered patterns

Source note: `factorization/singular-value-decomposition.qmd`

Why may an SVD component reverse sign across software runs?

## Slide 98: Checking the ordered patterns

Source note: `factorization/singular-value-decomposition.qmd`

The next page shows why the same right singular vectors are the principal-component directions of the centered PHOIBLE matrix.

## Slide 99: Principal component analysis

Source note: `factorization/principal-component-analysis.qmd`

Next, we take up Principal component analysis.

## Slide 100: Principal component analysis

Source note: `factorization/principal-component-analysis.qmd`

Principal component analysis (PCA) finds directions along which centered rows vary. For the PHOIBLE matrix, a row is an inventory record and a column is a segment listing. PCA thus summarizes covariance among database-segment columns. It does not use phonological labels, family names, or macroareas to fit the directions.

## Slide 101: Beginning with variation around column means

Source note: `factorization/principal-component-analysis.qmd`

Let

$$
\mathbf Z
=
\mathbf X
-
\mathbf 1_n\widehat{\boldsymbol\mu}^{\mathsf T}
$$

be the training-centered matrix.

## Slide 102: Beginning with variation around column means

Source note: `factorization/principal-component-analysis.qmd`

For a unit direction $\mathbf v$, the row scores are

$$
\mathbf t=\mathbf Z\mathbf v.
$$

## Slide 103: Beginning with variation around column means

Source note: `factorization/principal-component-analysis.qmd`

Their sample variance is

$$
\operatorname{Var}[\mathbf t]
=
\frac{1}{n-1}\mathbf t^{\mathsf T}\mathbf t
=
\mathbf v^{\mathsf T}
\left(\frac{\mathbf Z^{\mathsf T}\mathbf Z}{n-1}\right)
\mathbf v.
$$

## Slide 104: Beginning with variation around column means

Source note: `factorization/principal-component-analysis.qmd`

Define the sample covariance matrix

$$
\mathbf S
=
\frac{\mathbf Z^{\mathsf T}\mathbf Z}{n-1}.
$$

## Slide 105: Beginning with variation around column means

Source note: `factorization/principal-component-analysis.qmd`

The first principal-component direction solves

$$
\mathbf v_1
=
\arg\max_{\mathbf v^{\mathsf T}\mathbf v=1}
\mathbf v^{\mathsf T}\mathbf S\mathbf v.
$$

## Slide 106: Beginning with variation around column means

Source note: `factorization/principal-component-analysis.qmd`

Later directions maximize the same criterion while remaining orthogonal to the preceding directions.

## Slide 107: Connecting PCA to the SVD

Source note: `factorization/principal-component-analysis.qmd`

If

$$
\mathbf Z=\mathbf U\mathbf D\mathbf V^{\mathsf T},
$$

then

$$
\begin{aligned}
\mathbf S
&=\frac{1}{n-1}\mathbf Z^{\mathsf T}\mathbf Z\\
&=\frac{1}{n-1}
\mathbf V\mathbf D\mathbf U^{\mathsf T}
\mathbf U\mathbf D\mathbf V^{\mathsf T}\\
&=\mathbf V
\frac{\mathbf D^2}{n-1}
\mathbf V^{\mathsf T}.
\end{aligned}
$$

## Slide 108: Connecting PCA to the SVD

Source note: `factorization/principal-component-analysis.qmd`

Thus the PCA directions are the right singular vectors, and the covariance eigenvalues are

$$
\lambda_k=\frac{d_k^2}{n-1}.
$$

## Slide 109: Connecting PCA to the SVD

Source note: `factorization/principal-component-analysis.qmd`

The component scores satisfy

$$
\mathbf T
=
\mathbf Z\mathbf V
=
\mathbf U\mathbf D.
$$

## Slide 110: Connecting PCA to the SVD

Source note: `factorization/principal-component-analysis.qmd`

This is an identity between two computations, not a resemblance inferred from a plot.

## Slide 111: Verifying the identity on PHOIBLE

Source note: `factorization/principal-component-analysis.qmd`

The largest eigenvalue difference is 1.07e-14. The largest difference between the two score calculations is 4.22e-13. These discrepancies reflect floating-point arithmetic.

## Slide 112: Plotting scores, then adding metadata

Source note: `factorization/principal-component-analysis.qmd`

Macroarea did not enter the matrix, centering, SVD, or covariance calculation. We add it only after fitting to ask whether the unsupervised coordinates display broad descriptive differences.

## Slide 113: Plotting scores, then adding metadata

Source note: `factorization/principal-component-analysis.qmd`

This figure shows observed linguistic data for Plotting scores, then adding metadata.

## Slide 114: Plotting scores, then adding metadata

Source note: `factorization/principal-component-analysis.qmd`

The score clouds overlap substantially. Any apparent macroarea pattern may combine inventory size, source practices, genealogy, geography, and typological organization. The figure cannot distinguish those explanations because macroarea is neither a modeled cause nor the unit of the split.

## Slide 115: Interpreting the variance criterion narrowly

Source note: `factorization/principal-component-analysis.qmd`

PCA maximizes variance in the supplied representation. Here that representation contains centered binary listings for training-retained segments. A direction with high variance is not necessarily the best direction for reconstruction of hidden cells, classification, or a linguistic theory. Those targets require an external criterion.

## Slide 116: Interpreting the variance criterion narrowly

Source note: `factorization/principal-component-analysis.qmd`

PCA also does not discover a group contrast merely because groups can be colored after fitting. If a labeled contrast is the target, the evaluation must withhold appropriate units and assess it directly.

## Slide 117: Checking the variance direction

Source note: `factorization/principal-component-analysis.qmd`

Why must the matrix be centered before this covariance interpretation?

## Slide 118: Checking the variance direction

Source note: `factorization/principal-component-analysis.qmd`

What quantity does $\mathbf v^{\mathsf T}\mathbf S\mathbf v$ measure?

## Slide 119: Checking the variance direction

Source note: `factorization/principal-component-analysis.qmd`

Why are $\mathbf V$ and $\mathbf D^2/(n-1)$ the covariance eigenvectors and eigenvalues?

## Slide 120: Checking the variance direction

Source note: `factorization/principal-component-analysis.qmd`

Which metadata enter the fit on this page?

## Slide 121: Checking the variance direction

Source note: `factorization/principal-component-analysis.qmd`

Why can the macroarea facets not isolate a causal explanation?

## Slide 122: Checking the variance direction

Source note: `factorization/principal-component-analysis.qmd`

The next page separates the row coordinates from the segment directions and inspects both quantities without changing the fitted decomposition.

## Slide 123: Scores and loadings

Source note: `factorization/scores-and-loadings.qmd`

The next topic is Scores and loadings.

## Slide 124: Scores and loadings

Source note: `factorization/scores-and-loadings.qmd`

The PHOIBLE decomposition produces two related objects with different units. Scores locate inventory records in the fitted component coordinates. Loadings describe directions across segment columns. Keeping these index sets separate prevents a segment contrast from being described as if it were an inventory property.

## Slide 125: Scores locate row objects

Source note: `factorization/scores-and-loadings.qmd`

Let $\mathbf Z$ be the centered training matrix and let $\mathbf V_K$ contain the first $K$ right singular vectors. The score matrix is

$$
\mathbf T_K
=
\mathbf Z\mathbf V_K.
$$

## Slide 126: Scores locate row objects

Source note: `factorization/scores-and-loadings.qmd`

For inventory record $i$ and component $k$,

$$
t_{ik}
=
\mathbf z_i^{\mathsf T}\mathbf v_k
=
\sum_{j=1}^{p}z_{ij}v_{jk}.
$$

## Slide 127: Scores locate row objects

Source note: `factorization/scores-and-loadings.qmd`

Thus a score is a weighted sum of one centered inventory row. It is not a property of the Glottocode independently of the sampled inventory and retained segment representation.

## Slide 128: Scores locate row objects

Source note: `factorization/scores-and-loadings.qmd`

From the SVD,

$$
\mathbf Z
=
\mathbf U\mathbf D\mathbf V^{\mathsf T},
$$

orthogonality gives

$$
\mathbf T
=
\mathbf Z\mathbf V
=
\mathbf U\mathbf D.
$$

## Slide 129: Loadings describe column directions

Source note: `factorization/scores-and-loadings.qmd`

The entry $v_{jk}$ is the weight of segment column $j$ in component direction $k$. In these notes, **loading** refers to the unit vector $\mathbf v_k$. Some software instead reports $\sqrt{\lambda_k}\mathbf v_k$, so the convention should always be stated.

## Slide 130: Loadings describe column directions

Source note: `factorization/scores-and-loadings.qmd`

The score and loading matrices reconstruct the centered data:

$$
\widehat{\mathbf Z}^{(K)}
=
\mathbf T_K\mathbf V_K^{\mathsf T}
=
\mathbf U_K\mathbf D_K\mathbf V_K^{\mathsf T}.
$$

## Slide 131: Loadings describe column directions

Source note: `factorization/scores-and-loadings.qmd`

A simultaneous sign reversal leaves this product unchanged:

$$
(-\mathbf t_k)(-\mathbf v_k)^{\mathsf T}
=
\mathbf t_k\mathbf v_k^{\mathsf T}.
$$

## Slide 132: Loadings describe column directions

Source note: `factorization/scores-and-loadings.qmd`

Thus relative signs within a component are meaningful, but the global orientation is arbitrary.

## Slide 133: Extracting empirical scores and loadings

Source note: `factorization/scores-and-loadings.qmd`

The identifiers are joined only after the scores are computed. This keeps the row mapping explicit even if later filtering changes row order.

## Slide 134: Inspecting loading patterns

Source note: `factorization/scores-and-loadings.qmd`

This figure shows observed linguistic data for Inspecting loading patterns.

## Slide 135: Inspecting loading patterns

Source note: `factorization/scores-and-loadings.qmd`

The plot shows the twelve largest absolute weights for each of the first two directions. Segments on the same side contribute with the same sign, while segments on opposite sides define a contrast. Because the component may reverse sign, the important object is the relative pattern around zero.

## Slide 136: Inspecting loading patterns

Source note: `factorization/scores-and-loadings.qmd`

An isolated high loading does not name a component. Interpretation should ask whether a set of large weights forms a coherent pattern, whether the pattern is stable under resampling or nearby ranks, and whether independent evidence supports the proposed linguistic analysis. The present plot answers only the first question descriptively.

## Slide 137: Rows, columns, and metadata

Source note: `factorization/scores-and-loadings.qmd`

Family and macroarea labels are properties of inventory rows. Segment symbols and segment classes are properties of columns. Joining either kind of metadata requires its stable identifier: Mixing these tables by row position would be a unit error: their rows index different objects.

## Slide 138: Checking rows and columns

Source note: `factorization/scores-and-loadings.qmd`

What does $t_{ik}$ index?

## Slide 139: Checking rows and columns

Source note: `factorization/scores-and-loadings.qmd`

What does $v_{jk}$ index?

## Slide 140: Checking rows and columns

Source note: `factorization/scores-and-loadings.qmd`

Why are $\mathbf Z\mathbf V$ and $\mathbf U\mathbf D$ equal?

## Slide 141: Checking rows and columns

Source note: `factorization/scores-and-loadings.qmd`

Which loading convention do these notes use?

## Slide 142: Checking rows and columns

Source note: `factorization/scores-and-loadings.qmd`

Why should a component be interpreted from a pattern rather than one segment?

## Slide 143: Checking rows and columns

Source note: `factorization/scores-and-loadings.qmd`

The next page combines scores and loadings to predict cells deliberately hidden from held-out inventory records.

## Slide 144: Reconstruction

Source note: `factorization/reconstruction.qmd`

The next topic is Reconstruction.

## Slide 145: Reconstruction

Source note: `factorization/reconstruction.qmd`

Scores and loadings rebuild a matrix cell by cell. We evaluate that reconstruction with a matrix-completion task: learn segment structure from training inventories, choose rank with validation inventories, and reconstruct six cells hidden from each test inventory while its other retained segment cells remain visible.

## Slide 146: Reconstructing with the first $K$ terms

Source note: `factorization/reconstruction.qmd`

For centered training data,

$$
\widehat{\mathbf Z}^{(K)}
=
\mathbf U_K\mathbf D_K\mathbf V_K^{\mathsf T}
=
\mathbf T_K\mathbf V_K^{\mathsf T}.
$$

## Slide 147: Reconstructing with the first $K$ terms

Source note: `factorization/reconstruction.qmd`

The reconstructed centered cell is

$$
\widehat z_{ij}^{(K)}
=
\sum_{k=1}^{K}t_{ik}v_{jk}.
$$

## Slide 148: Reconstructing with the first $K$ terms

Source note: `factorization/reconstruction.qmd`

Returning to the original listing scale adds the training column mean:

$$
\widehat x_{ij}^{(K)}
=
\widehat\mu_j
+
\widehat z_{ij}^{(K)}.
$$

## Slide 149: Reconstructing with the first $K$ terms

Source note: `factorization/reconstruction.qmd`

For an observed training matrix, the residual is

$$
\mathbf E^{(K)}
=
\mathbf Z-\widehat{\mathbf Z}^{(K)},
$$

and the fraction of centered sum of squares represented is

$$
R_K
=
\frac{\sum_{k=1}^{K}d_k^2}
     {\sum_{k=1}^{r}d_k^2}
=
1-
\frac{\|\mathbf E^{(K)}\|_F^2}
     {\|\mathbf Z\|_F^2}.
$$

## Slide 150: Reconstructing with the first $K$ terms

Source note: `factorization/reconstruction.qmd`

This descriptive quantity assesses cells used in fitting. It is not held-out performance.

## Slide 151: Reconstructing partially observed inventories

Source note: `factorization/reconstruction.qmd`

Let $\mathbf x_i^*$ be a held-out inventory row in which hidden cells have been replaced by their training-column means. Their centered values are thus zero. For rank $K$,

$$
\widehat{\mathbf t}_i^{(K)}
=
(\mathbf x_i^*-\widehat{\boldsymbol\mu})^{\mathsf T}
\mathbf V_K,
$$

and

$$
\widehat{\mathbf x}_i^{(K)}
=
\widehat{\boldsymbol\mu}
+
\mathbf V_K\widehat{\mathbf t}_i^{(K)}.
$$

## Slide 152: Reconstructing partially observed inventories

Source note: `factorization/reconstruction.qmd`

This projection uses the observed cells to estimate a score. It is not a binary generative model, so fitted values may lie outside the unit interval. We clip them only when computing a probability loss.

## Slide 153: Building the split and masks

Source note: `factorization/reconstruction.qmd`

Validation selects rank 40. Only after that choice is fixed do we compute test loss. The segment-prevalence baseline has balanced Brier loss 0.1995, whereas the low-rank reconstruction has loss 0.1027.

## Slide 154: Showing raw hidden cells and predictions

Source note: `factorization/reconstruction.qmd`

This figure shows observed linguistic data for Showing raw hidden cells and predictions.

## Slide 155: Showing raw hidden cells and predictions

Source note: `factorization/reconstruction.qmd`

The raw points show all 1944 hidden test cells. The separated distributions indicate that the observed cells of a new inventory contain information about its hidden listings under this representation.

## Slide 156: Estimating the test gain

Source note: `factorization/reconstruction.qmd`

Balanced Brier loss gives listed and not-listed cells equal total weight:

$$
L_{\mathrm{bal}}
=
\frac{1}{2n_1}\sum_{x=1}(x-\widehat x)^2
+
\frac{1}{2n_0}\sum_{x=0}(x-\widehat x)^2.
$$

## Slide 157: Estimating the test gain

Source note: `factorization/reconstruction.qmd`

The following bootstrap resamples complete inventory records, preserving all six masked cells from a record.

## Slide 158: Estimating the test gain

Source note: `factorization/reconstruction.qmd`

The test loss gain is 0.0968, with an inventory bootstrap interval from 0.0874 to 0.1069. This interval describes inventory-record variability under the present split. It is not a family-level typological interval.

## Slide 159: What reconstruction establishes

Source note: `factorization/reconstruction.qmd`

The result supports a narrow conclusion: structure learned from training inventory records helps complete a few hidden database listings when most of a held-out record is observed. It does not reconstruct a wholly unseen inventory, establish phonological absence from a zero, or show that rank 40 is a phonological universal.

## Slide 160: Checking the rebuilt cells

Source note: `factorization/reconstruction.qmd`

Why are hidden cells filled with training-column means before projection?

## Slide 161: Checking the rebuilt cells

Source note: `factorization/reconstruction.qmd`

Which cells estimate a held-out inventory's scores?

## Slide 162: Checking the rebuilt cells

Source note: `factorization/reconstruction.qmd`

Why is observed reconstruction error not held-out prediction error?

## Slide 163: Checking the rebuilt cells

Source note: `factorization/reconstruction.qmd`

Why does balanced Brier loss weight the two cell statuses equally?

## Slide 164: Checking the rebuilt cells

Source note: `factorization/reconstruction.qmd`

What is the unit resampled by the bootstrap?

## Slide 165: Checking the rebuilt cells

Source note: `factorization/reconstruction.qmd`

The next page isolates the validation step that selected the retained rank without inspecting test loss.

## Slide 166: Choosing the number of components

Source note: `factorization/choosing-components.qmd`

The next topic is Choosing the number of components.

## Slide 167: Choosing the number of components

Source note: `factorization/choosing-components.qmd`

The singular values describe how well components reconstruct the training matrix. They do not determine how many components reconstruct genuinely hidden entries. The matrix-completion evaluation thus separates three operations: fit directions on training inventories, choose rank on validation inventories, and estimate performance once on test inventories.

## Slide 168: Separating fitting, selection, and evaluation

Source note: `factorization/choosing-components.qmd`

Let $\mathcal T$, $\mathcal V$, and $\mathcal E$ denote training, validation, and test inventory records. Training data determine: which segment columns occur often enough to retain. the segment means $\widehat{\boldsymbol\mu}_{\mathcal T}$. the component directions $\mathbf V_{\mathcal T}$.

## Slide 169: Separating fitting, selection, and evaluation

Source note: `factorization/choosing-components.qmd`

For a validation inventory with masked cells, scores at rank $K$ are

$$
\widehat{\mathbf t}_{i,K}
=
(\mathbf x_i^*-\widehat{\boldsymbol\mu}_{\mathcal T})^{\mathsf T}
\mathbf V_{\mathcal T,K},
$$

and the reconstruction is

$$
\widehat{\mathbf x}_{i,K}
=
\widehat{\boldsymbol\mu}_{\mathcal T}
+
\mathbf V_{\mathcal T,K}\widehat{\mathbf t}_{i,K}.
$$

## Slide 170: Separating fitting, selection, and evaluation

Source note: `factorization/choosing-components.qmd`

The selected rank is

$$
\widehat K
=
\arg\min_{K\in\mathcal K}
L_{\mathrm{bal}}(\mathcal V,K),
$$

where

$$
L_{\mathrm{bal}}
=
\frac{1}{2n_1}\sum_{x=1}(x-\widehat x)^2
+
\frac{1}{2n_0}\sum_{x=0}(x-\widehat x)^2.
$$

## Slide 171: Separating fitting, selection, and evaluation

Source note: `factorization/choosing-components.qmd`

The final test loss is evaluated at $\widehat K$. Test loss must not be used to revise $\mathcal K$, preprocessing, or the masking procedure. Otherwise the test set becomes another validation set, the one-split repeated-decisions problem.

## Slide 172: Implementing rank selection

Source note: `factorization/choosing-components.qmd`

This figure shows observed linguistic data for Implementing rank selection.

## Slide 173: Implementing rank selection

Source note: `factorization/choosing-components.qmd`

The validation minimum occurs at rank 40. The line marks the result of the fixed selection rule; it is the only annotation needed to read the curve.

## Slide 174: Preserving one final evaluation

Source note: `factorization/choosing-components.qmd`

the calculation computes the test comparison only after `selected_rank` exists.

## Slide 175: Preserving one final evaluation

Source note: `factorization/choosing-components.qmd`

The selected reconstruction reduces test balanced Brier loss from 0.1995 to 0.1027. Balanced log loss moves in the same direction, from 0.6425 to 0.3466.

## Slide 176: Preserving one final evaluation

Source note: `factorization/choosing-components.qmd`

One inventory was sampled per Glottocode, and the split is stratified by macroarea. Families were not assigned wholesale to splits. Thus this evaluation concerns held-out inventory records under broad area balance; it does not establish transfer to unseen families.

## Slide 177: Why other criteria answer different questions

Source note: `factorization/choosing-components.qmd`

Choosing a rank from observed training reconstruction rewards additional components by construction. A scree bend or a cumulative-variance threshold may summarize the observed matrix, but neither directly evaluates hidden cells. Conversely, validation loss is tied to the masking rule, loss function, and new-inventory target. It does not identify a true number of phonological dimensions.

## Slide 178: Why other criteria answer different questions

Source note: `factorization/choosing-components.qmd`

Rank selection also includes preprocessing. Segment retention, centering, component fitting, and masking must remain inside their assigned partitions. Letting validation or test inventories determine retained columns would create leakage through preprocessing.

## Slide 179: Checking rank selection

Source note: `factorization/choosing-components.qmd`

Which quantities are fitted on training inventories?

## Slide 180: Checking rank selection

Source note: `factorization/choosing-components.qmd`

Which data choose the rank?

## Slide 181: Checking rank selection

Source note: `factorization/choosing-components.qmd`

Why is the test set evaluated only once?

## Slide 182: Checking rank selection

Source note: `factorization/choosing-components.qmd`

Why can the training reconstruction curve not select a predictive rank?

## Slide 183: Checking rank selection

Source note: `factorization/choosing-components.qmd`

What generalization claim is blocked because family is not the split unit?

## Slide 184: Checking rank selection

Source note: `factorization/choosing-components.qmd`

The selected rank supports this matrix-completion task, not a universal dimensionality claim. The final page moves to a supervised problem in which PCA compression itself must compete with the uncompressed linguistic predictor.

## Slide 185: From VALEX distributions to MegaAcceptability profiles

Source note: `factorization/valex-megaacceptability.qmd`

Next, we take up From VALEX distributions to MegaAcceptability profiles.

## Slide 186: VALEX: the empirical object

Source note: `factorization/valex-megaacceptability.qmd`

The data source is VALEX and MegaAcceptability 1.2. It provides verb-frame counts paired with MegaAcceptability ratings.

## Slide 187: From VALEX distributions to MegaAcceptability profiles

Source note: `factorization/valex-megaacceptability.qmd`

The PHOIBLE sequence used factorization to reconstruct hidden cells. We test whether PCA of VALEX frame proportions improves held-out-verb prediction of MegaAcceptability profiles.

## Slide 188: From VALEX distributions to MegaAcceptability profiles

Source note: `factorization/valex-megaacceptability.qmd`

VALEX was acquired automatically from five corpora and the Web. Korhonen, Krymolowski, and Briscoe's dataset paper describes counts for English verb subcategorization frames and emphasizes automatic acquisition. The counts may contain parsing and frame-assignment error, and the release does not disambiguate verb senses.

## Slide 189: From VALEX distributions to MegaAcceptability profiles

Source note: `factorization/valex-megaacceptability.qmd`

The official MegaAcceptability archive is CC BY-SA 4.0, and its internal README identifies the release as v1.2. It contains judgments for English clause-embedding verbs in semantically bleached frames. White and Rawlins (2020) constructed lists in which each verb and frame appeared at most once, collected ordinal responses from participants reporting native American English, and modeled the relation between corpus frequencies and acceptability. The teaching analysis uses their empirical target but simplifies the model so that PCA is the only representational change.

## Slide 190: Defining the linguistic objects

Source note: `factorization/valex-megaacceptability.qmd`

The retained overlap contains one VALEX row per matched verb and one MegaAcceptability response profile per matched verb. If $c_{vj}$ is the automatically acquired count for verb $v$ in VALEX dimension $j$, define the within-verb proportion

$$
p_{vj}
=
\frac{c_{vj}}{\sum_h c_{vh}}.
$$

## Slide 191: Defining the linguistic objects

Source note: `factorization/valex-megaacceptability.qmd`

The row $\mathbf p_v$ represents the allocation of observed corpus evidence across frames, not total verb frequency. It is not a sense-specific grammatical description.

## Slide 192: Defining the linguistic objects

Source note: `factorization/valex-megaacceptability.qmd`

The raw MegaAcceptability unit is one participant's ordinal response to one verb-frame item. Within a training set $\mathcal T$, participant $q$'s response is transformed as

$$
z_{qi}
=
\frac{y_{qi}-\bar y_{q,\mathcal T}}
     {s_{q,\mathcal T}}.
$$

## Slide 193: Defining the linguistic objects

Source note: `factorization/valex-megaacceptability.qmd`

These values are averaged within verb-frame cells to form a response matrix $\mathbf Y$ with one verb per row and one experimental frame per column. Zero is the training-fitted participant origin, not a boundary between grammatical and ungrammatical sentences. This transformation is a fold-fitted approximation to the paper's ordinal normalization.

## Slide 194: Reading and checking the analysis inputs

Source note: `factorization/valex-megaacceptability.qmd`

The audited course bundle stores the raw inputs and validated predictions from the leakage-safe nested procedure. The R below reads every object used on this page and recomputes the reported summaries and figures. A complete R implementation of the fitting procedure follows in the next section.

## Slide 195: Reading and checking the analysis inputs

Source note: `factorization/valex-megaacceptability.qmd`

The empirical objects contain 958 matched verbs, 109 observed VALEX dimensions, 50 experimental frames, and 238,917 retained responses from 727 participants.

## Slide 196: Stating the competing procedures

Source note: `factorization/valex-megaacceptability.qmd`

The direct multivariate ridge model uses the complete VALEX proportion matrix. With an unpenalized intercept implemented by training centering, it solves

$$
(\widehat{\boldsymbol\beta}_{0,\lambda},
 \widehat{\mathbf B}_{\lambda})
=
\arg\min_{\boldsymbol\beta_0,\mathbf B}
\left\|\mathbf Y_{\mathcal T}
-\mathbf 1\boldsymbol\beta_0^{\mathsf T}
-\mathbf P_{\mathcal T}\mathbf B\right\|_F^2
+\lambda\|\mathbf B\|_F^2.
$$

## Slide 197: Stating the competing procedures

Source note: `factorization/valex-megaacceptability.qmd`

The factor procedure fits PCA only to training predictor rows,

$$
\mathbf F_K
=
(\mathbf P-\mathbf 1\bar{\mathbf p}_{\mathcal T}^{\mathsf T})
\mathbf V_{\mathcal T,K},
$$

then substitutes $\mathbf F_K$ for $\mathbf P$ in the same ridge objective.

## Slide 198: Stating the competing procedures

Source note: `factorization/valex-megaacceptability.qmd`

The outcomes, held-out units, and loss remain fixed. Thus the comparison asks whether shallow PCA compression improves prediction; it does not ask whether abstraction in general is useful.

## Slide 199: Stating the competing procedures

Source note: `factorization/valex-megaacceptability.qmd`

The direct hypothesis predicts that the complete VALEX distribution improves on a training-frame-mean baseline for held-out verbs. The compression hypothesis predicts that the factor procedure improves on the direct procedure.

## Slide 200: Keeping every fitted choice inside training data

Source note: `factorization/valex-megaacceptability.qmd`

Five repetitions of ten-fold outer cross-validation hold out complete verbs. Within every outer training set, independent five-fold validation selects the direct ridge penalty and jointly selects factor rank and ridge penalty. Participant normalization, response aggregation, predictor centering, PCA loadings, rank, and penalty are refitted in the relevant training split.

## Slide 201: Keeping every fitted choice inside training data

Source note: `factorization/valex-megaacceptability.qmd`

The fixed candidate sets are: The validated predictions keep the default page render short. The complete R teaching implementation is below. It uses base R's seeded shuffling, so it implements the registered split logic without reproducing NumPy's exact fold membership. The displayed audit results remain those of the registered procedure and the checked files above. Setting `eval: true` reruns fold construction, participant normalization, nested selection, and outer prediction from the two raw course inputs; it does not read the frozen prediction files.

## Slide 202: Keeping every fitted choice inside training data

Source note: `factorization/valex-megaacceptability.qmd`

Fitting one PCA to all verbs would create leakage through preprocessing, even though PCA does not use acceptability. The test verb's VALEX row is unavailable under the new-verb target and cannot determine its own component directions.

## Slide 203: Defining held-out skill

Source note: `factorization/valex-megaacceptability.qmd`

The baseline predicts the outer-training mean separately for each response frame. For model $m$, define

$$
R_m^2
=
1-
\frac{\sum_i(y_i-\widehat y_{m,i})^2}
     {\sum_i(y_i-\widehat y_{\mathrm{base},i})^2}.
$$

## Slide 204: Defining held-out skill

Source note: `factorization/valex-megaacceptability.qmd`

Positive values improve on the frame-mean baseline. The paired compression contrast is

$$
\Delta R^2
=
R_{\mathrm{factor}}^2-R_{\mathrm{direct}}^2.
$$

## Slide 205: Defining held-out skill

Source note: `factorization/valex-megaacceptability.qmd`

The frozen audit uses a verb bootstrap, so a sampled verb contributes every response frame and all repeated outer predictions.

## Slide 206: Defining held-out skill

Source note: `factorization/valex-megaacceptability.qmd`

The direct distribution achieves held-out skill 0.2455, with a verb-bootstrap interval from 0.2242 to 0.2656. The PCA procedure achieves 0.2389. Its difference from the direct procedure is -0.0066, and the paired interval lies below zero.

## Slide 207: Showing outcomes and held-out fits

Source note: `factorization/valex-megaacceptability.qmd`

Each verb-frame cell receives one prediction in every outer repetition. We average those five held-out predictions only for plotting.

## Slide 208: Showing outcomes and held-out fits

Source note: `factorization/valex-megaacceptability.qmd`

This figure shows observed linguistic data for Showing outcomes and held-out fits.

## Slide 209: Showing outcomes and held-out fits

Source note: `factorization/valex-megaacceptability.qmd`

Both fitted procedures recover substantial ordering across held-out cells, though dispersion around the identity line remains. The panels are similar because PCA preserves much, but not all, of the direct predictive signal.

## Slide 210: Inspecting selected rank

Source note: `factorization/valex-megaacceptability.qmd`

This figure shows observed linguistic data for Inspecting selected rank.

## Slide 211: Inspecting selected rank

Source note: `factorization/valex-megaacceptability.qmd`

Inner validation selects rank 50, the largest candidate, in all 50 outer fits. This result does not identify that rank as the number of grammatical dimensions. It suggests that directions beyond the tested compression remain predictively useful.

## Slide 212: Locating the predictive limitation

Source note: `factorization/valex-megaacceptability.qmd`

White and Rawlins report a marked weakness for finite clauses preceded by a direct object. The audit fixed the corresponding frame-family comparison before inspecting the new procedure.

## Slide 213: Locating the predictive limitation

Source note: `factorization/valex-megaacceptability.qmd`

This figure shows observed linguistic data for Locating the predictive limitation.

## Slide 214: Locating the predictive limitation

Source note: `factorization/valex-megaacceptability.qmd`

Direct skill for finite clauses without an object is 0.254, but falls to 0.083 for the matched object frames. PCA does not repair this difference.

## Slide 215: Locating the predictive limitation

Source note: `factorization/valex-megaacceptability.qmd`

White and Rawlins connect the object pattern to communicativity: with a verb such as *persuade*, the object may denote a recipient of communicated content. The present residual is consistent with that proposal, though it cannot separate communicativity from animacy, discourse, polysemy, item construction, or corpus-analysis error.

## Slide 216: What the application establishes

Source note: `factorization/valex-megaacceptability.qmd`

First, automatically acquired VALEX distributions contain information about MegaAcceptability profiles for verbs excluded from fitting. Second, PCA compression does not improve that mapping: the selected factor procedure performs slightly and stably worse than the direct profile. The result counts against this shallow compression for this target, not against abstract syntactic or semantic representations in general.

## Slide 217: What the application establishes

Source note: `factorization/valex-megaacceptability.qmd`

The teaching analysis differs from the paper in three declared ways. It uses raw VALEX proportions rather than the paper's best Beta Negative Binomial representation, PCA rather than a logistic factor model, and a fold-fitted z transformation rather than the released ordinal mixed-effects normalization. Those changes isolate the matrix operations taught here while preserving the held-out-verb question.

## Slide 218: Checking the reasoning

Source note: `factorization/valex-megaacceptability.qmd`

What does one VALEX row represent, and which sense distinction does it omit?

## Slide 219: Checking the reasoning

Source note: `factorization/valex-megaacceptability.qmd`

Why are counts converted to within-verb proportions?

## Slide 220: Checking the reasoning

Source note: `factorization/valex-megaacceptability.qmd`

Why must participant normalization be refitted inside each split?

## Slide 221: Checking the reasoning

Source note: `factorization/valex-megaacceptability.qmd`

What is held constant between the direct and factor procedures?

## Slide 222: Checking the reasoning

Source note: `factorization/valex-megaacceptability.qmd`

Why does selecting the largest candidate rank not identify a grammatical dimensionality?

## Slide 223: Checking the reasoning

Source note: `factorization/valex-megaacceptability.qmd`

What does the negative compression contrast rule out, and what remains a live possibility?

## Slide 224: Checking the reasoning

Source note: `factorization/valex-megaacceptability.qmd`

The live empirical question is which theory-guided representation of communicativity, argument structure, or event structure can improve held-out prediction without discarding the useful direct distributional signal.
