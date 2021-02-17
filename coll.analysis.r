# Coll.analysis V 3.2a
# Collostructional analysis: Computing the degree of association between words and words/constructions
# Coyright (C) 2007 Stefan Th. Gries (Latest changes in this version: 03/28/2010)

collostructions <-function() { # FUNCTION FOR COLLEXEME ANALYSIS
   cat("\nC o l l o c a t i o n a l / c o l l e x e m e    a n a l y s i s   . . .\n")

   # introduction
   cat("\nThis kind of analysis computes the degree of attraction and repulsion between\none word or construction and many other words using a user-defined statistic;\nall these statistics are based on 2-by-2 tables, and attraction and repulsion\nare indicated in a separate column in the output.\n")

   # input of parameters
   cat("\nWhat is the word W / the name of the construction C you investigate (without spaces)?\n")
   construction.name<-scan(nmax=1, what="char", quiet=T)
   if (length(construction.name)==0) construction.name<-"some_W_or_C"

   cat("\nEnter the size of the corpus (in constructions or words) without digit grouping symbols!\n")
   corpus<-scan(nmax=1, quiet=T)
   while (corpus<=0) { cat("\nWith a value of 0 or smaller, no such tests can be computed - enter the correct corpus size!\n"); corpus<-scan(nmax=1, quiet=T) }

   cat("\nEnter the frequency of", construction.name, "in the corpus you investigate (without digit grouping symbols)\n")
   construction.freq<-scan(nmax=1, quiet=T)
   while (construction.freq<=0) { cat("\nWith a value of 0 or smaller, no such tests can be computed - enter the correct word/construction frequency!\n"); construction.freq<-scan(nmax=1, quiet=T) }

   which.index<-menu(choice=c("-log10 (Fisher-Yates exact, one-tailed) (= default)", "log-likelihood", "Mutual Information", "Chi-square", "log10 of odds ratio (adds 0.5 to each cell)"), title="\nWhich index of association strength do you want to compute?")

   which.sort<-menu(choice=c("alphabetically", "co-occurrence frequency", "faith", "collostruction strength"), title="\nHow do you want to sort the output?")

   cat("\nEnter the number of decimals you'd like to see in the results (and '99', when you want the default output)!\n")
   which.accuracy<-scan(nmax=1, quiet=T); cat("\n")
   while (which.accuracy<=0) { cat("\nWith a value of 0 or smaller, the output might not be very meaningful - enter the correct number of decimals!\n"); which.accuracy<-scan(nmax=1, quiet=T) }

   cat("\nTo compute the collocational strength of one word W to many other words <A, B, ..., ?>,\nyou need a text file with the following kind of table (with column names!):\n\nWord\tFreq_A-?_in_Corpus\tFreq_A-?_&_W\nA\t...\t\t\t...\nB\t...\t\t\t...\n...\t...\t\t\t...\n\nTo compute the collostructional strength of one construction C to the words <A, B, ..., ?>,\nyou need a text file with the following kind of table (with column names!):\n\nWord\tFreq_A-?_in_Corpus\tFreq_A-?_in_C\nA\t...\t\t\t...\nB\t...\t\t\t...\n...\t...\t\t\t...\n\n")
   cat("Your table must not have decimal points/separators and ideally has no spaces (for the latter, use '_' instead)!\nAlso, don't forget that R's treatment of alphanumeric characters is case-sensitive!\n\nChoose this text file with the raw data!\t"); pause()
   data<-read.table(file.choose(), header=T, sep=",", quote="", comment.char="",encoding="UTF-8"); cases<-length(data[,1]); cat("\n")

   which.output<-menu(choice=c("text file (= default)", "terminal"), title="Where do you want the output ('text file' will append to already existing file with the same name)?")

   # computation

   words<-data[,1]; word.freq<-data[,2]; obs.freq<-data[,3]; exp.freq<-faith<-delta.p.constr.to.word<-delta.p.word.to.constr<-relation<-coll.strength<-c(rep(0, cases))

   for (i in 1:cases) {
      obs.freq.a<-obs.freq[i]
      obs.freq.b<-construction.freq-obs.freq.a
      obs.freq.c<-word.freq[i]-obs.freq.a
      obs.freq.d<-corpus-(obs.freq.a+obs.freq.b+obs.freq.c)

      exp.freq.a<-construction.freq*word.freq[i]/corpus; exp.freq[i]<-round(exp.freq.a, which.accuracy)
      exp.freq.b<-construction.freq*(corpus-word.freq[i])/corpus
      exp.freq.c<-(corpus-construction.freq)*word.freq[i]/corpus
      exp.freq.d<-(corpus-construction.freq)*(corpus-word.freq[i])/corpus

      faith[i]<-round((obs.freq.a/word.freq[i]), which.accuracy)

      delta.p.constr.to.word[i]<-round((obs.freq.a/(obs.freq.a+obs.freq.b))-(obs.freq.c/(obs.freq.c+obs.freq.d)), which.accuracy)
      delta.p.word.to.constr[i]<-round((obs.freq.a/(obs.freq.a+obs.freq.c))-(obs.freq.b/(obs.freq.b+obs.freq.d)), which.accuracy)

      coll.strength[i]<-round(switch(which.index,
         fye(obs.freq.a, exp.freq.a, construction.freq, corpus, word.freq[i]),
         llr(obs.freq.a, obs.freq.b, obs.freq.c, obs.freq.d, exp.freq.a, exp.freq.b, exp.freq.c, exp.freq.d),
         log((obs.freq.a/exp.freq.a), 2),
         (corpus*(((obs.freq.a)*((corpus-construction.freq-word.freq[i]+obs.freq.a)))-((construction.freq-obs.freq.a)*(word.freq[i]-obs.freq.a)))^2)/(construction.freq*word.freq[i]*((construction.freq-obs.freq.a)+((corpus-construction.freq-word.freq[i]+obs.freq.a)))*((word.freq[i]-obs.freq.a)+((corpus-construction.freq-word.freq[i]+obs.freq.a)))),
         log(((obs.freq.a+0.5)/(obs.freq.b+0.5))/((obs.freq.c+0.5)/(obs.freq.d+0.5)), 10)), which.accuracy)
      if (obs.freq.a>exp.freq.a) {
         relation[i]<-"attraction"
      } else if (obs.freq.a<exp.freq.a) {
         relation[i]<-"repulsion"
      } else {
         relation[i]<-"chance"
      }
   }

   output.table<-data.frame(words, word.freq, obs.freq, exp.freq, relation, faith, delta.p.constr.to.word, delta.p.word.to.constr, coll.strength)
   sort.index<-switch(which.sort, order(words), order(-obs.freq, words), order(-faith, words), order(relation, -coll.strength))
   output.table<-output.table[sort.index,]

   # hypothetical repulsion strength of unattested verbs
   corp.size<-as.integer(log(corpus, 10))
   absents.words<-absents.obs.freqs<-absents.exp.freqs<-absents.delta.p.constr.to.word<-absents.delta.p.word.to.constr<-absents.collstrengths<-c(rep(0, corp.size))
   for (i in 1:corp.size) {
      absents.words[i]<-letters[i]
      absents.obs.freqs[i]<-10^i

      obs.freq.a<-0
      obs.freq.b<-construction.freq
      obs.freq.c<-10^i
      obs.freq.d<-corpus-(construction.freq+10^i)

      exp.freq.a<-construction.freq*10^i/corpus; absents.exp.freqs[i]<-round(exp.freq.a, which.accuracy)
      exp.freq.b<-construction.freq*(corpus-10^i)/corpus
      exp.freq.c<-(corpus-construction.freq)*10^i/corpus
      exp.freq.d<-(corpus-construction.freq)*(corpus-10^i)/corpus

      absents.delta.p.constr.to.word[i]<-round((obs.freq.a/(obs.freq.a+obs.freq.b))-(obs.freq.c/(obs.freq.c+obs.freq.d)), which.accuracy)
      absents.delta.p.word.to.constr[i]<-round((obs.freq.a/(obs.freq.a+obs.freq.c))-(obs.freq.b/(obs.freq.b+obs.freq.d)), which.accuracy)

      absents.collstrengths[i]<-round(switch(which.index,
         fye(obs.freq.a, exp.freq.a, construction.freq, corpus, word.freq[i]),
         llr(obs.freq.a, obs.freq.b, obs.freq.c, obs.freq.d, exp.freq.a, exp.freq.b, exp.freq.c, exp.freq.d),
         log((obs.freq.a/exp.freq.a), 2),
         (corpus*(((obs.freq.a)*((corpus-construction.freq-word.freq[i]+obs.freq.a)))-((construction.freq-obs.freq.a)*(word.freq[i]-obs.freq.a)))^2)/(construction.freq*word.freq[i]*((construction.freq-obs.freq.a)+((corpus-construction.freq-word.freq[i]+obs.freq.a)))*((word.freq[i]-obs.freq.a)+((corpus-construction.freq-word.freq[i]+obs.freq.a)))),
         log(((obs.freq.a+0.5)/(obs.freq.b+0.5))/((obs.freq.c+0.5)/(obs.freq.d+0.5)), 10)), which.accuracy)
   }

   output.table.hyp<-data.frame(absents.words, absents.obs.freqs, absents.exp.freqs, "repulsion", absents.delta.p.constr.to.word, absents.delta.p.word.to.constr, absents.collstrengths)
   colnames(output.table.hyp)<-c("absents.words", "absents.obs.freqs", "absents.exp.freqs", "relation", "absents.delta.p.constr.to.word", "absents.delta.p.word.to.constr", "absents.collstrengths")
   cat("\a") # progress beep

   # output
   which.index<-switch(which.index, "-log10 (Fisher-Yates exact, one-tailed)", "log-likelihood", "Mutual Information", "Chi-square", "log10 of odds ratio (adds 0.5 to each cell)")
   if (which.output==1) {
      cat("\nWhich text file do you want to store the result in?\n(Note: if you choose a file that already exists, the current output will be appended to this file.)\t"); pause()
      output.file<-file.choose(); output<-file(output.file, open="at")
      cat("|---------------------------------------------------------------------|\n| This output is provided without any warranty on an as-is basis by   |\n| Stefan Th. Gries <http://www.linguistics.ucsb.edu/faculty/stgries/> |\n| Please cite the program as mentioned in <readme.txt>. Thanks a lot! |\n|---------------------------------------------------------------------|\n\n", date(), "\n\nword.freq: frequency of the word in the corpus\nobs.freq: observed frequency of the word with/in ", construction.name, file=output)
      cat("\nexp.freq: expected frequency of the word with/in ", construction.name, "\nfaith: percentage of how many instances of the word occur with/in ", construction.name, "\nrelation: relation of the word to ", construction.name, "\ndelta.p.constr.to.word: delta p: how much does the word/construction help guess the word?\ndelta.p.constr.to.word: delta p: how much does the construction help guess the word/construction?\ncoll.strength: index of collocational/collostructional strength: ", which.index, ", the higher, the stronger\n\n", sep="", file=output)
      write.table(output.table, file=output, quote=F, row.names=F, sep="\t", eol="\n")
      cat("\nIn order to determine the degree of repulsion of verbs that are not attested with/in", construction.name, ",\nthe following table gives the collocational/collostructional strength for all verb frequencies\nin orders of magnitude the corpus size allows for.\n\n\n", sep="", file=output)
      write.table(output.table.hyp, file=output, quote=F, row.names=F, sep="\t", eol="\n")
      cat("\n\nIf your collostruction strength is based on p-values, it can be interpreted as follows:\nColl.strength>3 => p<0.001; coll.strength>2 => p<0.01; coll.strength>1.30103 => p<0.05.\nI'd be happy if you provided me with feedback and acknowledged the use of Coll.analysis 3.2a.\n", file=output)
      close(output)
   } else {
      cat("|---------------------------------------------------------------------|\n| This output is provided without any warranty on an as-is basis by   |\n| Stefan Th. Gries <http://www.linguistics.ucsb.edu/faculty/stgries/> |\n| Please cite the program as mentioned in <readme.txt>. Thanks a lot! |\n|---------------------------------------------------------------------|\n\n", date(), "\n\nword.freq: frequency of the word in the corpus\nobs.freq: observed frequency of the word with/in ", construction.name)
      cat("\nexp.freq: expected frequency of the word with/in ", construction.name, "\nfaith: percentage of how many instances of the word occur with/in ", construction.name, "\nrelation: relation of the word to ", construction.name, "\ncoll.strength: index of collocational/collostructional strength: ", which.index, ", the higher, the stronger\n\n", sep="")
      print(output.table)
      cat("\nIn order to determine the degree of repulsion of words that are not attested with/in ", construction.name, ",\nthe following table gives the collocational/collostructional strength for all verb frequencies\nin orders of magnitude the corpus size allows for.\n\n", sep="")
      print(output.table.hyp)
      cat("\nIf your collostruction strength is based on p-values, it can be interpreted as follows:\nColl.strength>3 => p<0.001; coll.strength>2 => p<0.01; coll.strength>1.30103 => p<0.05.\nI'd be happy if you provided me with feedback and acknowledged the use of Coll.analysis 3.2a.\n")
   }
} # END OF FUNCTION FOR COLLOSTRUCTIONAL ANALYSIS



pause<-function() {
   cat("Press <Enter> to continue ... ")
   readline()
   invisible()
}

fye<-function(oa, ea, cf, cs, wf) {
   if(oa>ea) {
      return(-log(sum(dhyper(oa:cf, cf, (cs-cf), wf)), 10))
   } else {
      return(-log(sum(dhyper(0:oa, cf, (cs-cf), wf)), 10))
   }
}

llr<-function(oa, ob, oc, od, ea, eb, ec, ed) {
   s1<-ifelse(log((oa/ea), base=exp(1))*oa=="NaN", 0, log((oa/ea), base=exp(1))*oa)
   s2<-ifelse(log((ob/eb), base=exp(1))*ob=="NaN", 0, log((ob/eb), base=exp(1))*ob)
   s3<-ifelse(log((oc/ec), base=exp(1))*oc=="NaN", 0, log((oc/ec), base=exp(1))*oc)
   s4<-ifelse(log((od/ed), base=exp(1))*od=="NaN", 0, log((od/ed), base=exp(1))*od)
   return(2*sum(s1, s2, s3, s4))
}

collostructions()
