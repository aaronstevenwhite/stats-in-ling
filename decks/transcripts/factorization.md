# Factorizing linguistic data

This transcript is generated from the speaker notes in the slide source. Slide identifiers, titles, note-page provenance, and order are identical.

## Slide 1: Factorizing linguistic data

Source note: `factorization/index.qmd`

Welcome to Factorizing linguistic data. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.

## Slide 2: Factorization

Source note: `factorization/index.qmd`

We now turn to Factorization. Moran and McCloy's PHOIBLE 2.0 release collects phonological inventory records contributed by many descriptive sources. The download and license page distributes the release as a CLDF StructureDataset under CC BY-SA 3.0. An inventory record generally describes a doculect, but multiple records may share a Glottocode and some source collections aggregate several varieties.

## Slide 3: PHOIBLE: the empirical object

Source note: `factorization/index.qmd`

This is the first use of PHOIBLE in this module. The slide names the observation represented in the teaching table and links the original source. We will keep that unit fixed when we compute and interpret quantities from these data.

## Slide 4: Factorization

Source note: `factorization/index.qmd`

Moran and McCloy's PHOIBLE 2.0 release collects phonological inventory records contributed by many descriptive sources. The download and license page distributes the release as a CLDF StructureDataset under CC BY-SA 3.0. The prepared memberships exclude tone entries and rows explicitly marked as marginal. A matrix cell equal to one means that a retained PHOIBLE value row links an inventory record to a segment. A zero means that no such row is listed under this preparation; it is not direct evidence that a language lacks the segment. That distinction will matter again on the next slide.

## Slide 5: Constructing and decomposing the matrix

Source note: `factorization/index.qmd`

Linguistic data matrices define the row, column, and cell units, reproduce the Glottocode-level row selection, and retain segment columns using training records only. Centering and scaling then compare two transformations of the empirical binary columns. The primary analysis centers without variance standardization because standardization would give relatively greater weight to rare listings. Rank-one structure fits the first singular triplet and places the observed centered cells beside their rank-one reconstruction. Singular value decomposition extends that fit to ordered orthogonal terms. Principal component analysis derives the covariance identity from the same decomposition and adds macroarea only after fitting for descriptive interpretation. Keep the observational unit fixed while you interpret the result.

## Slide 6: Interpreting and evaluating components

Source note: `factorization/index.qmd`

Scores and loadings distinguish coordinates for inventory rows from directions over segment columns. A loading pattern may suggest a linguistic hypothesis, but the decomposition does not turn a component into a natural class, universal, or causal mechanism. Reconstruction hides listed and not-listed cells in each held-out record, estimates scores from the remaining cells, and returns predictions to the original cell scale. Choosing components selects rank on validation inventories with balanced reconstruction loss and reserves test inventories for one final comparison. Because families are not the split unit, the result does not establish transfer to unseen language families. The interpretation is conditional on the sampling and measurement design.

## Slide 7: From decomposition to supervised prediction

Source note: `factorization/index.qmd`

The final application changes both the dataset and the target. VALEX contains GPL-licensed, automatically acquired English verb subcategorization counts described by Korhonen, Krymolowski, and Briscoe (2006). The official MegaAcceptability archive is CC BY-SA 4.0; its internal README identifies the release as v1.2. The VALEX--MegaAcceptability page defines the **distribution-to-selection mapping (DSM)** and compares direct VALEX proportions with a PCA-compressed representation for verbs absent during fitting. Participant normalization, response aggregation, predictor centering, PCA, and tuning all occur inside their training splits. The application asks whether this shallow compression helps the held-out-verb target. Now connect the notation back to the linguistic comparison.

## Slide 8: Interpretation

Source note: `factorization/index.qmd`

The sequence thus moves from a declared empirical matrix, through its exact algebra, to two held-out targets on the original data scales. Begin with linguistic data matrices. That distinction will matter again on the next slide.

## Slide 9: Linguistic data matrices

Source note: `factorization/data-matrices.qmd`

We now turn to Linguistic data matrices. PHOIBLE 2.0 is a curated collection of phonological inventory records assembled from descriptive sources. Its documentation stresses that an inventory usually describes a doculect, that multiple inventories may share a Glottocode, and that some inherited inventories combine sources. We will thus call one row an **inventory record**, not a language.

## Slide 10: Linguistic data matrices

Source note: `factorization/data-matrices.qmd`

PHOIBLE 2.0 is a curated collection of phonological inventory records assembled from descriptive sources. Its documentation stresses that an inventory usually describes a doculect, that multiple inventories may share a Glottocode, and that some inherited inventories combine sources. We will thus call one row an **inventory record**, not a language. The course copy is pinned to PHOIBLE 2.0 and follows the release's download and citation guidance. It excludes tone entries and rows explicitly marked as marginal, then samples one inventory within each Glottocode. A cell equal to one means that a retained PHOIBLE value row links the inventory to the segment. A zero means **not listed under this preparation rule**. The interpretation is conditional on the sampling and measurement design.

## Slide 11: Defining the array and its indices

Source note: `factorization/data-matrices.qmd`

Let there be $n$ linguistic objects and $p$ measured variables. A data matrix is Its entries are Use the graph or equation to say the result in ordinary language.

## Slide 12: Defining the array and its indices: equation 1

Source note: `factorization/data-matrices.qmd`

The displayed expression formalizes defining the array and its indices: equation 1. Let there be $n$ linguistic objects and $p$ measured variables. A data matrix is Keep track of what each term refers to in the linguistic dataset.

## Slide 13: Defining the array and its indices: equation 2

Source note: `factorization/data-matrices.qmd`

The displayed expression formalizes defining the array and its indices: equation 2. Its entries are Keep track of what each term refers to in the linguistic dataset.

## Slide 14: Defining the array and its indices: equation 3

Source note: `factorization/data-matrices.qmd`

The displayed expression formalizes defining the array and its indices: equation 3. The complete row for object $i$ is Keep track of what each term refers to in the linguistic dataset.

## Slide 15: Defining the array and its indices: equation 4

Source note: `factorization/data-matrices.qmd`

The displayed expression formalizes defining the array and its indices: equation 4. and the complete column for variable $j$ is Keep track of what each term refers to in the linguistic dataset.

## Slide 16: Constructing the PHOIBLE matrix

Source note: `factorization/data-matrices.qmd`

The code below reproduces the row sample, the macroarea-stratified split, and the training-only column filter. The random seeds identify reproducible procedural choices; they are not linguistic measurements. The resulting matrix has observed inventory records and observed segment columns. Of its observed cells, observed are listed. This sparsity is a property of the prepared database matrix, not an estimate of how often phones occur in speech. Use the graph or equation to say the result in ordinary language.

## Slide 17: Seeing rows and columns

Source note: `factorization/data-matrices.qmd`

The full matrix is too large to label. The following plot thus displays four training inventories from each classified macroarea and the twenty most common training segments. Every plotted cell is read directly from `X`. The cell in a particular row and column can now be interpreted only by using both index maps. The first displayed row, for instance, can be recovered without copying its values into the notes. Now connect the notation back to the linguistic comparison.

