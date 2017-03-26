library(shiny)
library(shinyjs)

shinyUI(fluidPage(
  useShinyjs(),

  # Application title
  titlePanel("Firebase Session Upload"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      actionButton("button", "create link"),
      br(),
      br(),
      br(),
      p(id = "element", "")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))
