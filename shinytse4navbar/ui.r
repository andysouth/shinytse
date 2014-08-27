#shinytse4navbar/ui.r
#andy south 27/08/2014

#testing adding a navbar to phase2 grid & movement
#most changes are in ui.r not server

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
shinyUI(
  
  #navbarPage sets up navbar, title appears on left
  #navbarPage("rtsetse demonstrator",
  #trying a theme, must be compatible with Bootstrap 2.3.2 
  #from http://bootswatch.com/2/ saved in www/ folder
  navbarPage("rtsetse demonstrator", theme = "bootstrap.min.css",
             
    tabPanel("a test emptyish tabPanel",
      headerPanel("click next item on bar above to get to something interesting")
      ), #end of tabPanel
    
    tabPanel("spatial model",
    
      pageWithSidebar(
  
        #title for this page
        headerPanel("shinytse4 - simple grid model with dd"),
        
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
          
          sliderInput("iDays", 
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
          
          sliderInput("iPupaDensThresh", 
                      "8 Pupal Density Threshold per cell:", 
                      min = 20,
                      max = 5000,
                      step = 20,
                      value = 100),  
          
          sliderInput("fSlopeDD", 
                      "9 Slope of density-dependence in pupal mort.:", 
                      min = 0,
                      max = 1,
                      step=0.01,
                      value = 0.1), #0.25),     
          
          
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
          
          
        ), #end sidebarPanel
        
    
        mainPanel( 
          
          tabsetPanel(
            
            tabPanel("Maps daily", plotOutput("plotMapDays")),
            tabPanel("Map final", plotOutput("plotMapFinalDay")),           
            tabPanel("Popn whole grid", plotOutput("plotPopGrid")),
            tabPanel("Age structure", plotOutput("plotAgeStruct")),
            #tabPanel("Females by age", plotOutput("plotAgeStructF")),
            #tabPanel("Males by age", plotOutput("plotAgeStructM")),
            tabPanel("Mean age adults", plotOutput("plotMeanAgeGrid")),
            #tabPanel("test inputs", textOutput("testInputs")),
            tabPanel("About", includeMarkdown("about.md"))
            
          ) # end tabsetPanel         
        ) # end mainPanel
      ) # end pageWithSidebar
    ) # end tabPanel("spatial model")  
  ) # end navbarPage   
) # end shinyUI