## Slide 18: The representation constraint

Source note: `factorization/data-matrices.qmd`

Changing a row from an inventory record to a Glottocode-level average would change the observational unit. Changing the columns would change which segment contrasts are available. Repeating a column would give the corresponding listing pattern extra numerical weight. Before factorization, record (i) the row unit, (ii) the row-selection rule, (iii) the column-retention rule, (iv) the cell coding, and (v) the collection to which those records belong. This **representation constraint** fixes the information available to every later operation. Now connect the notation back to the linguistic comparison.

## Slide 19: Checking the representation

Source note: `factorization/data-matrices.qmd`

1. What does $x_{ij}=1$ mean in this matrix? 2. Why is “not listed” safer than “absent” for $x_{ij}=0$? 3. Why is one sampled inventory record not necessarily one language? 4. Which part of the code prevents validation and test inventories from selecting columns? 5. The next page changes the origin and possible unit of each segment column while keeping these row and column definitions fixed. Now connect the notation back to the linguistic comparison.

## Slide 20: Linguistic data matrices

Source note: `factorization/data-matrices.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Linguistic data matrices. Read the pattern before attaching a model interpretation to it.

## Slide 21: Centering and scaling

Source note: `factorization/centering-and-scaling.qmd`

We now turn to Centering and scaling. The PHOIBLE matrix represents inventory records in rows and retained segment listings in columns. Every column uses the same binary database-listing unit, but the columns differ in how often a segment is listed. Centering changes each column's origin. Standardization would additionally change its unit and, for binary data, its weight in the factorization.

## Slide 22: Centering and scaling

Source note: `factorization/centering-and-scaling.qmd`

The PHOIBLE matrix represents inventory records in rows and retained segment listings in columns. Every column uses the same binary database-listing unit, but the columns differ in how often a segment is listed. Centering changes each column's origin. The PHOIBLE matrix represents inventory records in rows and retained segment listings in columns. Every column uses the same binary database-listing unit, but the columns differ in how often a segment is listed. Centering changes each column's origin. Standardization would additionally change its unit and, for binary data, its weight in the factorization. Notice what is observed and what is supplied by the model.

## Slide 23: Centering changes the origin

Source note: `factorization/centering-and-scaling.qmd`

For column $j$, the training mean is Because $x_{ij}$ is binary here, $\widehat\mu_j$ is the training proportion of inventory records that list segment $j$. The centered entry is Keep the observational unit fixed while you interpret the result.

## Slide 24: Centering changes the origin: equation 1

Source note: `factorization/centering-and-scaling.qmd`

The displayed expression formalizes centering changes the origin: equation 1. For column $j$, the training mean is Keep track of what each term refers to in the linguistic dataset.

## Slide 25: Centering changes the origin: equation 2

Source note: `factorization/centering-and-scaling.qmd`

The displayed expression formalizes centering changes the origin: equation 2. Because $x_{ij}$ is binary here, $\widehat\mu_j$ is the training proportion of inventory records that list segment $j$. The centered entry is Keep track of what each term refers to in the linguistic dataset.

## Slide 26: Centering changes the origin: equation 3

Source note: `factorization/centering-and-scaling.qmd`

The displayed expression formalizes centering changes the origin: equation 3. and the complete centered training matrix is Keep track of what each term refers to in the linguistic dataset.

## Slide 27: Scaling changes the unit

Source note: `factorization/centering-and-scaling.qmd`

The sample standard deviation of column $j$ is Collecting these values on the diagonal of $\mathbf S$, the standardized matrix is That distinction will matter again on the next slide.

## Slide 28: Scaling changes the unit: equation 1

Source note: `factorization/centering-and-scaling.qmd`

The displayed expression formalizes scaling changes the unit: equation 1. The sample standard deviation of column $j$ is Keep track of what each term refers to in the linguistic dataset.

## Slide 29: Scaling changes the unit: equation 2

Source note: `factorization/centering-and-scaling.qmd`

The displayed expression formalizes scaling changes the unit: equation 2. Collecting these values on the diagonal of $\mathbf S$, the standardized matrix is Keep track of what each term refers to in the linguistic dataset.

## Slide 30: Scaling changes the unit: equation 3

Source note: `factorization/centering-and-scaling.qmd`

The displayed expression formalizes scaling changes the unit: equation 3. or, cell by cell, Keep track of what each term refers to in the linguistic dataset.

## Slide 31: Computing the PHOIBLE coordinate systems

Source note: `factorization/centering-and-scaling.qmd`

This page independently reconstructs the row selection, split, and training-only column set introduced on the previous page. The training set contains observed inventory records and observed retained segments. No retained column is constant because the training-frequency rule removes segments with too few listings. Use the graph or equation to say the result in ordinary language.

## Slide 32: The empirical weighting decision

Source note: `factorization/centering-and-scaling.qmd`

The least variable retained column would be multiplied by observed, whereas the most variable would be multiplied by observed. Standardization would thus assign relatively greater weight to rare segment listings. That weighting may be useful for some questions, but it is not neutral. The primary PHOIBLE analysis centers without variance standardization. Every column already shares the same listing unit, and the analysis lets common patterns contribute their observed variance. This choice does not claim that common segments are linguistically more important. It defines the numerical target of this factorization. Now connect the notation back to the linguistic comparison.

## Slide 33: Applying a fitted transformation

Source note: `factorization/centering-and-scaling.qmd`

Means and scales used for evaluation must come from training data. For a new matrix $\mathbf X_{\mathrm{new}}$, the fixed transformation is In R, that operation is: That distinction will matter again on the next slide.

## Slide 34: Applying a fitted transformation

Source note: `factorization/centering-and-scaling.qmd`

The displayed expression formalizes applying a fitted transformation. Means and scales used for evaluation must come from training data. For a new matrix $\mathbf X_{\mathrm{new}}$, the fixed transformation is Keep track of what each term refers to in the linguistic dataset.

## Slide 35: Checking the coordinate system

Source note: `factorization/centering-and-scaling.qmd`

1. What does zero mean in a centered PHOIBLE column? 2. Why does centering preserve differences between rows? 3. Why does standardization weight rare binary columns more heavily? 4. Which data determine `training_mean` and `training_sd`? 5. Why does the primary analysis retain `Z` rather than `Z_standardized`? The next page asks how much of this centered empirical matrix can be represented by a single shared row-by-column pattern. Keep the observational unit fixed while you interpret the result.

## Slide 36: Centering and scaling

Source note: `factorization/centering-and-scaling.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Centering and scaling. Read the pattern before attaching a model interpretation to it.

## Slide 37: Rank-one structure

Source note: `factorization/rank-one-structure.qmd`

We now turn to Rank-one structure. The centered PHOIBLE inventory matrix contains many linked listing patterns. A rank-one approximation asks what can be represented by one row pattern and one column pattern before adding further components.

## Slide 38: Rank-one structure

Source note: `factorization/rank-one-structure.qmd`

The centered PHOIBLE inventory matrix contains many linked listing patterns. A rank-one approximation asks what can be represented by one row pattern and one column pattern before adding further components. Now connect the notation back to the linguistic comparison.

