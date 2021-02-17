# Sentiment-Analysis-of-Chinese-Reviews-Using-Morphosyntactic-Patterns

The codes and data: What they are and what they do (listed in alphabetical order)
Data:
- ANTUSD.csv: the sentiment dictionary ANTUSD
- ANTUSD_PosNeg.csv: only the positive and negative words in ANTUSD
- Yahoo_Chinese_Reviews_Corpus.csv: the Chinese movie reviews corpus
Codes:
- coll.analysis.R: the collexeme analysis
- Experiment I.R: Experiment I
- Experiment II.R: Experiment II
- patterns_for_ranksum.R: the patterns with significant sentiment modulation
- preprocessing_for_coll.analysis.R: the preprocessing of data in order to perform the collexeme analysis
- weighting.R: weighting the co-occurrence of sentiment words in patterns based on the dfm of sentiment words
- wilcoxon_ranksum.R: the quantification of the pattern and non-pattern contexts & the Wilcoxon rank-sum test
Procedure: 
Wilcoxon rank-sum test >> Experiment I >> Experiment II >> Post-hoc Collexeme Analysis 


### Wilcoxon rank-sum test 
Please run ‘wilcoxon_ranksum.R’ for the rank-sum test.
1. Load & pre-process data: run line 1–18
2. Quantify the pattern context: run line 21–49
3. Quantify the NON-pattern context: run line 51–79
4. Multiply the token frequencies by rating: run line 82–117
5. Perform the Wilcoxon rank-sum test & Determine the modulation of patterns: run line 120–160

To run the rank-sum test on other patterns, open ‘patterns_for_ranksum.R’.
Copy the code for each pattern and replace the codes between line 25–35 in ‘wilcoxon_ranksum.R’ with the new code. Then run all of the codes in ‘wilcoxon_ranksum.R’.


### Experiment I
Please run ‘Experiment I.R’ for Experiment I.
1. Load & pre-process data: run line 1–37
2. Create feature sets: run line 40–162
3. Baseline models:
	A.	To build the SW+SW-Bigrams model, run line 168–177 first, and then line 180–190; finally, run line 241–295 for the classification experiment with the SW+SW-Bigrams model.
	B.	To build the SW+SW-Trigrams model, run line 193–203; then, run line 241–295 for the classification experiment with the SW+SW-Trigrams model.
	C.	To build the SW+SW-Four-grams model, run line 206–216; then, run line 241–295 for the classification experiment with the SW+SW-Four-grams model.
	D.	To build the SW+SW-Five-grams model, run line 219–229; then, run line 241–295 for the classification experiment with the SW+SW-Five-grams model.
4. Proposed model:
	A. First, open ‘weighting.R’ to perform weighting on the document-feature matrix based on the sentiment word features. 	Run all of the codes in ‘weighting.R’.
	B. Return to ‘Experiment I.R’ and run line 232–235 to build the SW+Morphosyntactic patterns model. Finally, run line 	241–295 for the classification experiment with the SW+Morphosyntactic patterns model.
5. Post-hoc t-test:
	A. Change the models to compare in line 306 and line 317.
	B. Run line 315–321 for the adjusted R2-squared value.


### Experiment II
Please run ‘Experiment II.R’ for Experiment II.
1. Load & pre-process data: run line 1–37
2. Create feature sets: run line 40–82
3. Baseline models:
	A.	To build the Unigrams–Bigrams model, run line 88–99 first, and then run line 138–192 for the classification experiment with the Unigrams–Bigrams model.
	B.	To build the Unigrams–Bigrams–Sentiment word model, run line 102–117, and then run line 138–192 for the classification experiment with the Unigrams–Bigrams–Sentiment word model.
	C.	To build the Unigrams–Bigrams–Sentiment word–Morphosyntactic patterns model, run line 120–132 (if you have already run ‘weighting.R’ to perform weighting on the document-feature matrix based on the sentiment word features). Then, run line 138–192 for the classification experiment with the Unigrams–Bigrams–Sentiment word–Morphosyntactic patterns model.
4. Post-hoc t-test: run line 198–210
	A. Change the models to compare in line 203.


### Post-hoc Collexeme Analysis 
Please run ‘preprocessing_for_coll.analysis.R’ first. This will generate a contingency table that includes the token frequency of every collexeme in a given pattern and the raw frequency of these collexemes in the corpus.
1. Load & pre-process data: run line 1–10
2. To get the contingency table for [feichang SW] (the prototypical sentiment-intensifying pattern), run line 13–80. This will generate ‘[feichang_SW]_table.csv’.
2. To get the contingency table for [youdian SW] (the prototypical sentiment-mitigating pattern), run line 85–133. This will generate ‘[youdian_SW]_table.csv’.

Please run ‘coll.analysis.R’ for the collexeme analysis and follow the instructions below:
What is the word W / the name of the construction C you investigate (without spaces)? 
>> [feichang SW] / [youdian SW]
Enter the size of the corpus (in constructions or words) without digit grouping symbols!
>> 92041
Enter the frequency of [feichang in the corpus you investigate (without digit grouping symbols)
>> 190 for [feichang SW] / 55 for [youdian SW]
Which index of association strength do you want to compute? 
>> -log10 (Fisher-Yates exact, one-tailed)
How do you want to sort the output? 
>> collostruction strength
Enter the number of decimals you'd like to see in the results
>> 99
Choose this text file with the raw data!
>> select ‘[feichang]_table.csv’ or ‘[youdian_SW]_table.csv’
