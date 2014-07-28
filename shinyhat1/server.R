#shinyhat1/server.r
#andy south 22/03/2014

#to run type this in R console
#library(shiny)
#setwd('C:\\Dropbox\\Ian and Andy\\andy\\shiny\\')
#runApp('shinyhat1')

library(shiny)
library(raster)
library(ggplot2)
library(reshape2)

#to read in R data
#load("dFcountry.rda")


#to read in a csv
#inFile <- "top5000.csv" 
#dFglobList <- read.csv(inFile,as.is=TRUE)

## can put functions here
## presumably I could source stuff too ?

#sourcing Alex's code
source("movement.R")
source("feed.R")
source("infected.R")
source("demog.R")
#my utility functions
source("rStackCreate.r")

#run the model once before start
source("HAT_trick_andy.r")

# Define server logic 
shinyServer(function(input, output) {

  #I only want to run model when the params are changed
  #or actually probably when a button is pressed
  
  #creating a reactive variable for the map+data
  #so that whenever it is changed anything using it updates
  v <- reactiveValues( pop.grid=pop.grid, 
                       infection.grid=infection.grid,
                       dFdaily=dFdaily,
                       size=size )  
  
  
  runModel <- reactive({
    
    cat("in runModel input$size=",input$size,"\n")
    
    #without mention of input$ params in here
    #this doesn't run even when the Run button is pressed
    #so this is a temporary workaround
    if ( input$size > 0 )
    {
      source("HAT_trick_andy.r", local=TRUE)      
      #source("HAT_trick_andy.r") 
      
      v$pop.grid <- pop.grid
      v$infection.grid <- infection.grid  
      v$dFdaily <- dFdaily
    }
    
    #cat("in runModel       size=",size,"\n")
        
  })
  
  
 
  ###############################
  # plot final pop grid
  output$gridPlotHat1 <- renderPlot({
        
    #needed to get plot to react when button is pressed
    #i'm not quite sure why, i thought it might react to v changing
    runModel()
    
    cat("in gridPlotHat1 input$size=",input$size,"\n")
    
    # plot the final map
    r <- raster( v$pop.grid[[length(v$pop.grid)]] )
    plot(r)
  })  
  
  ############################
  # plot grid for all days pop
  output$plotGridMultiPop <- renderPlot({

    #needed to get plot to react when button is pressed
    #i'm not quite sure why, i thought it might react to v changing
    runModel()
    
    rs <- rStackCreate(v$pop.grid)
    
    plot(rs)
  })    

  ############################
  # plot grid for all days infection
  output$plotGridMultiInf <- renderPlot({
    
    #needed to get plot to react when button is pressed
    #i'm not quite sure why, i thought it might react to v changing
    runModel()
    
    rs <- rStackCreate(v$infection.grid)
    
    plot(rs)
  })   
  
  
  ############################
  # plot grid for all days infection
  output$plotDailyPop <- renderPlot({

    #needed to get plot to react when button is pressed
    #i'm not quite sure why, i thought it might react to v changing
    runModel()
    
    #may need to melt, puts the other column names into a column called variable
    dFm <- melt(v$dFdaily, id.var = c("day"))
    
    #this does produce vaguely what I want
    p <- ggplot( data = dFm,
            aes(day,value, colour = variable) ) + 
            geom_line() +
            facet_grid(variable ~ ., scales="free")
    plot(p)
    
  })   
  
}) # end of shinyServer()
