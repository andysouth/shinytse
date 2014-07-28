#shinytsetse1/server.r
#andy south 22/03/2014

#to run type this in R console
#library(shiny)
#setwd('C:\\Dropbox\\Ian and Andy\\andy\\shinytse\\')
#runApp('shinytsetse1')

library(rtsetse)

library(shiny)
library(raster)
#library(ggplot2)
#library(reshape2)



#to read in R data
#load("dFcountry.rda")


#to read in a csv
#inFile <- "top5000.csv" 
#dFglobList <- read.csv(inFile,as.is=TRUE)

## can put functions here


#? run the model once before start
#source("HAT_trick_andy.r")
output <- rtPhase1Test(verbose=FALSE)


shinyServer(function(input, output) {

  #I only want to run model when a button is pressed
  
  #creating a reactive variable for the map+data
  #so that whenever it is changed anything using it updates
  #v <- reactiveValues( pop.grid=pop.grid, 
  #                     infection.grid=infection.grid,
  #                     dFdaily=dFdaily,
  #                     size=size ) 
  
  
  v <- reactiveValues( output=output ) 
  
  
  runModel <- reactive({
    
    cat("in runModel input$days=",input$days,"\n")
    
    #without mention of input$ params in here
    #this doesn't run even when the Run button is pressed
    #so this is a temporary workaround
    if ( input$days > 0 )
    {
      #source("HAT_trick_andy.r", local=TRUE)      

      v$output <- rtPhase1Test(iDays = input$days, 
                               iFirstLarva = input$iFirstLarva,
                               iInterLarva = input$iInterLarva,
                               pMortLarva = input$pMortLarva,                                 
                               pMortPupa = input$pMortPupa,
                               pMortF = input$pMortF,
                               pMortM = input$pMortM, 
                               iStartAges = input$iStartAges,
                               verbose=FALSE)
      
      #v$pop.grid <- pop.grid
    }
    
       
  })
  
  
 
  ###############################
  # plot female age structure
  output$plotAgeStructF <- renderPlot({
        
    #needed to get plot to react when button is pressed
    #i'm not quite sure why, i thought it might react to v changing
    runModel()
    
    cat("in plotAgeStructF input$days=",input$days,"\n")
    
    rtPlotAgeStructure(v$output$dfRecordF,"Females")
    
  })  

  ###############################
  # plot male age structure
  output$plotAgeStructM <- renderPlot({
    
    #needed to get plot to react when button is pressed
    #i'm not quite sure why, i thought it might react to v changing
    runModel()
    
    cat("in plotAgeStructM input$days=",input$days,"\n")
    
    rtPlotAgeStructure(v$output$dfRecordM,"Males")
    
  })    
  
  ###############################
  # plot total adult population
  output$plotPop <- renderPlot({
    
    #needed to get plot to react when button is pressed
    #i'm not quite sure why, i thought it might react to v changing
    runModel()
    
    cat("in plotPop input$days=",input$days,"\n")
    
    
    rtPlotPop(v$output$dfRecordF + v$output$dfRecordF,"Adult Flies")
    
  })  


  
}) # end of shinyServer()
