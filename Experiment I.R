########################################################################################
################################### Import Data ########################################
########################################################################################
#library(miceadds)
df2.binary <- read.csv('Yahoo_Chinese_Reviews_Corpus.csv', stringsAsFactors = F)

# convert ratings to binary "negative" and "positive"
df2.binary[df2.binary$rating == "1"|df2.binary$rating == "2", ]$rating <- "negative"
df2.binary[df2.binary$rating == "5", ]$rating <- "positive"
#View(df2.binary)


########################################################################################
############################ Pre-process data to create dfm ############################
########################################################################################
# tokenization (important!!!)
library(quanteda)
library(stringr)

df.tokens <- df2.binary$reviews_sentiword_seg %>% str_split(pattern="\\s+") %>% as.tokens
class(df.tokens)
ndoc(df.tokens)

# convert to dfm
dfm <- df.tokens %>% dfm
dim(dfm)

# remove any feature tha is numeric or an alphabet
dfm_cleaned = dfm_select(dfm, "[0-9]+", selection = 'remove', valuetype = 'regex')
nfeat(dfm_cleaned)
dfm_cleaned = dfm_select(dfm_cleaned, "[a-z]+", selection = 'remove', valuetype = 'regex', case_insensitive = TRUE)
nfeat(dfm_cleaned)
dfm_cleaned = dfm_select(dfm_cleaned, "[A-Z]+", selection = 'remove', valuetype = 'regex', case_insensitive = TRUE)
nfeat(dfm_cleaned)

# check dfm
dim(dfm_cleaned)


########################################################################################
################################### Create feature sets ################################
########################################################################################
# BASELINE 1 (SW-Bigrams)
# find all of the bigrams in the corpus
training.tokens.dfm.bigram <- df.tokens %>% tokens_ngrams(n = 2, concatenator = "_") %>% dfm()
featnames_Bigram <- featnames(training.tokens.dfm.bigram)
length(featnames_Bigram)
head(featnames_Bigram)
# select SW-Bigrams
# first, define positive and negative sentiment words
ANTUSD.PosNeg <- read.csv('ANTUSD_PosNeg.csv', stringsAsFactors = F)
ANTUSD.PosNeg.list <- as.character(ANTUSD.PosNeg$word) # word list
length(ANTUSD.PosNeg.list) # 20713

# then, select Bigrams that contain sentiment words
featnames_Bigram_SentiW <- c()
for (i in ANTUSD.PosNeg.list){
  w <- featnames_Bigram[str_detect(featnames_Bigram, i)]
  featnames_Bigram_SentiW <- append(w, featnames_Bigram_SentiW)
}
featnames_Bigram_SentiW[1:10]
# type freq.
length(unique(featnames_Bigram_SentiW))
# token freq.
length(featnames_Bigram_SentiW)

# create a dfm based on SW-Bigrams
Bigram_SentiW <- training.tokens.dfm.bigram %>% dfm_select(pattern = featnames_Bigram_SentiW, selection = 'keep') %>%
  dfm_trim(min_docfreq = 11, docfreq_type = "count") %>%
  dfm_sort(decreasing = TRUE, margin = "features") %>%
  dfm_weight(scheme = "boolean")
# check
dim(Bigram_SentiW) # nfeat = 133
# token freq.
sum(Bigram_SentiW)


# BASELINE 2 (SW-Trigrams)
# find all the trigrams in the corpus
training.tokens.dfm.trigram <- df.tokens %>% tokens_ngrams(n = 3, concatenator = "_") %>% dfm()
featnames_Trigram <- featnames(training.tokens.dfm.trigram)
length(featnames_Trigram)
head(featnames_Trigram)
# select SW-Trigrams
featnames_Trigram_SentiW <- c()
for (i in ANTUSD.PosNeg.list){
  w <- featnames_Trigram[str_detect(featnames_Trigram, i)]
  featnames_Trigram_SentiW <- append(w, featnames_Trigram_SentiW)
}
featnames_Trigram_SentiW[1:10]
# type freq.
length(unique(featnames_Trigram_SentiW))
# token freq.
length(featnames_Trigram_SentiW)

# create a dfm based on SW-Trigrams
Trigram_SentiW <- training.tokens.dfm.trigram %>% dfm_select(pattern = featnames_Trigram_SentiW, selection = 'keep') %>%
  dfm_trim(min_docfreq = 3, docfreq_type = "count") %>%
  dfm_sort(decreasing = TRUE, margin = "features") %>%
  dfm_weight(scheme = "boolean")
# check
dim(Trigram_SentiW) # nfeat = 1277
# token freq.
sum(Trigram_SentiW)


# BASELINE 3 (SW-Four-grams)
# find all the four-grams in the corpus
training.tokens.dfm.fourgram <- df.tokens %>% tokens_ngrams(n = 4, concatenator = "_") %>% dfm()
featnames_Fourgram <- featnames(training.tokens.dfm.fourgram)
length(featnames_Fourgram)
head(featnames_Fourgram)
# select SW-Four-grams
featnames_Fourgram_SentiW <- c()
for (i in ANTUSD.PosNeg.list){
  w <- featnames_Fourgram[str_detect(featnames_Fourgram, i)]
  featnames_Fourgram_SentiW <- append(w, featnames_Fourgram_SentiW)
}
featnames_Fourgram_SentiW[1:10]
# type freq.
length(unique(featnames_Fourgram_SentiW))
# token freq.
length(featnames_Fourgram_SentiW)

