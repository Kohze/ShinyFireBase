library(shinyjs)
library(httr)
library(jsonlite)
library(shiny)

dataInput = USArrests

shinyDB <- function(){
  shiny::runApp()
}

shinyServer(function(input, output, session) {
  #project settings
  dbURL <- "https://firedata-b0e54.firebaseio.com"
  project <- "/shinyTest"

  #path generation
   observe({
   if (!is.null(parseQueryString(session$clientData$url_search)[['DBpath']])) {
      dbURL <- "https://firedata-b0e54.firebaseio.com"
      path <- paste0("/shinyTest/", parseQueryString(session$clientData$url_search)[['DBpath']])
      fromDB("dataInput", "path" = path, "url" = dbURL)
      paste0(names(dataInput))
      print("works")
    } else {
    print("not found")
    }
   })
  
  fromDB <- function(..., path, url){
    entries <- list(...)
    dataJSON <- GET(paste0(url,path,".json"), content_type_json())
    dataFrame <- (fromJSON(content(dataJSON,"text")))
    for(i in 1:length(entries)){
      list2env(dataFrame[entries[[i]]], envir = environment())
    }
  }
  
  #adding content
  #use: addToDB("a" = mtcars)
  addToDB <- function(..., path){
    print(paste0(path))
    PUT(paste0(dbURL,"/",paste0(path),".json"), body = toJSON(list(...)))
  }
  
  observeEvent(input$button, {
    path <- paste0("/shinyTest/", as.numeric(Sys.time())*100000)
    addToDB("dataInput" = dataInput, "path" = path)
    html("element", paste0("Link: ", path))
  })
  
  output$distPlot <- renderPlot({
    x    <- dataInput[, 1]
    y    <- dataInput[, 2]
    plot(x,y)
  })
  
  output$queryText <- renderText({
    if (!is.null(parseQueryString(session$clientData$url_search)[['DBpath']])) {
      query <- parseQueryString(session$clientData$url_search)[['DBpath']]
      print(as.numeric(query))
    } else {
      "no query appended"
    }
  })
  
  output$link <- renderText({
    
  })

})