## Slide 39: Constructing one outer product

Source note: `factorization/rank-one-structure.qmd`

For a matrix with $n$ rows and $p$ columns, let Their outer product is Notice what is observed and what is supplied by the model.

## Slide 40: Constructing one outer product: equation 1

Source note: `factorization/rank-one-structure.qmd`

The displayed expression formalizes constructing one outer product: equation 1. For a matrix with $n$ rows and $p$ columns, let Keep track of what each term refers to in the linguistic dataset.

## Slide 41: Constructing one outer product: equation 2

Source note: `factorization/rank-one-structure.qmd`

The displayed expression formalizes constructing one outer product: equation 2. Their outer product is Keep track of what each term refers to in the linguistic dataset.

## Slide 42: Constructing one outer product: equation 3

Source note: `factorization/rank-one-structure.qmd`

The displayed expression formalizes constructing one outer product: equation 3. Every cell obeys the same rule, Keep track of what each term refers to in the linguistic dataset.

## Slide 43: Constructing one outer product: equation 4

Source note: `factorization/rank-one-structure.qmd`

The displayed expression formalizes constructing one outer product: equation 4. Thus all columns are scalar multiples of $\mathbf a$, and all rows are scalar multiples of $\mathbf b^{\mathsf T}$. Any nonzero matrix with this form has rank one. Keep track of what each term refers to in the linguistic dataset.

## Slide 44: Constructing one outer product: equation 5

Source note: `factorization/rank-one-structure.qmd`

The displayed expression formalizes constructing one outer product: equation 5. The individual vector scales are not identified by the product. For any nonzero constant $c$, Keep track of what each term refers to in the linguistic dataset.

## Slide 45: Fitting the empirical rank-one pattern

Source note: `factorization/rank-one-structure.qmd`

The following code reconstructs the PHOIBLE training matrix from the release object. Segment retention and centering depend only on training inventory records. The first fitted pattern accounts for observed of the centered sum of squares. That empirical proportion is far from complete reconstruction, so the rank-one matrix is an approximation rather than an exact representation of the inventory data. That distinction will matter again on the next slide.

## Slide 46: Comparing observed and fitted cells

Source note: `factorization/rank-one-structure.qmd`

To make the cell pattern legible, the plot uses the same training inventory rows and segment columns selected for the matrix display on the first page. Both panels use one diverging scale, centered at zero. The fitted panel is smoother because all its cells share one outer-product rule. Positive and negative values indicate deviations above and below training prevalence. They are not probabilities. Keep the observational unit fixed while you interpret the result.

## Slide 47: Compression and interpretation

Source note: `factorization/rank-one-structure.qmd`

An unrestricted $n\times p$ matrix contains $np$ cells. A rank-one representation stores $n+p+1$ fitted quantities before accounting for the unit-length and sign conventions. The reduction can be substantial, but it is useful only when the residual matrix is small enough for the target at hand. Now connect the notation back to the linguistic comparison.

## Slide 48: Compression and interpretation

Source note: `factorization/rank-one-structure.qmd`

The displayed expression formalizes compression and interpretation. An unrestricted $n\times p$ matrix contains $np$ cells. A rank-one representation stores $n+p+1$ fitted quantities before accounting for the unit-length and sign conventions. The reduction can be substantial, but it is useful only when the residual matrix Keep track of what each term refers to in the linguistic dataset.

## Slide 49: Checking the common pattern

Source note: `factorization/rank-one-structure.qmd`

1. Why are all rows of an exact rank-one matrix proportional? 2. What roles do $d_1$, $\mathbf u_1$, and $\mathbf v_1$ play? 3. What does a positive centered cell mean in the PHOIBLE matrix? 4. Why is the fitted rank-one matrix not a probability matrix? 5. The next page adds orthogonal rank-one terms in order of their empirical strength. Use the graph or equation to say the result in ordinary language.

## Slide 50: Rank-one structure

Source note: `factorization/rank-one-structure.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Rank-one structure. Read the pattern before attaching a model interpretation to it.

## Slide 51: Singular value decomposition

Source note: `factorization/singular-value-decomposition.qmd`

We now turn to Singular value decomposition. One rank-one pattern leaves substantial structure in the centered PHOIBLE matrix. The singular value decomposition (SVD) expresses that matrix as a sequence of mutually orthogonal rank-one terms, ordered by the centered sum of squares each term represents.

## Slide 52: Singular value decomposition

Source note: `factorization/singular-value-decomposition.qmd`

One rank-one pattern leaves substantial structure in the centered PHOIBLE matrix. The singular value decomposition (SVD) expresses that matrix as a sequence of mutually orthogonal rank-one terms, ordered by the centered sum of squares each term represents. Notice what is observed and what is supplied by the model.

## Slide 53: Stating the reduced decomposition

Source note: `factorization/singular-value-decomposition.qmd`

For $\mathbf Z\in\mathbb R^{n\times p}$ with rank $r$, the reduced SVD is where Keep the observational unit fixed while you interpret the result.

## Slide 54: Stating the reduced decomposition: equation 1

Source note: `factorization/singular-value-decomposition.qmd`

The displayed expression formalizes stating the reduced decomposition: equation 1. For $\mathbf Z\in\mathbb R^{n\times p}$ with rank $r$, the reduced SVD is Keep track of what each term refers to in the linguistic dataset.

## Slide 55: Stating the reduced decomposition: equation 2

Source note: `factorization/singular-value-decomposition.qmd`

The displayed expression formalizes stating the reduced decomposition: equation 2. where Keep track of what each term refers to in the linguistic dataset.

## Slide 56: Stating the reduced decomposition: equation 3

Source note: `factorization/singular-value-decomposition.qmd`

The displayed expression formalizes stating the reduced decomposition: equation 3. The columns are orthonormal, Keep track of what each term refers to in the linguistic dataset.

## Slide 57: Stating the reduced decomposition: equation 4

Source note: `factorization/singular-value-decomposition.qmd`

The displayed expression formalizes stating the reduced decomposition: equation 4. and $\mathbf D$ is diagonal with ordered nonnegative entries, Keep track of what each term refers to in the linguistic dataset.

## Slide 58: From a matrix product to rank-one terms

Source note: `factorization/singular-value-decomposition.qmd`

Multiplying by the diagonal matrix scales matched columns of $\mathbf U$ and $\mathbf V$. Thus Every summand is rank one. The rank-$K$ approximation keeps the first $K$ terms: Now connect the notation back to the linguistic comparison.

## Slide 59: From a matrix product to rank-one terms: equation 1

Source note: `factorization/singular-value-decomposition.qmd`

The displayed expression formalizes from a matrix product to rank-one terms: equation 1. Multiplying by the diagonal matrix scales matched columns of $\mathbf U$ and $\mathbf V$. Thus Keep track of what each term refers to in the linguistic dataset.

## Slide 60: From a matrix product to rank-one terms: equation 2

Source note: `factorization/singular-value-decomposition.qmd`

The displayed expression formalizes from a matrix product to rank-one terms: equation 2. Every summand is rank one. The rank-$K$ approximation keeps the first $K$ terms: Keep track of what each term refers to in the linguistic dataset.

## Slide 61: From a matrix product to rank-one terms: equation 3

Source note: `factorization/singular-value-decomposition.qmd`

The displayed expression formalizes from a matrix product to rank-one terms: equation 3. Among all rank-$K$ matrices, this approximation minimizes squared reconstruction error: Keep track of what each term refers to in the linguistic dataset.

## Slide 62: From a matrix product to rank-one terms: equation 4

Source note: `factorization/singular-value-decomposition.qmd`

The displayed expression formalizes from a matrix product to rank-one terms: equation 4. The Frobenius norm is the sum of squared cells, Keep track of what each term refers to in the linguistic dataset.

## Slide 63: From a matrix product to rank-one terms: equation 5

Source note: `factorization/singular-value-decomposition.qmd`

The displayed expression formalizes from a matrix product to rank-one terms: equation 5. Orthogonality yields Keep track of what each term refers to in the linguistic dataset.

## Slide 64: Computing the PHOIBLE decomposition

Source note: `factorization/singular-value-decomposition.qmd`

The empirical training matrix is observed by observed. The largest absolute departures from the two orthogonality identities are observed under this numerical fit. One rank-one pattern leaves substantial structure in the centered PHOIBLE matrix. The singular value decomposition (SVD) expresses that matrix as a sequence of mutually orthogonal rank-one terms, ordered by the centered sum of squares each term represents. The interpretation is conditional on the sampling and measurement design.

## Slide 65: Reading the empirical spectrum

Source note: `factorization/singular-value-decomposition.qmd`

The first component accounts for observed of centered sum of squares. The first forty account for observed. These are descriptive properties of the training matrix. They do not select a predictive rank and do not turn the components into linguistic categories. One rank-one pattern leaves substantial structure in the centered PHOIBLE matrix. The singular value decomposition (SVD) expresses that matrix as a sequence of mutually orthogonal rank-one terms, ordered by the centered sum of squares each term represents. Notice what is observed and what is supplied by the model.

## Slide 66: Sign and directional limits

Source note: `factorization/singular-value-decomposition.qmd`

For any component, Software may thus reverse both signs without changing the fitted matrix. Interpretation should concern contrasts among loadings or scores, not a privileged positive orientation. Notice what is observed and what is supplied by the model.

## Slide 67: Sign and directional limits

Source note: `factorization/singular-value-decomposition.qmd`

The displayed expression formalizes sign and directional limits. For any component, Keep track of what each term refers to in the linguistic dataset.

## Slide 68: Checking the ordered patterns

Source note: `factorization/singular-value-decomposition.qmd`

1. What are the dimensions of $\mathbf U$, $\mathbf D$, and $\mathbf V$? 2. Why is each term $d_k\mathbf u_k\mathbf v_k^{\mathsf T}$ rank one? 3. Why do squared singular values add to centered sum of squares? 4. What does the scree plot summarize, and what does it not select? 5. The next page shows why the same right singular vectors are the principal-component directions of the centered PHOIBLE matrix. Keep the observational unit fixed while you interpret the result.

## Slide 69: Singular value decomposition

Source note: `factorization/singular-value-decomposition.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Singular value decomposition. Read the pattern before attaching a model interpretation to it.

