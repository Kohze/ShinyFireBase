library(shinyjs)
library(httr)
library(jsonlite)
library(shiny)

shinyDB <- function(){
  shiny::runApp()
}

shinyServer(function(input, output, session) {
  #to make sure the DBpath number is not shortened to e+014
  options(scipen = 999)
  
  #project settings
  dbURL <- "https://firedata-b0e54.firebaseio.com"
  project <- "/shinyTest"

  #path generation and sending variables to firebase
   observe({
   if (!is.null(parseQueryString(session$clientData$url_search)[['DBpath']])) {
      dbURL <- "https://firedata-b0e54.firebaseio.com"
      path <- paste0("/shinyTest/", parseQueryString(session$clientData$url_search)[['DBpath']])
      fromDB("dataInput", "path" = path, "url" = dbURL)
    } else {
      ### Change your input here (mtcars, USArrests etc.) - will be exposed more later.   
      dataInput <<- USArrests
    }
   })
  
   #retrieving variables from firebase
  fromDB <- function(..., path, url){
    entries <- list(...)
    dataJSON = GET(paste0(url,path,".json"), content_type_json())
    dataFrame = unserialize(base64_dec(unlist(content(dataJSON))))
    for (i in 1:length(entries)) {
      list2env(dataFrame[entries[[i]]], envir = .GlobalEnv)
    }
  }
  
  #adding content
  addToDB <- function(..., path){
    PUT(paste0(dbURL,path,".json"), body = toJSON(base64_enc(serialize(list(...), NULL))))
  }
  
  #ShinyJS activated button
  observeEvent(input$button, {
    path <- as.numeric(Sys.time())*100000
    concPath <- paste0("/shinyTest/", path)
    addToDB("dataInput" = dataInput, "path" = concPath)
    #shinyJS syntax to modify <p> </p> element content
    html("element", paste0("https://frapbotbeta.shinyapps.io/shinyfirebase/?DBpath=", toString(path)))
  })
  
  output$distPlot <- renderPlot({
    x    <- dataInput[, 1]
    y    <- dataInput[, 2]
    plot(x,y)
  })
})
