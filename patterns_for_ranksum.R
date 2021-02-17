##############################################################################
###################### quantify significant patterns #########################
##############################################################################
# VP_pattern_1 (很+SW) [intensify positive]
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

# VP_pattern_3 (超/超級+SW) [intensify positive/intensify negative]
new_word_list <- list()
pos_word_in_pattern_count <- neg_word_in_pattern_count <- numeric()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  target_word <- word_list[which(word_list[-length(word_list)] %in% c('超','超級'))+1]
  target_word <- target_word[!target_word %in% DegreeAdv]

  new_word_list <- append(new_word_list, target_word)
  pos_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score > 0])
  neg_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score < 0])
}

# VP_pattern_4 (非常+SW) [intensify positive]
new_word_list <- list()
pos_word_in_pattern_count <- neg_word_in_pattern_count <- numeric()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  target_word <- word_list[which(word_list[-length(word_list)] == '非常')+1]
  target_word <- target_word[!target_word %in% DegreeAdv]

  new_word_list <- append(new_word_list, target_word)
  pos_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score > 0])
  neg_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score < 0])
}

# VP_pattern_5 (最+SW) [intensify positive]
new_word_list <- list()
pos_word_in_pattern_count <- neg_word_in_pattern_count <- numeric()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  target_word <- word_list[which(word_list[-length(word_list)] == '最')+1]
  target_word <- target_word[!target_word %in% DegreeAdv]

  new_word_list <- append(new_word_list, target_word)
  pos_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score > 0])
  neg_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score < 0])
}

# VP_pattern_7 (太+SW) [intensify positive]
new_word_list <- list()
pos_word_in_pattern_count <- neg_word_in_pattern_count <- numeric()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  target_word <- word_list[which(word_list[-length(word_list)] == '太')+1]
  target_word <- target_word[!target_word %in% DegreeAdv]

  new_word_list <- append(new_word_list, target_word)
  pos_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score > 0])
  neg_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score < 0])
}

# VP_pattern_10 (有點+SW) [mitigate negative]
new_word_list <- list()
pos_word_in_pattern_count <- neg_word_in_pattern_count <- numeric()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  target_word <- word_list[which(word_list[-length(word_list)] == '有點')+1]
  target_word <- target_word[!target_word %in% DegreeAdv]

  new_word_list <- append(new_word_list, target_word)
  pos_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score > 0])
  neg_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score < 0])
}

# VP_pattern_18 (實在+SW) [mitigate negative]
new_word_list <- list()
pos_word_in_pattern_count <- neg_word_in_pattern_count <- numeric()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  target_word <- word_list[which(word_list[-length(word_list)] == '實在')+1]
  target_word <- target_word[!target_word %in% DegreeAdv]

  new_word_list <- append(new_word_list, target_word)
  pos_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score > 0])
  neg_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score < 0])
}

# VP_pattern_23 (negator+SW) [mitigate positive/mitigate negative]
new_word_list <- list()
pos_word_in_pattern_count <- neg_word_in_pattern_count <- numeric()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  target_word <- word_list[which(word_list[-length(word_list)] %in% negator)+1]
  target_word <- target_word[!target_word %in% DegreeAdv]

  new_word_list <- append(new_word_list, target_word)
  pos_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score > 0])
  neg_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score < 0])
}

# NP_pattern_24 (SentiW+的一部+電影/片子) [intensify positive]
new_word_list <- list()
pos_word_in_pattern_count <- neg_word_in_pattern_count <- numeric()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  index1 <- which(word_list[-1] == '的')
  index2 <- which(word_list[-1] == '一部')
  index3 <- which(word_list[-1] %in% c('電影','片子'))
  target_word <- word_list[index1[sapply(index1, function(x) (((x+1) %in% index2) & ((x+2) %in% index3))) %>% unlist]]

  new_word_list <- append(new_word_list, target_word)
  pos_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score > 0])
  neg_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score < 0])
}

# DepClause_pattern_25 (W (as an independent clause)) [intensify positive.intensify negative]
new_word_list <- list()
pos_word_in_pattern_count <- neg_word_in_pattern_count <- numeric()
for (i in 1:length(sentence_seg)) {
  word_list <- sentence_seg[[i]]
  target_word <- word_list

  new_word_list <- append(new_word_list, target_word)
  pos_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score > 0])
  neg_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score < 0])
}

# DepClause_pattern_26 (讓人/令人/使人+SentiW) [intensify positive]
new_word_list <- list()
pos_word_in_pattern_count <- neg_word_in_pattern_count <- numeric()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  target_word <- word_list[which(word_list[-length(word_list)] %in% c('讓人','令人','使人')) +1]
  target_word <- target_word[!target_word %in% c(DegreeAdv,'感覺','感到','覺得')]

  new_word_list <- append(new_word_list, target_word)
  pos_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score > 0])
  neg_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score < 0])
}

# DepClause_pattern_27 (SentiW1+又+SentiW2) slot 2 [intensify positive]
new_word_list <- list()
pos_word_in_pattern_count <- neg_word_in_pattern_count <- numeric()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  index1 <- which(word_list[-length(word_list)] %in% ANTUSD.list)
  index3 <- which(word_list[-length(word_list)] == '又')
  target_word <- word_list[index1[sapply(index1, function(x) (((x+1) %in% index3))) %>% unlist] + 2]

  new_word_list <- append(new_word_list, target_word)
  pos_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score > 0])
  neg_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score < 0])
}

# DepClause_pattern_28 (SentiW+死了) [intensify negative]
new_word_list <- list()
pos_word_in_pattern_count <- neg_word_in_pattern_count <- numeric()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  index1 <- which(word_list[-1] == '死')
  index2 <- which(word_list[-1] %in% c('了','ㄌ'))
  target_word <- word_list[index1[sapply(index1, function(x) (((x+1) %in% index2))) %>% unlist]]

  new_word_list <- append(new_word_list, target_word)
  pos_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score > 0])
  neg_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score < 0])
}

# DepClause_pattern_31 (SentiW+也+沒有) [mitigate positive]
new_word_list <- list()
pos_word_in_pattern_count <- neg_word_in_pattern_count <- numeric()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  index1 <- which(word_list[-1] == '也')
  index2 <- which(word_list[-1] == '沒有')
  target_word <- word_list[index1[sapply(index1, function(x) (((x+1) %in% index2))) %>% unlist]]

  new_word_list <- append(new_word_list, target_word)
  pos_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score > 0])
  neg_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score < 0])
}

# DepClause_pattern_35 (讓人/令人/使人+覺得+SentiW) [mitigate negative]
new_word_list <- list()
pos_word_in_pattern_count <- neg_word_in_pattern_count <- numeric()
for (i in 1:length(sentiwords)) {
  word_list <- sentiwords[[i]]
  index1 <- which(word_list[-length(word_list)] %in% c('讓人','令人','使人'))
  index3 <- which(word_list[-length(word_list)] == '覺得')
  target_word <- word_list[index1[sapply(index1, function(x) ((x+1) %in% index3)) %>% unlist] + 2]
  target_word <- target_word[!target_word %in% c(DegreeAdv,'覺得')]

  new_word_list <- append(new_word_list, target_word)
  pos_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score > 0])
  neg_word_in_pattern_count[i] <- sum(target_word %in% ANTUSD$word[ANTUSD$score < 0])
}

