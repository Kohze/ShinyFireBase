#load packages
library(httr)
library(jsonlite)

#project settings
dbURL <- "https://firedata-b0e54.firebaseio.com"
path <- paste0("/shinyTest/", as.numeric(Sys.time())*100000)

#adding content
#use: addToDB("a" = mtcars)
addToDB <- function(...){
  PUT(paste0(dbURL,path,".json"), body = toJSON(base64_enc(serialize(list(...), NULL))))
}


#retrieving
#use: fromDB("a")
fromDB <- function(..., path, url){
  entries <- list(...)
  dataJSON = GET(paste0(url,path,".json"), content_type_json())
  dataFrame = unserialize(base64_dec(unlist(content(dataJSON))))
  for (i in 1:length(entries)) {
    list2env(dataFrame[entries[[i]]], envir = .GlobalEnv)
  }
}