## Slide 70: Principal component analysis

Source note: `factorization/principal-component-analysis.qmd`

We now turn to Principal component analysis. Principal component analysis (PCA) finds directions along which centered rows vary. For the PHOIBLE matrix, a row is an inventory record and a column is a segment listing. PCA thus summarizes covariance among database-segment columns. It does not use phonological labels, family names, or macroareas to fit the directions.

## Slide 71: Principal component analysis

Source note: `factorization/principal-component-analysis.qmd`

Principal component analysis (PCA) finds directions along which centered rows vary. For the PHOIBLE matrix, a row is an inventory record and a column is a segment listing. PCA thus summarizes covariance among database-segment columns. It does not use phonological labels, family names, or macroareas to fit the directions. Notice what is observed and what is supplied by the model.

## Slide 72: Beginning with variation around column means

Source note: `factorization/principal-component-analysis.qmd`

Let be the training-centered matrix. For a unit direction $\mathbf v$, the row scores are The interpretation is conditional on the sampling and measurement design.

## Slide 73: Beginning with variation around column means: equation 1

Source note: `factorization/principal-component-analysis.qmd`

The displayed expression formalizes beginning with variation around column means: equation 1. Let Keep track of what each term refers to in the linguistic dataset.

## Slide 74: Beginning with variation around column means: equation 2

Source note: `factorization/principal-component-analysis.qmd`

The displayed expression formalizes beginning with variation around column means: equation 2. be the training-centered matrix. For a unit direction $\mathbf v$, the row scores are Keep track of what each term refers to in the linguistic dataset.

## Slide 75: Beginning with variation around column means: equation 3

Source note: `factorization/principal-component-analysis.qmd`

The displayed expression formalizes beginning with variation around column means: equation 3. Their sample variance is Keep track of what each term refers to in the linguistic dataset.

## Slide 76: Beginning with variation around column means: equation 4

Source note: `factorization/principal-component-analysis.qmd`

The displayed expression formalizes beginning with variation around column means: equation 4. Define the sample covariance matrix Keep track of what each term refers to in the linguistic dataset.

## Slide 77: Beginning with variation around column means: equation 5

Source note: `factorization/principal-component-analysis.qmd`

The displayed expression formalizes beginning with variation around column means: equation 5. The first principal-component direction solves Keep track of what each term refers to in the linguistic dataset.

## Slide 78: Connecting PCA to the SVD

Source note: `factorization/principal-component-analysis.qmd`

If then That distinction will matter again on the next slide.

## Slide 79: Connecting PCA to the SVD: equation 1

Source note: `factorization/principal-component-analysis.qmd`

The displayed expression formalizes connecting pca to the svd: equation 1. If Keep track of what each term refers to in the linguistic dataset.

## Slide 80: Connecting PCA to the SVD: equation 2

Source note: `factorization/principal-component-analysis.qmd`

The displayed expression formalizes connecting pca to the svd: equation 2. then Keep track of what each term refers to in the linguistic dataset.

## Slide 81: Connecting PCA to the SVD: equation 3

Source note: `factorization/principal-component-analysis.qmd`

The displayed expression formalizes connecting pca to the svd: equation 3. Thus the PCA directions are the right singular vectors, and the covariance eigenvalues are Keep track of what each term refers to in the linguistic dataset.

## Slide 82: Connecting PCA to the SVD: equation 4

Source note: `factorization/principal-component-analysis.qmd`

The displayed expression formalizes connecting pca to the svd: equation 4. The component scores satisfy Keep track of what each term refers to in the linguistic dataset.

## Slide 83: Verifying the identity on PHOIBLE

Source note: `factorization/principal-component-analysis.qmd`

The largest eigenvalue difference is observed. The largest difference between the two score calculations is observed. These discrepancies reflect floating-point arithmetic. Principal component analysis (PCA) finds directions along which centered rows vary. For the PHOIBLE matrix, a row is an inventory record and a column is a segment listing. PCA thus summarizes covariance among database-segment columns. It does not use phonological labels, family names, or macroareas to fit the directions. Use the graph or equation to say the result in ordinary language.

