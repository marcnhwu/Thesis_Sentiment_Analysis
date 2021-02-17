########################################################################################
############################## load data & pre-process data ############################
########################################################################################
# load packages
library(dplyr)

# load data & texts
df2 <- read.csv('Yahoo_Chinese_Reviews_Corpus.csv', stringsAsFactors = F)
sentiwords <- df2$reviews_sentiword_seg %>% str_split(pattern = "\\s+")
sentence_seg <- df2$reviews %>% str_split(pattern = "( |，|,|。|、|！|\\!|\\?|？|~|～|>|<)+")

# load ANTUSD, list of negators, and list of degree adverbs
ANTUSD <- read.csv('ANTUSD.csv', stringsAsFactors = F)
ANTUSD.list <- as.character(ANTUSD$word)
negator <- c('不','沒','沒有','不是','不行','無','無法','非','不夠','未','絕非','並非','別','不太','了無','不可','不可以','不用','不會','不要','不應','不應該','不能','不需','不需要','不敢')
DegreeAdv <- c('太','很','好','非常','超','超級','最','蠻','滿','挺','相當','無敵','十分','實在','特別','滿滿','滿滿的','強力','一定','一定要','有點','有些','太過','頗為','頗','大','有夠','根本','完全','只有','不太','好像','真','真的','真的是','十足','無比')

# load the dfm of sentiment word on which the weighting will be performed
SentiW_dfm <- read.csv("SentiW_dfm.csv")

# set the hyperparameter for weighting
weighting <- 2


########################################################################################
################################## perform weighting ###################################
########################################################################################
# weight the sentiment words occurring in NP-based patterns & clausal patterns first
# line 31-210: define the weightings for NP-based patterns & clausal patterns

# NP_pattern_24 (SentiW+的一部+電影/片子) [intensify positive]
pos_effect_size = 0.06 # effect size of the median difference as reported by rank-sum test when the pattern co-occurs with positive words
phrase = c()
weight.value = c()
pos.list_NP_24 = list()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  index1 <- which(word_list[-1] == '的')
  index2 <- which(word_list[-1] == '一部')
  index3 <- which(word_list[-1] %in% c('電影','片子'))
  target_word <- word_list[index1[sapply(index1, function(x) (((x+1) %in% index2) & ((x+2) %in% index3))) %>% unlist]]

  pos.list_NP_24[[i]] = data.frame()
  if(length(target_word)>0){
    pos.senti.postion = which(target_word %in% ANTUSD$word[ANTUSD$score > 0]) # only look at positive words
    for (h in pos.senti.postion) {
      outcome = 1
      outcome = outcome + weighting*outcome*pos_effect_size
      pos.list_NP_24[[i]] = data.frame(phrase = target_word[h],weight.value = outcome)
    }
  }
}
pos.list_NP_24

# DepClause_pattern_25 (W (as an independent clause)) [intensify positive]
pos_effect_size = 0.07
phrase = c()
weight.value = c()
pos.list_DepClause_25 = list()
for (i in 1:length(sentence_seg)) {
  word_list <- sentence_seg[[i]]
  target_word <- word_list

  pos.list_DepClause_25[[i]] = data.frame()
  if(length(target_word)>0){
    pos.senti.postion = which(target_word %in% ANTUSD$word[ANTUSD$score > 0])
    for (h in pos.senti.postion) {
      outcome = 1
      outcome = outcome + weighting*outcome*pos_effect_size
      pos.list_DepClause_25[[i]] = data.frame(phrase = target_word[h],weight.value = outcome)
    }
  }
}
pos.list_DepClause_25

# DepClause_pattern_25 (W (as an independent clause)) [intensify negative]
neg_effect_size = 0.11
phrase = c()
weight.value = c()
neg.list_DepClause_25 = list()
for (i in 1:length(sentence_seg)) {
  word_list <- sentence_seg[[i]]
  target_word <- word_list

  neg.list_DepClause_25[[i]] = data.frame()
  if(length(target_word)>0){
    neg.senti.postion = which(target_word %in% ANTUSD$word[ANTUSD$score < 0]) # only look at negative words
    for (h in neg.senti.postion) {
      outcome = 1
      outcome = outcome + weighting*outcome*neg_effect_size
      neg.list_DepClause_25[[i]] = data.frame(phrase = target_word[h],weight.value = outcome)
    }
  }
}
neg.list_DepClause_25

