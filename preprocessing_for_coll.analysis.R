########################################################################################
############################### Post-hoc collexeme analysis ############################
########################################################################################
# load data & texts
df2 <- read.csv('Yahoo_Chinese_Reviews_Corpus.csv', stringsAsFactors = F)
sentiwords <- df2$reviews_sentiword_seg %>% str_split(pattern = "\\s+")
# load ANTUSD and list of degree adverbs
ANTUSD <- read.csv('ANTUSD.csv', stringsAsFactors = F)
ANTUSD.list <- as.character(ANTUSD$word)
DegreeAdv <- c('太','很','好','非常','超','超級','最','蠻','滿','挺','相當','無敵','十分','實在','特別','滿滿','滿滿的','強力','一定','一定要','有點','有些','太過','頗為','頗','大','有夠','根本','完全','只有','不太','好像','真','真的','真的是','十足','無比')


# the prototypical sentiment-intensifying pattern [feichang SW]
new_word_list <- list()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  target_word <- word_list[which(word_list[-length(word_list)] == '非常')+1]
  target_word <- target_word[!target_word %in% DegreeAdv]

  new_word_list <- append(new_word_list, target_word)
}
# combine pos_word_list and neg_word_list
new_word_list <- unlist(new_word_list)
pos_word_list <- new_word_list[new_word_list %in% ANTUSD$word[ANTUSD$score > 0]]
length(pos_word_list)

new_word_list <- unlist(new_word_list)
neg_word_list <- new_word_list[new_word_list %in% ANTUSD$word[ANTUSD$score < 0]]
length(neg_word_list)

# combine into a word list
word_list <- c(pos_word_list, neg_word_list)
length(word_list) # token number of the given pattern

# get SW that appear in the pattern & their token freq.
word_list_df <- table(word_list) %>% as.data.frame() %>% .[order(- .$Freq),]
word_list_df <- rename(word_list_df, SW_Pattern = Freq)
word_list_vec <- word_list_df$word_list %>% as.character()
word_list_vec


# for each SW on word_list, get the RAW TOTAL freq. in the corpus
# first, perform tokenization and turn the corpus into a dfm
df.tokens <- df2$reviews_sentiword_seg %>% str_split(pattern="\\s+") %>% as.tokens
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
# get word freq. for each feature
word_freq <- textstat_frequency(dfm_cleaned) %>% as.data.frame()
word_list_freq <- word_freq[word_freq$feature %in% word_list_vec, ] %>% arrange(factor(feature, levels = word_list_vec))
View(word_list_freq)

# For the same group of SWs, get 1) token freq. in [feichang SW], and 2) token freq. in the corpus
# SW_Pattern = token freq. in [feichang SW]
# SW_RawTotal = token freq. in the corpus
SW_Pattern <- SW_RawTotal <- c()
for (i in 1:length(word_list_vec)){
  SW_Pattern[i] <- word_list_df$SW_Pattern[which(word_list_df$word_list == word_list_vec[[i]])]
  SW_RawTotal[i] <- word_list_freq$frequency[which(word_list_freq$feature == word_list_vec[[i]])]
}

# put into a table
Contingency_Table <- data.frame(Word = word_list_vec,
                                Freq_A_in_Corpus = SW_RawTotal,
                                Freq_A_in_C = SW_Pattern)
# output
write.csv(Contingency_Table, "[feichang_SW]_table.csv", row.names = F, fileEncoding = "UTF-8")
# check the token number of the pattern
sum(Contingency_Table$Freq_A_in_C) # token number = 190

###########

# the prototypical sentiment-mitigating pattern [youdian SW]
new_word_list <- list()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  target_word <- word_list[which(word_list[-length(word_list)] == '有點')+1]
  target_word <- target_word[!target_word %in% DegreeAdv]

  new_word_list <- append(new_word_list, target_word)
}
# combine pos_word_list and neg_word_list
new_word_list <- unlist(new_word_list)
pos_word_list <- new_word_list[new_word_list %in% ANTUSD$word[ANTUSD$score > 0]]
length(pos_word_list)

new_word_list <- unlist(new_word_list)
neg_word_list <- new_word_list[new_word_list %in% ANTUSD$word[ANTUSD$score < 0]]
length(neg_word_list)

# combine into a word list
word_list <- c(pos_word_list, neg_word_list)
length(word_list) # token number of the given pattern

# get SW that appear in the pattern & their token freq.
word_list_df <- table(word_list) %>% as.data.frame() %>% .[order(- .$Freq),]
word_list_df <- rename(word_list_df, SW_Pattern = Freq)
word_list_vec <- word_list_df$word_list %>% as.character()
word_list_vec

# for each SW on word_list, get the RAW TOTAL freq. in the corpus
word_freq <- textstat_frequency(dfm_cleaned) %>% as.data.frame()
word_list_freq <- word_freq[word_freq$feature %in% word_list_vec, ] %>% arrange(factor(feature, levels = word_list_vec))
View(word_list_freq)

# For the same group of SWs, get 1) token freq. in [youdian SW], and 2) token freq. in the corpus
# SW_Pattern = token freq. in [youdian SW]
# SW_RawTotal = token freq. in the corpus
SW_Pattern <- SW_RawTotal <- c()
for (i in 1:length(word_list_vec)){
  SW_Pattern[i] <- word_list_df$SW_Pattern[which(word_list_df$word_list == word_list_vec[[i]])]
  SW_RawTotal[i] <- word_list_freq$frequency[which(word_list_freq$feature == word_list_vec[[i]])]
}

# put into a table
Contingency_Table <- data.frame(Word = word_list_vec,
                                Freq_A_in_Corpus = SW_RawTotal,
                                Freq_A_in_C = SW_Pattern)
# output
write.csv(Contingency_Table, "[youdian_SW]_table.csv", row.names = F, fileEncoding = "UTF-8")
# check the token number of the pattern
sum(Contingency_Table$Freq_A_in_C) # token number = 55