# create a dfm based on SW-Four-grams
Fourgram_SentiW <- training.tokens.dfm.fourgram %>% dfm_select(pattern = featnames_Fourgram_SentiW, selection = 'keep') %>%
  dfm_trim(min_docfreq = 3, docfreq_type = "count") %>%
  dfm_sort(decreasing = TRUE, margin = "features") %>%
  dfm_weight(scheme = "boolean")
# check
dim(Fourgram_SentiW) # nfeat = 1193
# token freq
sum(Fourgram_SentiW)


# BASELINE 4 (SW-Five-grams)
# find all the five-grams in the corpus
training.tokens.dfm.fivegram <- df.tokens %>% tokens_ngrams(n = 5, concatenator = "_") %>% dfm()
featnames_Fivegram <- featnames(training.tokens.dfm.fivegram)
length(featnames_Fivegram)
head(featnames_Fivegram)
# select SW-Five-grams
featnames_Fivegram_SentiW <- c()
for (i in ANTUSD.PosNeg.list){
  w <- featnames_Fivegram[str_detect(featnames_Fivegram, i)]
  featnames_Fivegram_SentiW <- append(w, featnames_Fivegram_SentiW)
}
featnames_Fivegram_SentiW[1:10]
# type freq.
length(unique(featnames_Fivegram_SentiW))
# token freq.
length(featnames_Fivegram_SentiW)

# create a dfm based on SW-Five-grams
Fivegram_SentiW <- training.tokens.dfm.fivegram %>% dfm_select(pattern = featnames_Fivegram_SentiW, selection = 'keep') %>%
  dfm_trim(min_docfreq = 3, docfreq_type = "count") %>%
  dfm_sort(decreasing = TRUE, margin = "features") %>%
  dfm_weight(scheme = "boolean")
# check
dim(Fivegram_SentiW) # 1253
# token freq.
sum(Fivegram_SentiW)


########################################################################################
##################################### Build models #####################################
########################################################################################
# create dfm based on sentiment words (b/c each baseline model is 'SW + SW-n-grams')
SentiW <- dfm_cleaned %>% dfm_select(pattern = ANTUSD.PosNeg.list, selection = 'keep') %>%
  dfm_weight(scheme = "boolean")
# check
dim(SentiW) # nfeat = 2101
# convert dfm to data.frame
SentiW_df <- SentiW %>% convert(to = 'data.frame')
SentiW_df <- as.data.frame(SentiW_df, row.names = df2.binary$reviewID)
SentiW_df <- SentiW_df[ , -which(names(SentiW_df) == "document")]
ncol(SentiW_df)


# BASELINE 1 (SW + SW-Bigrams)
# convert the SW-Bigrams dfm to data.frame
Bigram_SentiW_df <- Bigram_SentiW %>% convert(to = 'data.frame')
Bigram_SentiW_df <- as.data.frame(Bigram_SentiW_df, row.names = df2.binary$reviewID)
Bigram_SentiW_df <- Bigram_SentiW_df[ , -which(names(Bigram_SentiW_df) == "document")]
ncol(Bigram_SentiW_df) # nfeat = 133
# build the model
SentiW_df_label <- cbind(Label = df2.binary$rating, SentiW_df) # add rating label to SentiW
ncol(SentiW_df_label) # ncol = 1+2101 = 2102 (1 = the rating label)
Final_df_label <- cbind(SentiW_df_label, Bigram_SentiW_df) # add SW-Bigrams
ncol(Final_df_label) # ncol = 2102+133 = 2235


# BASELINE 2 (SW + SW-Trigrams)
# convert the SW-Trigrams dfm to data.frame
Trigram_SentiW_df <- Trigram_SentiW %>% convert(to = 'data.frame')
Trigram_SentiW_df <- as.data.frame(Trigram_SentiW_df, row.names = df2.binary$reviewID)
Trigram_SentiW_df <- Trigram_SentiW_df[ , -which(names(Trigram_SentiW_df) == "document")]
ncol(Trigram_SentiW_df) # nfeat = 1277
# build the model
SentiW_df_label <- cbind(Label = df2.binary$rating, SentiW_df) # add rating label to SentiW
ncol(SentiW_df_label) # ncol = 1+2101 = 2102
Final_df_label <- cbind(SentiW_df_label, Trigram_SentiW_df) # add SW-Bigrams
ncol(Final_df_label) # ncol = 2102+1277 = 3379