# DepClause_pattern_26 (讓人/令人/使人+SentiW) [intensify positive]
pos_effect_size = 0.10
phrase = c()
weight.value = c()
pos.list_DepClause_26 = list()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  target_word <- word_list[which(word_list[-length(word_list)] %in% c('讓人','令人','使人')) +1]
  target_word <- target_word[!target_word %in% c(DegreeAdv,'感覺','感到','覺得')]

  pos.list_DepClause_26[[i]] = data.frame()
  if(length(target_word)>0){
    pos.senti.postion = which(target_word %in% ANTUSD$word[ANTUSD$score > 0])
    for (h in pos.senti.postion) {
      outcome = 1
      outcome = outcome + weighting*outcome*pos_effect_size
      pos.list_DepClause_26[[i]] = data.frame(phrase = target_word[h],weight.value = outcome)
    }
  }
}
pos.list_DepClause_26

# DepClause_pattern_27 (SentiW1+又+SentiW2) slot 2 [intensify positive]
pos_effect_size = 0.06
phrase = c()
weight.value = c()
pos.list_DepClause_27 = list()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  index1 <- which(word_list[-length(word_list)] %in% ANTUSD.list)
  index3 <- which(word_list[-length(word_list)] == '又')
  target_word <- word_list[index1[sapply(index1, function(x) (((x+1) %in% index3))) %>% unlist] + 2]

  pos.list_DepClause_27[[i]] = data.frame()
  if(length(target_word)>0){
    pos.senti.postion = which(target_word %in% ANTUSD$word[ANTUSD$score > 0])
    for (h in pos.senti.postion) {
      outcome = 1
      outcome = outcome + weighting*outcome*pos_effect_size
      pos.list_DepClause_27[[i]] = data.frame(phrase = target_word[h],weight.value = outcome)
    }
  }
}
pos.list_DepClause_27

# DepClause_pattern_28 (SentiW+死了) [intensify negative]
neg_effect_size = 0.16
phrase = c()
weight.value = c()
neg.list_DepClause_28 = list()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  index1 <- which(word_list[-1] == '死')
  index2 <- which(word_list[-1] %in% c('了','ㄌ'))
  target_word <- word_list[index1[sapply(index1, function(x) (((x+1) %in% index2))) %>% unlist]]

  neg.list_DepClause_28[[i]] = data.frame()
  if(length(target_word)>0){
    neg.senti.postion = which(target_word %in% ANTUSD$word[ANTUSD$score < 0])
    for (h in neg.senti.postion) {
      outcome = 1
      outcome = outcome + weighting*outcome*neg_effect_size
      neg.list_DepClause_28[[i]] = data.frame(phrase = target_word[h],weight.value = outcome)
    }
  }
}
neg.list_DepClause_28

# DepClause_pattern_31 (SentiW+也+沒有) [mitigate positive]
pos_effect_size = -0.16
phrase = c()
weight.value = c()
pos.list_DepClause_31 = list()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  index1 <- which(word_list[-1] == '也')
  index2 <- which(word_list[-1] == '沒有')
  target_word <- word_list[index1[sapply(index1, function(x) (((x+1) %in% index2))) %>% unlist]]

  pos.list_DepClause_31[[i]] = data.frame()
  if(length(target_word)>0){
    pos.senti.postion = which(target_word %in% ANTUSD$word[ANTUSD$score > 0])
    for (h in pos.senti.postion) {
      outcome = 1
      outcome = outcome + weighting*outcome*pos_effect_size
      pos.list_DepClause_31[[i]] = data.frame(phrase = target_word[h],weight.value = outcome)
    }
  }
}
pos.list_DepClause_31

# DepClause_pattern_35 (讓人/令人/使人+覺得+SentiW) [mitigate negative]
neg_effect_size = -0.22
phrase = c()
weight.value = c()
neg.list_DepClause_35 = list()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  index1 <- which(word_list[-length(word_list)] %in% c('讓人','令人','使人'))
  index3 <- which(word_list[-length(word_list)] == '覺得')
  target_word <- word_list[index1[sapply(index1, function(x) ((x+1) %in% index3)) %>% unlist] + 2]
  target_word <- target_word[!target_word %in% c(DegreeAdv,'覺得')]

  neg.list_DepClause_35[[i]] = data.frame()
  if(length(target_word)>0){
    neg.senti.postion = which(target_word %in% ANTUSD$word[ANTUSD$score < 0])
    for (h in neg.senti.postion) {
      outcome = 1
      outcome = outcome + weighting*outcome*neg_effect_size
      neg.list_DepClause_35[[i]] = data.frame(phrase = target_word[h],weight.value = outcome)
    }
  }
}
neg.list_DepClause_35


# now we will weight the sentiment words occurring in VP-based patterns
# we first deal with the positive words occurring in patterns
# find all the positive words in SentiW_dfm
pos.senti = colnames(SentiW_dfm)[which(colnames(SentiW_dfm) %in% ANTUSD$word[ANTUSD$score > 0])]

