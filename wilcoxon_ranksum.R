########################################################################################
############################## load data & pre-process data ############################
########################################################################################
# load packages
library(dplyr)
library(miceadds)
library(tidyverse)

# load data & texts
df2 <- read.csv('Yahoo_Chinese_Reviews_Corpus.csv', stringsAsFactors = F)
sentiwords <- df2$reviews_sentiword_seg %>% str_split(pattern = "\\s+")
sentence_seg <- df2$reviews %>% str_split(pattern = "( |，|,|。|、|！|\\!|\\?|？|~|～|>|<)+")

# load ANTUSD, list of negators, and list of degree adverbs
ANTUSD <- read.csv('ANTUSD.csv', stringsAsFactors = F)
ANTUSD.list <- as.character(ANTUSD$word)
negator <- c('不','沒','沒有','不是','不行','無','無法','非','不夠','未','絕非','並非','別','不太','了無','不可','不可以','不用','不會','不要','不應','不應該','不能','不需','不需要','不敢')
DegreeAdv <- c('太','很','好','非常','超','超級','最','蠻','滿','挺','相當','無敵','十分','實在','特別','滿滿','滿滿的','強力','一定','一定要','有點','有些','太過','頗為','頗','大','有夠','根本','完全','只有','不太','好像','真','真的','真的是','十足','無比')


########################################################################################
###################### quantify pattern & non-pattern contexts #########################
########################################################################################
# step1: find the positive words & negative words that occur in a given pattern, then create a new word list
new_word_list <- list()
pos_word_in_pattern_count <- neg_word_in_pattern_count <- numeric()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  target_word <- word_list[which(word_list[-length(word_list)] == '很')+1]
  target_word <- target_word[!target_word %in% DegreeAdv]

  new_word_list <- append(new_word_list, target_word)
  pos_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score > 0])
  neg_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score < 0])
}

# step2-1: pos_word_list from new_word_list
new_word_list <- unlist(new_word_list)
pos_word_list <- new_word_list[new_word_list %in% ANTUSD$word[ANTUSD$score > 0]]
pos_word_list
length(pos_word_list)
# step2-2: neg_word_list from neg_word_list
new_word_list <- unlist(new_word_list)
neg_word_list <- new_word_list[new_word_list %in% ANTUSD$word[ANTUSD$score < 0]]
neg_word_list
length(neg_word_list)

# token number of the given pattern
length(c(pos_word_list,neg_word_list))

#step3: use this list to examine pos_word_count & neg_word_count in the review
pos_word_count <- numeric()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  pos_word_count[i] <- sum(word_list %in% pos_word_list)
}
pos_word_count

neg_word_count <- numeric()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  neg_word_count[i] <- sum(word_list %in% neg_word_list)
}
neg_word_count

# the same group of positive words & negative words but now in non-pattern contexts
# remove the tokens in the pattern from the total pos_word_count & neg_word_count individually
df2$pos_word_count <- pos_word_count-pos_word_in_pattern_count
df2$pos_word_in_pattern_count <- pos_word_in_pattern_count
df2$neg_word_count <- neg_word_count-neg_word_in_pattern_count
df2$neg_word_in_pattern_count <- neg_word_in_pattern_count

# check the counts
num <- nrow(subset(df2, (pos_word_in_pattern_count >0 | neg_word_in_pattern_count >0)))
num
num_pos <- nrow(subset(df2, pos_word_in_pattern_count >0))
num_pos
num_neg <- nrow(subset(df2, neg_word_in_pattern_count >0))
num_neg


########################################################################################
#### time the token frequency of pattern context and non-pattern contexts by rating ####
########################################################################################
# expand 'rating' according to the counts in the four columns
names(df2)
df2 <- df2[complete.cases(df2), ]
nrow(df2)
# pos_word_in_pattern_count vs. pos_word_count
# start with pos_word_in_pattern_count and rating (SCORE-1)
attach(df2)
rating <- as.numeric(df2$rating)
pos_word_in_pattern_rep_with_rating <- c()
for (i in 1:length(rating)){
  pos_word_in_pattern_rep_with_rating<- append(pos_word_in_pattern_rep_with_rating,rep(rating[i],pos_word_in_pattern_count[i]))
}

# move onto pos_word_count and rating (SCORE-2)
pos_word_rep_with_rating <- c()
for (i in 1:length(rating)){
  pos_word_rep_with_rating<- append(pos_word_rep_with_rating, rep(rating[i],pos_word_count[i]))
}

# neg_word_in_pattern_count vs. neg_word_count
# start with neg_word_in_pattern_count and rating (SCORE-1)
attach(df2)
rating <- as.numeric(df2$rating)
neg_word_in_pattern_rep_with_rating <- c()
for (i in 1:length(rating)){
  neg_word_in_pattern_rep_with_rating<- append(neg_word_in_pattern_rep_with_rating,rep(rating[i],neg_word_in_pattern_count[i]))
}

# move onto neg_word_count and rating (SCORE-2)
neg_word_rep_with_rating <- c()
for (i in 1:length(rating)){
  neg_word_rep_with_rating <- append(neg_word_rep_with_rating, rep(rating[i],neg_word_count[i]))
}


########################################################################################
########################## run Wilcoxon Rank-Sum test ##################################
########################################################################################
# pos_word_in_pattern_count vs. pos_word_count (SCORE-1 vs. SCORE-2)
wilcox_pos <- wilcox.test(pos_word_rep_with_rating, pos_word_in_pattern_rep_with_rating)
wilcox_pos

# if the median difference is significant, compare the mean of SCORE-1 and SCORE-2
sum(pos_word_in_pattern_rep_with_rating)/length(pos_word_in_pattern_rep_with_rating) # pattern
sum(pos_word_rep_with_rating)/length(pos_word_rep_with_rating) # non-pattern

# calculate effect size
N <- length(c(pos_word_rep_with_rating, pos_word_in_pattern_rep_with_rating))
N

rFromWilcox_pos <- function(wilcoxModel, N){
  z <- qnorm(wilcoxModel$p.value/2)
  r <- z/ sqrt(N)
  cat(wilcoxModel$data.name, "Effect Size, r = ", r)
}
rFromWilcox_pos(wilcox_pos, N) # effect size of the pattern


# neg_word_in_pattern_count vs. neg_word_count (SCORE-1 vs. SCORE-2)
wilcox_neg <- wilcox.test(neg_word_rep_with_rating, neg_word_in_pattern_rep_with_rating, exact = FALSE, correct= FALSE)
wilcox_neg

# if the median difference is significant, compare the mean of SCORE-1 and SCORE-2
sum(neg_word_in_pattern_rep_with_rating)/length(neg_word_in_pattern_rep_with_rating) # pattern
sum(neg_word_rep_with_rating)/length(neg_word_rep_with_rating) # non-pattern

# calculate effect size
N <- length(c(neg_word_rep_with_rating, neg_word_in_pattern_rep_with_rating))
N

rFromWilcox_neg <- function(wilcoxModel, N){
  z <- qnorm(wilcoxModel$p.value/2)
  r <- z/ sqrt(N)
  cat(wilcoxModel$data.name, "Effect Size, r = ", r)
}
rFromWilcox_neg(wilcox_neg, N) # effect size of the pattern

