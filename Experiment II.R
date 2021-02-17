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

# remove any feature tha is numeric or romance alphabet
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
# Unigrams
# find the (non-sentiment) Unigrams in the corpus
# define symbols that need to be removed
symbols <- c("!", "！", "?", "？", "~", "～", "..", "...", "#", "＃", "\"", "“", "「", "（", "(")
# create a dfm based on Unigrams
Unigram <- dfm_cleaned %>% dfm_select(pattern = ANTUSD.list, selection = "remove") %>% #remove all sentiment words
  dfm_select(pattern = symbols, selection = 'remove') %>%
  dfm_trim(min_docfreq = 4, docfreq_type = "count") %>% # min. doc. freq.= 4
  dfm_sort(decreasing = TRUE, margin = "features") %>%
  dfm_weight(scheme = "boolean") # binary-valued

dim(Unigram) # nfeat = 1098
# token freq.
sum(Unigram)


# Bigrams
# find the same number of Bigrams as Unigrams in the corpus
# create a dfm based on Bigrams
training.tokens.dfm.bigram <- df.tokens %>% tokens_ngrams(n = 2, concatenator = "_") %>% dfm()
Bigram <- training.tokens.dfm.bigram %>%
  dfm_select(names(topfeatures(., n = 1098, scheme = "count"))) %>%
  dfm_sort(decreasing = TRUE, margin = "features") %>%
  dfm_weight(scheme = "boolean") # binary-valued

dim(Bigram) # nfeat = 1098
# token freq.
sum(Bigram)


# Sentiment words
# find the positive and negative sentiment words in the corpus
ANTUSD.PosNeg <- read.csv('ANTUSD_PosNeg.csv', stringsAsFactors = F)
ANTUSD.PosNeg.list <- as.character(ANTUSD.PosNeg$word) # word list
length(ANTUSD.PosNeg.list) # 20713
# create a dfm based on sentiment words
SentiW <- dfm_cleaned %>% dfm_select(pattern = ANTUSD.PosNeg.list, selection = 'keep') %>%
  dfm_weight(scheme = "boolean")

dim(SentiW) # nfat = 2101


########################################################################################
##################################### Build models #####################################
########################################################################################
# MODEL 1 (the Unigrams-Bigrams baseline)
Ngrams <- cbind(Unigram, Bigram)
# convert the Ngrams dfm to data.frame
Ngrams_df <- Ngrams %>% convert(to = 'data.frame')
Ngrams_df <- as.data.frame(Ngrams_df, row.names = df2.binary$reviewID)
Ngrams_df <- Ngrams_df[ , -which(names(Ngrams_df) == "document")]

# build the model
Ngrams_df_label <- cbind(Label = df2.binary$rating, Ngrams_df) # add rating label
ncol(Ngrams_df_label) # ncol = 1+2196 = 2197
Final_df_label <- Ngrams_df_label
ncol(Final_df_label)


# MODEL 2 (Unigrams + Bigrams + sentiment words)
Ngrams <- cbind(Unigram, Bigram)
# convert the Ngrams dfm to data.frame
Ngrams_df <- Ngrams %>% convert(to = 'data.frame')
Ngrams_df <- as.data.frame(Ngrams_df, row.names = df2.binary$reviewID)
Ngrams_df <- Ngrams_df[ , -which(names(Ngrams_df) == "document")]
# convert the SentiW dfm to data.frame
SentiW_df <- SentiW %>% convert(to = 'data.frame')
SentiW_df <- as.data.frame(SentiW_df, row.names = df2.binary$reviewID)
SentiW_df <- SentiW_df[ , -which(names(SentiW_df) == "document")]

# build the model
Ngrams_df_label <- cbind(Label = df2.binary$rating, Ngrams_df) # add rating label
ncol(Ngrams_df_label) # ncol = 1+2196 = 2197
Final_df_label <- cbind(Ngrams_df_label, SentiW_df)
ncol(Final_df_label) # ncol = 2197+2101 = 4298


# MODEL 3 (Unigrams + Bigrams + sentiment words + MorphoSyntactic Patterns)
Ngrams <- cbind(Unigram, Bigram)
# convert the Ngrams dfm to data.frame
Ngrams_df <- Ngrams %>% convert(to = 'data.frame')
Ngrams_df <- as.data.frame(Ngrams_df, row.names = df2.binary$reviewID)
Ngrams_df <- Ngrams_df[ , -which(names(Ngrams_df) == "document")]

# build the model
# run 'weighting.r' first to weight sentiment words by morphosyntactic patterns
Ngrams_df_label <- cbind(Label = df2.binary$rating, Ngrams_df) # add rating label
ncol(Ngrams_df_label) # ncol = 1+2196 = 2197
Final_df_label <- cbind(Ngrams_df_label, SentiW_weighted)
ncol(Final_df_label)


########################################################################################
################################### Train the model ####################################
########################################################################################
# split the data into training data and test data
#install.packages("caret")
library(caret)
library(kernlab) # for SVM

# performance metrics
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
folds <- createFolds(Final_df_label$Label, k=10) #change here
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
t_test <- t.test(trial_summary_cleaned$EXP2_MOD2, trial_summary_cleaned$EXP2_MOD3, paired = T)
t_test

# calculate the effect size
t <- t_test$statistic[[1]]
df <- t_test$parameter[[1]]
r2 <- sqrt(t^2/(t^2+df))
round(r2, 3)