# compile every VP-based patterns that significantly impact positive words and their effect sizes
construction = c("很","超","超級","非常","最","太",negator)
value = c(0.10,0.11,0.11,0.12,0.08,0.06, rep(-0.19,length(negator)))
pos.effect.size = data.frame(construction,value)
pos.effect.size

# define the function for weighting the positive words in VP-based patterns
pos.word.weight = function(sentiwords){
  sent_in_sentence = c()
  wordlist = sentiwords
  # first, select the reviews that have the positive words, deposit in "sent_in_sentence"
  for (j in 1:length(pos.senti)) {
    if (length(which(wordlist == pos.senti[j]))>0){
      sent_in_sentence = c(sent_in_sentence, pos.senti[j])
    }
  }
  phrase = c()
  weight.value = c()
  sent.dat =NULL
  # second, for each selected review...
  for (k in 1:length(sent_in_sentence)){
    # find the positive words' position in the review
    num.sent = which(wordlist == sent_in_sentence[k])
        # third, in each selected review, find the word before the positive words in the review
        for(h in num.sent){
          form = wordlist[h-1]
          outcome = 1 # set the occurence of the positive words as 1
          if(length(form)>0){
            # if the word before the positive words in the review belongs to any of the degree adverbs from VP-based patterns defined in line 220,
            # weight the occurrence of positive words by the effect size of that pattern
            if(form %in% c("很","超","超級","非常","最","太",negator)){
              outcome = outcome + weighting*pos.effect.size$value[pos.effect.size$construction==form]
          }
          }
          phrase = c(phrase,wordlist[h]) # output the positive words' names
          weight.value = c(weight.value,outcome) # output the weighted values for the words
        }
  }
  # combine the positive words and their weighted values
    sent.dat = data.frame(phrase,weight.value)
    return(sent.dat)
}
# apply the function to weight positive words by the effect size of patterns
pos.list = lapply(sentiwords, pos.word.weight)

#####

# find all the negative words in SentiW_dfm
neg.senti = colnames(SentiW_dfm)[which(colnames(SentiW_dfm) %in% ANTUSD$word[ANTUSD$score < 0])]
# compile every VP-based patterns that significantly impact negative words and their effect sizes
neg.construction = c("超","超級","有點","實在",negator)
value = c(0.07,0.07,-0.15,-0.14, rep(-0.06, length(negator)))
neg.effect.size = data.frame(neg.construction,value)

# define the function for weighting the negative words in VP-based patterns (which is the same as the function for the positive words)
neg.word.weight = function(sentiwords){
  sent_in_sentence = c()
  wordlist = sentiwords
  for (j in 1:length(neg.senti)) {
    if (length(which(wordlist == neg.senti[j]))>0){
      sent_in_sentence = c(sent_in_sentence,neg.senti[j])
    }
  }
  phrase = c()
  weight.value = c()
  sent.dat =NULL
  for (k in 1:length(sent_in_sentence)){
    num.sent = which(wordlist == sent_in_sentence[k])
    for(h in num.sent){
      form = wordlist[h-1]
      outcome = 1
      if(length(form)>0){
        if(form %in% neg.construction){
          outcome = outcome + weighting*neg.effect.size$value[neg.effect.size$neg.construction==form]
        }
      }
      phrase = c(phrase,wordlist[h])
      weight.value = c(weight.value,outcome)
    }
  }
  sent.dat = data.frame(phrase,weight.value)
  return(sent.dat)
}
# apply the function to weight negative words by the effect size of patterns
neg.list = lapply(sentiwords,neg.word.weight)

# combine sentiment words as weighted by VP-based patterns, NP-based patterns, and clausal patterns into a list
list = list()
for(i in 1:length(pos.list)){
  list[[i]] = rbind(pos.list[[i]],neg.list[[i]],
                    pos.list_NP_24[[i]],
                    pos.list_DepClause_25[[i]],neg.list_DepClause_25[[i]],pos.list_DepClause_26[[i]],pos.list_DepClause_27[[i]],
                    neg.list_DepClause_28[[i]],pos.list_DepClause_31[[i]],neg.list_DepClause_35[[i]])
  if (length(unlist(list[[i]]))>0){
    list[[i]] = list[[i]] %>%
      group_by(phrase) %>%            # put the same sentiment words together
      summarise(mean(weight.value))   # average the sum of values
  }
}

# fill the values in the dfm of sentiment word one by one
for (i in 1:length(list)) {
  comment = list[[i]]
  for (j in 1:ncol(SentiW_dfm)) {
    if (length(which(comment$phrase == colnames(SentiW_dfm)[j])>0)) {
      SentiW_dfm[i,j] =comment$`mean(weight.value)`[which(comment$phrase == colnames(SentiW_dfm)[j])]
    }
  }
}
# check
View(SentiW_dfm)
# output
SentiW_weighted <- SentiW_dfm


