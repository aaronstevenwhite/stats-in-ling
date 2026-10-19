# Random variables and probability distributions

This transcript is generated from the speaker notes in the slide source. Slide identifiers, titles, note-page provenance, and order are identical.

## Slide 1: Random variables and probability distributions

Source note: `random-variables-and-distributions/index.qmd`

Welcome to Random variables and probability distributions. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.

## Slide 2: From outcomes to distributions

Source note: `random-variables-and-distributions/index.qmd`

Our next step is From outcomes to distributions.

## Slide 3: From outcomes to distributions

Source note: `random-variables-and-distributions/index.qmd`

The foundations module gave us a probability space $\langle\Omega,\mathcal F,\mathbb{P}\rangle$. But a linguistic outcome in $\Omega$ may be a complete token, utterance, or annotated tree, while the next analysis may need only its duration, case, or dependency length. How do we move from the complete outcome to the particular property named in the research question?

## Slide 4: From outcomes to distributions

Source note: `random-variables-and-distributions/index.qmd`

A random variable maps each outcome to a value without replacing the outcome that supports it. More specifically, it is a measurable function from outcomes to values, so questions about those values correspond to events in $\mathcal F$.

## Slide 5: From outcomes to distributions

Source note: `random-variables-and-distributions/index.qmd`

For a pronoun-token outcome space, a case variable can be defined by

$$
C(\omega)
\equiv
\text{the annotated case value of token }\omega.
$$

## Slide 6: From outcomes to distributions

Source note: `random-variables-and-distributions/index.qmd`

If $\mathcal X_C$ is the set of case values attested under the declared filtering rule, its value space and sigma-algebra are

$$
\mathcal G_C\equiv 2^{\mathcal X_C}.
$$

## Slide 7: From outcomes to distributions

Source note: `random-variables-and-distributions/index.qmd`

Now take any set of case values $B\in\mathcal G_C$. The event we can assign probability to is the set of pronoun outcomes that $C$ sends into $B$, that is, the preimage $C^{-1}(B)$. Thus the distribution of $C$ assigns $B$ the probability

$$
\mathbb{P}(C\in B)
\equiv
\mathbb{P}\!\left(C^{-1}(B)\right).
$$

## Slide 8: From outcomes to distributions

Source note: `random-variables-and-distributions/index.qmd`

As a function of $B$, this assignment is a probability measure on $\langle\mathcal X_C,\mathcal G_C\rangle$. We retain $\mathbb{P}$ for the probability measure on $\langle\Omega,\mathcal F\rangle$ and introduce no second measure symbol. Expressions such as $\mathbb{P}(C=c)$ abbreviate the corresponding preimage events. Lowercase $p$ and $q$ denote PMFs; lowercase $f$ and $g$ denote PDFs; uppercase $F$ and $G$ denote CDFs. These conventions stay fixed throughout the module.

## Slide 9: Random variables and one-variable distributions

Source note: `random-variables-and-distributions/index.qmd`

We first explain why random variables are needed and then give the measurable-function definition. These pages assume the foundations treatment of event spaces and sigma-algebras. The next pages introduce discrete random variables and their probability mass functions, followed by absolutely continuous random variables and their probability density functions. A page on cumulative distribution functions then gives the representation shared by both types. This order states what values are possible and immediately specifies how probability is assigned to them.

## Slide 10: Expectations and moments

Source note: `random-variables-and-distributions/index.qmd`

Once a distribution has been represented, we can ask what features of it one number might summarize. The expected value is an integral with respect to a probability distribution when that integral exists. The notes then develop expectations of functions, linearity of expectation, and failure of finite expectations. Variance, standard deviation, and central moments summarize specified powers of centered values. Each summary assumes the relevant expectation exists.

## Slide 11: Distribution families

Source note: `random-variables-and-distributions/index.qmd`

We next reuse those objects in particular observation models. The discrete families are categorical, Bernoulli, binomial, hypergeometric, geometric, negative binomial, and Poisson. Their supports and probability mass functions differ because they represent different observation processes. The page order moves from one finite-category draw to totals, waits, and exposure-based counts.

## Slide 12: Distribution families

Source note: `random-variables-and-distributions/index.qmd`

The continuous families are uniform, beta, normal, chi-squared, and Student's t. Each page states the support, parameterization, and density or defining construction before using the family. The sampling pages then show how a CDF turns a basic uniform draw into a draw from another distribution and how a random seed makes the computational realization reproducible.

## Slide 13: Joint distributions

Source note: `random-variables-and-distributions/index.qmd`

Finally, we move from one variable to several. A joint distribution preserves value pairings from the same outcome. Marginalization sums or integrates out one coordinate. Conditional independence states that one conditional distribution is invariant to an additional conditioning variable. Conditional expectation, covariance, and correlation summarize features of conditional or joint distributions. These pages rely on the foundations definitions of joint event probability, conditional probability, and independence, so they give only working reminders of those ideas.

## Slide 14: Joint distributions

Source note: `random-variables-and-distributions/index.qmd`

The chapter dependency graph records the prerequisite relations among these definitions. Begin with why random variables are needed.

## Slide 15: Why use random variables?

Source note: `random-variables-and-distributions/why-random-variables.qmd`

Our next step is Why use random variables.

## Slide 16: CMUdict: the empirical object

Source note: `random-variables-and-distributions/why-random-variables.qmd`

The data source is CMUdict 0.7b. It provides pronunciation entries with phone and vowel counts.

## Slide 17: Why use random variables?

Source note: `random-variables-and-distributions/why-random-variables.qmd`

The foundations chapter defined outcomes and sample spaces, events, and probability measures. An outcome in a pronunciation lexicon may be a complete entry containing an orthographic form, a pronunciation variant, and an ordered phone sequence. But a research question may concern only the number of phones. How can we ask a probability question about that number while retaining the complete entry as the outcome?

## Slide 18: Why use random variables?

Source note: `random-variables-and-distributions/why-random-variables.qmd`

A random variable resolves this mismatch by mapping a rich outcome to the particular value used in an analysis.

## Slide 19: The pronunciation-entry outcomes

Source note: `random-variables-and-distributions/why-random-variables.qmd`

We use the CMU Pronouncing Dictionary (CMUdict) version 0.7b, a machine-readable pronunciation lexicon for US English developed for speech technology. The pinned source is distributed under CMU's permissive license, and the prepared teaching table retains every pronunciation entry and its ARPAbet phone sequence. It then deterministically counts all phones and vowel phones, identifying vowels from CMUdict's stress digits. The data record gives the source checksum, preprocessing, and license.

## Slide 20: The pronunciation-entry outcomes

Source note: `random-variables-and-distributions/why-random-variables.qmd`

One row is one dictionary pronunciation, not a word token in running speech. Alternate pronunciations of one orthographic form are separate, related rows, and CMUdict supplies no token frequencies. Thus every probability on this page describes uniform sampling from this pinned lexicon.

## Slide 21: The pronunciation-entry outcomes

Source note: `random-variables-and-distributions/why-random-variables.qmd`

Let $\Omega$ contain the 133,854 pronunciation-entry outcomes. Define

$$
X(\omega)\equiv\text{number of phones in pronunciation entry }\omega
$$

and

$$
V(\omega)\equiv\text{number of vowel phones in pronunciation entry }\omega.
$$

## Slide 22: The pronunciation-entry outcomes

Source note: `random-variables-and-distributions/why-random-variables.qmd`

The outcome remains the complete entry. The mappings return two numerical properties of that entry.

## Slide 23: The pronunciation-entry outcomes

Source note: `random-variables-and-distributions/why-random-variables.qmd`

This figure shows observed phone and vowel-phone counts. Point area represents the number of pronunciation entries with each pair of values.

## Slide 24: Values give us new events

Source note: `random-variables-and-distributions/why-random-variables.qmd`

We derive a threshold from the empirical phone-count distribution rather than choosing a convenient number.

## Slide 25: Values give us new events

Source note: `random-variables-and-distributions/why-random-variables.qmd`

The empirical third quartile is 8 phones. The event above that threshold is

$$
\{\omega\in\Omega\mid X(\omega)>q_{.75}\},
$$

where $q_{.75}=8$ phones is the observed third quartile in CMUdict.

## Slide 26: Values give us new events

Source note: `random-variables-and-distributions/why-random-variables.qmd`

It contains 20,253 pronunciation entries and has empirical probability 0.151. The event contains outcomes, not bare counts.

## Slide 27: Values give us new events

Source note: `random-variables-and-distributions/why-random-variables.qmd`

Basically, a **random variable** maps outcomes to values. More specifically, a probability statement about values denotes the corresponding event in the original outcome space. The next page makes this correspondence precise with preimages and measurability.

## Slide 28: One outcome can support several questions

Source note: `random-variables-and-distributions/why-random-variables.qmd`

The same pronunciation can satisfy both $X(\omega)=x$ and $V(\omega)=v$. The two mappings do not compete because they encode different questions about the same represented entry.

## Slide 29: One outcome can support several questions

Source note: `random-variables-and-distributions/why-random-variables.qmd`

This separation matters because a stored linguistic record is usually richer than any one response. Keeping the outcome identifier, orthographic form, and phone sequence lets a later analysis study alternate pronunciations or particular phone patterns. Replacing the entry with its count would remove those possibilities.

## Slide 30: Why use random variables?: question 1

Source note: `random-variables-and-distributions/why-random-variables.qmd`

Use `cmu` to list the entries in the event $V=1$. Why are the entries, rather than the number one, the event members?

## Slide 31: Why use random variables?: answer 1

Source note: `random-variables-and-distributions/why-random-variables.qmd`

The event $V=1$ contains the 16,935 pronunciation-entry rows with one vowel phone; the rows are members because an event is a subset of outcomes, while one is the mapped value.

## Slide 32: Why use random variables?: question 2

Source note: `random-variables-and-distributions/why-random-variables.qmd`

Define a random variable that maps a pronunciation entry to its number of consonant phones. Verify from the data that $X=V+C$ for every entry.

## Slide 33: Why use random variables?: answer 2

Source note: `random-variables-and-distributions/why-random-variables.qmd`

Defining $C(\omega)$ as the consonant-phone count gives `all(cmu$phone_count == cmu$vowel_phone_count + cmu$consonant_phone_count)`, so $X=V+C$ for every entry.

## Slide 34: Why use random variables?: question 3

Source note: `random-variables-and-distributions/why-random-variables.qmd`

Change `phone_threshold` to the empirical median. How many outcomes belong to the resulting upper-tail event?

## Slide 35: Why use random variables?: answer 3

Source note: `random-variables-and-distributions/why-random-variables.qmd`

The empirical median is 6 phones, and the strict upper-tail event $X>6$ contains 56,478 outcomes.

## Slide 36: Why use random variables?: question 4

Source note: `random-variables-and-distributions/why-random-variables.qmd`

Which information is lost if `phone_count` replaces the complete pronunciation-entry record?

## Slide 37: Why use random variables?: answer 4

Source note: `random-variables-and-distributions/why-random-variables.qmd`

Replacing the full record with `phone_count` loses word identity, pronunciation identity and sequence, stress information, and the vowel-consonant composition.

## Slide 38: Defining random variables

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

Next, we take up Defining random variables.

## Slide 39: Defining random variables

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

The preceding page introduced a random variable as a function from complete outcomes to values. But not every function between arbitrary measurable spaces automatically supports probability statements. What property must the mapping have? We now add the measurability condition that answers this question.

## Slide 40: Defining random variables

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

We continue with the pinned CMUdict pronunciation table introduced on the preceding page. Let $V$ map each pronunciation entry to its number of vowel phones.

## Slide 41: Distinguishing the two spaces

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

Let $\langle\Omega,\mathcal F\rangle$ be the measurable space of pronunciation-entry outcomes, using the event space introduced earlier. Let $\langle\mathcal X,\mathcal G\rangle$ be the measurable space of nonnegative integer counts. The function has the form

$$
V:\Omega\longrightarrow\mathcal X.
$$

## Slide 42: Distinguishing the two spaces

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

The set $\mathcal X$ is the declared codomain of $V$, written $\operatorname{cod}(V)$. A statement such as $v\in\operatorname{cod}(V)$ refers to the declared value space. It does not mean that $v$ appeared in the observed resource, and it does not require that $v$ have positive probability.

## Slide 43: Distinguishing the two spaces

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

For current purposes, we take

$$
\mathcal X\equiv\mathbb Z_{\geq0}
$$

and let $\mathcal G$ contain all subsets of $\mathcal X$.

## Slide 44: Distinguishing the two spaces

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

This codomain includes counts absent from the pinned lexicon.

## Slide 45: Working backward with a preimage

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

We use the observed median vowel-phone count to define a set in the value space.

## Slide 46: Working backward with a preimage

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

Before writing notation, state the operation in words: collect every pronunciation entry whose vowel-phone count equals the empirical median. The result is

$$
V^{-1}(\{q_{.5}\})
\equiv
\{\omega\in\Omega\mid V(\omega)\in\{q_{.5}\}\}.
$$

## Slide 47: Working backward with a preimage

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

This set is the **preimage** of $\{q_{.5}\}$ under $V$. Here $q_{.5}$ is 2, and the preimage contains 61,493 entries.

## Slide 48: Working backward with a preimage

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

The superscript $-1$ does not say that $V$ has an inverse function. Many pronunciation entries map to the same vowel count, so the count cannot recover one unique entry. The preimage collects all of them.

## Slide 49: Working backward with a preimage

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

Empirical vowel-phone counts. The accent bar marks the value whose preimage is inspected above.

## Slide 50: Stating measurability

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

The function $V$ is a random variable when

$$
E\in\mathcal G
\quad\Longrightarrow\quad
V^{-1}(E)\in\mathcal F.
$$

## Slide 51: Stating measurability

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

This condition is called **measurability**. It says that every measurable question about the value corresponds to a measurable event in the original outcome space.

## Slide 52: Stating measurability

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

If $\{q_{.5}\}\in\mathcal G$, then the set of pronunciation entries in its preimage must belong to $\mathcal F$. Otherwise the expression “the probability that a pronunciation has the median vowel count” would refer to an event to which the model assigns no probability.

## Slide 53: Stating measurability

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

In this finite empirical model, $\mathcal F\equiv2^\Omega$, so every preimage is measurable because every subset of pronunciation entries belongs to $\mathcal F$. The requirement becomes more substantive for larger outcome spaces, but its interpretation remains the same.

## Slide 54: Reading probability notation through the preimage

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

Once $V$ is defined, probability notation for its values is shorthand:

$$
\mathbb{P}(V=q_{.5})
\equiv
\mathbb{P}\bigl(V^{-1}(\{q_{.5}\})\bigr).
$$

## Slide 55: Reading probability notation through the preimage

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

Similarly,

$$
\mathbb{P}(V\leq q_{.5})
$$

means the probability of the preimage of all values at or below the median.

## Slide 56: Reading probability notation through the preimage

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

The probability measure still acts on an event of outcomes.

## Slide 57: Defining random variables: question 1

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

Use `cmu` to compute $V^{-1}(\{1\})$. How many pronunciation entries does it contain?

## Slide 58: Defining random variables: answer 1

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

$V^{-1}(\{1\})$ contains the 16,935 pronunciation-entry outcomes with exactly one vowel phone.

## Slide 59: Defining random variables: question 2

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

Why is a preimage a set of pronunciation entries rather than a set of vowel counts?

## Slide 60: Defining random variables: answer 2

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

A preimage is a subset of the domain, so its members are pronunciation entries mapped to one rather than the output value one itself.

## Slide 61: Defining random variables: question 3

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

State the measurability condition in words.

## Slide 62: Defining random variables: answer 3

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

Measurability requires the preimage of every measurable set of output values to be a measurable event in the pronunciation-entry space.

## Slide 63: Defining random variables: question 4

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

Use `at_most_median_preimage` to compute the empirical probability $\mathbb{P}(V\leq q_{.5})$.

## Slide 64: Defining random variables: answer 4

Source note: `random-variables-and-distributions/defining-random-variables.qmd`

The empirical probability is $\mathbb{P}(V\leq q_{.5})=(16{,}935+61{,}493)/133{,}854=0.585922$. We now know what a random variable must preserve. The next page considers variables whose possible values can be listed.

## Slide 65: Discrete random variables

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

Now we turn to Discrete random variables.

## Slide 66: Discrete random variables

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

The formal definition of a random variable requires a measurable mapping from outcomes to values. We now ask a different question: can the possible values be listed one at a time? The answer separates discrete variables from the continuous variables introduced later.

## Slide 67: Discrete random variables

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

We continue with the CMUdict pronunciation outcomes. Let $X$ map an entry to its total number of phones.

## Slide 68: Discrete random variables

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

We declare

$$
\operatorname{cod}(X)=\mathbb Z_{\geq0},
$$

whose values begin

$$
0,1,2,3,\ldots
$$

## Slide 69: Discrete random variables

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

There is no fixed largest pronunciation length in this declared model, but the codomain values can be placed in a list. This property makes $X$ a **discrete random variable**.

## Slide 70: Discrete random variables

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

The **support** is the subset that receives positive probability:

$$
\operatorname{supp}(X)
\equiv\{x\in\operatorname{cod}(X):\mathbb{P}(X=x)>0\}.
$$

## Slide 71: Discrete random variables

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

In the finite empirical distribution over this pinned lexicon, the observed support contains 22 values, from 1 through 32 phones, with gaps allowed. The declared codomain is larger. This distinction prevents an observed maximum from becoming a claim about every possible English pronunciation.

## Slide 72: Discrete random variables

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

This figure shows the empirical support of total phone count consists of separate integer values.

## Slide 73: Finite and countably infinite sets

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

More specifically, a random variable is discrete when some finite or countably infinite set $\mathcal S$ satisfies $\mathbb{P}(X\in\mathcal S)=1$. *Countably infinite* means that every value can be assigned a position in a sequence even though the sequence has no final value.

## Slide 74: Finite and countably infinite sets

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

The observed phone-count support is finite. The declared nonnegative-integer codomain is countably infinite. Both are discrete because their values occur as separate, listable possibilities.

## Slide 75: Finite and countably infinite sets

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

Support values need not be numerical. The derived `first_phone` variable is a finite, unordered discrete variable: its values are ARPAbet labels. Numerical coding may be convenient in software, but it does not create discreteness.

## Slide 76: Values define separate events

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

For any observed count $x$, the statement $X=x$ corresponds to the event

$$
\{\omega\in\Omega\mid X(\omega)=x\},
$$

which contains every pronunciation entry with exactly $x$ phones.

## Slide 77: Values define separate events

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

An upper-tail statement corresponds to

$$
\{\omega\in\Omega\mid X(\omega)\in\{x,x+1,x+2,\ldots\}\}.
$$

## Slide 78: Values define separate events

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

For a discrete variable, each support value can be considered separately. A single value may receive positive probability.

## Slide 79: Discrete is not the same as unordered

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

`first_phone` is usually treated as a set of categories without a numerical distance between them. Total phone count is ordered, and a difference in counts has an interpretation in phones. Both variables are discrete.

## Slide 80: Discrete is not the same as unordered

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

Thus discreteness concerns whether the probability-carrying values are separate and listable. It does not determine whether the codomain is ordered or whether arithmetic on its labels is meaningful.

## Slide 81: Discrete random variables: question 1

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

Which integer values between the observed minimum and maximum are absent from `observed_support`?

## Slide 82: Discrete random variables: answer 1

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

Between the observed minimum 1 and maximum 32, the absent phone counts are 21-27 and 29-31.

## Slide 83: Discrete random variables: question 2

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

Why is `first_phone` discrete even though its values are not numbers?

## Slide 84: Discrete random variables: answer 2

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

`first_phone` is discrete because its possible ARPABET labels form a countable set, even though those labels are not numbers.

## Slide 85: Discrete random variables: question 3

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

Use `cmu` to define an event containing pronunciations at or above the empirical third quartile of `phone_count`.

## Slide 86: Discrete random variables: answer 3

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

The empirical third quartile is 8 phones, so the event $\{\omega:X(\omega)\geq8\}$ contains 35,473 pronunciation entries.

## Slide 87: Discrete random variables: question 4

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

Explain why the largest observed count does not determine the upper end of the declared codomain.

## Slide 88: Discrete random variables: answer 4

Source note: `random-variables-and-distributions/discrete-random-variables.qmd`

The largest observed CMUdict phone count only describes this finite resource; the declared codomain can include unobserved larger counts for other pronunciation entries. The codomain declares the values to which a PMF assigns mass, including zero mass. The next page defines that assignment.

## Slide 89: Probability mass functions

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

Now we turn to Probability mass functions.

## Slide 90: Probability mass functions

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

The preceding page distinguished a random variable's declared codomain from its positive-probability support. Knowing that CMUdict phone count $X$ is discrete does not tell us how often its values occur. What object pairs each possible count with its probability?

## Slide 91: Probability mass functions

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

We answer this question with the empirical distribution over the CMUdict pronunciation entries introduced earlier. Uniformly sampling one row gives each pronunciation entry the same mass; aggregating those row masses by `phone_count` produces an empirical probability mass function.

