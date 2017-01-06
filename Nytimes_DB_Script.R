library(rtimes)
library(dplyr)
library(data.table)
library(readr)

 ## Creating yearly datasets
 for (i in 1991:2016)
  {
   print("start")
   setwd(paste0("C:/Users/Jay/Desktop/Prof.Mike/ArticleDB/",i))
   files = list.files(pattern="*.csv")
   tbl = lapply(files, read.csv) %>% bind_rows() 
   write.csv(tbl,file=paste0(i,'.csv'), row.names=FALSE)
 }
 
 ## obtaining unique rows for yearly datasets
 for (i in 1991:2016)
  {
   print("start")
   setwd(paste0("C:/Users/Jay/Desktop/Prof.Mike/ArticleDB/",i))
   files = paste0(i,".csv")
   tbl = read_csv(files) 
   data_tbl=tbl[apply(tbl[,-1], 1, function(y) !all(is.na(y))),]
   data_tbl=unique(data_tbl)
   write.csv(data_tbl,file=paste0(i,'clean.csv'), row.names=FALSE)
   print(i)
 }

# Binding all cleanded datasets
 setwd(paste0("C:/Users/Jay/Desktop/Prof.Mike/ArticleDB/",1991))
 files = list.files(pattern="*clean.csv")
 tbl = read_csv(files)
 full_data=as.data.frame(tbl)
  for (i in 1992:2016)
   {
    print("start reading")
    setwd(paste0("C:/Users/Jay/Desktop/Prof.Mike/ArticleDB/",i))
    files_new = list.files(pattern="*clean.csv")
    tbl_new = read_csv(files_new) %>% as.data.frame()
    full_data=rbind(full_data,tbl_new) %>% as.data.frame()
    }
 dim(full_data)
 setwd("C:/Users/Jay/Desktop/Prof.Mike/ArticleDB")
 write.csv(full_data,"full_data.csv",row.names=FALSE)

Full_data=fread("C:/Users/Jay/Desktop/Prof.Mike/ArticleDB/full_data.csv")


