#shinyddtestpop/ui.r
#andy south 19/06/2014

#to look at aspatial density dependence

#to run type this in R console
#setwd('C:\\Dropbox\\Ian and Andy\\andy\\shiny\\')
#library(shiny)
#runApp('shinyddtestpop')

library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("shinyddtestpop - testing density dependence based on pop in previous day"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(

    submitButton("Run Model"),
    
    sliderInput("days", 
                "1 Days:", 
                min = 1,
                max = 1000, 
                value = 100),

    sliderInput("pMortF", 
                "2 Mortality per day:", 
                min = 0,
                max = 0.2,
                step=0.01,
                value = 0.03),

    sliderInput("pBirth", 
                "3 Births per day:", 
                min = 0,
                max = 0.2,
                step=0.01,
                value = 0.03),    
    
    sliderInput("iCarryCap", 
                "4 Carrying Capacity:", 
                min = 100,
                max = 10000,
                step = 100,
                value = 500),   
        
    sliderInput("iStartAdults", 
                "5 Total starting adults:", 
                min = 10,
                max = 5000,
                step=10,
                value = 200)    
    
    

  ),
  
  # mainPanel
  mainPanel(
    
    tabsetPanel(

      tabPanel("Popn", plotOutput("plotPop")),
      #tabPanel("Females by age", plotOutput("plotAgeStructF")),
      #tabPanel("Males by age", plotOutput("plotAgeStructM")),
      #tabPanel("Mean age adults", plotOutput("plotMeanAge")),
      tabPanel("About", includeMarkdown("about.md"))


      
    ) # end tabsetPanel         
  ) # end mainPanel
))