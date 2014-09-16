#shinytse4/ui.r
#andy south 16/06/2014

#2nd test of phase2 grid & movement

#to run type this in R console
#setwd('C:\\Dropbox\\Ian and Andy\\andy\\shiny\\')
#library(shiny)
#runApp('shinytse4')

#for me to deploy online
#devtools::install_github('AndySouth/rtsetse')
#library(shinyapps)
#deployApp('shinytse4')


library(shiny)
library(rmarkdown)

# Define UI 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("shinytse4 - simple grid model with movement and density dependence"),
  
  # Sidebar
  sidebarPanel(

    #splitLayout did kind of work to create 2 columns of inputs, maybe come back to
    #have to make sure there's no comma before final bracket
    #splitLayout(
    submitButton("Run Model"),   
    #next 2 for report download
    downloadButton('downloadReport',label='download run report'),
    #),
    #radioButtons('format', 'Document format', c('PDF', 'HTML', 'Word'), inline = TRUE),
    
    sliderInput("nRow", 
                "1 rows:", 
                min = 1,
                max = 100,
                step= 1,
                value = 9),
    
    sliderInput("nCol", 
                "2 columns:", 
                min = 1,
                max = 100,
                step= 1,
                value = 9),
    
    sliderInput("pMove", 
                "3 proportion moving:", 
                min = 0,
                max = 1,
                step = 0.05,
                value = 0.4),   
    
    sliderInput("daysGridModel", 
                "4 Days:", 
                min = 1,
                max = 200, 
                value = 4),

    sliderInput("pMortF", 
                "5 Mortality Adult F per day:", 
                min = 0,
                max = 0.2,
                step=0.01,
                value = 0.03),
    
    sliderInput("pMortM", 
                "6 Mortality Adult M per day:", 
                min = 0,
                max = 0.2,
                step=0.01,
                value = 0.04),
    
    sliderInput("pMortPupa", 
                "7 Mortality Pupal per pupal period:", 
                min = 0,
                max = 0.5,
                step=0.05,
                value = 0.25),
    
        sliderInput("iCarryCap", 
                    "7 Carrying Capacity:", 
                    min = 100,
                    max = 10000,
                    step = 100,
                    value = 500),       
        sliderInput("propMortAdultDD", 
                    "4 Proportion of Ad mortality density dependent:", 
                    min = 0,
                    max = 1,
                    step=0.05,
                    value = 0.25),
    
        sliderInput("propMortPupaDD", 
                    "12 Proportion of pupal mort. density dependent:", 
                    min = 0,
                    max = 1,
                    step=0.05,
                    value = 0.25),    
    
#     sliderInput("iPupaDensThresh", 
#                 "8 Pupal Density Threshold per cell:", 
#                 min = 20,
#                 max = 5000,
#                 step = 20,
#                 value = 100),  
#     
#     sliderInput("fSlopeDD", 
#                 "9 Slope of density-dependence in pupal mort.:", 
#                 min = 0,
#                 max = 1,
#                 step=0.01,
#                 value = 0.1), #0.25),     
    
    
    sliderInput("iStartAges", 
                "10 Number of starting age classes:", 
                min = 1,
                max = 50,
                step=1,
                value = 20),
    
    sliderInput("iStartAdults", 
                "11 Total starting adults:", 
                min = 10,
                max = 5000,
                step=10,
                value = 200)    
 
    

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
# 

        
    
    
  ),
  
  # mainPanel
  mainPanel(
    
    tabsetPanel(

      tabPanel("Maps daily", plotOutput("plotMapDays")),
      tabPanel("Map final", plotOutput("plotMapFinalDay")),           
      tabPanel("Popn whole grid", plotOutput("plotPopGrid")),
      tabPanel("Age structure", plotOutput("plotAgeStructGrid")),
      #tabPanel("Females by age", plotOutput("plotAgeStructF")),
      #tabPanel("Males by age", plotOutput("plotAgeStructM")),
      tabPanel("Mean age adults", plotOutput("plotMeanAgeGrid")),
      #tabPanel("test inputs", textOutput("testInputs")),
      tabPanel("About", includeMarkdown("about.md"))

      
    ) # end tabsetPanel         
  ) # end mainPanel
))