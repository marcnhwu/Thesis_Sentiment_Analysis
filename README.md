# Sentiment Analysis of Chinese Reviews Using Morphosyntactic Patterns

This is the supplementary code and datasets for the machine learning experiments in my thesis project, titled [Sentiment Analysis of Chinese Reviews Using Morphosyntactic Patterns](https://etds.lib.ntnu.edu.tw/thesis/detail/819c7c0758c6126061166d3ff3f15f5a/?seq=1). 

## Abstract of the thesis project
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sentiment analysis is one of the most commonly discussed topics in the field of Natural Language Processing. While the traditional bag-of-words approach using n-grams is generally adopted for the sentiment analysis tasks like sentiment classification, studies have suggested that features beyond bags-of-word, such as grammatical and textual features, are crucial to the classifier’s performance. In particular, this study investigates to what extent linguistically-motivated morphosyntactic patterns may contribute to the sentiment classification through analyzing their impacts on the sentiment polarity of lexical features such as sentiment words in Chinse online movie reviews. We adopt pattern grammar as our theoretical framework to qualitatively encode patterns and the Wilcoxon rank-sum test to quantitatively determine significant patterns and their sentiment preferences.
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Our analyses show that morphosyntactic patterns demonstrate two prominent sentiment modulation of lexical sentiment polarity: intensifying the positive lexical sentiment or mitigating the negative lexical sentiment. Our post-hoc collexeme analyses of these patterns also show that sentiment-intensifying patterns attract more positive words and that sentiment-mitigating patterns attract more negative words. These preferences reveal how Chinese speakers utilize morphosyntactic patterns to modulate the sentiment in their opinions and establish their credibility in online movies reviews. Finally, we train a series of Support Vector Machines models and perform two document classification experiments to validate the effectiveness of morphosyntactic patterns in comparison to the traditional bag-of-words models. In the first experiment, we examine whether our linguistically-motivated morphosyntactic patterns could capture comparable amount of the beyond-single-word information as opposed to the sentiment-word-embedded n-grams, which are traditional n-grams that specifically contain sentiment words. In the second experiment, we test if sentiment-modulating morphosyntactic patterns do contribute to sentiment classification on top of the traditional n-gram-based model. Results of the first experiment suggest that morphosyntactic patterns can encode a wider range of the crucial morphosyntactic properties of sentiment words more efficiently than sentiment-word-embedded n-grams. The second experiment shows that morphosyntactic patterns improved the traditional n-gram-based model comprising unigrams and bigrams. Moreover, we obtained an averaged F1 score of 87.80 when considering morphosyntactic patterns with other features such as n-grams and sentiment words in the classifier. We conclude that the handcrafted, linguistically-motivated morphosyntactic patterns can provide an alternative to the brutal n-gram methods that have been commonly employed in building classifiers for sentiment classification tasks.

:bulb: If you'd like to use the material, please cite this repository:
Wu, N. (2021). Supplementary Material for Sentiment Analysis of Chinese Reviews Using Morphosyntactic Patterns (Version 1.0.0) [Computer software]. https://doi.org/10.6345/NTNU202100009


## Table of Content
### Dataset
- **ANTUSD.csv**: the sentiment dictionary [ANTUSD](https://aclanthology.org/L16-1428/)
- **ANTUSD_PosNeg.csv**: only the positive and negative words in ANTUSD
- **Yahoo_Chinese_Reviews_Corpus.csv**: the Chinese movie reviews corpus collected by the author 
### Code
- **coll.analysis.R**: [the Collexeme Analysis](http://www.stgries.info/teaching/groningen/index.html)
- **Experiment I.R**: Experiment I for machine learning
- **Experiment II.R**: Experiment II for machine learning
- **patterns_for_ranksum.R**: the morphosyntactic patterns with significant sentiment modulation
- **preprocessing_for_coll.analysis.R**: preprocessing data in order to perform the Collexeme Analysis
- **weighting.R**: weighting the co-occurrence of sentiment words in patterns based on the document-feature matrix (dfm) of sentiment words
- **wilcoxon_ranksum.R**: quantifying the pattern and non-pattern contexts & performing the Wilcoxon rank-sum test


### Experiment Procedure
Wilcoxon rank-sum test >> Experiment I >> Experiment II >> Post-hoc Analysis 

#### _Wilcoxon rank-sum test_ 
Run **wilcoxon_ranksum.R** for the rank-sum test.
1. Load & pre-process data: run line 1–18.
2. Quantify the pattern context: run line 21–49.
3. Quantify the NON-pattern context: run line 51–79.
4. Multiply the token frequencies by rating: run line 82–117.
5. Perform the Wilcoxon rank-sum test & Determine the modulation of patterns: run line 120–160.

To run the rank-sum test on other patterns, open **patterns_for_ranksum.R**.
Copy the code for each pattern and replace the codes between line 25–35 in **wilcoxon_ranksum.R** with the new code.
Then run all of the codes in **wilcoxon_ranksum.R**.


#### _Experiment I_
Run **Experiment I.R** for Experiment I.
1. Load & pre-process data: run line 1–37.
2. Create feature sets: run line 40–162.
3. Baseline models:
- To build the _SW+SW-Bigrams_ model, run line 168–177 first, and then line 180–190; finally, run line 241–295 for the classification experiment with the _SW+SW-Bigrams_ model.
- To build the _SW+SW-Trigrams_ model, run line 193–203; then, run line 241–295 for the classification experiment with the _SW+SW-Trigrams_ model.
- To build the _SW+SW-Four-grams_ model, run line 206–216; then, run line 241–295 for the classification experiment with the _SW+SW-Four-grams_ model.
- To build the _SW+SW-Five-grams_ model, run line 219–229; then, run line 241–295 for the classification experiment with the _SW+SW-Five-grams_ model.
4. Proposed model:
- First, open **weighting.R** to perform weighting on the document-feature matrix based on the sentiment word features. Run all of the codes in **weighting.R**.
- Return to **Experiment I.R** and run line 232–235 to build the _SW+MorphosyntacticPatterns_ model. Finally, run line 241–295 for the classification experiment with the _SW+MorphosyntacticPatterns_ model.
5. Post-hoc t-test:
- Change the models to compare in line 306 and line 317.
- Run line 315–321 for the adjusted R2-squared value.


#### _Experiment II_
Please run **Experiment II.R** for Experiment II.
1. Load & pre-process data: run line 1–37.
2. Create feature sets: run line 40–82.
3. Baseline models:
- To build the _Unigrams–Bigrams_ model, run line 88–99 first, and then run line 138–192 for the classification experiment with the _Unigrams–Bigrams_ model.
- To build the _Unigrams–Bigrams–SentimentWord_ model, run line 102–117, and then run line 138–192 for the classification experiment with the _Unigrams–Bigrams–SentimentWord_ model.
- To build the _Unigrams–Bigrams–SentimentWord–MorphosyntacticPatterns_ model, run line 120–132 (If you have already run **weighting.R** to perform weighting on the document-feature matrix based on the sentiment word features). Then, run line 138–192 for the classification experiment with the _Unigrams–Bigrams–SentimentWord–MorphosyntacticPatterns_ model.
4. Post-hoc t-test: run line 198–210.
- Change the models to compare in line 203.


#### _Post-hoc Collexeme Analysis_
Run **preprocessing_for_coll.analysis.R** first. This will generate a contingency table that includes the token frequency of every collexeme in a given pattern and the raw frequency of these collexemes in the corpus.
1. Load & pre-process data: run line 1–10.
2. To get the contingency table for _[feichang SW]_ (the prototypical sentiment-intensifying pattern), run line 13–80. This will generate **[feichang_SW]_table.csv**.
2. To get the contingency table for _[youdian SW]_ (the prototypical sentiment-mitigating pattern), run line 85–133. This will generate **[youdian_SW]_table.csv**.

Run **coll.analysis.R** for the collexeme analysis and follow the instructions below:
- What is the word W / the name of the construction C you investigate (without spaces)? >> _[feichang SW]_ / _[youdian SW]_
- Enter the size of the corpus (in constructions or words) without digit grouping symbols! >> _92041_
- Enter the frequency of [feichang in the corpus you investigate (without digit grouping symbols) >> _190_ for _[feichang SW]_ / _55_ for _[youdian SW]_
- Which index of association strength do you want to compute? >> _-log10 (Fisher-Yates exact, one-tailed)_
- How do you want to sort the output? >> _collostruction strength_
- Enter the number of decimals you'd like to see in the results >> _99_
- Choose this text file with the raw data! >> select **_[feichang]_table.csv_** or **_[youdian_SW]_table.csv_**
