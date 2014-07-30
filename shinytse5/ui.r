#shinytse5/ui.r
#andy south 30/07/2014

#test of phase3 feeding

#to run type this in R console
#library(shiny)
#runApp('shinytse4')

#for me to deploy online
#devtools::install_github('AndySouth/rtsetse')
#library(shinyapps)
#deployApp('shinytse5')


library(shiny)
library(rmarkdown)

# Define UI 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("shinytse5 - feeding demonstration"),
  
  # Sidebar
  sidebarPanel(

    submitButton("Run Model"),   

    helpText("Press button above after modifying inputs below",
             "and the outputs on the right will update."),
    
    sliderInput("iNumHuntPeriods", 
                "1 No. hunt periods:", 
                min = 1,
                max = 40,
                step= 1,
                value = 30),
    
    sliderInput("fHunters", 
                "2 No. hunting flies:", 
                min = 1,
                max = 1000,
                step= 1,
                value = 1000),
    
    sliderInput("pDetectMan", 
                "3 Detection Human:", 
                min = 0,
                max = 1,
                step = 0.001,
                value = 0.001),   
    
    sliderInput("pDetectOxe", 
                "4 Detection Other host:", 
                min = 0,
                max = 1, 
                step = 0.001,
                value = 0.005),

    sliderInput("pFeedMan", 
                "5 Feeding Human:", 
                min = 0,
                max = 1,
                step = 0.01,
                value = 0.1),   
    
    sliderInput("pFeedOxe", 
                "6 Feeding Other host:", 
                min = 0,
                max = 1,
                step = 0.01,
                value = 0.8),   
    
    sliderInput("fDensityMan", 
                "7 Human density:", 
                min = 0,
                max = 50,
                step = 1,
                value = 1),
    
    sliderInput("fDensityOxe", 
                "8 Other host density:", 
                min = 0,
                max = 50,
                step = 1,
                value = 10)    
    
    
  ),
  
  # mainPanel
  mainPanel(
    
    helpText("Feeding for a single group of flies in a single hunger cycle.
       In Hat-trick each hunger cycle is composed of hunt periods, in rtsetse
       the plan is to set the number of hunt periods at 15 for age1 and 30 for later.
       Detection probabilities refer to one host per km2 and 
       are increased for higher densities. The outputs in the 2nd row of the 
       numeric tab should be equivalent to those from the revised Tables 
       1 & 2 from HAT-trick NittyGritty. Any hunters remaining at the end will starve."),
    
    tabsetPanel(

      tabPanel("Feeding graph", plotOutput("plotFeedingOneCycle")),
      tabPanel("Numeric results", tableOutput("showResultsNumeric")),
      tabPanel("About", includeMarkdown("about.md"))
      
    ) # end tabsetPanel         
  ) # end mainPanel
))