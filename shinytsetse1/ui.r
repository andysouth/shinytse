#shinytsetse1/ui.r
#andy south 22/03/2014

#to run type this in R console
#library(shiny)
#setwd('C:\\Dropbox\\Ian and Andy\\andy\\shiny\\')
#runApp('shinytsetse1')

library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("shinytsetse1"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(

    submitButton("Run Model"),
    
    sliderInput("days", 
                "Days:", 
                min = 1,
                max = 500, 
                value = 30),
    
    sliderInput("iFirstLarva", 
                "Age that F produces first larva:", 
                min = 14,
                max = 18,
                step=1,
                value = 16),

    sliderInput("iInterLarva", 
                "Days between larvae:", 
                min = 7,
                max = 11,
                step=1,
                value = 10),
    
    sliderInput("pMortLarva", 
                "Mortality Larval per larval period:", 
                min = 0.01,
                max = 0.4,
                step=0.01,
                value = 0.05),
    
    sliderInput("pMortPupa", 
                "Mortality Pupal per pupal period:", 
                min = 0,
                max = 0.5,
                step=0.05,
                value = 0.25),
    
    sliderInput("pMortF", 
                "Mortality Adult F per day:", 
                min = 0,
                max = 0.2,
                step=0.01,
                value = 0.03),

    sliderInput("pMortM", 
                "Mortality Adult M per day:", 
                min = 0,
                max = 0.2,
                step=0.01,
                value = 0.03),    
    
    sliderInput("iStartAges", 
                "Number of starting age classes:", 
                min = 1,
                max = 50,
                step=1,
                value = 1)    
    

  ),
  
  # mainPanel
  mainPanel(
    
    tabsetPanel(

      tabPanel("Popn", plotOutput("plotPop")),
      tabPanel("Females by age", plotOutput("plotAgeStructF")),
      tabPanel("Males by age", plotOutput("plotAgeStructM"))
      #tabPanel("Daily Fly Maps", plotOutput("plotGridMultiPop")),
      #tabPanel("Daily Infection Maps", plotOutput("plotGridMultiInf")),

      
    ) # end tabsetPanel         
  ) # end mainPanel
))