## Slide 92: Probability mass functions

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

Basically, we need a lookup rule from values to probabilities. More specifically, the function assigning a probability to each codomain value is a **probability mass function**, abbreviated **PMF**. We write

$$
p_X:\mathbb Z_{\geq0}\to[0,1],
\qquad
p_X(x)\equiv\mathbb{P}(X=x).
$$

## Slide 93: Probability mass functions

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

For the empirical lexicon distribution with $N$ entries,

$$
\widehat p_X(x)
\equiv
\frac{1}{N}\sum_{i=1}^N\mathbb 1\{X(\omega_i)=x\}.
$$

## Slide 94: Probability mass functions

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

The capital $X$ denotes the random variable. The lowercase $x$ stands for one possible value.

## Slide 95: Probability mass functions

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

The most frequent value is 6 phones, with mass 0.203. By the PMF definition, this is the empirical probability of the event containing all pronunciation entries with that phone count.

## Slide 96: Checking the two PMF requirements

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

First, a PMF must assign nonnegative mass:

$$
p_X(x)\geq0
\qquad\text{for every }x\in\operatorname{cod}(X).
$$

## Slide 97: Checking the two PMF requirements

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

Second, the masses across the codomain must sum to one:

$$
\sum_{x\in\operatorname{cod}(X)}p_X(x)=1.
$$

## Slide 98: Checking the two PMF requirements

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

Values in the codomain but outside the support contribute zero, so this sum has the same numerical value as a sum restricted to $\operatorname{supp}(X)$. The displayed assertions check nonnegativity and normalization from the data.

## Slide 99: Checking the two PMF requirements

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

This figure shows empirical PMF of total phone count under uniform sampling from the pinned CMUdict pronunciation entries.

## Slide 100: Adding mass across selected values

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

The probability that $X$ exceeds its empirical third quartile is

$$
\begin{aligned}
\mathbb{P}(X>q_{.75})
&=\sum_{\substack{x\in\operatorname{cod}(X)\\x>q_{.75}}}p_X(x).
\end{aligned}
$$

## Slide 101: Adding mass across selected values

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

Here $q_{.75}$ is 8 phones and the computed tail mass is 0.151. We add masses because exact-count events do not overlap.

## Slide 102: Interpreting zero mass carefully

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

If $p_X(x)=0$, then $X=x$ has zero probability under the stated empirical model. This may mean only that the count does not occur in the pinned lexicon. It does not mean that no English pronunciation with that count can exist.

## Slide 103: Interpreting zero mass carefully

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

The PMF belongs to a represented sampling process. A lexicon weighted by pronunciation entries and a corpus weighted by word tokens would generally assign different masses to the same phone counts.

## Slide 104: Probability mass functions: question 1

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

Use `phone_frequency` to compute $\mathbb{P}(X\leq q_{.75})$ and verify it by averaging a logical condition over `cmu$phone_count`.

## Slide 105: Probability mass functions: answer 1

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

The third quartile is 8 phones, and both the PMF sum and `mean(cmu$phone_count <= 8)` give $\mathbb{P}(X\leq q_{.75})=0.848693$.

## Slide 106: Probability mass functions: question 2

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

Find an integer inside the observed minimum--maximum range that has zero mass. Does it belong to the declared codomain?

## Slide 107: Probability mass functions: answer 2

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

The integer 21 lies between the observed minimum and maximum but has mass zero; it still belongs to the declared nonnegative-integer codomain.

## Slide 108: Probability mass functions: question 3

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

Recompute the PMF over unique `word` values after retaining only one pronunciation per word. Which probability experiment has changed?

## Slide 109: Probability mass functions: answer 3

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

Retaining one pronunciation for each of 133,228 unique words changes the experiment from sampling a pronunciation entry to sampling a word with one selected pronunciation.

## Slide 110: Probability mass functions: question 4

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

Why would dropping rare counts and renormalizing define a conditional distribution rather than preserve the PMF above?

## Slide 111: Probability mass functions: answer 4

Source note: `random-variables-and-distributions/probability-mass-functions.qmd`

Dropping rare counts restricts the experiment to the event that the count was retained, and renormalization thus produces the conditional PMF given that event. A PMF assigns mass to separate support values. The next page considers a model whose values instead fill an interval.

## Slide 112: Continuous random variables

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

Next, we take up Continuous random variables.

## Slide 113: Hillenbrand et al. (1995): the empirical object

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

The data source is Hillenbrand et al. (1995). It provides American English /hVd/ vowel tokens with acoustic measurements.

## Slide 114: Continuous random variables

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

The discrete variable page treated separate, listable support values. Acoustic measurements such as vowel duration are different: between two possible durations lie indefinitely many others. How should probability be represented when modeled values fill an interval rather than occupy separate points?

## Slide 115: Hillenbrand vowel duration

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

We use the vowel measurements from Hillenbrand, Getty, Clark, and Wheeler (1995). The study recorded men, women, and children producing 12 American English vowels in /hVd/ words, measured duration and formant trajectories, and collected listener identifications. The prepared teaching table is the audited `phonTools::h95` table from package version 0.2-2.2 under its BSD-2-Clause license; the data record documents the source and checksum.

## Slide 116: Hillenbrand vowel duration

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

One row is one vowel token nested within one speaker, and each speaker contributes one token for each vowel. The package imputed some F2 and F3 measurements, but our focal duration and F1 columns are complete. We restrict attention to adult men producing *heed* /i/, giving one token per speaker and avoiding a mixture over vowels.

## Slide 117: Hillenbrand vowel duration

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

Let $D$ map a token to its vowel duration in milliseconds. A useful modeled support is

$$
\operatorname{supp}(D)=(0,\infty)
$$

because durations are positive.

## Slide 118: Hillenbrand vowel duration

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

This support is a modeling choice about the acoustic quantity, not a claim that the recording system stored infinitely precise values.

## Slide 119: Hillenbrand vowel duration

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

This figure shows raw durations for adult men producing /i/ in Hillenbrand et al. (1995). Small vertical jitter separates overlapping records.

## Slide 120: Hillenbrand vowel duration

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

One tempting definition calls every variable with an uncountable range continuous. That definition is too weak for current purposes: an uncountable range does not guarantee that probability can be represented by a density. We use *continuous random variable* for the stronger, absolutely continuous case.

## Slide 121: Hillenbrand vowel duration

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

To see why range and distribution must be separated, consider paired duration and F1 measurements. Let

$$
\Omega\equiv\mathbb R_+^2
$$

and equip this space with its Borel sigma-algebra.

## Slide 122: Hillenbrand vowel duration

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

Define the identity random vector

$$
X:\mathbb R_+^2\to\mathbb R_+^2,
\qquad
X(\omega)\equiv\omega.
$$

For every Borel set $B\subseteq\mathbb R_+^2$,

$$
X^{-1}(B)=B,
$$

so $X$ is measurable.

## Slide 123: Hillenbrand vowel duration

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

This fact alone does not make its distribution absolutely continuous. Absolute continuity additionally requires the probability measure to admit a density with respect to two-dimensional Lebesgue measure.

## Slide 124: Hillenbrand vowel duration

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

More specifically, a random variable $X$ is **absolutely continuous** when there is a nonnegative function $f_X$ such that

$$
\mathbb{P}(X\in A)=\int_A f_X(x)\,\mathrm dx
$$

for every measurable set $A$.

## Slide 125: Hillenbrand vowel duration

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

We use *continuous random variable* for this class.

## Slide 126: A recorded value and a modeled point

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

The durations are stored as whole milliseconds. We derive the observed median and its empirical mass directly from the table.

## Slide 127: A recorded value and a modeled point

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

In the empirical distribution of the stored records, the value 240 ms has mass 0.022. Under an absolutely continuous model,

$$
\mathbb{P}(D=d)=0
$$

for every exact duration $d$, including the recorded median.

## Slide 128: A recorded value and a modeled point

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

This does not make a duration near $d$ impossible. An interval around it may have positive probability:

$$
\mathbb{P}(d-\varepsilon<D<d+\varepsilon)>0.
$$

## Slide 129: A recorded value and a modeled point

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

The distinction is between a stored, rounded measurement and a continuous model of the acoustic quantity. A spreadsheet column containing integers does not settle that representational choice.

## Slide 130: Continuous random variables: question 1

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

Why does the empirical distribution assign positive mass to `median_duration` while an absolutely continuous model assigns point probability zero?

## Slide 131: Continuous random variables: answer 1

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

The empirical distribution places mass $1/45=0.022222$ at the recorded median of 240 ms, whereas an absolutely continuous model assigns $\mathbb{P}(D=240)=0$.

## Slide 132: Continuous random variables: question 2

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

Give one reason to model the integer durations as rounded observations from a continuous process and one reason to analyze the recorded integers discretely.

## Slide 133: Continuous random variables: answer 2

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

A continuous model can represent integer milliseconds as rounded measurements of latent duration, while a discrete analysis respects the actual recorded values without adding that measurement model.

## Slide 134: Continuous random variables: question 3

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

Which dependence was removed by restricting to one vowel token per adult male speaker? Which population limitation remains?

## Slide 135: Continuous random variables: answer 3

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

Selecting one /i/ token per adult male speaker removes repeated-speaker dependence within the subset, but the result remains limited to sampled adult men and the study's regional population.

## Slide 136: Continuous random variables: question 4

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

Is a manually assigned five-point prominence score continuous? Explain from its response process rather than its display format.

## Slide 137: Continuous random variables: answer 4

Source note: `random-variables-and-distributions/continuous-random-variables.qmd`

A manually assigned five-point prominence score is discrete and ordinal because its response process offers only five ordered categories, regardless of numeric display. A continuous support cannot be represented by a PMF over individual points. The next page represents probability by area across intervals.

## Slide 138: Probability density functions

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

Next, we take up Probability density functions.

## Slide 139: Probability density functions

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

The preceding page explained why a continuous distribution assigns zero probability to an exact value. A table of point masses thus cannot describe how probability is arranged across the modeled duration support. If individual points have zero probability, what quantity lets us recover the probability of an interval?

## Slide 140: Probability density functions

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

Basically, we describe how quickly probability accumulates near each value and compute interval probability as area. More specifically, a **probability density function**, abbreviated **PDF**, is a function $f_D:\mathbb R\to[0,\infty)$ satisfying

$$
\mathbb{P}(D\in A)=\int_A f_D(d)\,\mathrm dd
$$

for every measurable set $A$.

## Slide 141: Probability density functions

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

Probability is obtained by integration, not by reading the density at one point.

## Slide 142: Probability density functions

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

We estimate a descriptive density for the Hillenbrand adult-men /i/ durations introduced on the preceding page. This kernel density is a smoothed representation of the observed values, not a model fitted in the original paper.

## Slide 143: Area, not height

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

The distinction between density and probability is visible in

$$
\mathbb{P}(D=d)=0
$$

even when $f_D(d)>0$.

## Slide 144: Area, not height

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

The height describes how quickly probability accumulates near $d$; it is not the probability of exactly $d$.

## Slide 145: Area, not height

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

We use the observed median as the center of a one-millisecond recording bin and integrate the fitted density over that bin.

## Slide 146: Area, not height

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

Thus the fitted interval probability is

$$
\mathbb{P}(d-.5<D<d+.5)
=\int_{d-.5}^{d+.5}f_D(u)\,\mathrm du,
$$

where $d$ is the empirical median of the adult-women /I/ durations.

## Slide 147: Area, not height

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

The resulting probability is 0.0099. It is area over a one-millisecond bin, not the density height at the median.

## Slide 148: Area, not height

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

Raw adult-men /i/ durations and a kernel density estimate. The rug shows every observed token.

## Slide 149: Checking the PDF requirements

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

A density must be nonnegative:

$$
f_D(d)\geq0
\qquad\text{for every }d.
$$

## Slide 150: Checking the PDF requirements

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

Its total area must equal one:

$$
\int_{-\infty}^{\infty}f_D(d)\,\mathrm dd=1.
$$

## Slide 151: Checking the PDF requirements

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

These conditions concern area, so a density height may exceed one when probability is concentrated on a narrow interval. That fact does not produce a probability larger than one.

## Slide 152: Interpreting density in measurement units

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

The density $f_D(d)$ has units reciprocal to those of $D$. Because $D$ is measured in milliseconds, $f_D(d)$ is measured per millisecond. Multiplying by an interval width in milliseconds cancels the units and produces a unitless probability.

## Slide 153: Interpreting density in measurement units

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

This unit check is another reason not to interpret density height as probability. The two objects have different units as well as different mathematical roles.

## Slide 154: Probability density functions: question 1

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

Modify `bin_lower` and `bin_upper` to span five milliseconds around the empirical median. How does the fitted interval probability change?

## Slide 155: Probability density functions: answer 1

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

Expanding the interval to 237.5-242.5 ms raises the fitted KDE probability from 0.009857 for the one-millisecond interval to 0.049246 for the five-millisecond interval.

## Slide 156: Probability density functions: question 2

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

Why can a density height exceed one without producing a probability larger than one?

## Slide 157: Probability density functions: answer 2

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

Density has inverse-measurement units, so its height may exceed one while probability remains the area under the curve and the total area remains one.

## Slide 158: Probability density functions: question 3

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

What does `density_function(median_duration)` describe, and what does it not describe?

## Slide 159: Probability density functions: answer 3

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

`density_function(240)` is the fitted density height, about 0.009857 per millisecond; it is neither a point probability nor an interval probability.

## Slide 160: Probability density functions: question 4

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

Which parts of this page come from the observed Hillenbrand tokens, and which part is the descriptive smoothing model?

## Slide 161: Probability density functions: answer 4

Source note: `random-variables-and-distributions/probability-density-functions.qmd`

The 45 duration tokens and their histogram are observed Hillenbrand data, whereas `density()` supplies the descriptive kernel-smoothing model. Mass and density represent probability differently. The next page gives one threshold function that applies to both representations.

## Slide 162: Cumulative distribution functions

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

The next topic is Cumulative distribution functions.

## Slide 163: Cumulative distribution functions

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

The earlier pages represented discrete probability with a probability mass function and continuous probability with a probability density function. Must we switch representations every time we move between the two kinds of variable? A cumulative distribution function gives one threshold-based representation that applies to both.

## Slide 164: Cumulative distribution functions

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

A **cumulative distribution function**, abbreviated **CDF**, records the probability at or below every threshold:

$$
F_X:\mathbb R\to[0,1],
\qquad
F_X(x)\equiv\mathbb{P}(X\leq x).
$$

## Slide 165: Cumulative distribution functions

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

The function accumulates probability from the lower end of the support through the threshold $x$.

## Slide 166: Cumulative distribution functions

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

We compute the empirical CDF (ECDF) of the Hillenbrand adult-men /i/ durations. One row is one token from one adult male speaker.

## Slide 167: Constructing a discrete CDF

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

For a discrete variable,

