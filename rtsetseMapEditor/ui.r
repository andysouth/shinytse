library(shiny)
library(raster)

shinyUI(pageWithSidebar(
  
  headerPanel("rtsetse map editor"),
  
  sidebarPanel(
    fileInput('layer', 'Choose Layer', multiple=FALSE) #, accept='.asc')
  ),
  
  mainPanel(
    #plotOutput("plotAsc")
    plotOutput("plotTxtChar")
  )
))