## Slide 84: Plotting scores, then adding metadata

Source note: `factorization/principal-component-analysis.qmd`

Macroarea did not enter the matrix, centering, SVD, or covariance calculation. We add it only after fitting to ask whether the unsupervised coordinates display broad descriptive differences. The score clouds overlap substantially. Any apparent macroarea pattern may combine inventory size, source practices, genealogy, geography, and typological organization. The figure cannot distinguish those explanations because macroarea is neither a modeled cause nor the unit of the split. Now connect the notation back to the linguistic comparison.

## Slide 85: Interpreting the variance criterion narrowly

Source note: `factorization/principal-component-analysis.qmd`

PCA maximizes variance in the supplied representation. Here that representation contains centered binary listings for training-retained segments. A direction with high variance is not necessarily the best direction for reconstruction of hidden cells, classification, or a linguistic theory. Those targets require an external criterion. PCA also does not discover a group contrast merely because groups can be colored after fitting. If a labeled contrast is the target, the evaluation must withhold appropriate units and assess it directly. Keep the observational unit fixed while you interpret the result.

## Slide 86: Checking the variance direction

Source note: `factorization/principal-component-analysis.qmd`

1. Why must the matrix be centered before this covariance interpretation? 2. What quantity does $\mathbf v^{\mathsf T}\mathbf S\mathbf v$ measure? 3. Why are $\mathbf V$ and $\mathbf D^2/(n-1)$ the covariance eigenvectors and eigenvalues? 4. Which metadata enter the fit on this page? 5. Why can the macroarea facets not isolate a causal explanation? The next page separates the row coordinates from the segment directions and inspects both quantities without changing the fitted decomposition. The interpretation is conditional on the sampling and measurement design.

## Slide 87: Principal component analysis

Source note: `factorization/principal-component-analysis.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Principal component analysis. Read the pattern before attaching a model interpretation to it.

## Slide 88: Scores and loadings

Source note: `factorization/scores-and-loadings.qmd`

We now turn to Scores and loadings. The PHOIBLE decomposition produces two related objects with different units. Scores locate inventory records in the fitted component coordinates. Loadings describe directions across segment columns. Keeping these index sets separate prevents a segment contrast from being described as if it were an inventory property.

## Slide 89: Scores and loadings

Source note: `factorization/scores-and-loadings.qmd`

The PHOIBLE decomposition produces two related objects with different units. Scores locate inventory records in the fitted component coordinates. Loadings describe directions across segment columns. Keeping these index sets separate prevents a segment contrast from being described as if it were an inventory property. Notice what is observed and what is supplied by the model.

## Slide 90: Scores locate row objects

Source note: `factorization/scores-and-loadings.qmd`

Let $\mathbf Z$ be the centered training matrix and let $\mathbf V_K$ contain the first $K$ right singular vectors. The score matrix is For inventory record $i$ and component $k$, The interpretation is conditional on the sampling and measurement design.

## Slide 91: Scores locate row objects: equation 1

Source note: `factorization/scores-and-loadings.qmd`

The displayed expression formalizes scores locate row objects: equation 1. Let $\mathbf Z$ be the centered training matrix and let $\mathbf V_K$ contain the first $K$ right singular vectors. The score matrix is Keep track of what each term refers to in the linguistic dataset.

## Slide 92: Scores locate row objects: equation 2

Source note: `factorization/scores-and-loadings.qmd`

The displayed expression formalizes scores locate row objects: equation 2. For inventory record $i$ and component $k$, Keep track of what each term refers to in the linguistic dataset.

## Slide 93: Scores locate row objects: equation 3

Source note: `factorization/scores-and-loadings.qmd`

The displayed expression formalizes scores locate row objects: equation 3. Thus a score is a weighted sum of one centered inventory row. It is not a property of the Glottocode independently of the sampled inventory and retained segment representation. Keep track of what each term refers to in the linguistic dataset.

## Slide 94: Scores locate row objects: equation 4

Source note: `factorization/scores-and-loadings.qmd`

The displayed expression formalizes scores locate row objects: equation 4. From the SVD, Keep track of what each term refers to in the linguistic dataset.

## Slide 95: Loadings describe column directions

Source note: `factorization/scores-and-loadings.qmd`

The entry $v_{jk}$ is the weight of segment column $j$ in component direction $k$. In these notes, **loading** refers to the unit vector $\mathbf v_k$. Some software instead reports $\sqrt{\lambda_k}\mathbf v_k$, so the convention should always be stated. The score and loading matrices reconstruct the centered data: Use the graph or equation to say the result in ordinary language.

## Slide 96: Loadings describe column directions: equation 1

Source note: `factorization/scores-and-loadings.qmd`

The displayed expression formalizes loadings describe column directions: equation 1. The entry $v_{jk}$ is the weight of segment column $j$ in component direction $k$. In these notes, **loading** refers to the unit vector $\mathbf v_k$. Some software instead reports $\sqrt{\lambda_k}\mathbf v_k$, so the convention should always be stated. Keep track of what each term refers to in the linguistic dataset.

## Slide 97: Loadings describe column directions: equation 2

Source note: `factorization/scores-and-loadings.qmd`

The displayed expression formalizes loadings describe column directions: equation 2. The score and loading matrices reconstruct the centered data: Keep track of what each term refers to in the linguistic dataset.

## Slide 98: Extracting empirical scores and loadings

Source note: `factorization/scores-and-loadings.qmd`

The identifiers are joined only after the scores are computed. This keeps the row mapping explicit even if later filtering changes row order. The PHOIBLE decomposition produces two related objects with different units. Scores locate inventory records in the fitted component coordinates. Loadings describe directions across segment columns. Keeping these index sets separate prevents a segment contrast from being described as if it were an inventory property. The interpretation is conditional on the sampling and measurement design.

## Slide 99: Inspecting loading patterns

Source note: `factorization/scores-and-loadings.qmd`

The plot shows the twelve largest absolute weights for each of the first two directions. Segments on the same side contribute with the same sign, while segments on opposite sides define a contrast. Because the component may reverse sign, the important object is the relative pattern around zero. An isolated high loading does not name a component. Interpretation should ask whether a set of large weights forms a coherent pattern, whether the pattern is stable under resampling or nearby ranks, and whether independent evidence supports the proposed linguistic analysis. The present plot answers only the first question descriptively. Use the graph or equation to say the result in ordinary language.

## Slide 100: Rows, columns, and metadata

Source note: `factorization/scores-and-loadings.qmd`

Family and macroarea labels are properties of inventory rows. Segment symbols and segment classes are properties of columns. Joining either kind of metadata requires its stable identifier: Mixing these tables by row position would be a unit error: their rows index different objects. That distinction will matter again on the next slide.

## Slide 101: Checking rows and columns

Source note: `factorization/scores-and-loadings.qmd`

1. What does $t_{ik}$ index? 2. What does $v_{jk}$ index? 3. Why are $\mathbf Z\mathbf V$ and $\mathbf U\mathbf D$ equal? 4. Which loading convention do these notes use? 5. Why should a component be interpreted from a pattern rather than one segment? The next page combines scores and loadings to predict cells deliberately hidden from held-out inventory records. That distinction will matter again on the next slide.

## Slide 102: Scores and loadings

Source note: `factorization/scores-and-loadings.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Scores and loadings. Read the pattern before attaching a model interpretation to it.

