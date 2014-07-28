#shinytse2/ui.r
#andy south 19/05/2014

#to look at aspatial density dependence

#to run type this in R console
#setwd('C:\\Dropbox\\Ian and Andy\\andy\\shiny\\')
#library(shiny)
#runApp('shinytse2')

library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("shinytse2 - aspatial density dependence"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(

    submitButton("Run Model"),
    
    sliderInput("days", 
                "1 Days:", 
                min = 1,
                max = 1000, 
                value = 250),

    sliderInput("pMortF", 
                "2 Mortality Adult F per day:", 
                min = 0,
                max = 0.2,
                step=0.01,
                value = 0.01),
    
    sliderInput("pMortM", 
                "3 Mortality Adult M per day:", 
                min = 0,
                max = 0.2,
                step=0.01,
                value = 0.04),
    
    sliderInput("propMortAdultDD", 
                "4 Proportion of Ad mortality density dependent:", 
                min = 0,
                max = 1,
                step=0.05,
                value = 0), #0.25),
    
    sliderInput("iCarryCap", 
                "5 Carrying Capacity:", 
                min = 100,
                max = 10000,
                step = 100,
                value = 200),   
    
    sliderInput("iMaxAge", 
                "6 Maximum Age:", 
                min = 80,
                max = 200,
                step = 10,
                value = 180),       
    
    sliderInput("iFirstLarva", 
                "7 Age that F produces first larva:", 
                min = 14,
                max = 18,
                step=1,
                value = 16),

    sliderInput("iInterLarva", 
                "8 Days between larvae:", 
                min = 7,
                max = 11,
                step=1,
                value = 10),
    
    sliderInput("pMortLarva", 
                "9 Mortality Larval per larval period:", 
                min = 0.01,
                max = 0.4,
                step=0.01,
                value = 0.05),
    
    sliderInput("propMortLarvaDD", 
                "10 Proportion of larval mort. density dependent:", 
                min = 0,
                max = 1,
                step=0.05,
                value = 0), # 0.25),
    
    sliderInput("pMortPupa", 
                "11 Mortality Pupal per pupal period:", 
                min = 0,
                max = 0.5,
                step=0.05,
                value = 0.25),

    sliderInput("propMortPupaDD", 
                "12 Proportion of pupal mort. density dependent:", 
                min = 0,
                max = 1,
                step=0.05,
                value = 0), # 0.25),
    
    sliderInput("iStartAges", 
                "13 Number of starting age classes:", 
                min = 1,
                max = 50,
                step=1,
                value = 20),
    
    sliderInput("iStartAdults", 
                "14 Total starting adults:", 
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