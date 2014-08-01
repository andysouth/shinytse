#shinytse5/server.r
#andy south 30/07/2014

#test of phase3 feeding

#to run type this in R console
#library(shiny)
#runApp('shinytse5')

library(rtsetse)

library(shiny)
#library(raster)
#i don't see why these are needed when they are imported by rtsetse but seems they are
#library(ggplot2) 
#library(reshape2)
#library(plyr)
#library(dplyr)
#library(abind) 


#run the model once before start with minimal params
#to initiate the global output object
output <- rtPhase3Test()



shinyServer(function(input, output) {

  
  #make the output reactive
  v <- reactiveValues( output=output ) 
  
  
  runModel <- reactive({
    
    cat("in runModel input$iNumHuntPeriods=",input$iNumHuntPeriods,"\n")
    
    #without mention of input$ params in here
    #this doesn't run even when the Run button is pressed
    #so this is a temporary workaround
    if ( input$iNumHuntPeriods > 0 )
    {

      v$output <- rtPhase3Test(iNumHuntPeriods=input$iNumHuntPeriods,
                               fHunters=input$fHunters,
                               pDetectMan=input$pDetectMan,
                               pDetectOxe=input$pDetectOxe,
                               pFeedMan=input$pFeedMan,
                               pFeedOxe=input$pFeedOxe,
                               fDensityMan=input$fDensityMan,
                               fDensityOxe=input$fDensityOxe )   

      
    }
    
       
  })
  

###############################
# plotting feeding outputs
output$plotFeedingOneCycle <- renderPlot({
  
  #needed to get plot to react when button is pressed
  runModel()
  
  cat("in plotplotFeedingOneCycle input$iNumHuntPeriods=",input$iNumHuntPeriods,"\n")
  
  rtPlotFeedingOneCycle(v$output)
})  

###############################
# plotting feeding outputs as proportion flies feeding on humans
output$plotFeedingOneCycleProp <- renderPlot({
  
  #needed to get plot to react when button is pressed
  runModel()
    
  rtPlotFeedingOneCycle(v$output, proportionPlot=TRUE)
})  

###############################
# plot table of output results
output$showResultsNumeric <- renderTable({
  
  runModel()
  
  #cat("in showResultsNumeric input$iNumHuntPeriods=",input$iNumHuntPeriods,"\n")
  
  v$output
  
  
})  

 
  
  
}) # end of shinyServer()
