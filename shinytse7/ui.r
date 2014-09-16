#shinytse7/ui.r
#andy south 15/09/2014

#seeking stability

#to run type this in R console
#library(shiny)
#runApp('shinytse7')
#for me to deploy online
#devtools::install_github('AndySouth/rtsetse')
#library(shinyapps)
#deployApp('shinytse7')


library(shiny)
library(markdown)

# Define UI 
shinyUI(
  
  #this didn't work to put text above the navbar
  #helpText("Test..."),
  
  #navbarPage sets up navbar, title appears on left
  #navbarPage("rtsetse demonstrator",
  #trying a theme, must be compatible with Bootstrap 2.3.2 
  #from http://bootswatch.com/2/ saved in www/ folder
  #this theme is flatly - blue navbar & turquoise links !
  navbarPage("rtsetse demonstrator", theme = "bootstrap.min.css",
    
    # tab "About" ---------------------------
    tabPanel("About", includeMarkdown("about.md")),
    
             
    # tab "seek stable mortality" ---------------------------
    tabPanel("1 seek stable mortality", 
      
      helpText("Set population parameters on the left and press the seek button to find",
               " values of adult mortality that generate a stable population."),
             
      pageWithSidebar(
        
        #title for this page
        #headerPanel("shinytse7 - seeking stability"),
        #if no headerPanel an error is generated
        headerPanel(""),
        
        # Sidebar for inputs
        sidebarPanel(
      
          submitButton("Seek Stable Mortality"),
          
          sliderInput("fMperF", 
                      "1 males per female:", 
                      min = 0.4,
                      max = 0.8, 
                      step = 0.05,
                      value = 0.5),
      
          sliderInput("iPupDurF", 
                      "2 pupal duration F:", 
                      min = 20,
                      max = 48,
                      step = 1,
                      value = 26),
      
          sliderInput("iPupDurM", 
                       "3 pupal duration M:", 
                       min = 22,
                       max = 50,
                       step = 1,
                       value = 28),    
          
          sliderInput("iFirstLarva", 
                      "4 Age that F produces first larva:", 
                      min = 14,
                      max = 18,
                      step=1,
                      value = 16),
          
          sliderInput("iInterLarva", 
                      "5 Days between larvae:", 
                      min = 7,
                      max = 11,
                      step=1,
                      value = 10),        
          
          sliderInput("pMortPupa", 
                      "6 Mortality Pupal per pupal period:", 
                      min = 0,
                      max = 0.5,
                      step=0.05,
                      value = 0.2),        
          
          sliderInput("pMortLarva", 
                      "7 Mortality Larval per larval period:", 
                      min = 0.01,
                      max = 0.4,
                      step=0.01,
                      value = 0.05),
          
          sliderInput("iMortMinAgeStartF", 
                      "8 Mortality minimum start day F:", 
                      min = 2,
                      max = 12,
                      step = 1,
                      value = 10),
          
          sliderInput("fMortMinPropF", 
                      "9 Mortality min., proportion of day1 F:", 
                      min = 0.05,
                      max = 1,
                      step = 0.05,
                      value = 0.2),          

          sliderInput("fMortOldPropF", 
                      "10 Mortality old, proportion of day1 F:", 
                      min = 0.2,
                      max = 1,
                      step = 0.1,
                      value = 0.3),        
          
          sliderInput("iMortMinAgeStartM", 
                      "11 Mortality minimum start day M:", 
                      min = 2,
                      max = 12,
                      step = 1,
                      value = 10),
          
          sliderInput("fMortMinPropM", 
                      "12 Mortality min., proportion of day1 M:", 
                      min = 0.05,
                      max = 1,
                      step = 0.05,
                      value = 0.2),          
          
          sliderInput("fMortOldPropM", 
                      "13 Mortality old, proportion of day1 M:", 
                      min = 0.2,
                      max = 1,
                      step = 0.1,
                      value = 0.3)
          
        ), #end sidebarPanel
        
        
        mainPanel(
          
          tabsetPanel(
      
            tabPanel("Seeking stability",
              helpText("Graph shows the program testing decreasing F mortalities until it finds",
                       " one that balances the population. It then similarly seeks a male mortality that",
                       " generates the M:F ratio requested by the user."),
              plotOutput("plotStableSeek")),     
            tabPanel("Mortality F", 
              helpText("Graph shows pattern of mortality generated by the inputs and used in later runs."),                     
              plotOutput("plotMortalityF")),
            tabPanel("Mortality M", 
              helpText("Graph shows pattern of mortality generated by the inputs and used in later runs."),                     
              plotOutput("plotMortalityM"))
          ) # end tabsetPanel         
        ) # end mainPanel
      ) # end pageWithSidebar
    ), # end tabPanel("seeking stable mortality")
    
    # tab "a-spatial model" ---------------------------
    tabPanel("2 aspatial model",
             
      helpText("Runs a model for a single population.",
               " Select parameter values on the left, press run, then view different outputs on the right.",
               " Uses mortality parameters calculated on the previous page."),
             
      pageWithSidebar(
         
         #title for this page
         #headerPanel("shinytse7 - seeking stability"),
         #if no headerPanel an error is generated
         headerPanel(""),
         
         sidebarPanel(
           
           submitButton("Run Model"),
           
           sliderInput("days", 
                       "1 Days:", 
                       min = 1,
                       max = 1000, 
                       value = 100),
           
           sliderInput("iCarryCap", 
                       "2 Carrying Capacity Females:", 
                       min = 100,
                       max = 10000,
                       step = 100,
                       value = 200),   
           
           sliderInput("fStartPopPropCC", 
                       "3 Start popn as a proportion of CC:", 
                       min = 0.1,
                       max = 2,
                       step= 0.1,
                       value = 1),   
           
           helpText("4 Density Dependent proportion of:"),
           
           wellPanel(
           sliderInput("propMortAdultDD", 
                       "a adult mortality:", 
                       min = 0,
                       max = 1,
                       step=0.05,
                       value = 0.25),
               
           sliderInput("propMortLarvaDD", 
                       "b larval mortality:", 
                       min = 0,
                       max = 1,
                       step=0.05,
                       value = 0.25),
           
           sliderInput("propMortPupaDD", 
                       "c pupal mortality:", 
                       min = 0,
                       max = 1,
                       step=0.05,
                       value = 0.25)            
           )#end wellPanel
           
           
         ), #end sidebarPanel   
         mainPanel( 
           tabsetPanel(
             # viewing outputs -----------------
             tabPanel("Popn", plotOutput("plotPop")),
             tabPanel("Females by age", plotOutput("plotAgeStructF")),
             tabPanel("Males by age", plotOutput("plotAgeStructM")),
             tabPanel("Mean age adults", plotOutput("plotMeanAge")),
             tabPanel("Code", verbatimTextOutput("printParams"))
           ) # end tabsetPanel         
         ) # end mainPanel
      ) # end pageWithSidebar             
    ), # end tabPanel("a-spatial model") 
    
    # tab "spatial model" ---------------------------
    tabPanel("3 spatial model",
             
     helpText("Will run gridded model (not implemented yet).",
              " Select parameter values on the left, press run, then view different outputs on the right.",
              " Will use parameters from previous pages."),
     
     pageWithSidebar(
       
       #if no headerPanel an error is generated
       headerPanel(""),
     
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
         
         sliderInput("daysGridModel", 
                     "3 Days:", 
                     min = 1,
                     max = 1000, 
                     value = 100),
         
         sliderInput("pMove", 
                     "4 proportion moving:", 
                     min = 0,
                     max = 1,
                     step = 0.05,
                     value = 0.4)
         
       ), #end sidebarPanel
       
       # mainPanel
       mainPanel(
         
         tabsetPanel(
           
           tabPanel("Maps daily", plotOutput("plotMapDays")),
           tabPanel("Map final", plotOutput("plotMapFinalDay")),           
           tabPanel("Popn whole grid", plotOutput("plotPopGrid")),
           tabPanel("Age structure", plotOutput("plotAgeStruct")),
           #tabPanel("Females by age", plotOutput("plotAgeStructF")),
           #tabPanel("Males by age", plotOutput("plotAgeStructM")),
           tabPanel("Mean age adults", plotOutput("plotMeanAgeGrid"))
           #tabPanel("test inputs", textOutput("testInputs")),
           #tabPanel("About", includeMarkdown("about.md"))
           
           ) # end tabsetPanel                 
         ) # end mainPanel         
       ) # end pageWithSidebar  
    ) # end tabPanel("spatial model") 
  ) # end navbarPage   
) # end shinyUI
            










