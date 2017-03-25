#load packages
library(httr)
library(jsonlite)

#project settings
dbURL <- "https://firedata-b0e54.firebaseio.com"
path <- "/parent/children4"

#adding content
#use: addToDB("a" = mtcars)
addToDB <- function(...){
  PUT(paste0(dbURL,path,".json"), body = toJSON(list(...)))
}

#retrieving
#use: fromDB("a")
fromDB <- function(...){
  entries <- list(...)
  dataJSON = GET(paste0(dbURL,path,".json"), content_type_json())
  dataFrame = (fromJSON(content(dataJSON,"text")))
  for(i in 1:length(entries)){
    list2env(dataFrame[entries[[i]]], envir = .GlobalEnv)
  }
}