## Slide 103: Reconstruction

Source note: `factorization/reconstruction.qmd`

We now turn to Reconstruction. Scores and loadings rebuild a matrix cell by cell. To make that algebra answer an empirical question, we use the **inventory-record completion target** (IRCT): learn segment structure from training inventories, choose rank with validation inventories, and reconstruct six cells hidden from each test inventory while its other retained segment cells remain visible.

## Slide 104: Reconstruction

Source note: `factorization/reconstruction.qmd`

Scores and loadings rebuild a matrix cell by cell. To make that algebra answer an empirical question, we use the **inventory-record completion target** (IRCT): learn segment structure from training inventories, choose rank with validation inventories, and reconstruct six cells hidden from each test inventory while its other retained segment cells remain visible. That distinction will matter again on the next slide.

## Slide 105: Reconstructing with the first $K$ terms

Source note: `factorization/reconstruction.qmd`

For centered training data, The reconstructed centered cell is Keep the observational unit fixed while you interpret the result.

## Slide 106: Reconstructing with the first $K$ terms: equation 1

Source note: `factorization/reconstruction.qmd`

The displayed expression formalizes reconstructing with the first $k$ terms: equation 1. For centered training data, Keep track of what each term refers to in the linguistic dataset.

## Slide 107: Reconstructing with the first $K$ terms: equation 2

Source note: `factorization/reconstruction.qmd`

The displayed expression formalizes reconstructing with the first $k$ terms: equation 2. The reconstructed centered cell is Keep track of what each term refers to in the linguistic dataset.

## Slide 108: Reconstructing with the first $K$ terms: equation 3

Source note: `factorization/reconstruction.qmd`

The displayed expression formalizes reconstructing with the first $k$ terms: equation 3. Returning to the original listing scale adds the training column mean: Keep track of what each term refers to in the linguistic dataset.

## Slide 109: Reconstructing with the first $K$ terms: equation 4

Source note: `factorization/reconstruction.qmd`

The displayed expression formalizes reconstructing with the first $k$ terms: equation 4. For an observed training matrix, the residual is Keep track of what each term refers to in the linguistic dataset.

## Slide 110: Reconstructing with the first $K$ terms: equation 5

Source note: `factorization/reconstruction.qmd`

The displayed expression formalizes reconstructing with the first $k$ terms: equation 5. and the fraction of centered sum of squares represented is Keep track of what each term refers to in the linguistic dataset.

## Slide 111: Reconstructing partially observed inventories

Source note: `factorization/reconstruction.qmd`

Let $\mathbf x_i^*$ be a held-out inventory row in which hidden cells have been replaced by their training-column means. Their centered values are thus zero. For rank $K$, and Now connect the notation back to the linguistic comparison.

## Slide 112: Reconstructing partially observed inventories: equation 1

Source note: `factorization/reconstruction.qmd`

The displayed expression formalizes reconstructing partially observed inventories: equation 1. Let $\mathbf x_i^*$ be a held-out inventory row in which hidden cells have been replaced by their training-column means. Their centered values are thus zero. For rank $K$, Keep track of what each term refers to in the linguistic dataset.

## Slide 113: Reconstructing partially observed inventories: equation 2

Source note: `factorization/reconstruction.qmd`

The displayed expression formalizes reconstructing partially observed inventories: equation 2. and Keep track of what each term refers to in the linguistic dataset.

## Slide 114: Building the split and masks

Source note: `factorization/reconstruction.qmd`

Validation selects rank observed. Only after that choice is fixed do we compute test loss. The segment-prevalence baseline has balanced Brier loss observed, whereas the low-rank reconstruction has loss observed. Scores and loadings rebuild a matrix cell by cell. To make that algebra answer an empirical question, we use the **inventory-record completion target** (IRCT): learn segment structure from training inventories, choose rank with validation inventories, and reconstruct six cells hidden from each test inventory while its other retained segment cells remain visible. The interpretation is conditional on the sampling and measurement design.

## Slide 115: Showing raw hidden cells and predictions

Source note: `factorization/reconstruction.qmd`

The raw points show all observed hidden test cells. The separated distributions indicate that the observed cells of a new inventory contain information about its hidden listings under this representation. Scores and loadings rebuild a matrix cell by cell. To make that algebra answer an empirical question, we use the **inventory-record completion target** (IRCT): learn segment structure from training inventories, choose rank with validation inventories, and reconstruct six cells hidden from each test inventory while its other retained segment cells remain visible. Notice what is observed and what is supplied by the model.

## Slide 116: Estimating the test gain

Source note: `factorization/reconstruction.qmd`

Take a minute before we move on. Balanced Brier loss gives listed and not-listed cells equal total weight: State the answer in terms of the dataset and the unit of analysis.

## Slide 117: Estimating the test gain

Source note: `factorization/reconstruction.qmd`

The displayed expression formalizes estimating the test gain. Balanced Brier loss gives listed and not-listed cells equal total weight: Keep track of what each term refers to in the linguistic dataset.

## Slide 118: What reconstruction establishes

Source note: `factorization/reconstruction.qmd`

The result supports a narrow conclusion: structure learned from training inventory records helps complete a few hidden database listings when most of a held-out record is observed. It does not reconstruct a wholly unseen inventory, establish phonological absence from a zero, or show that rank observed is a phonological universal. Scores and loadings rebuild a matrix cell by cell. To make that algebra answer an empirical question, we use the **inventory-record completion target** (IRCT): learn segment structure from training inventories, choose rank with validation inventories, and reconstruct six cells hidden from each test inventory while its other retained segment cells remain visible. That distinction will matter again on the next slide.

## Slide 119: Checking the rebuilt cells

Source note: `factorization/reconstruction.qmd`

1. Why are hidden cells filled with training-column means before projection? 2. Which cells estimate a held-out inventory's scores? 3. Why is observed reconstruction error not held-out prediction error? 4. Why does balanced Brier loss weight the two cell statuses equally? 5. What is the unit resampled by the bootstrap? The next page isolates the validation step that selected the retained rank without inspecting test loss. Notice what is observed and what is supplied by the model.

## Slide 120: Reconstruction

