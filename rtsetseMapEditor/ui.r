#rtsetseMapEditor/ui.r
#andy south 12/08/2014

library(shiny)
library(rmarkdown)
library(shinyTable) #for editable tables

shinyUI(pageWithSidebar(
  
  headerPanel("rtsetse map editor"),
  
  sidebarPanel(
    
    helpText("A demonstration of how maps could be loaded and edited by rtsetse, ",
             " currently it starts with an example map and accepts tab or space-delimited text files."),
    
    fileInput('layer', 'Choose a map text file', multiple=FALSE), #, accept='.asc')
    
    #actionButton('loadExDataButton', 'Load example data'),
    #br(),
    br(),
    downloadButton('saveFile', 'save modified file')
  ),
  
  mainPanel(

    
    tabsetPanel(
      
      tabPanel("map", plotOutput("plotTxtChar")),
      #tabPanel("plot of a gridascii", plotOutput("plotAsc")),
      tabPanel("editable", htable("tbl", colHeaders="provided")),
      tabPanel("test data view", tableOutput("tableTxtChar")),  
      #tabPanel("test button", textOutput("testButton")),      
      tabPanel("About", includeMarkdown("about.md"))
      
    ) # end tabsetPanel         
  ) # end mainPanel
))