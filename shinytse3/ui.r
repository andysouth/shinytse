#shinytse3/ui.r
#andy south 9/06/2014

#first test of phase2 grid & movement

#to run type this in R console
#setwd('C:\\Dropbox\\Ian and Andy\\andy\\shiny\\')
#library(shiny)
#runApp('shinytse3')

#for me to deploy online
#devtools::install_github('AndySouth/rtsetse')
#library(shinyapps)
#deployApp('shinytse3')


library(shiny)
library(markdown)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("shinytse3 - simple grid model"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(

    submitButton("Run Model"),
    
    sliderInput("nRow", 
                "1 rows:", 
                min = 1,
                max = 100,
                step= 1,
                value = 10),
    
    sliderInput("nCol", 
                "2 columns:", 
                min = 1,
                max = 100,
                step= 1,
                value = 10),
    
    sliderInput("pMove", 
                "3 proportion moving:", 
                min = 0,
                max = 1,
                step = 0.05,
                value = 0.4),   
    
    sliderInput("days", 
                "4 Days:", 
                min = 1,
                max = 100, 
                value = 8),

    sliderInput("pMortF", 
                "5 Mortality Adult F per day:", 
                min = 0,
                max = 0.2,
                step=0.01,
                value = 0.03),
    
    sliderInput("iCarryCap", 
                "6 Carrying Capacity:", 
                min = 100,
                max = 10000,
                step = 100,
                value = 500),    
    
    sliderInput("iStartAges", 
                "7 Number of starting age classes:", 
                min = 1,
                max = 50,
                step=1,
                value = 20),
    
    sliderInput("iStartAdults", 
                "8 Total starting adults:", 
                min = 10,
                max = 5000,
                step=10,
                value = 200)    
 
    
#     sliderInput("pMortM", 
#                 "3 Mortality Adult M per day:", 
#                 min = 0,
#                 max = 0.2,
#                 step=0.01,
#                 value = 0.06),
#     
#     sliderInput("propMortAdultDD", 
#                 "4 Proportion of Ad mortality density dependent:", 
#                 min = 0,
#                 max = 1,
#                 step=0.05,
#                 value = 0.25),
#     
#     
#     sliderInput("iMaxAge", 
#                 "6 Maximum Age:", 
#                 min = 80,
#                 max = 200,
#                 step = 10,
#                 value = 180),       
#     
#     sliderInput("iFirstLarva", 
#                 "7 Age that F produces first larva:", 
#                 min = 14,
#                 max = 18,
#                 step=1,
#                 value = 16),
# 
#     sliderInput("iInterLarva", 
#                 "8 Days between larvae:", 
#                 min = 7,
#                 max = 11,
#                 step=1,
#                 value = 10),
#     
#     sliderInput("pMortLarva", 
#                 "9 Mortality Larval per larval period:", 
#                 min = 0.01,
#                 max = 0.4,
#                 step=0.01,
#                 value = 0.05),
#     
#     sliderInput("propMortLarvaDD", 
#                 "10 Proportion of larval mort. density dependent:", 
#                 min = 0,
#                 max = 1,
#                 step=0.05,
#                 value = 0.25),
#     
#     sliderInput("pMortPupa", 
#                 "11 Mortality Pupal per pupal period:", 
#                 min = 0,
#                 max = 0.5,
#                 step=0.05,
#                 value = 0.25),
# 
#     sliderInput("propMortPupaDD", 
#                 "12 Proportion of pupal mort. density dependent:", 
#                 min = 0,
#                 max = 1,
#                 step=0.05,
#                 value = 0.25)
        
    
    
  ),
  
  # mainPanel
  mainPanel(
    
    tabsetPanel(

      tabPanel("Maps daily F", plotOutput("plotMapDaysF")),
      tabPanel("Map final F", plotOutput("plotMapFinalDayF")),           
      #tabPanel("Popn", plotOutput("plotPop")),
      #tabPanel("Females by age", plotOutput("plotAgeStructF")),
      #tabPanel("Males by age", plotOutput("plotAgeStructM")),
      #tabPanel("Mean age adults", plotOutput("plotMeanAge")),
      tabPanel("About", includeMarkdown("about.md"))

      
    ) # end tabsetPanel         
  ) # end mainPanel
))