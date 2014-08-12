#rtsetseMapEditor/ui.r
#andy south 12/08/2014

library(shiny)
library(rmarkdown)

shinyUI(pageWithSidebar(
  
  headerPanel("rtsetse map editor"),
  
  sidebarPanel(
    fileInput('layer', 'Choose Layer', multiple=FALSE) #, accept='.asc')
  ),
  
  mainPanel(

    
    tabsetPanel(
      
      tabPanel("map", plotOutput("plotTxtChar")),
      #tabPanel("plot of a gridascii", plotOutput("plotAsc")),
      tabPanel("data table", tableOutput("tableTxtChar")),      
      tabPanel("About", includeMarkdown("about.md"))
      
    ) # end tabsetPanel         
  ) # end mainPanel
))