Source note: `factorization/reconstruction.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Reconstruction. Read the pattern before attaching a model interpretation to it.

## Slide 121: Choosing the number of components

Source note: `factorization/choosing-components.qmd`

We now turn to Choosing the number of components. The singular values describe how well components reconstruct the training matrix. They do not determine how many components reconstruct genuinely hidden entries. The inventory-record completion target thus separates three operations: fit directions on training inventories, choose rank on validation inventories, and estimate performance once on test inventories.

## Slide 122: Choosing the number of components

Source note: `factorization/choosing-components.qmd`

The singular values describe how well components reconstruct the training matrix. They do not determine how many components reconstruct genuinely hidden entries. The inventory-record completion target thus separates three operations: fit directions on training inventories, choose rank on validation inventories, and estimate performance once on test inventories. Now connect the notation back to the linguistic comparison.

## Slide 123: Separating fitting, selection, and evaluation

Source note: `factorization/choosing-components.qmd`

Let $\mathcal T$, $\mathcal V$, and $\mathcal E$ denote training, validation, and test inventory records. Training data determine: 1. which segment columns occur often enough to retain; 2. the segment means $\widehat{\boldsymbol\mu}_{\mathcal T}$; 3. the component directions $\mathbf V_{\mathcal T}$. Keep the observational unit fixed while you interpret the result.

## Slide 124: Separating fitting, selection, and evaluation: equation 1

Source note: `factorization/choosing-components.qmd`

The displayed expression formalizes separating fitting, selection, and evaluation: equation 1. Let $\mathcal T$, $\mathcal V$, and $\mathcal E$ denote training, validation, and test inventory records. Training data determine: Keep track of what each term refers to in the linguistic dataset.

## Slide 125: Separating fitting, selection, and evaluation: equation 2

Source note: `factorization/choosing-components.qmd`

The displayed expression formalizes separating fitting, selection, and evaluation: equation 2. 1. which segment columns occur often enough to retain; 2. the segment means $\widehat{\boldsymbol\mu}_{\mathcal T}$; 3. the component directions $\mathbf V_{\mathcal T}$. Keep track of what each term refers to in the linguistic dataset.

## Slide 126: Separating fitting, selection, and evaluation: equation 3

Source note: `factorization/choosing-components.qmd`

The displayed expression formalizes separating fitting, selection, and evaluation: equation 3. For a validation inventory with masked cells, scores at rank $K$ are Keep track of what each term refers to in the linguistic dataset.

## Slide 127: Separating fitting, selection, and evaluation: equation 4

Source note: `factorization/choosing-components.qmd`

The displayed expression formalizes separating fitting, selection, and evaluation: equation 4. and the reconstruction is Keep track of what each term refers to in the linguistic dataset.

## Slide 128: Implementing rank selection

Source note: `factorization/choosing-components.qmd`

The validation minimum occurs at rank observed. The line marks the result of the fixed selection rule; it is the only annotation needed to read the curve. The singular values describe how well components reconstruct the training matrix. They do not determine how many components reconstruct genuinely hidden entries. The inventory-record completion target thus separates three operations: fit directions on training inventories, choose rank on validation inventories, and estimate performance once on test inventories. Keep the observational unit fixed while you interpret the result.

## Slide 129: Preserving one final evaluation

Source note: `factorization/choosing-components.qmd`

The code below computes the test comparison only after `selected_rank` exists. The selected reconstruction reduces test balanced Brier loss from observed to observed. Balanced log loss moves in the same direction, from observed to observed. Notice what is observed and what is supplied by the model.

## Slide 130: Why other criteria answer different questions

Source note: `factorization/choosing-components.qmd`

Choosing a rank from observed training reconstruction rewards additional components by construction. A scree bend or a cumulative-variance threshold may summarize the observed matrix, but neither directly evaluates hidden cells. Conversely, validation loss is tied to the masking rule, loss function, and new-inventory target. Rank selection also includes preprocessing. Segment retention, centering, component fitting, and masking must remain inside their assigned partitions. Letting validation or test inventories determine retained columns would create leakage through preprocessing. Keep the observational unit fixed while you interpret the result.

## Slide 131: Checking rank selection

Source note: `factorization/choosing-components.qmd`

1. Which quantities are fitted on training inventories? 2. Which data choose the rank? 3. Why is the test set evaluated only once? 4. Why can the training reconstruction curve not select a predictive rank? 5. What generalization claim is blocked because family is not the split unit? The selected rank supports the IRCT, not a universal dimensionality claim. The final page moves to a supervised problem in which PCA compression itself must compete with the uncompressed linguistic predictor. Now connect the notation back to the linguistic comparison.

## Slide 132: Choosing the number of components

Source note: `factorization/choosing-components.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Choosing the number of components. Read the pattern before attaching a model interpretation to it.

## Slide 133: Interpretation

Source note: `factorization/choosing-components.qmd`

The selected rank supports the IRCT, not a universal dimensionality claim. The final page moves to a supervised problem in which PCA compression itself must compete with the uncompressed linguistic predictor. The interpretation is conditional on the sampling and measurement design.

## Slide 134: From VALEX distributions to MegaAcceptability profiles

Source note: `factorization/valex-megaacceptability.qmd`

We now turn to From VALEX distributions to MegaAcceptability profiles. The PHOIBLE sequence used factorization to reconstruct hidden cells. We now ask whether factorization improves a supervised linguistic prediction. The **distribution-to-selection mapping** (DSM) maps a verb's corpus distribution across VALEX subcategorization frames to its acceptability profile across MegaAcceptability frames, holding out the complete verb.

## Slide 135: From VALEX distributions to MegaAcceptability profiles

Source note: `factorization/valex-megaacceptability.qmd`

The PHOIBLE sequence used factorization to reconstruct hidden cells. We now ask whether factorization improves a supervised linguistic prediction. The **distribution-to-selection mapping** (DSM) maps a verb's corpus distribution across VALEX subcategorization frames to its acceptability profile across MegaAcceptability frames, holding out the complete verb. VALEX was acquired automatically from five corpora and the Web. Korhonen, Krymolowski, and Briscoe's dataset paper describes counts for English verb subcategorization frames and emphasizes automatic acquisition. The counts may contain parsing and frame-assignment error, and the release does not disambiguate verb senses. The interpretation is conditional on the sampling and measurement design.

## Slide 136: Defining the linguistic objects

Source note: `factorization/valex-megaacceptability.qmd`

The retained overlap contains one VALEX row per matched verb and one MegaAcceptability response profile per matched verb. If $c_{vj}$ is the automatically acquired count for verb $v$ in VALEX dimension $j$, define the within-verb proportion The row $\mathbf p_v$ represents the allocation of observed corpus evidence across frames, not total verb frequency. It is not a sense-specific grammatical description. Now connect the notation back to the linguistic comparison.

## Slide 137: Defining the linguistic objects: equation 1

Source note: `factorization/valex-megaacceptability.qmd`

The displayed expression formalizes defining the linguistic objects: equation 1. The retained overlap contains one VALEX row per matched verb and one MegaAcceptability response profile per matched verb. If $c_{vj}$ is the automatically acquired count for verb $v$ in VALEX dimension $j$, define the within-verb proportion Keep track of what each term refers to in the linguistic dataset.

## Slide 138: Defining the linguistic objects: equation 2

Source note: `factorization/valex-megaacceptability.qmd`

The displayed expression formalizes defining the linguistic objects: equation 2. The row $\mathbf p_v$ represents the allocation of observed corpus evidence across frames, not total verb frequency. It is not a sense-specific grammatical description. Keep track of what each term refers to in the linguistic dataset.

## Slide 139: Reading and checking the analysis inputs

Source note: `factorization/valex-megaacceptability.qmd`