# BASELINE 3 (SW + SW-Four-grams)
# convert the SW-Four-grams dfm to data.frame
Fourgram_SentiW_df <- Fourgram_SentiW %>% convert(to = 'data.frame')
Fourgram_SentiW_df <- as.data.frame(Fourgram_SentiW_df, row.names = df2.binary$reviewID)
Fourgram_SentiW_df <- Fourgram_SentiW_df[ , -which(names(Fourgram_SentiW_df) == "document")]
ncol(Fourgram_SentiW_df) # nfeat = 1193
# build the model
SentiW_df_label <- cbind(Label = df2.binary$rating, SentiW_df) # add rating label to SentiW
ncol(SentiW_df_label) # ncol = 1+2101 = 2102
Final_df_label <- cbind(SentiW_df_label, Fourgram_SentiW_df) # add SW-Bigrams
ncol(Final_df_label) # ncol = 2102+1193 = 3295


# BASELINE 4 (SW + SW-Five-grams)
# convert the SW-Four-grams dfm to data.frame
Fivegram_SentiW_df <- Fivegram_SentiW %>% convert(to = 'data.frame')
Fivegram_SentiW_df <- as.data.frame(Fivegram_SentiW_df, row.names = df2.binary$reviewID)
Fivegram_SentiW_df <- Fivegram_SentiW_df[ , -which(names(Fivegram_SentiW_df) == "document")]
ncol(Fivegram_SentiW_df) # nfeat = 1253
# build the model
SentiW_df_label <- cbind(Label = df2.binary$rating, SentiW_df) # add rating label to SentiW
ncol(SentiW_df_label) # ncol = 1+2101 = 2102
Final_df_label <- cbind(SentiW_df_label, Fivegram_SentiW_df) # add SW-Bigrams
ncol(Final_df_label) # ncol = 2102+1253 = 3355


# PROPOSED MODEL (SW + Morphosyntactic Patterns)
# run 'weighting.r' first to weight sentiment words by morphosyntactic patterns
Final_df_label <- cbind(Label = df2.binary$rating, SentiW_weighted) # add rating label
ncol(Final_df_label) # ncol = 1+2101 = 2102


########################################################################################
################################### Train the model ####################################
########################################################################################
# split the data into training data and test data
#install.packages("caret")
library(caret)
library(kernlab) # for SVM

# define performance metrics
# function to compute precision
precisionNew <- function(ypred, y){
  tab <- table(ypred, y)
  return((tab[2,2])/(tab[2,1]+tab[2,2]))
}
# function to compute recall
recallNew <- function(ypred, y){
  tab <- table(ypred, y)
  return(tab[2,2]/(tab[1,2]+tab[2,2]))
}

# split the training data into ten folds, then perform 10-fold CV
set.seed(32984)
folds <- createFolds(Final_df_label$Label, k=10)
str(folds)

accuracy <- precisionPos <- recallPos <- F1Pos <- precisionNeg <- recallNeg <- F1Neg <- rep(0,10)
for(i in 1:10){
  training_data <- Final_df_label[-folds[[i]],]
  test_data <- Final_df_label[folds[[i]],]

  svm <- ksvm(Label~. , data = training_data, kernel = "vanilladot")
  test_predictions <- predict(svm, test_data)
  accuracy[i] <- mean(test_predictions == test_data$Label)

  precisionPos[i] <- precisionNew(test_predictions, test_data$Label)
  recallPos[i] <- recallNew(test_predictions, test_data$Label)
  F1Pos[i] <- (2 * precisionPos[i] * recallPos[i]) / (precisionPos[i] + recallPos[i])

  precisionNeg[i] <- precision(test_predictions, test_data$Label)
  recallNeg[i] <- recall(test_predictions, test_data$Label)
  F1Neg[i] <- (2 * precisionNeg[i] * recallNeg[i]) / (precisionNeg[i] + recallNeg[i])
}

# Positive texts
avg_precisionPos <- sum(precisionPos)/10
avg_recallPos <- sum(recallPos)/10
avg_F1Pos <- sum(F1Pos)/10
# Negative texts
avg_precisionNeg <- sum(precisionNeg)/10
avg_recallNeg <- sum(recallNeg)/10
avg_F1Neg <- sum(F1Neg)/10
# accuracy
avg_accuracy <- sum(accuracy)/10
# Macro F1
macro_F1 <- (avg_F1Pos + avg_F1Neg)/2

stats <- c(accuracy, avg_precisionPos, avg_recallPos, avg_F1Pos, avg_precisionNeg, avg_recallNeg, avg_F1Neg, avg_accuracy, macro_F1)
View(stats)


########################################################################################
################################### Post-hoc t-test ####################################
########################################################################################
library(readxl)
trial_summary <- read.csv('CV_trials.csv', stringsAsFactors = F)
trial_summary_cleaned <- trial_summary[-c(11:19),]

# run T-TEST on accuracies of the ten CV trials
t_test <- t.test(trial_summary_cleaned$EXP1_MOD4, trial_summary_cleaned$EXP1_MOD5, paired = T)
t_test

# calculate the effect size
t <- t_test$statistic[[1]]
df <- t_test$parameter[[1]]
r2 <- sqrt(t^2/(t^2+df))
round(r2, 3)

# adjusted R2
n <- 3200
p <- as.numeric(trial_summary$EXP1_MOD4[[19]]) - as.numeric(trial_summary$EXP1_MOD5[[19]])
p

adjusted_r2 <- 1- (((1-r2)*(n-1))/(n-p-1))
round(adjusted_r2, 3)