$$
F_X(x)
=\sum_{\substack{x'\in\operatorname{cod}(X)\\x'\leq x}}p_X(x').
$$

## Slide 168: Constructing a discrete CDF

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

The ECDF treats each observed duration record as a discrete outcome with equal mass. It consequently increases in jumps at recorded values, even though we may model the underlying acoustic quantity as continuous.

## Slide 169: Constructing a discrete CDF

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

Empirical cumulative distribution of adult-men /i/ duration. Rug marks show the observed tokens.

## Slide 170: Accumulating a continuous density

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

For an absolutely continuous variable with density $f_X$, the same definition is represented by area:

$$
F_X(x)=\int_{-\infty}^{x}f_X(x')\,\mathrm dx'.
$$

## Slide 171: Accumulating a continuous density

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

The operation changes from summing masses to integrating density, but the interpretation remains $\mathbb{P}(X\leq x)$.

## Slide 172: Accumulating a continuous density

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

The probability in an interval above $a$ and at or below $b$ is

$$
\begin{aligned}
\mathbb{P}(a<X\leq b)
&=F_X(b)-F_X(a).
\end{aligned}
$$

## Slide 173: Accumulating a continuous density

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

Under the empirical quartile thresholds, $\mathbb{P}(q_{.25}<D\leq q_{.75})=0.511$; ties at the lower threshold matter because the event is open on the left.

## Slide 174: Reading the threshold direction

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

The definition always uses the lower tail:

$$
F_X(x)\equiv\mathbb{P}(X\leq x).
$$

## Slide 175: Reading the threshold direction

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

An upper-tail probability follows by complementation:

$$
\mathbb{P}(X>x)=1-F_X(x).
$$

## Slide 176: Reading the threshold direction

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

Thus the empirical probability above 268 ms is 0.222. This value comes from the observed durations; it is not a claim about all American English /i/ productions.

## Slide 177: Cumulative distribution functions: question 1

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

Use `duration_ecdf()` to compute the empirical probability at or below the observed median duration.

## Slide 178: Cumulative distribution functions: answer 1

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

At the observed median of 240 ms, `duration_ecdf(240) = 23/45 = 0.511111`.

## Slide 179: Cumulative distribution functions: question 2

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

Verify the upper-tail probability above `q75` by averaging a logical condition over `adult_i$duration_ms`.

## Slide 180: Cumulative distribution functions: answer 2

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

The direct upper-tail calculation is `mean(adult_i$duration_ms > 268) = 10/45 = 0.222222`, equal to $1-F(268)$.

## Slide 181: Cumulative distribution functions: question 3

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

Why does the ECDF jump even when duration is modeled as an underlying continuous quantity?

## Slide 182: Cumulative distribution functions: answer 3

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

The ECDF jumps because it assigns equal positive mass to each of the 45 recorded tokens, even if the underlying duration process is modeled continuously.

## Slide 183: Cumulative distribution functions: question 4

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

Change the interval to $[q_{.25},q_{.75}]$. Which records are added relative to the interval used above?

## Slide 184: Cumulative distribution functions: answer 4

Source note: `random-variables-and-distributions/cumulative-distribution-functions.qmd`

Changing $(q_{.25},q_{.75}]$ to $[q_{.25},q_{.75}]$ adds the one record at 219 ms, increasing the interval probability by $1/45$. The CDF describes probability through every threshold. The next page compresses a complete distribution into one probability-weighted center.

## Slide 185: Expected values

Source note: `random-variables-and-distributions/expected-values.qmd`

Next, we take up Expected values.

## Slide 186: Expected values

Source note: `random-variables-and-distributions/expected-values.qmd`

The earlier pages introduced probability mass functions and probability density functions. We can now ask how to summarize the center of either distribution with one number. We do this by returning to total phone count in the pinned CMUdict pronunciation table.

## Slide 187: Expected values

Source note: `random-variables-and-distributions/expected-values.qmd`

The **expected value** weights each value by its probability. It is also called the mean of the distribution when the weighted average exists. For a discrete random variable,

$$
\mathbb{E}[X]
\equiv
\sum_{x\in\operatorname{cod}(X)}x\,p_X(x).
$$

## Slide 188: Expected values

Source note: `random-variables-and-distributions/expected-values.qmd`

Applying this definition to the empirical phone-count PMF gives

$$
\widehat{\mathbb{E}}[X]
=\sum_x x\,\widehat p_X(x).
$$

## Slide 189: Expected values

Source note: `random-variables-and-distributions/expected-values.qmd`

The displayed computation returns 6.381 phones. Averaging the distinct support values without their masses instead gives 12.273, because that calculation treats rare and frequent counts alike.

## Slide 190: Expected values

Source note: `random-variables-and-distributions/expected-values.qmd`

Each bar is a phone count's contribution to the empirical expectation, x times its empirical mass.

## Slide 191: Expected values

Source note: `random-variables-and-distributions/expected-values.qmd`

The figure makes the weighting operation visible. A value contributes when it is large, frequent, or both; summing all bar heights recovers the expected phone count.

## Slide 192: Interpreting a value outside the support

Source note: `random-variables-and-distributions/expected-values.qmd`

The expected value need not be a possible observed value. Phone counts are integers, but 6.381 is not an integer. It summarizes the empirical distribution rather than describing one dictionary entry.

## Slide 193: Interpreting a value outside the support

Source note: `random-variables-and-distributions/expected-values.qmd`

If $X_1,X_2,\ldots$ were independent draws from this empirical PMF, their sample mean would have expectation $\mathbb{E}[X]$ for every sample size. The later treatment of Monte Carlo uncertainty explains the additional conditions under which sample averages stabilize near this value. For current purposes, the expectation is a property of a distribution over pronunciation entries.

## Slide 194: The continuous form

Source note: `random-variables-and-distributions/expected-values.qmd`

For an absolutely continuous variable $Y$ with density $f_Y$, suppose

$$
\int_{-\infty}^{\infty}|y|f_Y(y)\,\mathrm dy<\infty.
$$

## Slide 195: The continuous form

Source note: `random-variables-and-distributions/expected-values.qmd`

Its expected value is

$$
\mathbb{E}[Y]
\equiv
\int_{-\infty}^{\infty}y f_Y(y)\,\mathrm dy.
$$

## Slide 196: The continuous form

Source note: `random-variables-and-distributions/expected-values.qmd`

The factor $y$ weights the probability density at each value. Absolute integrability guarantees that the expectation is finite. The discrete sum and continuous integral implement the same operation.

## Slide 197: Distribution-family calculations

Source note: `random-variables-and-distributions/expected-values.qmd`

If $K\sim\operatorname{Geometric}(\pi)$ counts failures before the first success, then

$$
\begin{aligned}
\mathbb{E}[K]
&=\sum_{k=0}^{\infty}k(1-\pi)^k\pi\\
&=\pi(1-\pi)
  \sum_{k=1}^{\infty}k(1-\pi)^{k-1}\\
&=\frac{1-\pi}{\pi}.
\end{aligned}
$$

## Slide 198: Distribution-family calculations

Source note: `random-variables-and-distributions/expected-values.qmd`

If $Y\sim\operatorname{Beta}(\alpha,\beta)$, then

$$
\begin{aligned}
\mathbb{E}[Y]
&=\int_0^1
y\frac{y^{\alpha-1}(1-y)^{\beta-1}}{B(\alpha,\beta)}
\,\mathrm dy\\
&=\frac{B(\alpha+1,\beta)}{B(\alpha,\beta)}\\
&=\frac{\alpha}{\alpha+\beta}.
\end{aligned}
$$

## Slide 199: Distribution-family calculations

Source note: `random-variables-and-distributions/expected-values.qmd`

These equations are derived properties of the corresponding PMF and PDF. They are not definitions of the geometric or beta families.

## Slide 200: Expected values: question 1

Source note: `random-variables-and-distributions/expected-values.qmd`

Recompute the empirical expectation for `phone_count` from its PMF.

## Slide 201: Expected values: answer 1

Source note: `random-variables-and-distributions/expected-values.qmd`

Summing $x p_X(x)$ over the empirical PMF gives $\mathbb{E}[X]=6.380586$ phones.

## Slide 202: Expected values: question 2

Source note: `random-variables-and-distributions/expected-values.qmd`

Why can the expected phone count fail to be an observed count?

## Slide 203: Expected values: answer 2

Source note: `random-variables-and-distributions/expected-values.qmd`

An expectation is a probability-weighted average, so it need not be an integer or one of the observed phone counts.

## Slide 204: Expected values: question 3

Source note: `random-variables-and-distributions/expected-values.qmd`

Which quantity provides the weights in a discrete expectation?

## Slide 205: Expected values: answer 3

Source note: `random-variables-and-distributions/expected-values.qmd`

The discrete expectation uses the PMF value $p_X(x)$ as the weight attached to each possible count $x$.

## Slide 206: Expected values: question 4

Source note: `random-variables-and-distributions/expected-values.qmd`

Compare the PMF-weighted expectation with the mean of the raw `phone_count` column. Why must they agree here?

## Slide 207: Expected values: answer 4

Source note: `random-variables-and-distributions/expected-values.qmd`

The PMF-weighted expectation and the raw-column mean both equal 6.380586 because the PMF groups the same 133,854 rows by count without changing their total weight. Expected value averages the original values. The next page asks how to average a transformed property of those values.

## Slide 208: Expectations of functions

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

Next, we take up Expectations of functions.

## Slide 209: Expectations of functions

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

The preceding page defined expectation as a probability-weighted average. Now suppose the quantity of interest is a function of pronunciation length rather than length itself. Should we average first and then transform, or transform each possible value and then average? This page separates those two operations using the CMUdict phone-count distribution.

## Slide 210: Transforming first, then averaging

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

For a discrete random variable, when $\sum_{x\in\operatorname{cod}(X)}|g(x)|p_X(x)<\infty$,

$$
\mathbb{E}[g(X)]
\equiv
\sum_{x\in\operatorname{cod}(X)}g(x)p_X(x).
$$

## Slide 211: Transforming first, then averaging

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

For an absolutely continuous random variable, when $\int|g(x)|f_X(x)\,\mathrm dx<\infty$,

$$
\mathbb{E}[g(X)]
\equiv
\int_{-\infty}^{\infty}g(x)f_X(x)\,\mathrm dx.
$$

## Slide 212: Transforming first, then averaging

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

We can use the distribution of $X$ directly. We do not need to derive a separate distribution for $g(X)$ before computing the expectation.

## Slide 213: Transforming first, then averaging

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

For the transformation $g(x)=x^2$, the empirical expectation is 45.278 phones squared.

## Slide 214: Transforming first, then averaging

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

This figure shows contribution of each observed phone count to the expectation of squared phone count.

## Slide 215: Transforming first, then averaging

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

The rare long entries contribute visibly because squaring gives large counts more weight. This is a mathematical summary of the pinned lexicon; it is not a theory of lexical-processing cost.

## Slide 216: Comparing two orders of operation

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

Squaring the expected phone count gives

$$
g(\mathbb{E}[X])=\mathbb{E}[X]^2,
$$

which equals 40.712 phones squared for the empirical CMUdict PMF.

## Slide 217: Comparing two orders of operation

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

This differs from 45.278, the expectation of the squared counts.

## Slide 218: Comparing two orders of operation

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

The two operations answer different questions. $g(\mathbb{E}[X])$ transforms the center of the original values, whereas $\mathbb{E}[g(X)]$ transforms every possible value and then averages the transformed results. Thus, for a nonlinear function $g$,

$$
g(\mathbb{E}[X])\neq\mathbb{E}[g(X)]
$$

in general.

## Slide 219: Interpreting the transformed expectation

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

The transformed expectation is expressed in the units created by $g$. Here those units are phones squared. A substantive interpretation would require a phonological or processing account that motivates the transformation. Mathematical validity does not supply that theory.

## Slide 220: Interpreting the transformed expectation

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

Choosing $g$ specifies which property is being averaged. The function should thus be stated before its expectation is interpreted.

## Slide 221: Expectations of functions: question 1

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

Use the displayed PMF to compute $\mathbb{E}[2X+1]$.

## Slide 222: Expectations of functions: answer 1

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

For the CMUdict total-phone variable $X$, the displayed PMF gives $\mathbb{E}[2X+1]=13.761173$.

## Slide 223: Expectations of functions: question 2

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

Compute $2\mathbb{E}[X]+1$ and compare it with your first answer.

## Slide 224: Expectations of functions: answer 2

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

$2\mathbb{E}[X]+1=2(6.380586)+1=13.761173$, exactly matching the direct transformed expectation.

## Slide 225: Expectations of functions: question 3

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

Explain why $\mathbb{E}[X^2]$ differs from $\mathbb{E}[X]^2$ in the data.

## Slide 226: Expectations of functions: answer 3

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

$\mathbb{E}[X^2]=45.278012$ exceeds $\mathbb{E}[X]^2=40.711882$ by $\operatorname{Var}[X]=4.566130$, because the phone counts vary.

## Slide 227: Expectations of functions: question 4

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

Replace `g` with `log1p`. Which units and substantive interpretation would the transformed expectation have?

## Slide 228: Expectations of functions: answer 4

Source note: `random-variables-and-distributions/expectation-of-functions.qmd`

Using `log1p` gives $\mathbb{E}[\log(1+X)]=1.957686$ in log-count units, interpretable as the mean log-transformed pronunciation length rather than a mean number of phones.

## Slide 229: Linearity of expectation

Source note: `random-variables-and-distributions/linearity-of-expectation.qmd`

Next, we take up Linearity of expectation.

## Slide 230: Linearity of expectation

Source note: `random-variables-and-distributions/linearity-of-expectation.qmd`

The preceding page showed that a nonlinear transformation is ordinarily applied before its expectation is taken. A linear combination has an additional simplification. In a CMUdict pronunciation, total phone count $X$ is the sum of vowel-phone count $V$ and consonant-phone count $C$. Must we derive a new PMF for $X$ before finding its expectation?

## Slide 231: Linearity of expectation

Source note: `random-variables-and-distributions/linearity-of-expectation.qmd`

Basically, we can average each contribution and then add those averages. More specifically, **linearity of expectation** gives

$$
\mathbb{E}[X]
=\mathbb{E}[V+C]
=\mathbb{E}[V]+\mathbb{E}[C].
$$

## Slide 232: Linearity of expectation

Source note: `random-variables-and-distributions/linearity-of-expectation.qmd`

The expected vowel and consonant contributions are 2.469 and 3.911 phones. Their sum is the empirical expected total, 6.381 phones.

## Slide 233: Linearity of expectation

Source note: `random-variables-and-distributions/linearity-of-expectation.qmd`

This figure shows every observed total phone count equals the sum of its vowel and consonant counts. Point area represents repeated count pairs.

## Slide 234: Stating the general rule

Source note: `random-variables-and-distributions/linearity-of-expectation.qmd`

For random variables $X_1,\ldots,X_n$ satisfying $\mathbb{E}[|X_i|]<\infty$ and constants $a_1,\ldots,a_n$,

$$
\mathbb{E}\!\left[\sum_{i=1}^n a_iX_i\right]
=\sum_{i=1}^n a_i\mathbb{E}[X_i].
$$

## Slide 235: Stating the general rule

Source note: `random-variables-and-distributions/linearity-of-expectation.qmd`

For two variables and an added constant, this gives

$$
\mathbb{E}[aX+bY+c]
=a\mathbb{E}[X]+b\mathbb{E}[Y]+c.
$$

## Slide 236: Stating the general rule

Source note: `random-variables-and-distributions/linearity-of-expectation.qmd`

The expectation operation passes through sums and constant multiples.

## Slide 237: Indicators

Source note: `random-variables-and-distributions/linearity-of-expectation.qmd`

An indicator $I_A$ takes value one when event $A$ occurs and zero otherwise. Define $\pi_A\equiv p_{I_A}(1)$. Then

$$
\begin{aligned}
\mathbb{E}[I_A]
&=0\times p_{I_A}(0)+1\times p_{I_A}(1)\\
&=\pi_A.
\end{aligned}
$$

## Slide 238: Indicators

Source note: `random-variables-and-distributions/linearity-of-expectation.qmd`

We verify the identity with the data-derived event that vowel-phone count equals its empirical median.

## Slide 239: Independence is not required

Source note: `random-variables-and-distributions/linearity-of-expectation.qmd`

Vowel and consonant counts are associated across pronunciation entries. Their empirical covariance is 0.784 phones squared. Linearity nevertheless holds because it concerns sums and marginal expectations, not products.

## Slide 240: Independence is not required

Source note: `random-variables-and-distributions/linearity-of-expectation.qmd`

The linear rule should not be extended to nonlinear operations. In general,

$$
\mathbb{E}[XY]
\neq\mathbb{E}[X]\mathbb{E}[Y].
$$

That product equality requires additional conditions.

## Slide 241: Linearity of expectation: question 1

Source note: `random-variables-and-distributions/linearity-of-expectation.qmd`

Verify linearity for the transformed count $2V+C$ using the row values and the component means.

## Slide 242: Linearity of expectation: answer 1

Source note: `random-variables-and-distributions/linearity-of-expectation.qmd`

The row mean of $2V+C$ is 8.849799, and $2\mathbb{E}[V]+\mathbb{E}[C]=2(2.469213)+3.911374=8.849799$.

## Slide 243: Linearity of expectation: question 2

Source note: `random-variables-and-distributions/linearity-of-expectation.qmd`

Why does the expected total calculation not require independent vowel and consonant counts?

## Slide 244: Linearity of expectation: answer 2

Source note: `random-variables-and-distributions/linearity-of-expectation.qmd`

Linearity applies to sums and constant multiples regardless of dependence, so vowel and consonant counts need not be independent.

## Slide 245: Linearity of expectation: question 3

Source note: `random-variables-and-distributions/linearity-of-expectation.qmd`

Show from the two possible indicator values that $\mathbb{E}[I_A]=p_{I_A}(1)$.

## Slide 246: Linearity of expectation: answer 3

Source note: `random-variables-and-distributions/linearity-of-expectation.qmd`

Because $I_A$ takes only 0 and 1, $\mathbb{E}[I_A]=0\,p_{I_A}(0)+1\,p_{I_A}(1)=p_{I_A}(1)$.

## Slide 247: Linearity of expectation: question 4

Source note: `random-variables-and-distributions/linearity-of-expectation.qmd`

Which operation in $\mathbb{E}[VC]$ prevents direct use of linearity?

## Slide 248: Linearity of expectation: answer 4

Source note: `random-variables-and-distributions/linearity-of-expectation.qmd`

The product in $\mathbb{E}[VC]$ is not a linear combination, so it cannot be separated without an additional condition such as independence. Linearity simplifies expectations that exist. The next page asks what must be checked before treating an expectation as a finite summary.

## Slide 249: When an expectation does not exist

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

Our next step is When an expectation does not exist.

## Slide 250: When an expectation does not exist

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

The expected value page required an absolute sum or integral. Why do we need that condition when a symmetric distribution appears to balance around its center? The Cauchy family gives a case in which a visual center exists but the probability-weighted mean does not.

## Slide 251: When an expectation does not exist

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

The Cauchy family exposes expectation failure here; its support for negative durations makes it inadequate for vowel duration.

## Slide 252: The Cauchy density

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

For $x_0\in\mathbb R$ and $\gamma>0$, write

$$
X\sim\operatorname{Cauchy}(x_0,\gamma)
$$

when $X$ has density

$$
f_X(x)
\equiv
\frac{1}{\pi\gamma
\left[1+\left(\frac{x-x_0}{\gamma}\right)^2\right]},
\qquad x\in\mathbb R.
$$

## Slide 253: The Cauchy density

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

The fitted location is 239.48 ms and the fitted scale is 23.51 ms. These values are computed from the observed tokens, but the curve is a reference distribution rather than observed speech data.

## Slide 254: The Cauchy density

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

Observed adult-men /i/ durations and the data-calibrated Cauchy reference. The curve is not proposed as a phonetic model.

## Slide 255: Checking the two sides before combining them

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

For the standard Cauchy density,

$$
x f_X(x)=\frac{x}{\pi(1+x^2)}.
$$

## Slide 256: Checking the two sides before combining them

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

Consider the positive part:

$$
\begin{aligned}
\int_0^b \frac{x}{\pi(1+x^2)}\,\mathrm dx
&=\frac{1}{2\pi}\log(1+b^2).
\end{aligned}
$$

## Slide 257: Checking the two sides before combining them

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

As $b\to\infty$, this quantity diverges to $+\infty$. By symmetry, the integral over the negative half-line diverges to $-\infty$. An expectation exists only when these two parts can be combined without making the result depend on how the limits are taken. Here they cannot, so

$$
\mathbb{E}[X]
$$

is undefined.

## Slide 258: Checking the two sides before combining them

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

Changing $x_0$ and $\gamma$ does not repair this failure.

## Slide 259: Principal value is not expectation

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

For every finite $b>0$,

$$
\int_{-b}^{b}x f_X(x)\,\mathrm dx=0.
$$

## Slide 260: Principal value is not expectation

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

Taking the symmetric limit produces a Cauchy principal value of zero. An expectation is not defined by forcing the positive and negative truncation bounds to approach infinity at the same rate. It requires the probability-weighted integral itself to exist. Thus the principal value is not $\mathbb{E}[X]$.

## Slide 261: Finite samples do not repair the model expectation

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

Every finite sample of Cauchy draws has a finite arithmetic mean, but that fact does not imply that the distribution has an expected value. We compare running means from two procedures: bootstrap draws from the observed duration distribution and simulated draws from the data-calibrated Cauchy reference.

## Slide 262: Finite samples do not repair the model expectation

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

Running means from empirical-duration bootstrap draws and simulated Cauchy-reference draws. The Cauchy paths are not observed speech data.

## Slide 263: Finite samples do not repair the model expectation

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

The bootstrap paths target the finite empirical mean of the observed durations. The Cauchy paths have no such target; their horizontal line marks the fitted location, not an expectation. An extreme simulated draw may move a Cauchy sample mean by an arbitrarily large amount.

## Slide 264: When an expectation does not exist: question 1

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

Evaluate the antiderivative of $x/[\pi(1+x^2)]$.

## Slide 265: When an expectation does not exist: answer 1

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

An antiderivative is $\int x/[\pi(1+x^2)]\,\mathrm dx=\log(1+x^2)/(2\pi)+C$.

## Slide 266: When an expectation does not exist: question 2

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

Explain why symmetry does not define the Cauchy mean.

## Slide 267: When an expectation does not exist: answer 2

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

Symmetry does not define the Cauchy mean because the positive and negative expectation integrals diverge separately, so their subtraction is undefined.

## Slide 268: When an expectation does not exist: question 3

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

Distinguish the Cauchy principal value from an expected value.

## Slide 269: When an expectation does not exist: answer 3

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

A Cauchy principal value takes a coordinated symmetric limit that may cancel, whereas an expected value requires the positive and negative parts to be separately finite.

## Slide 270: When an expectation does not exist: question 4

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

Which elements of the figures are observed Hillenbrand data, which are estimates from those data, and which are simulated references?

## Slide 271: When an expectation does not exist: answer 4

Source note: `random-variables-and-distributions/when-expectations-fail.qmd`

The duration histogram uses observed Hillenbrand tokens; the KDE, location, and scale are estimates from those tokens; the bootstrap and Cauchy running-mean paths are simulated references. Symmetry identifies a geometric center but does not guarantee a finite expected value. The later summaries in this module, including variance, likewise require their defining expectations to exist.

## Slide 272: Variance and covariance

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

Next, we take up Variance and covariance.

## Slide 273: Variance and covariance

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

The expected value page summarized the center of a distribution. But the mean does not say how tightly probability is concentrated around that center. We now measure spread in the CMUdict total phone-count distribution and then ask how vowel and consonant counts vary together.

## Slide 274: Variance and covariance

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

Basically, we need to average distance from the mean without letting positive and negative deviations cancel. The **variance** does this by summarizing expected squared distance:

$$
\operatorname{Var}[X]
\equiv
\mathbb{E}\!\left[(X-\mathbb{E}[X])^2\right].
$$

## Slide 275: Variance and covariance

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

For the empirical PMF,

$$
\widehat{\operatorname{Var}}(X)
=\sum_x (x-\widehat{\mathbb{E}}[X])^2\widehat p_X(x).
$$

## Slide 276: Variance and covariance

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

The denominator is the number of CMUdict entries because this variance describes the complete finite release, rather than an external population sample.

## Slide 277: Variance and covariance

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

This figure shows contribution of each observed phone count to the empirical population variance.

## Slide 278: Variance and covariance

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

The rare, long pronunciations contribute more than their small masses alone would suggest because variance squares their distances from the mean.

## Slide 279: Why square the deviations?

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

The expected signed deviation is

$$
\mathbb{E}[X-\mathbb{E}[X]]=0.
$$

the calculation verifies this identity up to floating-point precision.

## Slide 280: Why square the deviations?

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

Squaring prevents cancellation and gives greater weight to larger departures. Variance is thus sensitive to probability placed far from the mean.

## Slide 281: Covariance and a variance decomposition

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

The **covariance** of vowel count $V$ and consonant count $C$ is

$$
\operatorname{Cov}(V,C)
\equiv
\mathbb{E}\!\left[(V-\mathbb{E}[V])(C-\mathbb{E}[C])\right].
$$

## Slide 282: Covariance and a variance decomposition

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

The empirical covariance is 0.784 phones squared. Positive covariance means that entries with more vowel phones tend also to contain more consonant phones, relative to their respective means. It does not by itself identify a phonological mechanism.

## Slide 283: Covariance and a variance decomposition

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

Because $X=V+C$,

$$
\operatorname{Var}[X]
=\operatorname{Var}[V]
+\operatorname{Var}[C]
+2\operatorname{Cov}(V,C).
$$

## Slide 284: Covariance and a variance decomposition

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

The stated assertion checks this decomposition directly from the pronunciation entries.

## Slide 285: Keeping the units visible

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

If phone count is measured in phones, each deviation is measured in phones. Squaring produces phones squared. Squared units make variance useful for algebra but less direct as a descriptive distance. Standard deviation takes a square root to return to the original units.

## Slide 286: Keeping the units visible

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

Variance also requires the expected squared deviation to be finite. A variable can have a finite mean but place enough probability far from that mean for its variance to be infinite.

## Slide 287: Variance and covariance: question 1

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

Recompute the population variance of `vowel_phone_count` from its empirical PMF and compare it with `vowel_variance`.

## Slide 288: Variance and covariance: answer 1

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

The empirical PMF gives $\operatorname{Var}[V]=0.975784$ vowel phones squared, matching `vowel_variance`.

## Slide 289: Variance and covariance: question 2

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

Why is the expected signed deviation zero even though the variance is positive?

## Slide 290: Variance and covariance: answer 2

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

Signed deviations above and below the mean cancel to zero, while squaring prevents that cancellation and yields positive variance.

## Slide 291: Variance and covariance: question 3

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

Which term would vanish from the variance decomposition if vowel and consonant counts had zero covariance?

## Slide 292: Variance and covariance: answer 3

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

If vowel and consonant counts had zero covariance, the term $2\operatorname{Cov}[V,C]$ would vanish from $\operatorname{Var}[V+C]$.

## Slide 293: Variance and covariance: question 4

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

Why does the empirical covariance not imply that adding vowels causes consonants to be added?

## Slide 294: Variance and covariance: answer 4

Source note: `random-variables-and-distributions/variance-and-covariance.qmd`

The covariance describes co-variation among pronunciation entries; it does not identify an intervention in which adding vowels causes consonants to be added. Variance measures spread in squared units. The next page expresses the same spread scale in the units of the original variable.

## Slide 295: Standard deviation

Source note: `random-variables-and-distributions/standard-deviation.qmd`

The next topic is Standard deviation.

## Slide 296: Standard deviation

Source note: `random-variables-and-distributions/standard-deviation.qmd`

The preceding page defined variance as an expected squared deviation from the mean. That squaring prevents cancellation, but it also changes the measurement units. How do we retain the spread information while returning to the original scale? We answer with the CMUdict total phone counts.

## Slide 297: Standard deviation

Source note: `random-variables-and-distributions/standard-deviation.qmd`

The **standard deviation** is the nonnegative square root of the variance:

$$
\sigma_X
\equiv
\sqrt{\operatorname{Var}[X]}.
$$

## Slide 298: Standard deviation

Source note: `random-variables-and-distributions/standard-deviation.qmd`

For the empirical pronunciation-entry distribution,

$$
\widehat\sigma_X
=\sqrt{\widehat{\operatorname{Var}}(X)}.
$$

## Slide 299: Standard deviation

Source note: `random-variables-and-distributions/standard-deviation.qmd`

The variance is 4.566 phones squared, and its square root is 2.137 phones. Taking the square root returns the spread summary to the measurement units of $X$.

## Slide 300: Standard deviation

Source note: `random-variables-and-distributions/standard-deviation.qmd`

Empirical phone-count PMF. The blue line marks the mean; dashed lines mark one standard deviation on either side.

## Slide 301: What standard deviation summarizes

Source note: `random-variables-and-distributions/standard-deviation.qmd`

Standard deviation is the square root of the expected squared distance from the mean. It is not the average absolute distance from the mean. Squaring gives greater weight to large deviations, so the two summaries need not agree.

## Slide 302: What standard deviation summarizes

Source note: `random-variables-and-distributions/standard-deviation.qmd`

Standard deviation is also not a complete description of distribution shape. Equal means and standard deviations do not guarantee equal tails, symmetry, or modality.

## Slide 303: Standard deviation does not determine coverage

Source note: `random-variables-and-distributions/standard-deviation.qmd`

A fixed proportion of observations need not fall within one standard deviation of the mean. In this empirical PMF, 66.8% of pronunciation entries fall between 4.24 and 8.52 phones. The percentage is computed from CMUdict, not supplied by the definition of standard deviation.

## Slide 304: Standard deviation does not determine coverage

Source note: `random-variables-and-distributions/standard-deviation.qmd`

Standard deviation is a root mean squared distance; guaranteed coverage requires a justified distribution family.

## Slide 305: Standard deviation: question 1

Source note: `random-variables-and-distributions/standard-deviation.qmd`

Compute the population standard deviation of `vowel_phone_count` and report its units.

## Slide 306: Standard deviation: answer 1

Source note: `random-variables-and-distributions/standard-deviation.qmd`

The population standard deviation of `vowel_phone_count` is $\sqrt{0.975784}=0.987818$ vowel phones.

## Slide 307: Standard deviation: question 2

Source note: `random-variables-and-distributions/standard-deviation.qmd`

Compare the empirical coverage within one standard deviation for total and vowel-phone counts.

## Slide 308: Standard deviation: answer 2

Source note: `random-variables-and-distributions/standard-deviation.qmd`

Coverage within one standard deviation is 0.667615 for total phone count and 0.736609 for vowel-phone count.

## Slide 309: Standard deviation: question 3

Source note: `random-variables-and-distributions/standard-deviation.qmd`

Why do variance and standard deviation order two distributions by spread in the same way?

## Slide 310: Standard deviation: answer 3

Source note: `random-variables-and-distributions/standard-deviation.qmd`

Standard deviation is the strictly increasing square root of nonnegative variance, so comparing either summary gives the same ordering by spread.

## Slide 311: Standard deviation: question 4

Source note: `random-variables-and-distributions/standard-deviation.qmd`

Which additional assumption would license a familiar normal-distribution coverage statement?

## Slide 312: Standard deviation: answer 4

Source note: `random-variables-and-distributions/standard-deviation.qmd`

A normal-distribution assumption would license the familiar reference that about 68.27% of probability lies within one standard deviation of the mean. Standard deviation rescales the second central moment. The next page shows how changing the exponent summarizes other features of deviations from the mean.

## Slide 313: Central moments

Source note: `random-variables-and-distributions/central-moments.qmd`

The next topic is Central moments.

## Slide 314: Central moments

Source note: `random-variables-and-distributions/central-moments.qmd`

The preceding pages introduced variance and standard deviation. Variance summarizes squared deviations from the mean. But the empirical CMUdict phone-count distribution is asymmetric, with a small number of entries much farther above the mean than below it. Changing the exponent on the centered deviation gives a family of summaries sensitive to different aspects of that shape.

## Slide 315: Central moments

Source note: `random-variables-and-distributions/central-moments.qmd`

Basically, every member of this family centers first and then changes the power applied to the deviation. More specifically, the **$k$th central moment** of $X$ is

$$
\mu_k
\equiv\mathbb{E}\!\left[(X-\mathbb{E}[X])^k\right],
$$

when this expectation exists.

## Slide 316: Central moments

Source note: `random-variables-and-distributions/central-moments.qmd`

The word *central* indicates that each value is centered by subtracting the mean before the power is applied.

## Slide 317: The first and second central moments

Source note: `random-variables-and-distributions/central-moments.qmd`

For $k=1$,

$$
\mu_1
=\mathbb{E}[X-\mathbb{E}[X]]
=0.
$$

## Slide 318: The first and second central moments

Source note: `random-variables-and-distributions/central-moments.qmd`

The computed first central moment is -3.13e-15, which differs from zero only through floating-point arithmetic.

## Slide 319: The first and second central moments

Source note: `random-variables-and-distributions/central-moments.qmd`

For $k=2$,

$$
\mu_2
=\mathbb{E}\!\left[(X-\mathbb{E}[X])^2\right]
=\operatorname{Var}[X].
$$

## Slide 320: The first and second central moments

Source note: `random-variables-and-distributions/central-moments.qmd`

The empirical second central moment is 4.566 phones squared, and its square root is the standard deviation reported on the preceding page.

## Slide 321: The third central moment

Source note: `random-variables-and-distributions/central-moments.qmd`

For $k=3$, the sign of each centered value remains. The empirical third central moment is 7.452 phones cubed. Its positive sign reflects the greater cubed contribution of counts above the mean.

## Slide 322: The third central moment

Source note: `random-variables-and-distributions/central-moments.qmd`

This figure shows contribution of each observed phone count to the third central moment. Color only distinguishes direction relative to the empirical mean.

## Slide 323: The third central moment

Source note: `random-variables-and-distributions/central-moments.qmd`

A standardized third central moment divides by $\sigma_X^3$ so that the units cancel:

$$
\frac{\mu_3}{\sigma_X^3}.
$$

## Slide 324: The third central moment

Source note: `random-variables-and-distributions/central-moments.qmd`

This unitless summary is often called skewness. Its empirical value is 0.764.

## Slide 325: The fourth central moment

Source note: `random-variables-and-distributions/central-moments.qmd`

The fourth central moment is

$$
\mu_4
=\mathbb{E}\!\left[(X-\mathbb{E}[X])^4\right].
$$

## Slide 326: The fourth central moment

Source note: `random-variables-and-distributions/central-moments.qmd`

Dividing $\mu_4$ by $\sigma_X^4$ gives a unitless summary often called kurtosis:

$$
\frac{\mu_4}{\sigma_X^4}.
$$

## Slide 327: The fourth central moment

Source note: `random-variables-and-distributions/central-moments.qmd`

The empirical fourth central moment is 85.067 phones to the fourth power, and the standardized value is 4.080. This summary is sensitive to probability far from the mean, but one value does not reveal where that probability lies.

## Slide 328: A moment does not determine a distribution

Source note: `random-variables-and-distributions/central-moments.qmd`

An even power makes departures on both sides positive, while an odd power preserves direction. Increasing the power gives progressively more weight to values far from the mean. But a central moment does not provide a complete account of distribution shape, and different distributions can share the same first several moments.

## Slide 329: A moment does not determine a distribution

Source note: `random-variables-and-distributions/central-moments.qmd`

Plots locate which values create a summary. That is why the empirical contribution plot accompanies the algebra.

## Slide 330: Central moments: question 1

Source note: `random-variables-and-distributions/central-moments.qmd`

Recompute the first four central moments for `phone_count`.

## Slide 331: Central moments: answer 1

Source note: `random-variables-and-distributions/central-moments.qmd`

For total `phone_count`, the first four empirical central moments are approximately $0$, $4.566130$, $7.452172$, and $85.066716$.

## Slide 332: Central moments: question 2

Source note: `random-variables-and-distributions/central-moments.qmd`

Why is the first central moment zero whenever the mean exists?

## Slide 333: Central moments: answer 2

Source note: `random-variables-and-distributions/central-moments.qmd`

The first central moment is zero because $\mathbb{E}[X-\mathbb{E}[X]]=\mathbb{E}[X]-\mathbb{E}[X]=0$.

## Slide 334: Central moments: question 3

Source note: `random-variables-and-distributions/central-moments.qmd`

Why do odd central moments retain direction while even moments do not?

## Slide 335: Central moments: answer 3

Source note: `random-variables-and-distributions/central-moments.qmd`

Odd powers preserve the sign of a centered deviation, whereas even powers make deviations on both sides nonnegative.

## Slide 336: Central moments: question 4

Source note: `random-variables-and-distributions/central-moments.qmd`

Remove the pronunciation entries at the observed maximum `phone_count` and recompute skewness. Which tail contribution changed?

## Slide 337: Central moments: answer 4

Source note: `random-variables-and-distributions/central-moments.qmd`

Removing the single 32-phone entry reduces skewness from $0.763766$ to $0.752368$ by removing an extreme upper-tail contribution. This completes the shared representation and summary sequence. The next page begins the distribution-family pages using only objects already introduced here.

## Slide 338: Categorical and Bernoulli distributions

Source note: `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`

Next, we take up Categorical and Bernoulli distributions.

## Slide 339: UD Turkish BOUN: the empirical object

Source note: `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`

The data source is Türk et al. (2022), UD Turkish BOUN 2.18. It provides manually reviewed Turkish Universal Dependencies tokens.

## Slide 340: Categorical and Bernoulli distributions

Source note: `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`

A corpus annotation can record a label, such as an interrogative lemma, or a binary property, such as whether the token is an object. These outcomes require two closely related distributions: the **categorical distribution** for a finite label inventory and the **Bernoulli distribution** for a binary indicator.

## Slide 341: Turkish interrogative arguments

Source note: `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`

The extract retains *hangi*, *kim*, and *ne* tokens annotated as `nsubj` or `obj`; it does not infer missing dependencies.

## Slide 342: Turkish interrogative arguments

Source note: `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`

One row is one annotated token. Tokens remain nested in sentences, and the selected registers are not a probability sample of Turkish usage. Thus the empirical probabilities below describe this pinned corpus extract.

## Slide 343: Categorical outcomes

Source note: `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`

Let $L$ record interrogative lemma and let $\mathcal L$ be its finite support. A categorical probability vector $\boldsymbol\pi=(\pi_1,\ldots,\pi_K)$ satisfies $\pi_k\geq0$ and $\sum_k\pi_k=1$. We write

$$
L\sim\operatorname{Categorical}(\boldsymbol\pi),
\qquad
p_L(\ell_k)=\mathbb{P}(L=\ell_k)=\pi_k.
$$

## Slide 344: Categorical outcomes

Source note: `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`

The maximum-likelihood categorical probabilities are the empirical relative frequencies,

$$
\widehat\pi_k=\frac{n_k}{n}.
$$

## Slide 345: Categorical outcomes

Source note: `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`

The extract contains 167 tokens. Its most frequent lemma is *ne*, with empirical mass 0.880.

## Slide 346: Binary outcomes

Source note: `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`

Define $O=1$ when the source relation is `obj` and $O=0$ when it is `nsubj`. Then

$$
O\sim\operatorname{Bernoulli}(p),
\qquad
\mathbb{P}(O=o)=p^o(1-p)^{1-o},\quad o\in\{0,1\}.
$$

## Slide 347: Binary outcomes

Source note: `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`

The fitted value is $\widehat p=n^{-1}\sum_i o_i$, computed here as 0.695. This is a corpus proportion, not an estimate from independent sentence sampling.

## Slide 348: Binary outcomes

Source note: `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`

This figure shows empirical mass functions for interrogative lemma and annotated dependency relation in the Turkish BOUN extract.

## Slide 349: Binary outcomes

Source note: `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`

The categorical model preserves which lemma occurred; the Bernoulli mapping collapses the relation to a success/failure indicator. That collapse is useful only when the binary property answers the linguistic question.

## Slide 350: Categorical and Bernoulli distributions: question 1

Source note: `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`

Recompute the categorical PMF for `dependency_relation` directly from `questions`.

## Slide 351: Categorical and Bernoulli distributions: answer 1

Source note: `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`

The empirical relation PMF is $p_R(\text{nsubj})=51/167=0.305389$ and $p_R(\text{obj})=116/167=0.694611$.

## Slide 352: Categorical and Bernoulli distributions: question 2

Source note: `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`

Define a Bernoulli indicator for lemma *ne* and compute its empirical $p$.

## Slide 353: Categorical and Bernoulli distributions: answer 2

Source note: `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`

For $I_{\textit{ne}}=\mathbb{1}\{L=\textit{ne}\}$, the empirical Bernoulli parameter is $p=147/167=0.880240$.

## Slide 354: Categorical and Bernoulli distributions: question 3

Source note: `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`

Explain why treating the `object` indicator as a Bernoulli variable does not make the rows independent.

## Slide 355: Categorical and Bernoulli distributions: answer 3

Source note: `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`

Bernoulli coding specifies two possible row values but does not make rows independent, because multiple tokens can come from the same sentence and register.

## Slide 356: Categorical and Bernoulli distributions: question 4

Source note: `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`

Which information is lost when `dependency_relation` replaces the three-level lemma?

## Slide 357: Categorical and Bernoulli distributions: answer 4

Source note: `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`

Replacing the three-level lemma with dependency relation discards which of *hangi*, *kim*, or *ne* the token instantiates. The next page develops the Bernoulli expectation and variance for the same object indicator.

## Slide 358: The Bernoulli distribution

Source note: `random-variables-and-distributions/bernoulli-distribution.qmd`

Now we turn to The Bernoulli distribution.

## Slide 359: The Bernoulli distribution

Source note: `random-variables-and-distributions/bernoulli-distribution.qmd`

The preceding page mapped each interrogative argument in the Turkish BOUN extract to an object indicator. The **Bernoulli distribution** describes that single binary measurement.

## Slide 360: Mass, expectation, and variance

Source note: `random-variables-and-distributions/bernoulli-distribution.qmd`

For $O\in\{0,1\}$,

$$
\mathbb{P}(O=o)=p^o(1-p)^{1-o}.
$$

Because $O^2=O$, its expectation and variance follow directly:

$$
\mathbb{E}[O]=0(1-p)+1p=p,
$$

$$
\begin{aligned}
\operatorname{Var}[O]
&=\mathbb{E}[O^2]-\mathbb{E}[O]^2\\
&=p-p^2\\
&=p(1-p).
\end{aligned}
$$

## Slide 361: Mass, expectation, and variance

Source note: `random-variables-and-distributions/bernoulli-distribution.qmd`

Substituting the corpus-fitted value gives an expectation of 0.695 and a variance of 0.212. The expectation has an immediate interpretation: it is the empirical proportion of retained interrogative arguments annotated `obj`.

## Slide 362: Mass, expectation, and variance

Source note: `random-variables-and-distributions/bernoulli-distribution.qmd`

This figure shows observed Bernoulli mass for subject and object relations in the Turkish BOUN extract.

## Slide 363: What the model does not say

Source note: `random-variables-and-distributions/bernoulli-distribution.qmd`

The fitted $p$ summarizes the retained token table. It does not say that every sentence has the same object probability, nor does it describe repeated independent sampling from Turkish. Sentence and register identifiers remain available because discourse context and sampling structure may matter.

## Slide 364: The Bernoulli distribution: question 1

Source note: `random-variables-and-distributions/bernoulli-distribution.qmd`

Verify the identity $\widehat{\operatorname{Var}}(O)=\widehat p(1-\widehat p)$ from the individual rows.

## Slide 365: The Bernoulli distribution: answer 1

Source note: `random-variables-and-distributions/bernoulli-distribution.qmd`

The row-level indicator variance is $\widehat{\operatorname{Var}}[O]=0.212127$, equal to $\widehat p(1-\widehat p)=0.694611(0.305389)$.

## Slide 366: The Bernoulli distribution: question 2

Source note: `random-variables-and-distributions/bernoulli-distribution.qmd`

Compute the empirical Bernoulli PMF for the indicator `lemma == "ne"`.

## Slide 367: The Bernoulli distribution: answer 2

Source note: `random-variables-and-distributions/bernoulli-distribution.qmd`

For the *ne* indicator, $p(0)=20/167=0.119760$ and $p(1)=147/167=0.880240$.

## Slide 368: The Bernoulli distribution: question 3

Source note: `random-variables-and-distributions/bernoulli-distribution.qmd`

What linguistic distinction does the current zero value encode?

## Slide 369: The Bernoulli distribution: answer 3

Source note: `random-variables-and-distributions/bernoulli-distribution.qmd`

For the object indicator $O$, zero encodes the linguistic alternative `nsubj` rather than an absence of data.

## Slide 370: The Bernoulli distribution: question 4

Source note: `random-variables-and-distributions/bernoulli-distribution.qmd`

Why is $\mathbb{E}[O]$ both a mean and a proportion?

## Slide 371: The Bernoulli distribution: answer 4

Source note: `random-variables-and-distributions/bernoulli-distribution.qmd`

$\mathbb{E}[O]=0\,p_O(0)+1\,p_O(1)=p_O(1)$, which is both the sample mean of the zero-one values and the proportion of object tokens. The binomial distribution describes the count obtained by summing independent Bernoulli variables.

## Slide 372: The binomial distribution

Source note: `random-variables-and-distributions/binomial-distribution.qmd`

Now we turn to The binomial distribution.

## Slide 373: The binomial distribution

Source note: `random-variables-and-distributions/binomial-distribution.qmd`

A Bernoulli variable records whether one Turkish interrogative argument is annotated as an object. If $n$ independent opportunities had the same object probability $p$, their sum would follow a **binomial distribution**.

## Slide 374: Definition

Source note: `random-variables-and-distributions/binomial-distribution.qmd`

Let $O_1,\ldots,O_n\overset{\text{iid}}{\sim}\operatorname{Bernoulli}(p)$ and $Y=\sum_{i=1}^n O_i$. Then

$$
Y\sim\operatorname{Binomial}(n,p)
$$

with probability mass function

$$
\mathbb{P}(Y=y)
=\binom{n}{y}p^y(1-p)^{n-y},
\qquad y\in\{0,\ldots,n\}.
$$

## Slide 375: Definition

Source note: `random-variables-and-distributions/binomial-distribution.qmd`

Linearity of expectation and independence give

$$
\mathbb{E}[Y]=np,
\qquad
\operatorname{Var}[Y]=np(1-p).
$$

## Slide 376: Definition

Source note: `random-variables-and-distributions/binomial-distribution.qmd`

More explicitly,

$$
\begin{aligned}
\mathbb{E}[Y]
&=\mathbb{E}\left[\sum_{i=1}^nO_i\right]
=\sum_{i=1}^n\mathbb{E}[O_i]
=np,\\
\operatorname{Var}[Y]
&=\operatorname{Var}[\sum_{i=1}^nO_i]
=\sum_{i=1}^n\operatorname{Var}[O_i]
=np(1-p).
\end{aligned}
$$

## Slide 377: Definition

Source note: `random-variables-and-distributions/binomial-distribution.qmd`

The variance equality uses independence; the expectation equality does not. The support is $\{0,\ldots,n\}$, and $\binom ny$ counts which $y$ of the $n$ opportunities are successes.

## Slide 378: A corpus-calibrated reference

Source note: `random-variables-and-distributions/binomial-distribution.qmd`

the calculation fits $p$ from the Turkish BOUN extract introduced earlier, then uses the observed number of opportunities as $n$. This creates a binomial reference distribution on the scale of the observed count.

## Slide 379: A corpus-calibrated reference

Source note: `random-variables-and-distributions/binomial-distribution.qmd`

The plug-in reference has expectation 116.000 object tokens and variance 35.425 tokens squared. The equality between the fitted expectation and observed count is not a discovery: fitting $p=Y/n$ forces $n\widehat p=Y$.

## Slide 380: A corpus-calibrated reference

Source note: `random-variables-and-distributions/binomial-distribution.qmd`

Binomial reference distribution calibrated to the Turkish BOUN object proportion. The vertical line marks the observed count.

## Slide 381: The independence objection

Source note: `random-variables-and-distributions/binomial-distribution.qmd`

A potential worry is that the formula appears to model the corpus design. It does not. The BOUN extract contains tokens nested within sampled sentences, and its opportunity count was observed rather than fixed in repeated experiments. Thus the curve is a data-calibrated independent-trial reference. It shows the distribution implied by the binomial assumptions and prepares us to recognize when those assumptions fail.

## Slide 382: The binomial distribution: question 1

Source note: `random-variables-and-distributions/binomial-distribution.qmd`

Compute the reference standard deviation from `reference_variance`.

## Slide 383: The binomial distribution: answer 1

Source note: `random-variables-and-distributions/binomial-distribution.qmd`

The reference standard deviation is $\sqrt{35.42515}=5.951903$ object tokens.

## Slide 384: The binomial distribution: question 2

Source note: `random-variables-and-distributions/binomial-distribution.qmd`

Use `pbinom()` to calculate the reference probability of a count no greater than the observed count.

## Slide 385: The binomial distribution: answer 2

Source note: `random-variables-and-distributions/binomial-distribution.qmd`

The fitted reference probability of no more than 116 objects is `pbinom(116, 167, 116/167) = 0.529136`.

## Slide 386: The binomial distribution: question 3

Source note: `random-variables-and-distributions/binomial-distribution.qmd`

Why does fitting $p$ to the same count guarantee that the fitted expectation equals that count?

## Slide 387: The binomial distribution: answer 3

Source note: `random-variables-and-distributions/binomial-distribution.qmd`

Because $\widehat p=x/n$, the fitted expectation is $\mathbb{E}[X]=n\widehat p=n(x/n)=x=116$.

## Slide 388: The binomial distribution: question 4

Source note: `random-variables-and-distributions/binomial-distribution.qmd`

Name the grouping identifier that prevents a literal iid interpretation here.

## Slide 389: The binomial distribution: answer 4

Source note: `random-variables-and-distributions/binomial-distribution.qmd`

The repeated `sentence_id` values, 167 tokens from 159 sentences, prevent a literal iid interpretation of the token trials. The hypergeometric distribution changes the sampling design from independent draws to sampling without replacement.

## Slide 390: The hypergeometric distribution

Source note: `random-variables-and-distributions/hypergeometric-distribution.qmd`

Now we turn to The hypergeometric distribution.

## Slide 391: Turkish UniMorph: the empirical object

Source note: `random-variables-and-distributions/hypergeometric-distribution.qmd`

The data source is Pimentel et al. (2021) and Batsuren et al. (2022), Turkish UniMorph. It provides Turkish inflectional paradigms from the pinned UniMorph release.

## Slide 392: The hypergeometric distribution

Source note: `random-variables-and-distributions/hypergeometric-distribution.qmd`

The binomial distribution describes independent draws. A fixed sample drawn **without replacement** from a finite linguistic resource has less variation because each selected entry changes the composition of the remaining population. The **hypergeometric distribution** represents that design.

## Slide 393: A finite Turkish morphology population

Source note: `random-variables-and-distributions/hypergeometric-distribution.qmd`

We use the Turkish UniMorph release pinned at commit 6c179ac. Pimentel et al. (2021) describe the morphological-reinflection task and Turkish expansion; Batsuren et al. (2022) describe the type-level UniMorph representation. The data are CC BY-SA 3.0.

## Slide 394: A finite Turkish morphology population

Source note: `random-variables-and-distributions/hypergeometric-distribution.qmd`

The course population retains the distinct Turkish verb lemmas with one form in the feature cell `V;IND;PST;3;SG;POS;DECL`. The pinned README says that verbs were generated semi-automatically and partially checked by a native speaker; unverified noun and adjective material is excluded. The two-character `past_suffix` is a course-derived orthographic ending, not a UniMorph morpheme boundary.

## Slide 395: Mass, mean, and variance

Source note: `random-variables-and-distributions/hypergeometric-distribution.qmd`

If a population contains $N$ entries, $K$ carry a focal property, and $n$ entries are sampled without replacement, then the focal count $X$ has mass

$$
\mathbb{P}(X=x)
=\frac{\binom Kx\binom{N-K}{n-x}}{\binom Nn}.
$$

## Slide 396: Mass, mean, and variance

Source note: `random-variables-and-distributions/hypergeometric-distribution.qmd`

The support respects both finite stocks:

$$
\max\{0,n-(N-K)\}
\leq x\leq
\min\{n,K\}.
$$

## Slide 397: Mass, mean, and variance

Source note: `random-variables-and-distributions/hypergeometric-distribution.qmd`

The numerator counts samples containing $x$ focal entries and $n-x$ other entries; the denominator counts all size-$n$ samples.

## Slide 398: Mass, mean, and variance

Source note: `random-variables-and-distributions/hypergeometric-distribution.qmd`

Its expectation is the same as that of a binomial count with $p=K/N$, but its variance contains the **finite-population correction**:

$$
\mathbb{E}[X]=n\frac KN,
$$

$$
\operatorname{Var}[X]
=n\frac KN\left(1-\frac KN\right)\frac{N-n}{N-1}.
$$

## Slide 399: Mass, mean, and variance

Source note: `random-variables-and-distributions/hypergeometric-distribution.qmd`

For the fixed sample, the expected number of *t*-initial endings is 40.816. The without-replacement variance is 21.473, smaller than the independent-draw variance of 26.933.

## Slide 400: Mass, mean, and variance

Source note: `random-variables-and-distributions/hypergeometric-distribution.qmd`

Without-replacement and independent-draw reference masses for the Turkish UniMorph sample. The vertical line marks the fixed sample count.

## Slide 401: Mass, mean, and variance

Source note: `random-variables-and-distributions/hypergeometric-distribution.qmd`

The finite population is the pinned lexicon cell, not Turkish usage. The distribution describes repeated samples of lemmas from that resource.

## Slide 402: The hypergeometric distribution: question 1

Source note: `random-variables-and-distributions/hypergeometric-distribution.qmd`

Compute the probability of the observed count with `dhyper()`.

## Slide 403: The hypergeometric distribution: answer 1

Source note: `random-variables-and-distributions/hypergeometric-distribution.qmd`

The probability of the observed count is `dhyper(42, 200, 388, 120) = 0.082787`.

## Slide 404: The hypergeometric distribution: question 2

Source note: `random-variables-and-distributions/hypergeometric-distribution.qmd`

Explain why the two models have the same expectation but different variances.

## Slide 405: The hypergeometric distribution: answer 2

Source note: `random-variables-and-distributions/hypergeometric-distribution.qmd`

Both models have $\mathbb{E}[X]=nK/N=40.816327$, but sampling without replacement multiplies the binomial variance by the finite-population correction 0.797274.

## Slide 406: The hypergeometric distribution: question 3

Source note: `random-variables-and-distributions/hypergeometric-distribution.qmd`

What happens to the correction as $n/N$ approaches one?

## Slide 407: The hypergeometric distribution: answer 3

Source note: `random-variables-and-distributions/hypergeometric-distribution.qmd`

As $n/N$ approaches one, $(N-n)/(N-1)$ approaches zero and the sampling variance collapses because nearly the whole finite population is observed.

## Slide 408: The hypergeometric distribution: question 4

Source note: `random-variables-and-distributions/hypergeometric-distribution.qmd`

Why would a corpus-token claim be unsupported by this population?

## Slide 409: The hypergeometric distribution: answer 4

Source note: `random-variables-and-distributions/hypergeometric-distribution.qmd`

The population consists of 588 distinct UniMorph verb lemmas in one feature cell, not tokens sampled from Turkish usage, so it cannot support a corpus-token claim. The next two pages return to CMUdict to model waiting counts.

## Slide 410: The geometric distribution

Source note: `random-variables-and-distributions/geometric-distribution.qmd`

Next, we take up The geometric distribution.

## Slide 411: The geometric distribution

Source note: `random-variables-and-distributions/geometric-distribution.qmd`

The CMUdict sequence introduced pronunciation entries and their phone counts. We now ask how many consonants precede the first vowel phone in each entry. This is a **waiting count**: the number of failures before the first success.

## Slide 412: Definition

Source note: `random-variables-and-distributions/geometric-distribution.qmd`

If independent trials have constant success probability $p$, then

$$
X\sim\operatorname{Geometric}(p)
$$

has mass

$$
\mathbb{P}(X=x)=(1-p)^x p,
\qquad x\in\{0,1,2,\ldots\}.
$$

## Slide 413: Definition

Source note: `random-variables-and-distributions/geometric-distribution.qmd`

Differentiating the geometric series or using its probability-generating function gives

$$
\mathbb{E}[X]=\frac{1-p}{p},
\qquad
\operatorname{Var}[X]=\frac{1-p}{p^2}.
$$

## Slide 414: Definition

Source note: `random-variables-and-distributions/geometric-distribution.qmd`

To derive the mean, put $q=1-p$ and differentiate the geometric series:

$$
\sum_{x=0}^{\infty}q^x=\frac{1}{1-q},
\qquad
\sum_{x=1}^{\infty}xq^{x-1}=\frac{1}{(1-q)^2}.
$$

## Slide 415: Definition

Source note: `random-variables-and-distributions/geometric-distribution.qmd`

Thus

$$
\begin{aligned}
\mathbb{E}[X]
&=p\sum_{x=0}^{\infty}xq^x\\
&=pq\sum_{x=1}^{\infty}xq^{x-1}\\
&=\frac{1-p}{p}.
\end{aligned}
$$

## Slide 416: Definition

Source note: `random-variables-and-distributions/geometric-distribution.qmd`

The factorial moment $\mathbb{E}[X(X-1)]=2(1-p)^2/p^2$ then gives

$$
\operatorname{Var}[X]
=\mathbb{E}[X(X-1)]+\mathbb{E}[X]-\mathbb{E}[X]^2
=\frac{1-p}{p^2}.
$$

## Slide 417: Definition

Source note: `random-variables-and-distributions/geometric-distribution.qmd`

The tail probability also has a simple form:

$$
\mathbb{P}(X\geq k)=(1-p)^k.
$$

## Slide 418: Fitting the CMUdict waiting count

Source note: `random-variables-and-distributions/geometric-distribution.qmd`

Each CMUdict row is a dictionary pronunciation entry, not a running-speech token. The earlier introduction links the 0.7b release and states the dependence among alternate pronunciations.

## Slide 419: Fitting the CMUdict waiting count

Source note: `random-variables-and-distributions/geometric-distribution.qmd`

The maximum-likelihood estimate is $\widehat p=1/(1+\overline X)$, computed as 0.497. The fitted mean thus matches the empirical mean. But the fitted variance is 2.032, while the empirical population variance is only 0.321.

## Slide 420: Fitting the CMUdict waiting count

Source note: `random-variables-and-distributions/geometric-distribution.qmd`

This figure shows observed consonant waiting-count mass and fitted geometric mass. The fitted family matches the mean but greatly overstates the spread.

## Slide 421: Why the fit fails

Source note: `random-variables-and-distributions/geometric-distribution.qmd`

The geometric process assumes independent phone positions with one constant vowel probability. English phonotactics, syllable structure, and the dictionary's lexical composition violate that process story. Matching a mean is thus not evidence that the family explains the observed shape.

## Slide 422: The geometric distribution: question 1

Source note: `random-variables-and-distributions/geometric-distribution.qmd`

Compare the observed and fitted probabilities at the empirical median waiting count.

## Slide 423: The geometric distribution: answer 1

Source note: `random-variables-and-distributions/geometric-distribution.qmd`

At the empirical median wait of 1, the observed probability is 0.698388 and the fitted geometric probability is 0.249993.

## Slide 424: The geometric distribution: question 2

Source note: `random-variables-and-distributions/geometric-distribution.qmd`

Derive $\widehat p=1/(1+\overline X)$ from the geometric log likelihood.

## Slide 425: The geometric distribution: answer 2

Source note: `random-variables-and-distributions/geometric-distribution.qmd`

Differentiating $\ell(p)=n\log p+(\sum_i x_i)\log(1-p)$ and setting the derivative to zero gives $n/p-\sum_i x_i/(1-p)=0$, hence $\widehat p=1/(1+\overline X)$.

## Slide 426: The geometric distribution: question 3

Source note: `random-variables-and-distributions/geometric-distribution.qmd`

Which aspect of the plot reveals underdispersion relative to the fitted family?

## Slide 427: The geometric distribution: answer 3

Source note: `random-variables-and-distributions/geometric-distribution.qmd`

The observed distribution is much more concentrated at wait 1, with variance 0.321470 versus the fitted 2.031825, which shows underdispersion relative to the geometric family.

## Slide 428: The geometric distribution: question 4

Source note: `random-variables-and-distributions/geometric-distribution.qmd`

Why are pronunciation alternatives not independent word types?

## Slide 429: The geometric distribution: answer 4

Source note: `random-variables-and-distributions/geometric-distribution.qmd`

Pronunciation alternatives are clustered within an orthographic word, so they are neither distinct word types nor independent lexical observations. The negative-binomial distribution generalizes the waiting count to a later success.

## Slide 430: The negative-binomial distribution

Source note: `random-variables-and-distributions/negative-binomial-distribution.qmd`

Now we turn to The negative-binomial distribution.

## Slide 431: The negative-binomial distribution

Source note: `random-variables-and-distributions/negative-binomial-distribution.qmd`

The geometric distribution counts failures before the first success. The **negative-binomial distribution** counts failures before the $r$th success. For a pronunciation entry, let a vowel phone be a success and let $X$ count consonants before the third vowel.

## Slide 432: Definition

Source note: `random-variables-and-distributions/negative-binomial-distribution.qmd`

Under independent trials with constant success probability $p$,

$$
X\sim\operatorname{NegBin}(r,p)
$$

has mass

$$
\mathbb{P}(X=x)
=\binom{x+r-1}{x}(1-p)^x p^r,
\qquad x\in\{0,1,2,\ldots\}.
$$

## Slide 433: Definition

Source note: `random-variables-and-distributions/negative-binomial-distribution.qmd`

The mean and variance are

$$
\mathbb{E}[X]=\frac{r(1-p)}p,
\qquad
\operatorname{Var}[X]=\frac{r(1-p)}{p^2}.
$$

When $r=1$, these expressions reduce to the geometric distribution.

## Slide 434: Definition

Source note: `random-variables-and-distributions/negative-binomial-distribution.qmd`

Writing $\mu=\mathbb{E}[X]$ yields the mean--variance form

$$
\operatorname{Var}[X]
=\mu+\frac{\mu^2}{r}
>\mu.
$$

## Slide 435: Definition

Source note: `random-variables-and-distributions/negative-binomial-distribution.qmd`

Thus every finite-$r$ member is overdispersed relative to a Poisson variable with the same mean. The family also contains a Poisson limit. If

$$
X_r\sim\operatorname{NegBin}\left(r,\frac{r}{r+\lambda}\right),
$$

then $\mathbb{E}[X_r]=\lambda$ and, for each nonnegative integer $x$,

$$
\lim_{r\to\infty}\mathbb{P}(X_r=x)
=e^{-\lambda}\frac{\lambda^x}{x!}.
$$

## Slide 436: A third-vowel waiting count

Source note: `random-variables-and-distributions/negative-binomial-distribution.qmd`

The variable is defined only for CMUdict entries with at least three vowel phones. Excluding undefined rows changes the observational subset, so the calculation states and checks that restriction.

## Slide 437: A third-vowel waiting count

Source note: `random-variables-and-distributions/negative-binomial-distribution.qmd`

The fitted success probability is 0.467. As on the geometric page, the fitted mean matches by construction. The fitted variance is 7.339, compared with an empirical population variance of 1.076.

## Slide 438: A third-vowel waiting count

Source note: `random-variables-and-distributions/negative-binomial-distribution.qmd`

This figure shows observed consonant count before the third vowel and the fitted size-three negative-binomial mass.

## Slide 439: A third-vowel waiting count

Source note: `random-variables-and-distributions/negative-binomial-distribution.qmd`

The fit again spreads too much mass across the support. A sequence of phones is not an exchangeable succession of consonant failures and vowel successes. This model is useful because its visible failure makes the process assumptions testable.

## Slide 440: The negative-binomial distribution: question 1

Source note: `random-variables-and-distributions/negative-binomial-distribution.qmd`

Compute the fraction of CMUdict entries for which this waiting count is defined.

## Slide 441: The negative-binomial distribution: answer 1

Source note: `random-variables-and-distributions/negative-binomial-distribution.qmd`

The waiting count is defined for 55,426 of 133,854 entries, a fraction of 0.414078.

## Slide 442: The negative-binomial distribution: question 2

Source note: `random-variables-and-distributions/negative-binomial-distribution.qmd`

Compare the empirical and fitted zero probabilities.

## Slide 443: The negative-binomial distribution: answer 2

Source note: `random-variables-and-distributions/negative-binomial-distribution.qmd`

The empirical zero probability is 0.000307, whereas the fitted negative-binomial zero probability is 0.101748.

## Slide 444: The negative-binomial distribution: question 3

Source note: `random-variables-and-distributions/negative-binomial-distribution.qmd`

Show algebraically that the variance exceeds the mean under this parameterization.

## Slide 445: The negative-binomial distribution: answer 3

Source note: `random-variables-and-distributions/negative-binomial-distribution.qmd`

Here $\operatorname{Var}[X]-\mathbb{E}[X]=r(1-p)^2/p^2>0$ for $0<p<1$, so the variance necessarily exceeds the mean.

## Slide 446: The negative-binomial distribution: question 4

Source note: `random-variables-and-distributions/negative-binomial-distribution.qmd`

Why does conditioning on at least three vowels change the population being summarized?

## Slide 447: The negative-binomial distribution: answer 4

Source note: `random-variables-and-distributions/negative-binomial-distribution.qmd`

Conditioning on at least three vowels excludes all other pronunciations, so the fitted distribution summarizes only the selected 55,426-entry subpopulation. The Poisson distribution models a count without defining it as a waiting time.

## Slide 448: The Poisson distribution

Source note: `random-variables-and-distributions/poisson-distribution.qmd`

The next topic is The Poisson distribution.

## Slide 449: English dative: the empirical object

Source note: `random-variables-and-distributions/poisson-distribution.qmd`

The data source is Bresnan et al. (2007), English dative alternation. It provides attested English dative construction tokens.

## Slide 450: The Poisson distribution

Source note: `random-variables-and-distributions/poisson-distribution.qmd`

A Poisson model is often proposed for nonnegative counts. But matching the support is only the first check: the family also requires its mean and variance to be equal. English recipient length provides a direct test.

## Slide 451: The dative data

Source note: `random-variables-and-distributions/poisson-distribution.qmd`

We use the English dative-alternation data from the archived `languageR` 1.5.0 release, analyzed by Bresnan et al. (2007). A row is one dative token from Switchboard or the Wall Street Journal portion of the Penn Treebank. The source study models how lexical, discourse, referential, and constituent properties condition dative realization; the count analysis here is a teaching simplification, not a reproduction of that multivariable model.

## Slide 452: The dative data

Source note: `random-variables-and-distributions/poisson-distribution.qmd`

The prepared table is a value-preserving renamed extract with 3263 rows. It is redistributed under the package’s GPL 2.0-or-later terms. Tokens repeat verbs, spoken tokens repeat speakers, and the archived table has two fewer written rows than the paper reports.

## Slide 453: Definition and fit

Source note: `random-variables-and-distributions/poisson-distribution.qmd`

For $Y\sim\operatorname{Poisson}(\lambda)$,

$$
\mathbb{P}(Y=y)
=\frac{\lambda^y e^{-\lambda}}{y!},
\qquad y\in\{0,1,2,\ldots\},
$$

and

$$
\mathbb{E}[Y]=\lambda,
\qquad
\operatorname{Var}[Y]=\lambda.
$$

## Slide 454: Definition and fit

Source note: `random-variables-and-distributions/poisson-distribution.qmd`

The parameter must refer to a stated exposure. If events occur at rate $\rho$ per exposure unit and an observation has exposure $e$, then

$$
\lambda=\rho e.
$$

## Slide 455: Definition and fit

Source note: `random-variables-and-distributions/poisson-distribution.qmd`

For the present variable the exposure is one dative token, and the count is the number of recipient words beyond the first. The recurrence

$$
\frac{\mathbb{P}(Y=y+1)}{\mathbb{P}(Y=y)}
=\frac{\lambda}{y+1}
$$

shows how the mass increases up to the vicinity of $\lambda$ and decreases afterward.

## Slide 456: Definition and fit

Source note: `random-variables-and-distributions/poisson-distribution.qmd`

The log likelihood,

$$
\ell(\lambda)
=\sum_{i=1}^n\left[y_i\log\lambda-\lambda-\log(y_i!)\right],
$$

has derivative $\sum_i y_i/\lambda-n$, so $\widehat\lambda=\overline y$.

## Slide 457: Definition and fit

Source note: `random-variables-and-distributions/poisson-distribution.qmd`

The fitted value is 0.842 words beyond the first.

## Slide 458: Definition and fit

Source note: `random-variables-and-distributions/poisson-distribution.qmd`

This figure shows observed recipient-length mass and fitted Poisson mass. The model misses both the zero mass and the long tail.

## Slide 459: Definition and fit

Source note: `random-variables-and-distributions/poisson-distribution.qmd`

The empirical variance is 4.275, giving a variance-to-mean ratio of 5.08. The observed zero proportion is 0.683, compared with a fitted zero probability of 0.431. Thus the Poisson family fails its equidispersion pattern and its visible mass allocation.

## Slide 460: The Poisson distribution: question 1

Source note: `random-variables-and-distributions/poisson-distribution.qmd`

Use `ppois()` to find the fitted probability above the observed maximum.

## Slide 461: The Poisson distribution: answer 1

Source note: `random-variables-and-distributions/poisson-distribution.qmd`

With $\widehat\lambda=0.842170$ and observed maximum 30, `ppois(30, lambda_hat, lower.tail = FALSE) = 2.62e-37`.

## Slide 462: The Poisson distribution: question 2

Source note: `random-variables-and-distributions/poisson-distribution.qmd`

Why subtract one from `recipient_length_words`?

## Slide 463: The Poisson distribution: answer 2

Source note: `random-variables-and-distributions/poisson-distribution.qmd`

Subtracting one converts recipient length to the number of words beyond the unavoidable first word, producing a nonnegative count with zero for one-word recipients.

## Slide 464: The Poisson distribution: question 3

Source note: `random-variables-and-distributions/poisson-distribution.qmd`

Which two features of the plot show lack of fit?

## Slide 465: The Poisson distribution: answer 3

Source note: `random-variables-and-distributions/poisson-distribution.qmd`

The observed zero probability is 0.682807 versus 0.430775 fitted, and the observed variance-to-mean ratio is 5.075589 with a much heavier upper tail than the fitted Poisson.

## Slide 466: The Poisson distribution: question 4

Source note: `random-variables-and-distributions/poisson-distribution.qmd`

Why does repeated use of the same verb matter for population inference?

## Slide 467: The Poisson distribution: answer 4

Source note: `random-variables-and-distributions/poisson-distribution.qmd`

Repeated tokens of the same verb share lexical properties, so treating them as independent evidence would overstate information for inference beyond the represented corpus. The uniform distribution begins a two-page sequence on bounded measurements.

## Slide 468: The uniform distribution

Source note: `random-variables-and-distributions/uniform-distribution.qmd`

Our next step is The uniform distribution.

## Slide 469: Provo: the empirical object

Source note: `random-variables-and-distributions/uniform-distribution.qmd`

The data source is Luke and Christianson (2018), Provo Corpus. It provides content-word positions aggregated across Provo readers.

## Slide 470: The uniform distribution

Source note: `random-variables-and-distributions/uniform-distribution.qmd`

Some linguistic measurements are bounded even when their observed distributions are not flat. The **uniform distribution** separates these two ideas: its support may be appropriate while its equal-density assumption is not.

## Slide 471: Provo modeled predictability

Source note: `random-variables-and-distributions/uniform-distribution.qmd`

Luke and Christianson (2018) collected cloze norms and eye movements for English passages in the Provo Corpus release, licensed CC BY 4.0. The course table contains complete content-word positions from the source passages. One row is a word position aggregated across readers, not a participant trial.

## Slide 472: Provo modeled predictability

Source note: `random-variables-and-distributions/uniform-distribution.qmd`

Our variable, `OrthoMatchModel`, is the source authors' fitted orthographic-cloze value from a logit mixed model with a random intercept by word. It is not the raw cloze proportion and carries first-stage model uncertainty that this page does not recover.

## Slide 473: Definition

Source note: `random-variables-and-distributions/uniform-distribution.qmd`

For $X\sim\operatorname{Uniform}(a,b)$,

$$
f_X(x)
=\begin{cases}
\dfrac{1}{b-a},&a\leq x\leq b,\\[4pt]
0,&\text{otherwise}.
\end{cases}
$$

## Slide 474: Definition

Source note: `random-variables-and-distributions/uniform-distribution.qmd`

Integrating the density gives

$$
\mathbb{E}[X]=\frac{a+b}{2},
\qquad
\operatorname{Var}[X]=\frac{(b-a)^2}{12},
$$

and for $a\leq c<d\leq b$,

$$
\mathbb{P}(c\leq X\leq d)=\frac{d-c}{b-a}.
$$

## Slide 475: Definition

Source note: `random-variables-and-distributions/uniform-distribution.qmd`

The CDF is

$$
F_X(x)
=\begin{cases}
0,&x<a,\\
\dfrac{x-a}{b-a},&a\leq x\leq b,\\
1,&x>b.
\end{cases}
$$

## Slide 476: Definition

Source note: `random-variables-and-distributions/uniform-distribution.qmd`

Integrating the first two raw moments gives

$$
\mathbb{E}[X]
=\frac{1}{b-a}\int_a^b x\,\mathrm dx
=\frac{a+b}{2},
$$

and

$$
\operatorname{Var}[X]
=\mathbb{E}[X^2]-\mathbb{E}[X]^2
=\frac{(b-a)^2}{12}.
$$

Because this is a continuous distribution, $\mathbb{P}(X=x)=0$ for every exact point $x$, even where the density is positive.

## Slide 477: Definition

Source note: `random-variables-and-distributions/uniform-distribution.qmd`

Using the source-defined unit interval and the empirical quartiles as $c$ and $d$, the uniform reference assigns probability 0.172 to that interval. The endpoints were not selected to create a convenient result.

## Slide 478: Definition

Source note: `random-variables-and-distributions/uniform-distribution.qmd`

This figure shows observed distribution of Provo modeled predictability with a unit-interval uniform reference.

## Slide 479: Definition

Source note: `random-variables-and-distributions/uniform-distribution.qmd`

The support is correct, but the histogram is concentrated near zero. A bounded response thus does not imply a uniform distribution.

## Slide 480: The uniform distribution: question 1

Source note: `random-variables-and-distributions/uniform-distribution.qmd`

Compare the empirical mean with the unit-interval uniform mean.

## Slide 481: The uniform distribution: answer 1

Source note: `random-variables-and-distributions/uniform-distribution.qmd`

The empirical mean modeled predictability is 0.146337, far below the unit-uniform mean $\mathbb{E}[X]=0.5$.

## Slide 482: The uniform distribution: question 2

Source note: `random-variables-and-distributions/uniform-distribution.qmd`

Compute the uniform reference probability between the empirical minimum and median.

## Slide 483: The uniform distribution: answer 2

Source note: `random-variables-and-distributions/uniform-distribution.qmd`

The empirical minimum is 0.004972 and the median is 0.026630, so the unit-uniform reference assigns their interval probability $0.026630-0.004972=0.021658$.

## Slide 484: The uniform distribution: question 3

Source note: `random-variables-and-distributions/uniform-distribution.qmd`

Why does the histogram not represent participant-level ratings?

## Slide 485: The uniform distribution: answer 3

Source note: `random-variables-and-distributions/uniform-distribution.qmd`

Each row is a Provo word position with a first-stage modeled predictability value, not an individual participant's cloze rating.

## Slide 486: The uniform distribution: question 4

Source note: `random-variables-and-distributions/uniform-distribution.qmd`

Which part of the uniform model fails here: support or density shape?

## Slide 487: The uniform distribution: answer 4

Source note: `random-variables-and-distributions/uniform-distribution.qmd`

The unit-interval support is appropriate because every value lies strictly between zero and one, but the flat density shape fails to match the concentration near zero. The beta distribution retains the bounded support while allowing the density shape to be estimated.

## Slide 488: The beta distribution

Source note: `random-variables-and-distributions/beta-distribution.qmd`

Now we turn to The beta distribution.

## Slide 489: The beta distribution

Source note: `random-variables-and-distributions/beta-distribution.qmd`

The uniform reference respected the unit-interval support of Provo modeled predictability but missed its shape. The **beta distribution** retains that support and estimates two shape parameters from the observations.

## Slide 490: Definition

Source note: `random-variables-and-distributions/beta-distribution.qmd`

For $0<x<1$,

$$
f_X(x\mid\alpha,\beta)
=\frac{\Gamma(\alpha+\beta)}
       {\Gamma(\alpha)\Gamma(\beta)}
x^{\alpha-1}(1-x)^{\beta-1},
\qquad \alpha,\beta>0.
$$

## Slide 491: Definition

Source note: `random-variables-and-distributions/beta-distribution.qmd`

The denominator is the beta function,

$$
B(\alpha,\beta)
=\int_0^1 t^{\alpha-1}(1-t)^{\beta-1}\,\mathrm dt
=\frac{\Gamma(\alpha)\Gamma(\beta)}{\Gamma(\alpha+\beta)}.
$$

## Slide 492: Definition

Source note: `random-variables-and-distributions/beta-distribution.qmd`

It normalizes the numerator to unit area. The first two moments follow from beta-function recurrences:

$$
\begin{aligned}
\mathbb{E}[X]
&=\frac{B(\alpha+1,\beta)}{B(\alpha,\beta)}
=\frac{\alpha}{\alpha+\beta},\\
\mathbb{E}[X^2]
&=\frac{B(\alpha+2,\beta)}{B(\alpha,\beta)}
=\frac{\alpha(\alpha+1)}
{(\alpha+\beta)(\alpha+\beta+1)}.
\end{aligned}
$$

## Slide 493: Definition

Source note: `random-variables-and-distributions/beta-distribution.qmd`

The mean and variance are

$$
\mathbb{E}[X]=\frac{\alpha}{\alpha+\beta},
$$

$$
\operatorname{Var}[X]
=\frac{\alpha\beta}
{(\alpha+\beta)^2(\alpha+\beta+1)}.
$$

## Slide 494: Definition

Source note: `random-variables-and-distributions/beta-distribution.qmd`

The sum $\alpha+\beta$ is the **concentration**: at a fixed mean, larger concentration places more density near that mean.

## Slide 495: Definition

Source note: `random-variables-and-distributions/beta-distribution.qmd`

For an arbitrary finite interval $a<y<b$, the affine transformation $Y=a+(b-a)X$ has density

$$
f_Y(y)=\frac{1}{b-a}
f_X\!\left(\frac{y-a}{b-a}\right),
\qquad a<y<b.
$$

## Slide 496: Definition

Source note: `random-variables-and-distributions/beta-distribution.qmd`

The factor $1/(b-a)$ is the Jacobian required to preserve total probability.

## Slide 497: Maximum-likelihood fit

Source note: `random-variables-and-distributions/beta-distribution.qmd`

The page reloads the Provo word-position table introduced on the preceding page. It optimizes over log shapes so that both fitted parameters remain positive.

## Slide 498: Maximum-likelihood fit

Source note: `random-variables-and-distributions/beta-distribution.qmd`

The fitted shapes are $\widehat\alpha=$ 0.373 and $\widehat\beta=$ 1.839. They imply mean 0.169 and variance 0.044.

## Slide 499: Maximum-likelihood fit

Source note: `random-variables-and-distributions/beta-distribution.qmd`

This figure shows observed Provo modeled predictability with the unit-uniform reference and fitted beta density.

## Slide 500: Maximum-likelihood fit

Source note: `random-variables-and-distributions/beta-distribution.qmd`

The beta density captures the strong concentration near zero much better than the flat reference. But it remains a descriptive model over first-stage fitted values, and the word positions are nested in passages.

## Slide 501: The beta distribution: question 1

Source note: `random-variables-and-distributions/beta-distribution.qmd`

Verify the fitted mean and variance from the shape formulas.

## Slide 502: The beta distribution: answer 1

Source note: `random-variables-and-distributions/beta-distribution.qmd`

With $\widehat\alpha=0.373101$ and $\widehat\beta=1.839198$, the shape formulas give $\mathbb{E}[X]=0.168648$ and $\operatorname{Var}[X]=0.043647$.

## Slide 503: The beta distribution: question 2

Source note: `random-variables-and-distributions/beta-distribution.qmd`

Fit the beta distribution separately within each `Word_POS` category.

## Slide 504: The beta distribution: answer 2

Source note: `random-variables-and-distributions/beta-distribution.qmd`

Separate fits give $(\widehat\alpha,\widehat\beta)=(0.3983,4.6777)$ for adjectives, $(0.3408,1.8735)$ for adverbs, $(0.3620,1.4550)$ for nouns, and $(0.4318,2.1724)$ for verbs.

## Slide 505: The beta distribution: question 3

Source note: `random-variables-and-distributions/beta-distribution.qmd`

Why are exact zeros or ones incompatible with this beta density?

## Slide 506: The beta distribution: answer 3

Source note: `random-variables-and-distributions/beta-distribution.qmd`

The fitted beta density has support $0<x<1$, so exact predictability values of zero or one fall outside its modeled support.

## Slide 507: The beta distribution: question 4

Source note: `random-variables-and-distributions/beta-distribution.qmd`

What uncertainty is absent when we model `OrthoMatchModel` as directly observed?

## Slide 508: The beta distribution: answer 4

Source note: `random-variables-and-distributions/beta-distribution.qmd`

Treating `OrthoMatchModel` as observed omits the uncertainty from the first-stage model that estimated each predictability value from cloze responses. The normal distribution returns to an unbounded reference family for acoustic measurements.

## Slide 509: The normal distribution

Source note: `random-variables-and-distributions/normal-distribution.qmd`

Next, we take up The normal distribution.

## Slide 510: The normal distribution

Source note: `random-variables-and-distributions/normal-distribution.qmd`

The **normal distribution** is a symmetric location-scale family. Its parameters should be estimated from the linguistic measurement at hand, and its shape should be compared with those observations rather than assumed from the name of the variable.

## Slide 511: Definition

Source note: `random-variables-and-distributions/normal-distribution.qmd`

For $X\sim\mathcal N(\mu,\sigma^2)$,

$$
f_X(x)
=\frac{1}{\sqrt{2\pi\sigma^2}}
\exp\left[-\frac{(x-\mu)^2}{2\sigma^2}\right],
\qquad x\in\mathbb R.
$$

## Slide 512: Definition

Source note: `random-variables-and-distributions/normal-distribution.qmd`

The parameters are

$$
\mathbb{E}[X]=\mu,
\qquad
\operatorname{Var}[X]=\sigma^2.
$$

Because the centered distance is squared,

$$
f_X(\mu-d)=f_X(\mu+d).
$$

## Slide 513: Definition

Source note: `random-variables-and-distributions/normal-distribution.qmd`

Thus $\mu$ controls location while $\sigma$ controls scale. Standardization gives

$$
Z=\frac{X-\mu}{\sigma}\sim\mathcal N(0,1),
\qquad
\mathbb{P}(X\leq x)
=\Phi\!\left(\frac{x-\mu}{\sigma}\right),
$$

where

$$
\Phi(z)=\int_{-\infty}^z
\frac{1}{\sqrt{2\pi}}e^{-t^2/2}\,\mathrm dt.
$$

## Slide 514: Fitting /i/ F1 by speaker group

Source note: `random-variables-and-distributions/normal-distribution.qmd`

We return to the Hillenbrand et al. vowel data introduced earlier. Each speaker produced one /hVd/ token for each vowel, so restricting to /i/ leaves one F1 measurement per speaker. The complete teaching table is appropriate for F1 because that source column has no natural missing values.

## Slide 515: Fitting /i/ F1 by speaker group

Source note: `random-variables-and-distributions/normal-distribution.qmd`

For observations $x_1,\ldots,x_n$, maximum likelihood gives

$$
\widehat\mu=\frac1n\sum_{i=1}^n x_i,
\qquad
\widehat\sigma^2=\frac1n\sum_{i=1}^n(x_i-\widehat\mu)^2.
$$

## Slide 516: Fitting /i/ F1 by speaker group

Source note: `random-variables-and-distributions/normal-distribution.qmd`

The group-specific estimates are computed above rather than selected to illustrate location or spread.

## Slide 517: Fitting /i/ F1 by speaker group

Source note: `random-variables-and-distributions/normal-distribution.qmd`

Observed /i/ F1 measurements and group-specific fitted normal densities. Each facet contains one token per speaker.

## Slide 518: Fitting /i/ F1 by speaker group

Source note: `random-variables-and-distributions/normal-distribution.qmd`

The overlays provide a descriptive reference. They do not establish normal sampling, and the source design supports claims about these recorded /hVd/ productions rather than spontaneous speech.

## Slide 519: The normal distribution: question 1

Source note: `random-variables-and-distributions/normal-distribution.qmd`

Verify one row of `fits` directly from the raw measurements.

## Slide 520: The normal distribution: answer 1

Source note: `random-variables-and-distributions/normal-distribution.qmd`

For adult men, the 45 raw /i/ F1 measurements have mean 342.688889 Hz and population-standard-deviation estimate 27.915596 Hz, matching the `fits` row.

## Slide 521: The normal distribution: question 2

Source note: `random-variables-and-distributions/normal-distribution.qmd`

Why does the MLE for $\sigma^2$ divide by $n$ rather than $n-1$?

## Slide 522: The normal distribution: answer 2

Source note: `random-variables-and-distributions/normal-distribution.qmd`

The normal MLE divides by $n$ because maximizing the likelihood estimates mean squared deviation directly; division by $n-1$ is a separate unbiasedness correction.

## Slide 523: The normal distribution: question 3

Source note: `random-variables-and-distributions/normal-distribution.qmd`

Standardize the adult-men measurements with their fitted parameters and inspect the resulting histogram.

## Slide 524: The normal distribution: answer 3

Source note: `random-variables-and-distributions/normal-distribution.qmd`

Standardizing adult-men values as $(F1-342.688889)/27.915596$ produces values with empirical mean zero and population standard deviation one while retaining the histogram's observed shape.

## Slide 525: The normal distribution: question 4

Source note: `random-variables-and-distributions/normal-distribution.qmd`

Which source restriction makes the within-facet observations nonrepeated by speaker?

## Slide 526: The normal distribution: answer 4

Source note: `random-variables-and-distributions/normal-distribution.qmd`

Restricting each facet to one vowel category leaves one measurement per speaker, so no speaker is repeated within a facet. The chi-squared distribution describes a variance statistic under stronger normal-sampling assumptions.

## Slide 527: The chi-squared distribution

Source note: `random-variables-and-distributions/chi-squared-distribution.qmd`

Our next step is The chi-squared distribution.

## Slide 528: The chi-squared distribution

Source note: `random-variables-and-distributions/chi-squared-distribution.qmd`

The normal page estimated a mean and variance for each /i/ F1 speaker group. Under an independent normal-sampling model, the uncertainty in an estimated variance has a **chi-squared reference distribution**.

## Slide 529: Definition

Source note: `random-variables-and-distributions/chi-squared-distribution.qmd`

If $Z_1,\ldots,Z_\nu$ are independent standard-normal variables, then

$$
Q=\sum_{j=1}^{\nu}Z_j^2
\sim\chi^2_\nu.
$$

## Slide 530: Definition

Source note: `random-variables-and-distributions/chi-squared-distribution.qmd`

Its density is

$$
f_Q(q)
=\frac{q^{\nu/2-1}e^{-q/2}}
       {2^{\nu/2}\Gamma(\nu/2)},
\qquad q>0,
$$

with

$$
\mathbb{E}[Q]=\nu,
\qquad
\operatorname{Var}[Q]=2\nu.
$$

## Slide 531: Definition

Source note: `random-variables-and-distributions/chi-squared-distribution.qmd`

The moments follow from independence and the standard-normal moments:

$$
\begin{aligned}
\mathbb{E}[Q]
&=\sum_{j=1}^{\nu}\mathbb{E}[Z_j^2]
=\nu,\\
\operatorname{Var}[Q]
&=\sum_{j=1}^{\nu}\operatorname{Var}[Z_j^2]
=2\nu.
\end{aligned}
$$

## Slide 532: Definition

Source note: `random-variables-and-distributions/chi-squared-distribution.qmd`

For an independent sample from $\mathcal N(\mu,\sigma^2)$,

$$
\frac{(n-1)S^2}{\sigma^2}\sim\chi^2_{n-1}.
$$

## Slide 533: Degrees of freedom from the vowel data

Source note: `random-variables-and-distributions/chi-squared-distribution.qmd`

The degrees of freedom below are not illustrative choices. They come from the numbers of speakers who produced /i/ in the Hillenbrand dataset.

## Slide 534: Degrees of freedom from the vowel data

Source note: `random-variables-and-distributions/chi-squared-distribution.qmd`

For adult men, $\nu=$ 44. The reference mean is thus 44 and the reference variance is 88. The central reference interval runs from 27.57 to 64.20.

## Slide 535: Degrees of freedom from the vowel data

Source note: `random-variables-and-distributions/chi-squared-distribution.qmd`

This figure shows chi-squared reference densities whose degrees of freedom come from the observed /i/ speaker-group sizes.

## Slide 536: Degrees of freedom from the vowel data

Source note: `random-variables-and-distributions/chi-squared-distribution.qmd`

The curves use the vowel sample size to show how the reference changes with degrees of freedom.

## Slide 537: The chi-squared distribution: question 1

Source note: `random-variables-and-distributions/chi-squared-distribution.qmd`

Confirm each degree of freedom from the raw /i/ rows.

## Slide 538: The chi-squared distribution: answer 1

Source note: `random-variables-and-distributions/chi-squared-distribution.qmd`

The raw /i/ groups contain 27 boys, 19 girls, 45 men, and 48 women, giving 26, 18, 44, and 47 degrees of freedom, respectively.

## Slide 539: The chi-squared distribution: question 2

Source note: `random-variables-and-distributions/chi-squared-distribution.qmd`

Why does the variance statistic use $n-1$ degrees of freedom?

## Slide 540: The chi-squared distribution: answer 2

Source note: `random-variables-and-distributions/chi-squared-distribution.qmd`

The variance statistic has $n-1$ degrees of freedom because estimating the sample mean imposes the constraint that the centered deviations sum to zero.

## Slide 541: The chi-squared distribution: question 3

Source note: `random-variables-and-distributions/chi-squared-distribution.qmd`

Use `qchisq()` to compute the corresponding central interval for another speaker group.

## Slide 542: The chi-squared distribution: answer 3

Source note: `random-variables-and-distributions/chi-squared-distribution.qmd`

For the 48 women, `qchisq(c(.025, .975), df = 47)` gives the central interval $[29.956,67.821]$.

## Slide 543: The chi-squared distribution: question 4

Source note: `random-variables-and-distributions/chi-squared-distribution.qmd`

Why would substituting the sample variance for $\sigma^2$ erase the inferential question?

## Slide 544: The chi-squared distribution: answer 4

Source note: `random-variables-and-distributions/chi-squared-distribution.qmd`

Replacing $\sigma^2$ with the same sample variance makes $(n-1)S^2/S^2=n-1$ identically, erasing the comparison to an unknown population variance. The Student-t distribution incorporates variance estimation into a standardized mean statistic.

## Slide 545: The Student-t distribution

Source note: `random-variables-and-distributions/student-t-distribution.qmd`

The next topic is The Student-t distribution.

## Slide 546: The Student-t distribution

Source note: `random-variables-and-distributions/student-t-distribution.qmd`

Standardizing a sample mean with an estimated standard deviation adds uncertainty. Under independent normal sampling, the resulting statistic follows a **Student-$t$ distribution**, which has heavier tails than the standard normal.

## Slide 547: Construction

Source note: `random-variables-and-distributions/student-t-distribution.qmd`

If $Z\sim\mathcal N(0,1)$, $Q\sim\chi^2_\nu$, and $Z$ is independent of $Q$, then

$$
T=\frac{Z}{\sqrt{Q/\nu}}\sim t_\nu.
$$

## Slide 548: Construction

Source note: `random-variables-and-distributions/student-t-distribution.qmd`

For independent normal differences $D_1,\ldots,D_n$ with population mean $\mu_D$,

$$
\overline D=\frac1n\sum_{i=1}^nD_i,
\qquad
S_D^2=\frac{1}{n-1}\sum_{i=1}^n(D_i-\overline D)^2,
$$

$$
T
=\frac{\overline D-\mu_D}{S_D/\sqrt n}
\sim t_{n-1}.
$$

## Slide 549: Construction

Source note: `random-variables-and-distributions/student-t-distribution.qmd`

The centered differences obey

$$
\sum_{i=1}^n(D_i-\overline D)=0,
$$

so only $n-1$ deviations vary freely.

## Slide 550: Construction

Source note: `random-variables-and-distributions/student-t-distribution.qmd`

The density is symmetric, $f_T(-t)=f_T(t)$, and for $c>0$,

$$
\mathbb{P}(|T|\geq c)=2\mathbb{P}(T\geq c).
$$

## Slide 551: Construction

Source note: `random-variables-and-distributions/student-t-distribution.qmd`

As $\nu$ increases, estimating the scale matters less and the $t$ density approaches the standard-normal density.

## Slide 552: Paired acoustic measurements

Source note: `random-variables-and-distributions/student-t-distribution.qmd`

Hillenbrand et al. recorded each speaker producing both /ae/ in *had* and /i/ in *heed*. We preserve that pairing and define $D$ as F1(/ae/) minus F1(/i/) in hertz.

## Slide 553: Paired acoustic measurements

Source note: `random-variables-and-distributions/student-t-distribution.qmd`

The observed mean difference is 251.0 Hz, with standard error 6.93 Hz. Relative to a zero-difference reference, the standardized statistic is 36.23 with 138 degrees of freedom. This calculation describes the paired measurements; its sampling interpretation still requires the model assumptions above.

## Slide 554: Paired acoustic measurements

Source note: `random-variables-and-distributions/student-t-distribution.qmd`

Observed within-speaker F1 differences. The accent line marks the observed mean; the dashed line marks zero.

## Slide 555: Paired acoustic measurements

Source note: `random-variables-and-distributions/student-t-distribution.qmd`

This figure shows the t reference determined by the paired sample size, compared with a standard-normal density.

## Slide 556: The Student-t distribution: question 1

Source note: `random-variables-and-distributions/student-t-distribution.qmd`

Recompute the paired differences by reshaping rather than merging.

## Slide 557: The Student-t distribution: answer 1

Source note: `random-variables-and-distributions/student-t-distribution.qmd`

Reshaping to one row per speaker reproduces 139 /ae/-/i/ F1 differences with mean 250.964 Hz and standard deviation 81.665 Hz.

## Slide 558: The Student-t distribution: question 2

Source note: `random-variables-and-distributions/student-t-distribution.qmd`

Why is the speaker, rather than the vowel token, the paired unit?

## Slide 559: The Student-t distribution: answer 2

Source note: `random-variables-and-distributions/student-t-distribution.qmd`

The speaker is the paired unit because each difference combines that speaker's /ae/ and /i/ tokens; the two vowel tokens are the measurements being paired.

## Slide 560: The Student-t distribution: question 3

Source note: `random-variables-and-distributions/student-t-distribution.qmd`

Compare `dt()` and `dnorm()` farther into the tails.

## Slide 561: The Student-t distribution: answer 3

Source note: `random-variables-and-distributions/student-t-distribution.qmd`

Farther from zero, the $t_{138}$ density and tail probabilities exceed their standard-normal counterparts because estimating scale produces heavier tails.

## Slide 562: The Student-t distribution: question 4

Source note: `random-variables-and-distributions/student-t-distribution.qmd`

What assumption is needed to interpret the displayed $t$ density as the statistic's sampling distribution?

## Slide 563: The Student-t distribution: answer 4

Source note: `random-variables-and-distributions/student-t-distribution.qmd`

The $t_{138}$ density is a sampling reference for the paired Hillenbrand F1 statistic only if the speaker-level differences are independent normal draws, or an approximation is justified. The inverse-transform page returns to the empirical Turkish interrogative-lemma distribution and shows how to sample from it.

## Slide 564: Inverse-transform sampling

Source note: `random-variables-and-distributions/inverse-transform-sampling.qmd`

Our next step is Inverse-transform sampling.

## Slide 565: Inverse-transform sampling

Source note: `random-variables-and-distributions/inverse-transform-sampling.qmd`

The empirical Turkish interrogative-lemma PMF assigns probability to labels, while a computer's basic random-number generator produces values on the unit interval. **Inverse-transform sampling** maps those uniform values into draws from the target PMF.

## Slide 566: From cumulative mass to labels

Source note: `random-variables-and-distributions/inverse-transform-sampling.qmd`

For an ordered numerical support, define the generalized inverse CDF by

$$
F^{-1}(u)=\inf\{x:F(x)\geq u\},
\qquad 0<u<1.
$$

## Slide 567: From cumulative mass to labels

Source note: `random-variables-and-distributions/inverse-transform-sampling.qmd`

If $U\sim\operatorname{Uniform}(0,1)$, then $F^{-1}(U)$ has CDF $F$. For categorical labels, we first assign a computational order. That order does not imply that *hangi*, *kim*, and *ne* form a linguistic scale.

## Slide 568: From cumulative mass to labels

Source note: `random-variables-and-distributions/inverse-transform-sampling.qmd`

The construction works because, at continuity points of $F$,

$$
\mathbb{P}\!\left(F^{-1}(U)\leq x\right)
=\mathbb{P}\!\left(U\leq F(x)\right)
=F(x).
$$

## Slide 569: From cumulative mass to labels

Source note: `random-variables-and-distributions/inverse-transform-sampling.qmd`

The cumulative intervals $[c_{k-1},c_k)$ have widths

$$
c_k-c_{k-1}=\widehat p_k.
$$

## Slide 570: From cumulative mass to labels

Source note: `random-variables-and-distributions/inverse-transform-sampling.qmd`

Thus a uniform draw lands in the interval for lemma $k$ with the empirical lemma probability $\widehat p_k$.

## Slide 571: From cumulative mass to labels

Source note: `random-variables-and-distributions/inverse-transform-sampling.qmd`

This figure shows empirical Turkish interrogative-lemma probabilities and proportions from an inverse-transform diagnostic.

## Slide 572: From cumulative mass to labels

Source note: `random-variables-and-distributions/inverse-transform-sampling.qmd`

The simulation is an implementation check, not a replacement for the corpus probabilities. Increasing the number of draws generally reduces simulation error, while it does nothing to repair the corpus's sentence clustering or register coverage.

## Slide 573: Inverse-transform sampling: question 1

Source note: `random-variables-and-distributions/inverse-transform-sampling.qmd`

Inspect the first rows of `draws` and verify each interval assignment manually.

## Slide 574: Inverse-transform sampling: answer 1

Source note: `random-variables-and-distributions/inverse-transform-sampling.qmd`

The first six uniforms, 0.4051, 0.7612, 0.1691, 0.9279, 0.3046, and 0.3345, all fall in the *ne* interval $[0.119760,1]$, so each is assigned *ne*.

## Slide 575: Inverse-transform sampling: question 2

Source note: `random-variables-and-distributions/inverse-transform-sampling.qmd`

Change `diagnostic_n` and compare the absolute errors.

## Slide 576: Inverse-transform sampling: answer 2

Source note: `random-variables-and-distributions/inverse-transform-sampling.qmd`

With seed 20261018, increasing `diagnostic_n` from 10,000 to 100,000 reduces the *hangi*, *kim*, and *ne* errors from 0.001064, 0.002196, and 0.003260 to 0.000146, 0.000786, and 0.000640.

## Slide 577: Inverse-transform sampling: question 3

Source note: `random-variables-and-distributions/inverse-transform-sampling.qmd`

Reverse the category order and confirm that the target masses remain attached to the same labels.

## Slide 578: Inverse-transform sampling: answer 3

Source note: `random-variables-and-distributions/inverse-transform-sampling.qmd`

Reversing category order changes interval locations but not widths, so the target masses remain 0.017964 for *hangi*, 0.101796 for *kim*, and 0.880240 for *ne*.

## Slide 579: Inverse-transform sampling: question 4

Source note: `random-variables-and-distributions/inverse-transform-sampling.qmd`

Why are the simulated proportions not new linguistic observations?

## Slide 580: Inverse-transform sampling: answer 4

Source note: `random-variables-and-distributions/inverse-transform-sampling.qmd`

The simulated proportions are computational draws from the empirical PMF, not newly observed Turkish tokens or annotations. The random-seed page separates reproducibility of the computation from replication of the linguistic data.

## Slide 581: Random seeds

Source note: `random-variables-and-distributions/random-seeds.qmd`

Our next step is Random seeds.

## Slide 582: Random seeds

Source note: `random-variables-and-distributions/random-seeds.qmd`

A pseudorandom generator produces a deterministic sequence from an initial state. A **random seed** records that state, allowing a stochastic computation to be reproduced exactly. Reproducing a sequence is not the same as collecting a new linguistic sample.

## Slide 583: Repeating the Turkish lemma sampler

Source note: `random-variables-and-distributions/random-seeds.qmd`

This page reloads the BOUN interrogative table and reconstructs the inverse-transform sampler. The sample size and seeds below are computational settings; the target probabilities still come from the corpus.

## Slide 584: Repeating the Turkish lemma sampler

Source note: `random-variables-and-distributions/random-seeds.qmd`

Calling `set.seed()` restores the generator state. The same sampler then consumes the same uniform sequence and returns the same lemma sequence. The second seed changes the Monte Carlo realization but not the target PMF.

## Slide 585: Repeating the Turkish lemma sampler

Source note: `random-variables-and-distributions/random-seeds.qmd`

Cumulative simulated proportion of ne under two seeds. The horizontal line is the empirical target probability.

## Slide 586: Repeating the Turkish lemma sampler

Source note: `random-variables-and-distributions/random-seeds.qmd`

Both paths fluctuate because each is finite. A seed makes those fluctuations inspectable and debuggable; choosing a different seed is not a robustness analysis by itself. Robustness requires examining the distribution of results across many independently generated sequences or using an exact calculation when one is available.

## Slide 587: Random seeds: question 1

Source note: `random-variables-and-distributions/random-seeds.qmd`

Confirm that `draw_a1` and `draw_a2` agree element by element.

## Slide 588: Random seeds: answer 1

Source note: `random-variables-and-distributions/random-seeds.qmd`

`identical(draw_a1, draw_a2)` is `TRUE`, so the two same-seed draws agree element by element.

## Slide 589: Random seeds: question 2

Source note: `random-variables-and-distributions/random-seeds.qmd`

Move `set.seed()` outside the function and explain how the behavior changes.

## Slide 590: Random seeds: answer 2

Source note: `random-variables-and-distributions/random-seeds.qmd`

With `set.seed()` outside the function, successive calls consume later parts of the random stream and differ, though rerunning the whole seeded sequence remains reproducible.

## Slide 591: Random seeds: question 3

Source note: `random-variables-and-distributions/random-seeds.qmd`

Repeat the final proportion across many seeds and plot its distribution.

## Slide 592: Random seeds: answer 3

Source note: `random-variables-and-distributions/random-seeds.qmd`

Across seeds 1-1,000 with 250 draws each, the *ne* proportion has mean 0.878912, standard deviation 0.021040, and range 0.804-0.940 around the empirical target 0.880240.

## Slide 593: Random seeds: question 4

Source note: `random-variables-and-distributions/random-seeds.qmd`

Why does setting a seed not address sentence-level dependence in the corpus?

## Slide 594: Random seeds: answer 4

Source note: `random-variables-and-distributions/random-seeds.qmd`

A seed controls computational reproducibility but does not change the fact that corpus tokens can share sentences, registers, or other sampling units. The joint-distribution page turns from simulation to paired measurements in the English dative data.

## Slide 595: Joint distributions

Source note: `random-variables-and-distributions/joint-probability.qmd`

Next, we take up Joint distributions.

## Slide 596: Joint distributions

Source note: `random-variables-and-distributions/joint-probability.qmd`

Recipient length and theme length are measured on the same dative token. Separate distributions discard that pairing. A **joint distribution** assigns mass to the ordered length pair and thus preserves which values co-occur.

## Slide 597: Definition

Source note: `random-variables-and-distributions/joint-probability.qmd`

Let $R$ be recipient length in words and $T$ be theme length in words. Their joint PMF is

$$
p_{R,T}(r,t)
=\mathbb{P}(R=r,T=t).
$$

## Slide 598: Definition

Source note: `random-variables-and-distributions/joint-probability.qmd`

It must satisfy

$$
p_{R,T}(r,t)\geq0,
\qquad
\sum_r\sum_t p_{R,T}(r,t)=1.
$$

## Slide 599: Definition

Source note: `random-variables-and-distributions/joint-probability.qmd`

For any set $A$ of length pairs,

$$
\mathbb{P}\big(\langle R,T\rangle\in A\big)
=\sum_{\langle r,t\rangle\in A}p_{R,T}(r,t).
$$

## Slide 600: Definition

Source note: `random-variables-and-distributions/joint-probability.qmd`

For absolutely continuous variables, the corresponding definition is

$$
\mathbb{P}\big(\langle R,T\rangle\in A\big)
=\iint_A f_{R,T}(r,t)\,\mathrm dr\,\mathrm dt,
$$

where $f_{R,T}(r,t)\geq0$ and $\iint_{\mathbb R^2}f_{R,T}(r,t)\,\mathrm dr\,\mathrm dt=1$.

## Slide 601: The observed dative joint PMF

Source note: `random-variables-and-distributions/joint-probability.qmd`

We return to the English dative table introduced on the Poisson page. The original study treats relative length as one of many predictors of dative realization; here we first describe the paired constituent lengths without fitting that response model.

## Slide 602: The observed dative joint PMF

Source note: `random-variables-and-distributions/joint-probability.qmd`

The most frequent observed pair is a recipient of 1 word(s) with a theme of 2 word(s). Its empirical joint mass is 0.175. Both values belong to the same token; independently tabulating the two variables would lose that fact.

## Slide 603: The observed dative joint PMF

Source note: `random-variables-and-distributions/joint-probability.qmd`

This figure shows observed joint distribution of recipient and theme lengths. Point area represents the number of dative tokens in each length pair.

## Slide 604: The observed dative joint PMF

Source note: `random-variables-and-distributions/joint-probability.qmd`

The dense lower-left region shows that both constituents are often short, while the rarer points retain the long tails. A joint PMF describes this pinned table; repeated verbs and speakers still limit independent-sampling claims.

## Slide 605: Joint distributions: question 1

Source note: `random-variables-and-distributions/joint-probability.qmd`

Compute the empirical probability that both lengths are at most their empirical medians.

## Slide 606: Joint distributions: answer 1

Source note: `random-variables-and-distributions/joint-probability.qmd`

For recipient length $R$ and theme length $T$, the empirical probability that both are at most their respective medians is 0.425375.

## Slide 607: Joint distributions: question 2

Source note: `random-variables-and-distributions/joint-probability.qmd`

Verify one joint cell directly from the row-level data.

## Slide 608: Joint distributions: answer 2

Source note: `random-variables-and-distributions/joint-probability.qmd`

The modal joint cell contains 572 rows with recipient length 1 and theme length 2, giving $572/3263=0.175299$.

## Slide 609: Joint distributions: question 3

Source note: `random-variables-and-distributions/joint-probability.qmd`

Explain why shuffling theme lengths leaves both marginal PMFs unchanged but changes the joint PMF.

## Slide 610: Joint distributions: answer 3

Source note: `random-variables-and-distributions/joint-probability.qmd`

Shuffling theme lengths preserves every recipient and theme count separately but breaks the row pairings that determine the joint PMF.

## Slide 611: Joint distributions: question 4

Source note: `random-variables-and-distributions/joint-probability.qmd`

Which identifier would you preserve when asking how the pairing varies by verb?

## Slide 612: Joint distributions: answer 4

Source note: `random-variables-and-distributions/joint-probability.qmd`

The `verb` identifier should be retained to study how recipient-theme length pairings vary across repeated verb types. The next page recovers either one-variable distribution by summing the joint mass.

## Slide 613: Marginal distributions

Source note: `random-variables-and-distributions/marginal-distributions.qmd`

Our next step is Marginal distributions.

## Slide 614: Marginal distributions

Source note: `random-variables-and-distributions/marginal-distributions.qmd`

A joint PMF preserves two paired measurements. A **marginal distribution** removes one measurement by summing over all of its possible values.

## Slide 615: Marginalization

Source note: `random-variables-and-distributions/marginal-distributions.qmd`

For recipient length $R$ and theme length $T$,

$$
p_R(r)=\sum_t p_{R,T}(r,t),
\qquad
p_T(t)=\sum_r p_{R,T}(r,t).
$$

## Slide 616: Marginalization

Source note: `random-variables-and-distributions/marginal-distributions.qmd`

Each marginal normalizes:

$$
\sum_r p_R(r)=1,
\qquad
\sum_t p_T(t)=1.
$$

## Slide 617: Marginalization

Source note: `random-variables-and-distributions/marginal-distributions.qmd`

Marginalization forgets the pairing but not the frequency of the retained variable.

## Slide 618: Marginalization

Source note: `random-variables-and-distributions/marginal-distributions.qmd`

For a joint density, summation becomes integration:

$$
f_R(r)=\int_{-\infty}^{\infty}f_{R,T}(r,t)\,\mathrm dt,
\qquad
f_T(t)=\int_{-\infty}^{\infty}f_{R,T}(r,t)\,\mathrm dr.
$$

## Slide 619: Marginalization

Source note: `random-variables-and-distributions/marginal-distributions.qmd`

Marginalization should not be confused with conditioning. When $p_T(t)>0$,

$$
p_{R\mid T}(r\mid t)=\frac{p_{R,T}(r,t)}{p_T(t)},
$$

which fixes one value and renormalizes instead of summing it out.

## Slide 620: Marginalization

Source note: `random-variables-and-distributions/marginal-distributions.qmd`

The empirical marginal expectations can be computed either from the row-level measurements or from their PMFs:

$$
\mathbb{E}[R]=\sum_r r\,p_R(r),
\qquad
\mathbb{E}[T]=\sum_t t\,p_T(t).
$$

## Slide 621: Marginalization

Source note: `random-variables-and-distributions/marginal-distributions.qmd`

In this table, those means are 1.842 recipient words and 4.272 theme words.

## Slide 622: Marginalization

Source note: `random-variables-and-distributions/marginal-distributions.qmd`

This figure shows marginal empirical PMFs obtained by summing the dative joint distribution.

## Slide 623: Marginalization

Source note: `random-variables-and-distributions/marginal-distributions.qmd`

The plots retain the different supports and tail shapes. They do not show whether a long recipient occurred with a long or short theme; that information existed only in the joint distribution.

## Slide 624: Marginal distributions: question 1

Source note: `random-variables-and-distributions/marginal-distributions.qmd`

Marginalize `joint` with `rowsum()` or matrix operations and compare the result.

## Slide 625: Marginal distributions: answer 1

Source note: `random-variables-and-distributions/marginal-distributions.qmd`

Summing `joint` over theme columns reproduces `recipient_margin`, and summing over recipient rows reproduces the theme margin; both normalized margins sum to one.

## Slide 626: Marginal distributions: question 2

Source note: `random-variables-and-distributions/marginal-distributions.qmd`

Compute each marginal variance from the PMF.

## Slide 627: Marginal distributions: answer 2

Source note: `random-variables-and-distributions/marginal-distributions.qmd`

The PMFs give $\operatorname{Var}[R]=4.274507$ and $\operatorname{Var}[T]=18.986650$ words squared.

## Slide 628: Marginal distributions: question 3

Source note: `random-variables-and-distributions/marginal-distributions.qmd`

Why can two datasets have identical marginal plots but different joint plots?

## Slide 629: Marginal distributions: answer 3

Source note: `random-variables-and-distributions/marginal-distributions.qmd`

Identical marginals retain the same separate value frequencies but can arise from different pairings, which produce different joint distributions.

## Slide 630: Marginal distributions: question 4

Source note: `random-variables-and-distributions/marginal-distributions.qmd`

Which marginal has the longer observed support?

## Slide 631: Marginal distributions: answer 4

Source note: `random-variables-and-distributions/marginal-distributions.qmd`

Theme length has the longer observed support: 36 distinct values from 1 to 46, versus 20 recipient values from 1 to 31. The conditional-independence page asks whether two dative annotations factorize after modality is held fixed.

## Slide 632: Conditional independence

Source note: `random-variables-and-distributions/conditional-independence.qmd`

The next topic is Conditional independence.

## Slide 633: Conditional independence

Source note: `random-variables-and-distributions/conditional-independence.qmd`

Two variables can remain associated even after a third variable is held fixed. **Conditional independence** names the stronger claim that their conditional joint distribution factorizes within every value of the conditioning variable.

## Slide 634: Definition

Source note: `random-variables-and-distributions/conditional-independence.qmd`

Let $A$ record recipient pronominality, $B$ recipient realization, and $M$ corpus modality. We write

$$
A\perp B\mid M
$$

when, for every value with positive conditioning probability,

$$
\mathbb{P}(A=a,B=b\mid M=m)
=\mathbb{P}(A=a\mid M=m)\,
 \mathbb{P}(B=b\mid M=m).
$$

## Slide 635: Definition

Source note: `random-variables-and-distributions/conditional-independence.qmd`

Equivalently, wherever the conditioning probabilities are positive,

$$
\mathbb{P}(A=a\mid B=b,M=m)
=\mathbb{P}(A=a\mid M=m).
$$

## Slide 636: Definition

Source note: `random-variables-and-distributions/conditional-independence.qmd`

This equality states the usual conditional-independence criterion: learning $B$ supplies no further information about $A$ after $M$ is known.

## Slide 637: Definition

Source note: `random-variables-and-distributions/conditional-independence.qmd`

For a contingency table within modality $m$, factorization predicts cell count

$$
\widehat n_{ab\mid m}
=\frac{n_{a+\mid m}\,n_{+b\mid m}}{n_{++\mid m}}.
$$

## Slide 638: Checking factorization in the dative table

Source note: `random-variables-and-distributions/conditional-independence.qmd`

The paper analyzes pronominality, modality, and realization jointly with other predictors. The calculation is a descriptive factorization check, not the paper's fitted model.

## Slide 639: Checking factorization in the dative table

Source note: `random-variables-and-distributions/conditional-independence.qmd`

Under conditional independence, the NP proportion would be constant across pronominality values within each modality. The observed values depart from that factorization in both panels.

## Slide 640: Checking factorization in the dative table

Source note: `random-variables-and-distributions/conditional-independence.qmd`

This figure shows observed NP-recipient proportions and the proportions predicted by conditional independence within modality.

## Slide 641: Checking factorization in the dative table

Source note: `random-variables-and-distributions/conditional-independence.qmd`

A Pearson discrepancy summarizes the departures, but row-level independence is not credible because tokens repeat verbs and spoken speakers. We thus use it descriptively here and do not attach a confirmatory reference claim.

## Slide 642: Conditional independence: question 1

Source note: `random-variables-and-distributions/conditional-independence.qmd`

Verify one expected cell from its conditional margins.

## Slide 643: Conditional independence: answer 1

Source note: `random-variables-and-distributions/conditional-independence.qmd`

For spoken nonpronominal NP recipients, the conditional-independence count is $(475\times1859)/2360=374.163$, compared with 192 observed.

## Slide 644: Conditional independence: question 2

Source note: `random-variables-and-distributions/conditional-independence.qmd`

Which graphical pattern would conditional independence produce?

## Slide 645: Conditional independence: answer 2

Source note: `random-variables-and-distributions/conditional-independence.qmd`

Conditional independence would put the two pronominality values at the same NP probability within each modality, so each panel's observed line would be horizontal at its reference line.

## Slide 646: Conditional independence: question 3

Source note: `random-variables-and-distributions/conditional-independence.qmd`

Why does conditioning on modality not remove the observed association?

## Slide 647: Conditional independence: answer 3

Source note: `random-variables-and-distributions/conditional-independence.qmd`

Conditioning on modality does not remove the association because the observed NP proportions still differ by pronominality: 0.404 versus 0.884 in speech and 0.541 versus 0.987 in writing.

## Slide 648: Conditional independence: question 4

Source note: `random-variables-and-distributions/conditional-independence.qmd`

Why is a row-independent chi-squared test poorly matched to these data?

## Slide 649: Conditional independence: answer 4

Source note: `random-variables-and-distributions/conditional-independence.qmd`

A row-independent chi-squared reference is poorly matched because corpus tokens repeat verbs and, in the spoken data, speakers. The conditional-expectation page asks how mean recipient length changes with realization.

## Slide 650: Conditional expectation

Source note: `random-variables-and-distributions/conditional-expectation.qmd`

Next, we take up Conditional expectation.

## Slide 651: Conditional expectation

Source note: `random-variables-and-distributions/conditional-expectation.qmd`

A marginal mean averages across all dative tokens. If recipient length differs between NP and PP realizations, that average conceals structured variation. A **conditional expectation** gives the mean within a specified condition.

## Slide 652: Definition

Source note: `random-variables-and-distributions/conditional-expectation.qmd`

For discrete $X$ and $Y$,

$$
\mathbb{E}[X\mid Y=y]
=\sum_x x\,\mathbb{P}(X=x\mid Y=y).
$$

## Slide 653: Definition

Source note: `random-variables-and-distributions/conditional-expectation.qmd`

For a conditional density, the analogous definition is

$$
\mathbb{E}[X\mid Y=y]
=\int_{-\infty}^{\infty}x f_{X\mid Y}(x\mid y)\,\mathrm dx.
$$

## Slide 654: Definition

Source note: `random-variables-and-distributions/conditional-expectation.qmd`

Writing $m(y)=\mathbb{E}[X\mid Y=y]$ makes the **conditional-mean function** explicit. The conditional expectation $\mathbb{E}[X\mid Y]=m(Y)$ is itself a random variable: its value depends on the realized category of $Y$.

## Slide 655: Definition

Source note: `random-variables-and-distributions/conditional-expectation.qmd`

The **law of total expectation** reconnects conditional and marginal means:

$$
\mathbb{E}[X]
=\sum_y \mathbb{E}[X\mid Y=y]\mathbb{P}(Y=y).
$$

## Slide 656: Definition

Source note: `random-variables-and-distributions/conditional-expectation.qmd`

Indeed, substituting the conditional PMF gives

$$
\begin{aligned}
\mathbb{E}[X]
&=\sum_x x\sum_y\mathbb{P}(X=x,Y=y)\\
&=\sum_y\left[
  \sum_x x\,\mathbb{P}(X=x\mid Y=y)
  \right]\mathbb{P}(Y=y).
\end{aligned}
$$

## Slide 657: Recipient length by realization

Source note: `random-variables-and-distributions/conditional-expectation.qmd`

The conditional mean is 1.328 words for NP recipients and 3.304 words for PP recipients. Weighting those means by the empirical realization probabilities reconstructs the marginal mean of 1.842 words.

## Slide 658: Recipient length by realization

Source note: `random-variables-and-distributions/conditional-expectation.qmd`

Observed recipient lengths by realization. Accent points mark the conditional means.

## Slide 659: Recipient length by realization

Source note: `random-variables-and-distributions/conditional-expectation.qmd`

The difference is descriptive. It does not by itself show that constituent length causes realization, because the source paper identifies several correlated syntactic, semantic, and discourse predictors.

## Slide 660: Conditional expectation: question 1

Source note: `random-variables-and-distributions/conditional-expectation.qmd`

Reconstruct each conditional mean from a conditional PMF rather than row-level averaging.

## Slide 661: Conditional expectation: answer 1

Source note: `random-variables-and-distributions/conditional-expectation.qmd`

The conditional PMFs give $\mathbb{E}[R\mid\mathrm{NP}]=1.328086$ and $\mathbb{E}[R\mid\mathrm{PP}]=3.303887$ words.

## Slide 662: Conditional expectation: question 2

Source note: `random-variables-and-distributions/conditional-expectation.qmd`

Verify every term in the law of total expectation from `conditional`.

## Slide 663: Conditional expectation: answer 2

Source note: `random-variables-and-distributions/conditional-expectation.qmd`

The total-expectation terms are $0.739810(1.328086)=0.982531$ and $0.260190(3.303887)=0.859638$, which sum to $\mathbb{E}[R]=1.842170$.

## Slide 664: Conditional expectation: question 3

Source note: `random-variables-and-distributions/conditional-expectation.qmd`

What would the conditional-expectation function look like if the two group means were equal?

## Slide 665: Conditional expectation: answer 3

Source note: `random-variables-and-distributions/conditional-expectation.qmd`

If the group means were equal, the conditional-expectation function would be constant at that common mean for both NP and PP realizations.

## Slide 666: Conditional expectation: question 4

Source note: `random-variables-and-distributions/conditional-expectation.qmd`

Why is the observed mean difference not a causal effect?

## Slide 667: Conditional expectation: answer 4

Source note: `random-variables-and-distributions/conditional-expectation.qmd`

The mean difference is descriptive rather than causal because realization was not randomly assigned and covaries with other properties of the corpus tokens. The covariance page returns to the paired recipient and theme lengths and measures their linear co-variation.

## Slide 668: Covariance

Source note: `random-variables-and-distributions/covariance.qmd`

Now we turn to Covariance.

## Slide 669: Covariance

Source note: `random-variables-and-distributions/covariance.qmd`

Recipient and theme lengths are paired on each dative token. The **covariance** summarizes whether their deviations from their respective means tend to have the same sign.

## Slide 670: Definition

Source note: `random-variables-and-distributions/covariance.qmd`

For random variables $R$ and $T$,

$$
\operatorname{Cov}(R,T)
=\mathbb{E}\left[(R-\mathbb{E}[R])(T-\mathbb{E}[T])\right].
$$

## Slide 671: Definition

Source note: `random-variables-and-distributions/covariance.qmd`

Expanding the product gives the equivalent identity

$$
\operatorname{Cov}(R,T)
=\mathbb{E}[RT]-\mathbb{E}[R]\mathbb{E}[T].
$$

## Slide 672: Definition

Source note: `random-variables-and-distributions/covariance.qmd`

More explicitly,

$$
\begin{aligned}
\mathbb{E}[(R-\mathbb{E}[R])(T-\mathbb{E}[T])]
&=\mathbb{E}[RT]
-\mathbb{E}[R]\mathbb{E}[T]\\
&\quad-\mathbb{E}[T]\mathbb{E}[R]
+\mathbb{E}[R]\mathbb{E}[T]\\
&=\mathbb{E}[RT]-\mathbb{E}[R]\mathbb{E}[T].
\end{aligned}
$$

## Slide 673: Definition

Source note: `random-variables-and-distributions/covariance.qmd`

For constants $a,b,c,d$,

$$
\operatorname{Cov}(aR+b,cT+d)
=ac\,\operatorname{Cov}(R,T).
$$

## Slide 674: Definition

Source note: `random-variables-and-distributions/covariance.qmd`

Covariance has units equal to the product of the two measurement units. Here both lengths are measured in words, so covariance is measured in words squared.

## Slide 675: Empirical covariance of dative lengths

Source note: `random-variables-and-distributions/covariance.qmd`

The empirical population covariance is 0.284 words squared. Its positive sign means that same-direction deviations make a slightly larger average contribution than opposite-direction deviations.

## Slide 676: Empirical covariance of dative lengths

Source note: `random-variables-and-distributions/covariance.qmd`

Observed dative length pairs. Point area shows token count; accent lines mark the two empirical means.

## Slide 677: Empirical covariance of dative lengths

Source note: `random-variables-and-distributions/covariance.qmd`

The cloud extends far on both axes but has little diagonal organization. Covariance alone does not show nonlinear dependence, and its magnitude cannot be compared across variables with different units or scales.

## Slide 678: Sample covariance

Source note: `random-variables-and-distributions/covariance.qmd`

When rows are treated as a sample for estimating a population covariance, the familiar estimator is

$$
s_{R,T}
=\frac{1}{n-1}\sum_{i=1}^n(R_i-\overline R)(T_i-\overline T).
$$

## Slide 679: Sample covariance

Source note: `random-variables-and-distributions/covariance.qmd`

The page reports the empirical population covariance of the pinned table because its immediate target is that table's joint distribution. Later inferential work must state a sampling unit and accommodate repeated verbs and speakers.

## Slide 680: Covariance: question 1

Source note: `random-variables-and-distributions/covariance.qmd`

Verify covariance with the $\mathbb{E}[RT]-\mathbb{E}[R]\mathbb{E}[T]$ identity.

## Slide 681: Covariance: answer 1

Source note: `random-variables-and-distributions/covariance.qmd`

$\mathbb{E}[RT]-\mathbb{E}[R]\mathbb{E}[T]=0.284045$ words squared, matching the mean centered product.

## Slide 682: Covariance: question 2

Source note: `random-variables-and-distributions/covariance.qmd`

Identify which quadrants around the mean lines contribute positively.

## Slide 683: Covariance: answer 2

Source note: `random-variables-and-distributions/covariance.qmd`

Observations above both means and observations below both means contribute positively because the two centered factors have the same sign.

## Slide 684: Covariance: question 3

Source note: `random-variables-and-distributions/covariance.qmd`

Explain the difference between the two denominators used above.

## Slide 685: Covariance: answer 3

Source note: `random-variables-and-distributions/covariance.qmd`

Dividing by $n$ treats the represented rows as the empirical population, whereas dividing by $n-1$ applies the usual sample-covariance degrees-of-freedom correction.

## Slide 686: Covariance: question 4

Source note: `random-variables-and-distributions/covariance.qmd`

Why can a covariance near zero coexist with dependence?

## Slide 687: Covariance: answer 4

Source note: `random-variables-and-distributions/covariance.qmd`

Covariance can be near zero under strong nonlinear or sign-canceling dependence, because it summarizes only average linear co-movement. The correlation page standardizes covariance to remove its units.

## Slide 688: Correlation

Source note: `random-variables-and-distributions/correlation.qmd`

Our next step is Correlation.

## Slide 689: Correlation

Source note: `random-variables-and-distributions/correlation.qmd`

Covariance changes when either variable is rescaled. **Correlation** divides covariance by both standard deviations, producing a unitless measure of linear association.

## Slide 690: Definition

Source note: `random-variables-and-distributions/correlation.qmd`

For variables with positive finite variances,

$$
\rho_{R,T}
=\operatorname{Corr}(R,T)
=\frac{\operatorname{Cov}(R,T)}
{\sqrt{\operatorname{Var}[R]\operatorname{Var}[T]}}.
$$

## Slide 691: Definition

Source note: `random-variables-and-distributions/correlation.qmd`

Equivalently, if

$$
Z_R=\frac{R-\mathbb{E}[R]}{\operatorname{SD}(R)},
\qquad
Z_T=\frac{T-\mathbb{E}[T]}{\operatorname{SD}(T)},
$$

then

$$
\rho_{R,T}=\mathbb{E}[Z_RZ_T].
$$

## Slide 692: Definition

Source note: `random-variables-and-distributions/correlation.qmd`

Cauchy--Schwarz implies $-1\leq\rho_{R,T}\leq1$. The endpoints occur only under exact positive or negative linear dependence.

## Slide 693: Definition

Source note: `random-variables-and-distributions/correlation.qmd`

Correlation is symmetric, $\rho_{R,T}=\rho_{T,R}$. For nonzero $a$ and $c$,

$$
\operatorname{Corr}(aR+b,cT+d)
=\operatorname{sign}(ac)\operatorname{Corr}(R,T).
$$

## Slide 694: Definition

Source note: `random-variables-and-distributions/correlation.qmd`

Thus positive unit conversions leave correlation unchanged, while reversing exactly one axis reverses its sign.

## Slide 695: Standardizing the dative lengths

Source note: `random-variables-and-distributions/correlation.qmd`

The empirical correlation is 0.032. The positive sign agrees with the covariance, but standardization shows that the linear association is very small relative to the two marginal spreads.

## Slide 696: Standardizing the dative lengths

Source note: `random-variables-and-distributions/correlation.qmd`

This figure shows standardized dative length pairs. Point area gives the number of tokens at each pair.

## Slide 697: What near-zero correlation does not establish

Source note: `random-variables-and-distributions/correlation.qmd`

A near-zero correlation rules out only a strong linear relation in this empirical table. It does not establish independence: the joint distribution can retain nonlinear structure, and both variables are associated with other properties of the construction. Nor does it license a causal conclusion about constituent planning.

## Slide 698: What near-zero correlation does not establish

Source note: `random-variables-and-distributions/correlation.qmd`

The usual sample correlation can be written

$$
r
=\frac{\sum_i(R_i-\overline R)(T_i-\overline T)}
{\sqrt{\sum_i(R_i-\overline R)^2}
 \sqrt{\sum_i(T_i-\overline T)^2}}.
$$

## Slide 699: What near-zero correlation does not establish

Source note: `random-variables-and-distributions/correlation.qmd`

The common denominator convention cancels, which is why R's `cor()` agrees with the population-standardized calculation above.

## Slide 700: Correlation: question 1

Source note: `random-variables-and-distributions/correlation.qmd`

Recompute correlation as the mean product of the standardized values.

## Slide 701: Correlation: answer 1

Source note: `random-variables-and-distributions/correlation.qmd`

The mean product of the population-standardized recipient and theme lengths is $0.031530$, equal to their empirical correlation.

## Slide 702: Correlation: question 2

Source note: `random-variables-and-distributions/correlation.qmd`

Multiply recipient length by a unit-conversion constant and verify that correlation is unchanged.

## Slide 703: Correlation: answer 2

Source note: `random-variables-and-distributions/correlation.qmd`

Multiplying recipient length by any positive conversion constant multiplies its covariance and standard deviation by the same factor, leaving the correlation at $0.031530$.

## Slide 704: Correlation: question 3

Source note: `random-variables-and-distributions/correlation.qmd`

Compare the joint plot with the marginal plots. What information is unique to each?

## Slide 705: Correlation: answer 3

Source note: `random-variables-and-distributions/correlation.qmd`

The joint plot shows which recipient and theme lengths occur together, whereas the marginal plots show each length distribution without preserving pairings.

## Slide 706: Correlation: question 4

Source note: `random-variables-and-distributions/correlation.qmd`

Give a dependent relationship whose correlation could be zero.

## Slide 707: Correlation: answer 4

Source note: `random-variables-and-distributions/correlation.qmd`

A symmetric nonlinear relation such as $T=(R-\mathbb{E}[R])^2$ can be deterministic while having zero correlation with $R$. This closes the distribution chapter. The statistical-inference chapter next asks what an observed sample can say about an unknown quantity.
