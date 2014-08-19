#rtsetseMapEditor/ui.r
#andy south 12/08/2014

library(shiny)
library(rmarkdown)
library(shinyTable) #for editable tables

shinyUI(pageWithSidebar(
  
  headerPanel("rtsetse map editor"),
  
  sidebarPanel(
    
    helpText("A demonstration of how maps could be loaded and edited by rtsetse, ",
             " currently it accepts tab or space-delimited text files."),
    
    fileInput('layer', 'Choose a map text file', multiple=FALSE), #, accept='.asc')
    
    downloadButton('saveFile', 'save modified file')
  ),
  
  mainPanel(

    
    tabsetPanel(
      
      tabPanel("map", plotOutput("plotTxtChar")),
      #tabPanel("plot of a gridascii", plotOutput("plotAsc")),
      tabPanel("editable", htable("tbl", colHeaders="provided")),
      tabPanel("test data view", tableOutput("tableTxtChar")),  
      tabPanel("About", includeMarkdown("about.md"))
      
    ) # end tabsetPanel         
  ) # end mainPanel
))