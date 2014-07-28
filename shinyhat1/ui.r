#shinyhat1/ui.r
#andy south 22/03/2014

#to run type this in R console
#library(shiny)
#setwd('C:\\Dropbox\\Ian and Andy\\andy\\')
#runApp('shinyhat1')

library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("shinyhat1"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    sliderInput("size", 
                "Grid size:", 
                min = 2,
                max = 50, 
                value = 5),

    sliderInput("days", 
                "Days:", 
                min = 1,
                max = 20, 
                value = 2),
    
    submitButton("Run Model")
  ),
  
  # mainPanel
  mainPanel(
    
    tabsetPanel(

      tabPanel("Final Fly Map", plotOutput("gridPlotHat1")),
      tabPanel("Daily Fly Maps", plotOutput("plotGridMultiPop")),
      tabPanel("Daily Infection Maps", plotOutput("plotGridMultiInf")),
      tabPanel("Daily Fly", plotOutput("plotDailyPop"))
      
    ) # end tabsetPanel         
  ) # end mainPanel
))