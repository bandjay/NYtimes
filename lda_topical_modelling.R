require("ggplot2")
require("grid")
require("dplyr")
require(reshape)
#library(ScottKnott)
require(lda)
require(tm)
setwd("C:/Users/Jay/Desktop/Prof.Mike/ArticleDB/")
full_data<- read.csv('full_data.csv',sep=",",stringsAsFactors = FALSE)
dim(full_data)
full_data=unique(full_data)
dim(full_data)
names(full_data)
full_data=full_data[sample(nrow(full_data),size=1000,replace=FALSE),]
dim(full_data)

word_corpus <- function(documents){
  documents = gsub("[^a-zA-Z0-9 ]", "", documents)
  documents= gsub("[[:digit:]]", "",documents)
  documents= gsub("http\\w+", "", documents)
  documents = gsub("\n", "", documents)  
  wordcorpus <- Corpus(VectorSource(documents)) %>% 
    tm_map(content_transformer(tolower)) %>%
    tm_map(stemDocument,language = "english") %>% 
    tm_map(removePunctuation) %>%
    tm_map(stripWhitespace) %>% 
    tm_map(removeWords,stopwords("english")) %>%
    tm_map(removeWords,
           c("nytimes","http","website","WWW")) %>%
    DocumentTermMatrix(control = list(weighting = function(x) weightTfIdf(x, normalize = FALSE))) %>%
    removeSparseTerms(0.9999) %>%
    as.matrix() %>%
    as.data.frame()
  return(wordcorpus)
}

doc_tfidf=word_corpus(full_data$lead_paragraph)
summary(doc_tfidf)

### Faster Way of doing LDA 

corpusLDA <- lexicalize(doc_tfidf)
require(lda)

ldaModel=lda.collapsed.gibbs.sampler(corpusLDA$documents,K=10,vocab=corpusLDA$vocab,burnin=9999,num.iterations=1000,alpha=1,eta=0.1)
top.words <- top.topic.words(ldaModel$topics, 5, by.score=TRUE)
print(top.words) 
