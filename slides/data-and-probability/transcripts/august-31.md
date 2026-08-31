# August 31 lecture transcript

Target running time: 75 minutes, including short pauses during incremental reveals and about three minutes for questions after the course requirements.

Planned pacing is 18 minutes for Slides 0 through 23, 27 minutes for Slides 24 through 53, 28 minutes for Slides 54 through 91, and 2 minutes for Slides 92 and 93.

Spoken style reference: [Aaron White, invited talk](https://www.youtube.com/watch?v=vzZTaIT-5_4&t=45s).

The text under each slide heading is the text to say. Directions in brackets are not spoken.

## Title slide. Describing what happens

Good afternoon. I am Aaron White, and this is Statistical Methods in Linguistics. The title of this first module is *Describing what happens*. That phrase is going to organize both today's lecture and, more generally, the course. We are going to ask what counts as something that happens, how linguistic data record what happens, and how probability and statistics let us describe those things precisely. More specifically, we will ask what can happen and how often it happens.

## Slide 1. Describing what happens precisely

The basic claim for the course is this: probability and statistics is all about describing what happens precisely. That means stating what can happen and how often it happens. We are going to spend a lot of time making each part of that claim precise. What counts as happening? What exactly is the thing we are describing? What determines how often it happens? And what makes a description precise? Probability gives us the mathematical objects we need to answer the first three questions. Statistics lets us use observations to learn about the probabilities and processes that interest us.

## Slide 2. This module

This first module occupies three class meetings. [Advance.] Today, August 31, we will ask what linguistic data can describe. That question is broader than it may initially sound. [Advance.] On September 2, we will turn to outcomes, events, and probability spaces. That is where we begin to state possible happenings mathematically. [Advance.] On September 9, we will use those objects to define joint probability, conditional probability, and independence. The three meetings build on one another, so the question we start with today will still be with us at the end of the module.

## Slide 3. Welcome

Okay. So before we get into the content, let me say a little about who I am and how the course works. Then we will return to the central question and work through Zipf's law as our first substantial case.

## Slide 4. I am Aaron White

I am Aaron White. I am an associate professor in Linguistics and Computer Science here at Rochester. My office is 511A Lattimore Hall. My website is aaronstevenwhite.io, and that is where you can find my office hour scheduler as well as links to course materials. If you need to meet with me, please use the scheduler rather than trying to catch me in the hallway. I am happy to talk about the course, a problem set, a possible project, or a statistical question arising in other work.

## Slide 5. I am a computational semanticist

I am a computational semanticist. I study how words, constructions, and discourses encode events, attitudes, and inferences. One part of my work asks how the meaning of a verb relates to the clauses and other syntactic frames that it can take. Another part asks how event structure can be recovered from annotations of predicates, arguments, and relations among events. A third part asks how speakers update a discourse when a sentence supports an inference with some uncertainty. These projects concern different parts of meaning, but all of them require an explicit account of the linguistic representation and of the observations that bear on it.

## Slide 6. Statistics connects data to representations

The data in this work include acceptability and inference judgments, corpus distributions, and decompositional semantic annotations. I use probability and statistics to connect patterns in those observations to hypotheses about the representations that could have produced them. For instance, in work on clause-taking verbs, the observations include judgments about many verbs in many syntactic frames. The object of interest is not the list of responses. It is the relationship between a verb's meaning and its syntactic distribution. In work on event structure, the observations are annotations, while the object of interest is a system of recurring event, entity, and relation types. Statistics provides the connection between the observations and the proposed representation.

## Slide 7. Why take this course?

So why take this course? My answer is the claim on this slide: probability and statistics is all about describing what happens precisely. That means stating what can happen and how often it happens. Let me give you a sense of how broadly I intend both parts of that statement.

## Slide 8. Articulating a sound

First, what can happen? A speaker can produce many tongue and lip trajectories while articulating a vowel. The tongue is not fixed at one position for every production of a vowel, and its movement is not identical across speakers or speaking contexts. [Advance.] Second, how often does each possibility happen? We can describe how articulatory trajectories are distributed across vowels, speakers, and contexts. [Advance.] Later, when we introduce random variables and distributions, we will ask how variables represent measurements from these articulatory events and how a probability distribution describes the values those variables can take.

## Slide 9. Producing an acoustic signal

Now consider the acoustic signal produced by that articulation. What can happen? A vowel token can have different durations, formant values, and formant trajectories. [Advance.] How often does each possibility happen? We can describe how those measurements are distributed across vowels, speakers, and speaking contexts. Notice that the acoustic signal is related to the articulation but is not identical to it. The articulation produces the signal, and a recording gives us measurements of that signal. [Advance.] During the statistical inference portion of the course, we will ask what a sample of those measurements can tell us about a larger population of productions.

## Slide 10. Reading a sentence

What can happen while a comprehender reads a sentence? The comprehender can spend different amounts of time reading a word or sentence region. [Advance.] How often do those reading-time values occur? We can describe how their distribution varies with theoretically relevant properties such as word frequency and syntactic structure, as well as with readers and passages. [Advance.] When we get to linear regression and prediction, we will use those predictors to describe reading time and then ask whether the fitted relationship predicts values in passages the model has not seen.

## Slide 11. Choosing a construction

Suppose a speaker wants to describe a transfer event. What can happen? The speaker can use the double object construction, as in *give the child the book*, or the prepositional dative, as in *give the book to the child*. [Advance.] How often does each choice happen? We can describe how the probability of each construction varies with properties of the theme, recipient, verb, and discourse context. [Advance.] This is a categorical response, which will motivate generalized linear models later in the semester.

## Slide 12. Giving a slider rating

Now consider a slider task. What can happen? A participant can choose the left endpoint, the right endpoint, or a value in the interior. [Advance.] How often does each possibility happen? We need to describe the probability of each endpoint and the distribution of the interior values. The response format therefore matters to the statistical model. [Advance.] We will return to this case when we discuss bounded responses, because a model that assigns probability zero to the endpoints cannot describe how often participants choose values that the task explicitly permits.

## Slide 13. Participants and items

What can happen when a participant responds to an item? Each participant-item pairing can yield a different response. [Advance.] How often do those responses happen? Their distribution can vary across participants and items as well as across the conditions we manipulate. Two participants may use a rating scale differently, and two sentence items may elicit different responses for reasons we did not manipulate. [Advance.] When each participant responds to many items and each item receives many responses, a model must account for those recurring sources of variation. That is the motivation for the mixed effects models we will study in November.

## Slide 14. Experimental design

Experimental design constrains both parts of our course claim. What can happen? The design determines which conditions each participant and item can appear in and which observations can enter the analysis. [Advance.] How often does each possibility happen? Assignment probabilities and replication determine how often the comparisons supported by the design occur. Counterbalancing, exclusion rules, and the number of participants and items all affect those comparisons. [Advance.] A statistical model cannot recover a comparison that the design never made possible. We will examine those constraints in the experimental design module.

## Slide 15. Vowel inventories

Now let us stretch the notion of what happens. What can happen? An acoustic token can arise from one of several vowel categories that we do not observe directly. [Advance.] How often does each possibility happen? We can describe how frequently each category generates a token and how acoustic measurements are distributed within each category. The object of interest is not simply one formant measurement. It is the structure of a vowel inventory inferred from many measurements. [Advance.] We will return to this distinction when we discuss clustering and mixture models in the latent structure module.

## Slide 16. Acceptability lexicons

We can stretch the notion further. What can happen? A verb-frame combination can receive a range of acceptability judgments. [Advance.] How often do those judgments occur? We can describe their distribution across verb-frame combinations and ask which recurring patterns support a structured acceptability lexicon. That lexicon is not one observed response. It is an abstract object that we infer from many responses. [Advance.] The factorization module will ask how a smaller set of recurring patterns can describe variation across the resulting verb by frame table.

## Slide 17. Missing measurements

Missing data require us to represent another possibility. What can happen? A language-feature combination can be observed or missing, and an observed combination can take different values. [Advance.] How often do these possibilities happen? We can describe how missingness varies with sampling and documentation and how the recorded values are distributed. We cannot fill every blank and proceed as though the completed table had been observed. [Advance.] In the missing data module, we will distinguish the process that determines which values are recorded from the process that determines the values themselves.

## Slide 18. Annotations

Finally, consider a branching annotation task. What can happen? An earlier response can determine which question an annotator sees next, and the annotator can then choose among the responses available at that point. [Advance.] How often does each path and response happen? We can describe their probabilities across annotators and items. In that setting, we may want a statistical model that describes the annotation process together with the linguistic property being measured. [Advance.] The custom model design module will show how to construct that model when the standard response models do not represent the task.

## Slide 19. Not every object is observed

The upshot is that the thing we want to describe and the data we collect to learn about it need not be identical. That distinction will recur throughout the course.

## Slide 20. Verb-frame acceptability

Consider the acceptability of one verb in one syntactic frame. We might observe the verb used in that frame in a corpus. We might also ask a participant to judge a sentence containing that verb and frame. Neither observation is identical to the verb's acceptability in that frame. A corpus token records one successful use in one context. A judgment records one participant's response to one sentence under one task. Acceptability is the more abstract object that we are trying to learn about from those observations.

## Slide 21. Corpus tokens and judgments

The two observations provide different evidence. A corpus token tells us that a producer used the form in a particular context. It does not tell us that nearby alternatives would have been unacceptable. A judgment tells us how one participant responded under a particular experimental procedure. It does not tell us how often the form is used in ordinary production. Both observations may inform an account of acceptability, but they do so through different processes. A statistical analysis should preserve that difference rather than treating both as direct readings of the same quantity.

## Slide 22. Data and the processes that produce them

Okay. So this follows directly from the course claim. Describing what can happen and how often it happens requires us to describe the data we collect. It may also require us to describe the processes that could have produced those data. Sometimes a description of the observations is enough for the question at hand. In other cases, especially when we want to generalize or explain, we need to state the process explicitly.

## Slide 23. Six questions organize the course

The course is organized around six questions. [Advance.] What can happen under the representation? That question leads to sample spaces and events. [Advance.] How can a variable describe those possibilities? That leads to random variables. [Advance.] What does a probability distribution say about the variable? [Advance.] What can a sample tell us about a larger population? [Advance.] How does a model connect a theoretically interesting linguistic predictor to a response? [Advance.] And how do we check the resulting description? Each new question depends on the preceding ones. We will introduce the relevant concepts in that order, so we do not use a method before we have built the objects it requires.

## Slide 24. Course requirements

Before we turn to Zipf's law, let me walk through the structure and requirements of the course. I am going to be fairly detailed here because there are two course numbers, several kinds of assessment, and a staged final project for LING 414. Please interrupt me if something is unclear. I would rather resolve a question now than have you make a plan for the semester on the basis of a misunderstanding.

## Slide 25. We meet on Mondays and Wednesdays

We meet on Mondays and Wednesdays from 12:30 to 1:45 in Lattimore 513. Today, Monday, August 31, is the first meeting. Monday, December 14, is the final class meeting and also one of the possible project presentation dates. The schedule on the syllabus is the authoritative schedule. If I need to change a topic or reading, I will update the syllabus and announce the change on Zulip.

## Slide 26. Weeks 1 to 4: probability

The first four weeks establish the probability language that the rest of the course requires. [Advance.] August 31, September 2, and September 9 cover linguistic data, probability spaces, and events. [Advance.] September 14 and 16 introduce random variables and discrete distributions. [Advance.] September 21 and 23 move to continuous and joint distributions. The ordering matters. We begin with the represented possibilities, then define variables over those possibilities, and only then introduce distributions over the variables.

## Slide 27. Weeks 5 to 8: inference and prediction

The next four weeks move from samples to inference and prediction. [Advance.] September 28 and 30 introduce populations, samples, and uncertainty. [Advance.] October 5 and 7 cover paired inference and begin linear regression. [Advance.] October 14 covers multiple regression and model criticism. [Advance.] October 19 and 21 ask whether a fitted model predicts new observations, including observations from new groups. This part of the course is where the distinction between describing the observed sample and generalizing beyond it becomes central.

## Slide 28. October 26 and 28

Monday, October 26, is a review class. Wednesday, October 28, is the midterm. For students enrolled in LING 414, October 28 is also the final project proposal deadline. I will return to the project timeline in a few slides. The important point for now is that the proposal is due at the midpoint of the course, after we have covered the core probability and regression material.

## Slide 29. November: responses and data structures

November extends the kinds of responses and structures our models can describe. [Advance.] November 2 and 4 cover binary, count, and bounded responses. [Advance.] November 9 and 11 cover experimental design and the populations to which an experiment can generalize. [Advance.] November 16 and 18 cover mixed models for ordinal and bounded responses. [Advance.] November 23 introduces clustering and mixture models. [Advance.] November 30 introduces factorization. Each topic adds one new representational or modeling problem rather than introducing several unrelated techniques at once.

## Slide 30. December: missing data and custom models

[Advance.] On December 2, we cover missing data and custom model design. This is where we ask what to do when the observation process does not match one of the standard models introduced earlier. [Advance.] December 7, 9, and 14 are the LING 414 project presentation dates. [Advance.] The LING 414 oral assessments take place during the December 18 to 23 finals period. I will schedule those assessments individually.

## Slide 31. We do not meet on three scheduled dates

There are three scheduled dates on which we do not meet. [Advance.] Monday, September 7, is Labor Day. [Advance.] Monday, October 12, is Fall Break. [Advance.] Wednesday, November 25, is Thanksgiving recess. These dates are already incorporated into the syllabus schedule and the problem set deadlines.

## Slide 32. The course is four credits

This is a four credit course. We meet for two 75 minute sessions each week. You should plan for at least 480 minutes of work outside class each week. That work includes reading the notes, completing the assigned readings, working through problem sets, and, for LING 414 students, developing the final project. The prerequisite is LING 110 with a grade of C minus or better. If you are concerned that your background does not match that prerequisite, talk with me this week.

## Slide 33. The notes are the course textbook

The notes carry the main exposition for the course. You should treat them as the course textbook, not as a short summary to consult after class. Each chapter introduces one principal concept, works through that concept slowly, and links back to the chapters it requires. The notes are released one module at a time. When a module is not yet available, its pages remain visible in the navigation but show a short synopsis and the date on which the content will appear.

## Slide 34. Three textbooks support the notes

Three textbooks support the notes. [Advance.] Nicenboim, Schad, and Vasishth provide the main reference for Bayesian data analysis in cognitive science. [Advance.] Winter provides a linguistics focused introduction using R. [Advance.] Kruschke provides a second detailed treatment of Bayesian modeling. You will not read these books straight through. The relevant chapter will appear in a reading box where it becomes useful. We will also read linguistics papers when their data or argument bears directly on the method under discussion.

## Slide 35. We will work in R

We will do the statistical work in R. You may use RStudio or Visual Studio Code as your editor. Begin installing R and your editor before Wednesday. If you encounter a problem, post it on the course Zulip so that the answer remains available to everyone. Do not spend several hours silently fighting an installation problem that someone else may already have solved.

## Slide 36. LING 214 has three assessment components

LING 214 has three assessment components. The five problem sets contribute 65 percent of the course grade. The midterm on October 28 contributes 25 percent. Two office hour meetings contribute the remaining 10 percent. There is no independent final project in LING 214. The problem sets are therefore the main sustained analyses in that version of the course.

## Slide 37. LING 414 includes a final project

LING 414 adds an independent final project. The five problem sets contribute 40 percent of the course grade. The midterm contributes 20 percent. The final project contributes 40 percent. The project is not an extra problem set completed at the end of the semester. It develops in stages, beginning with a preproposal meeting in October and ending with the paper, code, presentation, and oral assessment in December.

## Slide 38. Five problem sets

There are five problem sets, each centered on a different linguistic data set. [Advance.] Problem Set 1 is due October 7 and concerns paired vowel measurements. [Advance.] Problem Set 2 is due October 21 and concerns reading time prediction across passages. [Advance.] Problem Set 3 is due November 11 and concerns the choice between dative constructions. [Advance.] Problem Set 4 is due November 23 and concerns discourse commitment judgments. [Advance.] Problem Set 5 is due December 7 and concerns phonological inventory structure. We use a new data set each time so that each problem requires you to determine what the variables mean rather than repeat a familiar recipe.

## Slide 39. Problem sets are readings

The problem sets are part of the course reading. By that I mean that they develop analyses and interpretations that the notes prepare you to understand. You are not simply filling in missing code. You are reading the problem, working through the analysis, examining the output, and explaining what the output says about the linguistic question. Some of the content needed for the following module will be developed in the problem set, so waiting until the due date to open it will make the next part of the course harder.

## Slide 40. Two assessments per problem set

Each problem set has two assessment components. [Advance.] Functionality and completeness contribute 50 percent. The submitted analysis must run and must answer the assigned questions. [Advance.] An in class explanation contributes the other 50 percent. Students will be selected at random to present, and you will not know in advance whether you are presenting. The explanation is not an optional bonus. It is half of the assessment because understanding the analysis is distinct from obtaining code that runs.

## Slide 41. Be ready to explain your analysis

All students must attend and be ready to present on any assessment day following a due date. You should be able to explain what each important part of the code does, why the analysis answers the linguistic question, and what the result means. You do not need to memorize punctuation or function arguments. You do need to understand the representation, the model, and the interpretation well enough to reconstruct the logic in your own words.

## Slide 42. The LING 414 project has five deadlines

The LING 414 project has five deadlines. [Advance.] Complete the preproposal meeting by October 16. [Advance.] Submit the proposal on October 28. [Advance.] Present on December 7, 9, or 14. [Advance.] Submit the paper and code on December 14. [Advance.] Complete the code oral assessment during the December 18 to 23 finals period. The stages are designed to force the research question, data, and analysis into alignment before the final weeks of the semester.

## Slide 43. LING 414 projects can take three forms

The project can take one of three forms. [Advance.] You may conduct a corpus analysis that extracts and analyzes data for a particular linguistic hypothesis. [Advance.] You may design a judgment or reading experiment, build the instrument, simulate the expected data, and write the analysis. [Advance.] Or you may conduct a mechanistic interpretation study of a deep learning model. The final project rubric gives the distinct requirements for each option. Choose the option that best matches the research question, not the option whose tools seem most familiar.

## Slide 44. LING 214 requires two meetings

LING 214 students meet with me twice during the semester. Schedule those meetings through the link on my website. The meetings can concern course material, a problem set, a possible transition into LING 414 work, or a statistical question arising in another project. These meetings create two occasions for a focused conversation that may not happen during a full class meeting.

## Slide 45. Use Zulip for course communication

All course communication happens on Zulip. Please do not use email for course questions. Keeping the discussion in one place makes it possible to search earlier answers and makes public answers available to the full class.

## Slide 46. Use channels for public questions

Use a public channel for questions whose answers may help other students. That includes questions about a reading, a problem set instruction, an R error, or the interpretation of a result. Use a direct message for grades, absences, accommodations, or other private matters. If you send a general question privately, I may ask you to repost it in the relevant channel before I answer.

## Slide 47. Expect replies during working hours

I generally reply within one to two business days. I do not monitor Zulip after 5 PM or on weekends. A message sent late Sunday night may therefore receive an answer on Tuesday. Please account for that when you plan work near a deadline. If a problem blocks your progress, ask early enough that there is time for an exchange.

## Slide 48. Late problem sets

A late problem set loses 10 percent per day and may be submitted at most three days late. Project components are not accepted late without prior approval. If you need an extension on a project component, ask at least 48 hours before the deadline, except in an emergency. The purpose of the policy is to keep the assessments and subsequent course material synchronized, since later work often assumes that you completed the earlier analysis.

## Slide 49. Collaboration is encouraged

You may discuss problem sets with classmates. In fact, I encourage you to talk through the linguistic question, compare interpretations, and help one another diagnose code. But each student must write and submit their own solution. Shared discussion should leave you able to explain the analysis independently. If two submissions contain the same code and neither student can explain it, the fact that the students collaborated does not resolve the problem.

## Slide 50. Generative AI may assist with code

You may use generative AI for coding assistance on problem sets and projects. You must understand the resulting code, and you must cite the tool and provide the specific prompts in code comments. Generative AI may not be used to write the prose submitted for assignments or the final paper. The oral assessments make this policy practical. If a tool generated part of the code, you are still responsible for explaining what that code does and why it belongs in the analysis.

## Slide 51. The grading scale is fixed

The grading scale is fixed. An A begins at 93, an A minus at 90, a B plus at 87, and so on through the scale shown here. I do not curve the final course grades. The component weights and this scale determine the grade.

## Slide 52. Disability accommodations

Students seeking accommodations should contact the University Office of Disability Resources. Please begin that process early enough for us to implement the accommodation. Faculty are also mandatory reporters for Title IX matters. The syllabus links to confidential and nonconfidential resources, so please consult those links before deciding what information to share with me.

## Slide 53. What should you do before September 2?

Before Wednesday, please do four things. [Advance.] Join the Fall 2026 course Zulip. [Advance.] Confirm that you can open the course notes. [Advance.] Begin installing R and your editor. [Advance.] Read the notes on linguistic data and Zipf's law. Before we leave the administrative material, what questions do you have about the schedule, assessments, communication, or course policies? [Pause for questions.] Okay. Let us return to the claim that probability and statistics is all about describing what happens precisely. That means stating what can happen and how often it happens. We will now ask what both parts of that claim mean for an entire corpus.

## Slide 54. Describing an entire corpus

We are going to use Piantadosi's 2014 paper on Zipf's law as our first extended case. The paper is useful because it begins with a strikingly simple statistical description and then asks what that description does and does not explain.

## Slide 55. Zipf's law describes corpus frequencies

Zipf's law relates each word type's frequency to its frequency rank across an entire corpus. That makes it a particularly broad description of what happened. It is not a description of one speaker producing one word. It compresses a large collection of choices by many speakers and writers into a relation between two quantities.

## Slide 56. A corpus records what happened

Consider what a corpus contains. It records many usages produced by many people in many contexts, often across a long period of time. Each token resulted from a particular producer choosing a particular expression in a particular context. Zipf's law ignores most of that local structure and asks whether the aggregate collection has a simple shape. So we have an unusually complex object paired with an unusually compact description.

## Slide 57. Begin by counting word types

We begin by counting word types. Suppose *the* occurs 10,000 times, *of* occurs 5,100 times, and *and* occurs 3,400 times. We order the types by their counts. The most frequent type receives rank 1, the next most frequent receives rank 2, and so on. The question is then how frequency changes as rank increases.

## Slide 58. Zipf proposed an inverse relation

Zipf proposed that frequency is approximately inversely related to rank. We write the frequency of the type at rank $r$ as $f(r)$. The relation says that $f(r)$ is proportional to one divided by $r$ raised to the power $\alpha$. The parameter $\alpha$ controls how quickly frequency falls as rank increases. For word frequencies, $\alpha$ is often near 1. The equation is not claiming that every observed count lies exactly on the curve. It states the broad relation the curve is meant to capture.

## Slide 59. When $\alpha=1$

When $\alpha$ equals 1, the interpretation is especially simple. If the first ranked word occurs 10,000 times, then the second ranked word should occur about 5,000 times, and the third ranked word should occur about 3,333 times. Doubling the rank halves the predicted frequency. Tripling the rank divides the predicted frequency by three. That is what an inverse relation means here.

## Slide 60. Mandelbrot shifts frequency rank

Mandelbrot introduced an additional parameter, $\beta$, which shifts the rank before the power is applied. Piantadosi treats this Zipf and Mandelbrot form as the working description. The shift changes the curve most strongly among the highest frequency words, where adding a fixed amount to rank has the largest proportional effect. The two parameters therefore control different aspects of the curve.

## Slide 61. Why use logarithmic axes?

Rank and frequency each extend over several orders of magnitude. On ordinary axes, the high frequency words occupy a small portion of the plot and the long tail is compressed. Logarithmic axes give comparable visual space to comparable ratios. The interval from 10 to 100 receives the same width as the interval from 100 to 1,000. The broad power law relation is much easier to see on those axes.

## Slide 62. The ANC is approximately Zipfian

This figure shows normalized word frequency against frequency rank in the American National Corpus. The red curve is the fitted Zipf and Mandelbrot relation. At this scale, the corpus is approximately Zipfian. The gray curve follows a local average more closely. Notice that the red curve captures the overall decline while missing smaller bends in the gray curve. That difference will become important in a moment.

## Slide 63. Rank and frequency errors are coupled

There is a measurement problem with the usual rank-frequency plot. If we estimate a word's rank and its frequency from the same corpus counts, the errors in those estimates are coupled. Suppose two word types have the same underlying probability. A chance difference in their observed counts gives one type the higher rank and, by construction, the higher measured frequency. We can therefore create apparent local agreement between rank and frequency simply by using the same random counts to estimate both.

## Slide 64. Estimate rank and frequency separately

Piantadosi addresses this problem by randomly splitting the corpus tokens into two parts. One part estimates each word's rank. The other estimates its frequency. A chance fluctuation in one half cannot affect both measurements. This separation lets us interpret the difference between an observed frequency and the fitted curve without building the same sampling fluctuation into both axes.

## Slide 65. The broad fit hides departures

Once rank and frequency are estimated separately, we can inspect the departures from the curve. The vertical axis here is the observed log frequency minus the log frequency predicted by the Zipf and Mandelbrot curve. A value above zero means the word is more frequent than the curve predicts. A value below zero means it is less frequent. If the broad curve captured the full structure, these departures should not show long, systematic patterns.

## Slide 66. Departures from the curve are systematic

But the departures do show systematic structure. There are long runs above and below zero, including the large scoop among lower frequency words. Even the highest frequency words show local bends that the simple curve does not describe. We do not merely see isolated points scattered around zero. We see neighboring ranks departing in related ways.

## Slide 67. The broad fit misses local structure

So two levels of description need to be kept separate. The large scale relation between rank and frequency is approximately Zipfian. The full distribution contains systematic local structure that the fitted curve misses. Saying that a corpus is Zipfian is informative, but it is not a complete description of the corpus's word frequencies.

## Slide 68. A power law does not identify its cause

This creates the explanatory problem that organizes the rest of Piantadosi's paper. Many incompatible processes can produce an approximately power law distribution. Deriving the curve from one process does not show that speakers or writers use that process. A theory must also account for observations that distinguish its process from the alternatives. Piantadosi therefore examines properties of word frequency beyond the broad rank-frequency relation.

## Slide 69. Meaning ranks are similar across languages

The first property concerns meaning. This figure uses Swadesh list meanings across 17 languages. The common ordering on the horizontal axis is estimated across languages. Meanings that rank as relatively frequent in one language tend to rank as relatively frequent in others. So frequency is not arbitrary with respect to meaning. Whatever process explains word frequency must allow semantically similar items to occupy similar portions of the distribution across languages.

## Slide 70. Smaller numbers are more frequent

Number words provide a particularly transparent case because the horizontal axis is cardinality rather than a frequency rank assigned from the same counts. Across English, Russian, and Italian, smaller numbers are used more frequently. The word for *one* is more frequent than the word for *ten*, and the decline continues as cardinality increases. This relation is tied to what the words mean, not merely to an ordering constructed from their observed frequencies.

## Slide 71. Similar referents, unequal frequencies

The next case asks whether shared reference removes the unequal distribution. These are taboo words referring to sexual activity and feces. The words within a referential category still differ sharply in frequency. So reference alone does not determine use. Social register, conventional preferences, and other aspects of context may distinguish expressions that can refer to roughly the same thing.

## Slide 72. Constrained referents remain Zipfian

Months, planets, and chemical elements give a language relatively little freedom to choose the relevant referents. The calendar fixes the months, astronomy fixes the planets under the chosen classification, and chemistry fixes the elements. Yet the names in these categories still have strongly unequal frequencies and remain approximately Zipfian. A theory based only on how a language partitions an unconstrained conceptual space will therefore be incomplete.

## Slide 73. Syntactic categories are also Zipfian

The pattern is not restricted to word types. This figure shows the frequency distribution of syntactic categories in the Penn Treebank. Those categories also form a strongly unequal distribution. The most common categories occur far more often than the less common categories. So a Zipfian pattern can arise at a level of representation different from the lexicon.

## Slide 74. Each category has its own curve

But the syntactic categories do not all have the same internal frequency distribution. Determiners, prepositions, modals, nouns, and the two verb categories shown here differ in their fitted curves and in their departures from those curves. Again, the broad family resemblance does not erase the local structure. A theory that predicts only that every category is approximately Zipfian leaves these differences unexplained.

## Slide 75. Frequency varies with context and time

Word frequency also changes with context and time. Piantadosi uses *Dallas* as an intuitive case. The probability of that word differs between a discussion of Lyndon Johnson and a discussion of Carl Sagan. Topics, social groups, technologies, and historical events all change which words are useful. There is therefore no reason to assume that every token in a large corpus was generated from one unchanging distribution.

## Slide 76. Corpus frequencies average over contexts

A corpus frequency averages over all of those contexts. The simple rank-frequency curve describes the aggregate, even when the component contexts have different distributions. This matters for explanation. A process that fits the aggregate may fail to describe any particular speaker, topic, or period that contributed to it.

## Slide 77. Novel names also show unequal use

Piantadosi then asks whether a near Zipfian pattern can arise when speakers are given a small set of novel names. Twenty-five participants wrote stories of at least 2,000 words using eight alien names that had been introduced for the experiment. The average across participants was near Zipfian. Even without an established lexical history for those names, participants reused some names much more often than others.

## Slide 78. The within-participant pattern is unknown

The result has an important limitation. Piantadosi orders the names by frequency within each participant and then averages those ordered frequencies across participants. That analysis establishes an aggregate pattern after rank alignment. It does not establish that each participant's own eight-name distribution was reliably Zipfian. A larger study with more observations per participant would be needed to estimate that within-participant pattern.

## Slide 79. Zipfian patterns occur outside language

Near Zipfian distributions also occur outside language, including in music, computer programs, and internet systems. That breadth admits at least two possibilities. There may be a sufficiently general process operating across these systems, or different processes may converge on similar aggregate distributions. The curve alone does not tell us which possibility is correct.

## Slide 80. Random typing reproduces the broad curve

Random typing makes the problem especially sharp. Imagine a process that emits characters independently and occasionally emits a space. The strings between spaces have a highly unequal frequency distribution that can be approximately Zipfian. But humans do not produce words by emitting independent characters until a space happens to occur. The process reproduces the broad curve while giving an implausible account of linguistic production.

## Slide 81. False boundaries preserve the curve

Piantadosi gives an even more direct demonstration using the American National Corpus. Treat the letter *e* as though it were a word boundary and count the resulting strings. Those strings still produce a near Zipfian curve. The units are not words, and the boundary rule is not a plausible model of linguistic segmentation. The persistence of the curve shows how little the broad shape tells us about the represented units or the process.

## Slide 82. Curve fit does not validate a process

This is the central warning from the paper. A model can fit the aggregate pattern while misdescribing how speakers produce words. Fit to the rank-frequency curve is evidence that the model reproduces that curve. It is not, by itself, evidence that the model's process is psychologically or linguistically correct.

## Slide 83. Preferential reuse produces inequality

One possible process is preferential reuse. If a word becomes more likely to recur after it has already occurred, small early differences can grow into a strongly unequal distribution. But even here we need to distinguish mechanism from correlation. A discourse topic may explain both the earlier use and the later reuse. The recurrence of the word need not itself cause the increased probability.

## Slide 84. Meaning explains only part of the pattern

Semantic organization is also part of the explanation. The cross-linguistic results and the number word results show that meaning predicts frequency. But the constrained referent categories and the novel-name experiment show that semantic organization alone is not sufficient. An adequate account must represent meaning while allowing other processes to shape frequency.

## Slide 85. Optimization requires independent evidence

Communicative optimization models can yield Zipfian frequencies by balancing assumptions about speaker and listener costs. That is a possible explanation, but the assumptions and parameter values need independent support. If the costs are chosen only because they produce the observed curve, the curve cannot then serve as independent evidence for those costs. The model needs predictions beyond the pattern it was constructed to reproduce.

## Slide 86. Universal accounts need new predictions

The same issue applies to universal accounts based on information, computation, or entropy. Such accounts may explain why power laws occur in many systems. But to distinguish one account from another, we need new predictions. Which local departures should occur? How should the curve change across contexts or categories? Without observations of that kind, the shared broad curve cannot adjudicate among the proposed processes.

## Slide 87. The memory account remains a hypothesis

The novel-name experiment suggests that memory may contribute to unequal reuse even without an established lexicon. Piantadosi presents this as a possible direction, not as an established result. The current analysis does not identify a memory mechanism, and it does not establish the pattern within individual participants. A fuller model and new data would be needed to make that explanation precise.

## Slide 88. Explanations need new predictions

An explanation of Zipfian frequency should meet four requirements. [Advance.] It should state a process that could plausibly produce the data. [Advance.] It should test the assumptions of that process independently. [Advance.] It should predict observations beyond the rank-frequency curve. [Advance.] And it should account for the effects of meaning, category, context, time, and novel production. Reproducing one aggregate relation is the beginning of the analysis, not the end.

## Slide 89. What happened in the corpus?

We can now return to both parts of the course claim. What can happen? A speaker or writer can choose a word type in a particular context. How often does it happen? Zipf's law describes the aggregate frequencies of those choices across an entire corpus. The object is extremely broad. The process that produces it consists of individual choices made by particular speakers and writers across contexts and historical periods. A statistical model can describe the aggregate frequencies, the component processes, or both, but those are different descriptions.

## Slide 90. Description is not explanation

Describing what can happen and how often it happens does not by itself identify the process that produced the pattern. So statistical work separates two questions. What pattern does the data exhibit? And which process could have produced that pattern? A good answer to the first question does not automatically answer the second.

## Slide 91. Later modules return to this distinction

We will return to this distinction throughout the semester. [Advance.] On October 14, model criticism asks where a fitted description fails. [Advance.] On October 19 and 21, prediction asks whether the description extends to new data. [Advance.] On November 30, factorization describes structured lexical objects. [Advance.] On December 2, custom model design states processes that could produce complex annotations. Zipf's law gives us the first case in which all four questions are visible at once.

## Slide 92. Four conclusions from August 31

Let me end with four conclusions. [Advance.] Probability and statistics describe what can happen and how often it happens. [Advance.] The object of interest may be more abstract than an observed response. [Advance.] A statistical model can describe an aggregate pattern or a process that produces data. [Advance.] And matching one broad pattern does not by itself identify the process. These conclusions set up our next step, which is to state possible outcomes and events mathematically.

## Slide 93. Read before September 2

Before Wednesday, read the notes on turning linguistic records into data and the notes on Zipf's law. On Wednesday, we will begin with a single represented observation and ask what outcomes the model permits. That is where today's broad question becomes a probability space.
