  library(rtimes)
  library(dplyr)
  #Sys.setenv(NYTIMES_AS_KEY ="4e7c325c6f1d44849eff1dbe583e265c")
  Sys.setenv(NYTIMES_AS_KEY ="f78e906571dc446681f3e78aa6eda15f")
  setwd("C:/Users/Jay/Desktop/Prof.Mike/ArticleDB/2016")
  Date="2016/12/20"
  Date <- as.Date(Date, '%Y/%m/%d')
  today=gsub("[-/]","",Date)
  date=c(rep(NA,10))
  web_url=c(rep(NA,10))
  snippet=rep(NA,10)
  lead_paragraph=rep(NA,10)                             
  abstract=rep(NA,10)
  headline=rep(NA,10)
  document_type=rep(NA,10)
  word_count=rep(NA,10)
  section_name=rep(NA,10)
  type_of_material=rep(NA,10)
  articles_dataset=as.data.frame(cbind(date,web_url,snippet,lead_paragraph,abstract,headline,document_type,word_count,section_name,type_of_material))
  articles_dataset=articles_dataset[0,]
  full_dataset=as.data.frame(cbind(date,web_url,snippet,lead_paragraph,abstract,headline,document_type,word_count,section_name,type_of_material))
  full_dataset=articles_dataset[0,]
  #Date_mat=rep(0,20)
  for (k in 1:300)
  {
    today=gsub("[-/]","",Date)
    for (j in 0:20)
    {
      Sys.sleep(1)
      articles=as_search(q="immigration", begin_date =today , end_date = today,page = j,
                         fl="web_url,snippet,lead_paragraph,abstract,headline,source,document_type,word_count",
                         facet_field="section_name,type_of_material",hl=TRUE)
      for (i in 1:10)
      {
        try(
          {
            date[i]=today
            web_url[i]=ifelse(is.null(articles$data$docs[[i]]$web_url),"NA",articles$data$docs[[i]]$web_url)
            snippet[i]=ifelse(is.null(articles$data$docs[[i]]$snippet),"NA",articles$data$docs[[i]]$snippet)
            lead_paragraph[i]=ifelse(is.null(articles$data$docs[[i]]$lead_paragraph),"NA",articles$data$docs[[i]]$lead_paragraph)
            abstract[i]=ifelse(is.null(articles$data$docs[[i]]$abstract),"NA",articles$data$docs[[i]]$abstract)
            headline[i]=ifelse(is.null(articles$data$docs[[i]]$headline$main),"NA",articles$data$docs[[i]]$headline$main)
            document_type[i]=ifelse(is.null(articles$data$docs[[i]]$document_type),"NA",articles$data$docs[[i]]$document_type)
            word_count[i]=ifelse(is.null(articles$data$docs[[i]]$word_count),"NA",articles$data$docs[[i]]$word_count)
            section_name[i]=ifelse(is.null(articles$data$facets$section_name$terms[[i]]$term),"NA",articles$data$facets$section_name$terms[[i]]$term)
            type_of_material[i]=ifelse(is.null(articles$data$facets$type_of_material$terms[[i]]$term),"NA",articles$data$facets$type_of_material$terms[[i]]$term)
          },silent = TRUE)
           dataset=as.data.frame(cbind(date,web_url,snippet,lead_paragraph,abstract,headline,document_type,word_count,section_name,type_of_material))
      }
      articles_dataset=rbind(articles_dataset,dataset) 01
    }
   Date=Date+1 
   #full_dataset=rbind(full_dataset,articles_dataset)
   articles_dataset=distinct(articles_dataset)
   write.csv(articles_dataset,file=paste0(today,'data.csv'), row.names=FALSE)
   articles_dataset=articles_dataset[0,]
  }
