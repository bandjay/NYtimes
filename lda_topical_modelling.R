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
full_data=full_data[sample(nrow(full_data),size=10000,replace=FALSE),]
dim(full_data)

# word_corpus <- function(documents){
#   documents = gsub("[^a-zA-Z0-9 ]", "", documents)
#   documents= gsub("[[:digit:]]", "",documents)
#   documents= gsub("http\\w+", "", documents)
#   documents = gsub("\n", "", documents)  
#   wordcorpus <- Corpus(VectorSource(documents)) %>% 
#     tm_map(content_transformer(tolower)) %>%
#     tm_map(stemDocument,language = "english") %>% 
#     tm_map(removePunctuation) %>%
#     tm_map(stripWhitespace) %>% 
#     tm_map(removeWords,stopwords("english")) %>%
#     tm_map(removeWords,
#            c("nytimes","http","website","WWW")) %>%
#     DocumentTermMatrix() %>%
#     #DocumentTermMatrix(control = list(weighting = function(x) weightTfIdf(x, normalize = FALSE))) %>%
#     removeSparseTerms(0.9999)
#     as.matrix() %>%
#     as.data.frame()
#   return(wordcorpus)
# }
# 
# doc_tfidf=word_corpus(full_data$lead_paragraph)
# summary(doc_tfidf)
# 
# ### Faster Way of doing LDA 
# 
# corpusLDA <- lexicalize(doc_tfidf)
# require(lda)
# 
# ldaModel=lda.collapsed.gibbs.sampler(doc_tfidf,K=3,vocab=corpusLDA$vocab,burnin=99,num.iterations=100,alpha=1,eta=0.2)
# top.words <- top.topic.words(ldaModel$topics, 5, by.score=TRUE)
# print(top.words) 
# 


####################
corpus <- Corpus(VectorSource(full_data$lead_paragraph))%>% 
  tm_map(content_transformer(tolower)) %>%
  tm_map(removeWords,c("nytimes","http","website","WWW","york","new","city","will","now",
                       "can","say","take","hours","day","monday","tuesday","wednesday",
                       "thursday","friday","saturday","sunday","times","time","may","set",
                       "see","get","still","just","back","begin","here","far","way","next",
                       "state","street","county","much"))
ny_dtm <- DocumentTermMatrix(corpus,control = list(stemming = FALSE, stopwords = TRUE, minWordLength = 3,
                                 removeNumbers = TRUE, removePunctuation = TRUE))

library("slam")
summary(col_sums(ny_dtm))
term_tfidf <-tapply(ny_dtm$v/row_sums(ny_dtm)[ny_dtm$i], ny_dtm$j, mean) * log2(nDocs(ny_dtm)/col_sums(ny_dtm > 0))
summary(term_tfidf)
ny_dtm <- ny_dtm[,term_tfidf >= 0.1]
ny_dtm <- ny_dtm[row_sums(ny_dtm) > 0,]
summary(col_sums(ny_dtm))
dim(ny_dtm)
require(topicmodels)
lda_topic=LDA(ny_dtm,4,method="Gibbs")
#Topic <- topics(lda_topic, 1)
#Topic
Terms <- terms(lda_topic, 25)
Terms

