#shinytse2v3/ui.r
#andy south 03/09/2014

#seeking stability

#to run type this in R console
#library(shiny)
#runApp('shinytse2v3')
#for me to deploy online
#devtools::install_github('AndySouth/rtsetse')
#library(shinyapps)
#deployApp('shinytse2v3')


library(shiny)
library(markdown)

# Define UI 
shinyUI(
  
  #this didn't work to put text above the navbar
  #helpText("Test..."),
  
  #navbarPage sets up navbar, title appears on left
  navbarPage("rtsetse demonstrator",
    
    # tab "About" ---------------------------
    tabPanel("About", includeMarkdown("about.md")),
    
             
    # tab "seek stable mortality" ---------------------------
    tabPanel("1 seek stable mortality", 
      
      helpText("Here you can set population parameters and press the seek button to find",
               " values of adult mortality that generate a stable population."),
             
      pageWithSidebar(
        
        #title for this page
        #headerPanel("shinytse2v3 - seeking stability"),
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
      
            tabPanel("Seeking stability", plotOutput("plotStableSeek"))     
            #tabPanel("Popn", plotOutput("plotPop")),

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
         #headerPanel("shinytse2v3 - seeking stability"),
         #if no headerPanel an error is generated
         headerPanel(""),
         
         sidebarPanel(
           
           submitButton("Run Model"),
           
           sliderInput("days", 
                       "1 Days:", 
                       min = 1,
                       max = 1000, 
                       value = 100)
         ), #end sidebarPanel   
         mainPanel( 
           tabsetPanel(
             # viewing outputs -----------------
             tabPanel("Popn", plotOutput("plotPop")),
             tabPanel("params used", textOutput("printParams"))
             #tabPanel("Females by age", plotOutput("plotAgeStructF")),
             #tabPanel("Males by age", plotOutput("plotAgeStructM")),
             #tabPanel("Mean age adults", plotOutput("plotMeanAge")),
             #tabPanel("About", includeMarkdown("about.md"))
           ) # end tabsetPanel         
         ) # end mainPanel
      ) # end pageWithSidebar             
    ), # end tabPanel("a-spatial model") 
    
    # tab "spatial model" ---------------------------
    tabPanel("3 spatial model",
             
     helpText("Will run gridded model (not implemented yet).",
              " Select parameter values on the left, press run, then view different outputs on the right.",
              " Will use parameters from previous pages.")
    ) # end tabPanel("spatial model") 
  ) # end navbarPage   
) # end shinyUI
            










