#shinytse2v2/ui.r
#andy south 30/06/2014

#to look at aspatial density dependence

#to run type this in R console
#setwd('C:\\Dropbox\\Ian and Andy\\andy\\shiny\\')
#library(shiny)
#runApp('shinytse2v2')
#for me to deploy online
#devtools::install_github('AndySouth/rtsetse')
#library(shinyapps)
#deployApp('shinytse2v2')


library(shiny)
library(markdown)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("shinytse2v2 - aspatial density dependence pupa only"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(

    submitButton("Run Model"),
    
    sliderInput("days", 
                "1 Days:", 
                min = 1,
                max = 1000, 
                value = 200),

    sliderInput("pMortF", 
                "2 Mortality Adult F per day:", 
                min = 0,
                max = 0.2,
                step=0.01,
                value = 0.02),
    
    sliderInput("pMortM", 
                "3 Mortality Adult M per day:", 
                min = 0,
                max = 0.2,
                step=0.01,
                value = 0.04),

    sliderInput("pMortPupa", 
                "4 Mortality Pupal per pupal period:", 
                min = 0,
                max = 0.5,
                step=0.05,
                value = 0.2),    
    
    sliderInput("iPupaDensThresh", 
                "5 Pupal Density Threshold-DD operates above:", 
                min = 100,
                max = 10000,
                step = 100,
                value = 200),  
    
    sliderInput("fSlopeDD", 
                "6 Slope of density-dependence in pupal mort.:", 
                min = 0,
                max = 1,
                step=0.01,
                value = 0.1), #0.25), 
    
    sliderInput("iMaxAge", 
                "7 Maximum Age:", 
                min = 80,
                max = 200,
                step = 10,
                value = 180),       
    
    sliderInput("iFirstLarva", 
                "8 Age that F produces first larva:", 
                min = 14,
                max = 18,
                step=1,
                value = 16),

    sliderInput("iInterLarva", 
                "9 Days between larvae:", 
                min = 7,
                max = 11,
                step=1,
                value = 10),
    
    sliderInput("pMortLarva", 
                "10 Mortality Larval per larval period:", 
                min = 0.01,
                max = 0.4,
                step=0.01,
                value = 0.05),
    
    sliderInput("iStartAges", 
                "11 Number of starting age classes:", 
                min = 1,
                max = 50,
                step=1,
                value = 50),
    
    sliderInput("iStartAdults", 
                "12 Total starting adults:", 
                min = 10,
                max = 5000,
                step=10,
                value = 200),    
    
    sliderInput("iStartPupae", 
                "13 Total starting pupae:", 
                min = 10,
                max = 5000,
                step=10,
                value = 200)       

  ),
  
  # mainPanel
  mainPanel(
    
    tabsetPanel(

      tabPanel("Popn", plotOutput("plotPop")),
      tabPanel("Females by age", plotOutput("plotAgeStructF")),
      tabPanel("Males by age", plotOutput("plotAgeStructM")),
      tabPanel("Mean age adults", plotOutput("plotMeanAge")),
      tabPanel("About", includeMarkdown("about.md"))


      
    ) # end tabsetPanel         
  ) # end mainPanel
))