The audited course bundle stores the raw inputs and validated predictions from the leakage-safe nested procedure. The R below reads every object used on this page and recomputes the reported summaries and figures. A complete R implementation of the fitting procedure follows in the next section. The empirical objects contain observed matched verbs, observed observed VALEX dimensions, observed experimental frames, and observed retained responses from observed participants. Use the graph or equation to say the result in ordinary language.

## Slide 140: Stating the competing procedures

Source note: `factorization/valex-megaacceptability.qmd`

The direct multivariate ridge model uses the complete VALEX proportion matrix. With an unpenalized intercept implemented by training centering, it solves The factor procedure fits PCA only to training predictor rows, The interpretation is conditional on the sampling and measurement design.

## Slide 141: Stating the competing procedures: equation 1

Source note: `factorization/valex-megaacceptability.qmd`

The displayed expression formalizes stating the competing procedures: equation 1. The direct multivariate ridge model uses the complete VALEX proportion matrix. With an unpenalized intercept implemented by training centering, it solves Keep track of what each term refers to in the linguistic dataset.

## Slide 142: Stating the competing procedures: equation 2

Source note: `factorization/valex-megaacceptability.qmd`

The displayed expression formalizes stating the competing procedures: equation 2. The factor procedure fits PCA only to training predictor rows, Keep track of what each term refers to in the linguistic dataset.

## Slide 143: Keeping every fitted choice inside training data

Source note: `factorization/valex-megaacceptability.qmd`

Five repetitions of ten-fold outer cross-validation hold out complete verbs. Within every outer training set, independent five-fold validation selects the direct ridge penalty and jointly selects factor rank and ridge penalty. Participant normalization, response aggregation, predictor centering, PCA loadings, rank, and penalty are refitted in the relevant training split. The fixed candidate sets are: That distinction will matter again on the next slide.

## Slide 144: Defining held-out skill

Source note: `factorization/valex-megaacceptability.qmd`

The baseline predicts the outer-training mean separately for each response frame. For model $m$, define Positive values improve on the frame-mean baseline. The paired compression contrast is Now connect the notation back to the linguistic comparison.

## Slide 145: Defining held-out skill: equation 1

Source note: `factorization/valex-megaacceptability.qmd`

The displayed expression formalizes defining held-out skill: equation 1. The baseline predicts the outer-training mean separately for each response frame. For model $m$, define Keep track of what each term refers to in the linguistic dataset.

## Slide 146: Defining held-out skill: equation 2

Source note: `factorization/valex-megaacceptability.qmd`

The displayed expression formalizes defining held-out skill: equation 2. Positive values improve on the frame-mean baseline. The paired compression contrast is Keep track of what each term refers to in the linguistic dataset.

## Slide 147: Showing outcomes and held-out fits

Source note: `factorization/valex-megaacceptability.qmd`

Each verb-frame cell receives one prediction in every outer repetition. We average those five held-out predictions only for plotting. Both fitted procedures recover substantial ordering across held-out cells, though dispersion around the identity line remains. The panels are similar because PCA preserves much, but not all, of the direct predictive signal. That distinction will matter again on the next slide.

## Slide 148: Inspecting selected rank

Source note: `factorization/valex-megaacceptability.qmd`

Inner validation selects rank observed, the largest candidate, in all observed outer fits. This result does not identify that rank as the number of grammatical dimensions. It suggests that directions beyond the tested compression remain predictively useful. The PHOIBLE sequence used factorization to reconstruct hidden cells. We now ask whether factorization improves a supervised linguistic prediction. The **distribution-to-selection mapping** (DSM) maps a verb's corpus distribution across VALEX subcategorization frames to its acceptability profile across MegaAcceptability frames, holding out the complete verb. Notice what is observed and what is supplied by the model.

## Slide 149: Locating the predictive limitation

Source note: `factorization/valex-megaacceptability.qmd`

White and Rawlins report a marked weakness for finite clauses preceded by a direct object. The audit fixed the corresponding frame-family comparison before inspecting the new procedure. Direct skill for finite clauses without an object is observed, but falls to observed for the matched object frames. PCA does not repair this difference. Use the graph or equation to say the result in ordinary language.

## Slide 150: What the application establishes

Source note: `factorization/valex-megaacceptability.qmd`

First, automatically acquired VALEX distributions contain information about MegaAcceptability profiles for verbs excluded from fitting. Second, PCA compression does not improve that mapping: the selected factor procedure performs slightly and stably worse than the direct profile. The teaching analysis differs from the paper in three declared ways. It uses raw VALEX proportions rather than the paper's best Beta Negative Binomial representation, PCA rather than a logistic factor model, and a fold-fitted z transformation rather than the released ordinal mixed-effects normalization. Those changes isolate the matrix operations taught here while preserving the held-out-verb question. Use the graph or equation to say the result in ordinary language.

## Slide 151: Checking the reasoning

Source note: `factorization/valex-megaacceptability.qmd`

1. What does one VALEX row represent, and which sense distinction does it omit? 2. Why are counts converted to within-verb proportions? 3. Why must participant normalization be refitted inside each split? 4. What is held constant between the direct and factor procedures? 5. The live empirical question is which theory-guided representation of communicativity, argument structure, or event structure can improve held-out prediction without discarding the useful direct distributional signal. Notice what is observed and what is supplied by the model.

## Slide 152: From VALEX distributions to MegaAcceptability profiles

Source note: `factorization/valex-megaacceptability.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for From VALEX distributions to MegaAcceptability profiles. Read the pattern before attaching a model interpretation to it.

## Slide 153: From VALEX distributions to MegaAcceptability profiles

Source note: `factorization/valex-megaacceptability.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for From VALEX distributions to MegaAcceptability profiles. Read the pattern before attaching a model interpretation to it.

## Slide 154: From VALEX distributions to MegaAcceptability profiles

Source note: `factorization/valex-megaacceptability.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for From VALEX distributions to MegaAcceptability profiles. Read the pattern before attaching a model interpretation to it.

## Slide 155: From VALEX distributions to MegaAcceptability profiles

Source note: `factorization/valex-megaacceptability.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for From VALEX distributions to MegaAcceptability profiles. Read the pattern before attaching a model interpretation to it.

## Slide 156: From VALEX distributions to MegaAcceptability profiles

Source note: `factorization/valex-megaacceptability.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for From VALEX distributions to MegaAcceptability profiles. Read the pattern before attaching a model interpretation to it.

## Slide 157: From VALEX distributions to MegaAcceptability profiles

Source note: `factorization/valex-megaacceptability.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for From VALEX distributions to MegaAcceptability profiles. Read the pattern before attaching a model interpretation to it.

## Slide 158: From VALEX distributions to MegaAcceptability profiles

Source note: `factorization/valex-megaacceptability.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for From VALEX distributions to MegaAcceptability profiles. Read the pattern before attaching a model interpretation to it.

## Slide 159: Interpretation

Source note: `factorization/valex-megaacceptability.qmd`

The live empirical question is which theory-guided representation of communicativity, argument structure, or event structure can improve held-out prediction without discarding the useful direct distributional signal. Now connect the notation back to the linguistic comparison.
