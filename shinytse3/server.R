#shinytse3/server.r
#andy south 9/06/2014

#first test of phase2 grid & movement

#to run type this in R console
#setwd('C:\\Dropbox\\Ian and Andy\\andy\\shiny\\')
#library(shiny)
#runApp('shinytse3')

library(rtsetse)

library(shiny)
library(raster)
#library(ggplot2)
#library(reshape2)
library(plyr)

#to read in a csv
#inFile <- "top5000.csv" 
#dFglobList <- read.csv(inFile,as.is=TRUE)

## can put functions here


#run the model once before start with minimal params
#to initiate the global output object
output <- rtPhase2Test(nRow=1,nCol=1,iDays=1)


shinyServer(function(input, output) {

  
  #in shinytse3 the output is different to shinytse2
  #it's now a multi-dimensional array
  #[day,x,y,ages] just for F to start
  v <- reactiveValues( output=output ) 
  
  
  runModel <- reactive({
    
    cat("in runModel input$days=",input$days,"\n")
    
    #without mention of input$ params in here
    #this doesn't run even when the Run button is pressed
    #so this is a temporary workaround
    if ( input$days > 0 )
    {

      v$output <- rtPhase2Test(nRow = input$nRow,
                               nCol = input$nCol,
                               pMove = input$pMove,
                               iDays = input$days,
                               pMortF = input$pMortF,
                               iStartAges = input$iStartAges,
                               iStartAdults = input$iStartAdults,     
                               iCarryCap = input$iCarryCap )
                               
#                                pMortM = input$pMortM, 
#                                propMortAdultDD = input$propMortAdultDD,
#                                iMaxAge = input$iMaxAge,
#                                iFirstLarva = input$iFirstLarva,
#                                iInterLarva = input$iInterLarva,
#                                pMortLarva = input$pMortLarva,        
#                                propMortLarvaDD = input$propMortLarvaDD,
#                                pMortPupa = input$pMortPupa,
#                                propMortPupaDD = input$propMortPupaDD,                          
#                                verbose=FALSE)
      
    }
    
       
  })
  


###############################
# first go at plotting pop maps for all days
output$plotMapDaysF <- renderPlot({
  
  #needed to get plot to react when button is pressed
  #i'm not quite sure why, i thought it might react to v changing
  runModel()
  
  cat("in plotMapDaysF input$days=",input$days,"\n")
  
  #to sum the age structures in each cell on each day
  #and give result as [days,x,y]
  aDays <- aaply( v$output, .margins=c(1,2,3), sum )
  #aDays <- aaply( v$output, .margins=c(1,2,3), .drop=FALSE, sum )
  
  #!!BEWARE!!
  #!a tricky workaround for if nRow or nCol is 1
  #!and it will need to change when the format of v$output changes
  #if nRow==1 or nCol==1 the corresponding dimension is lost 
  #but it can be put back
  #the easiest way at the moment might be to reset to the dimensions 
  #of v$output minus the last one which was age 
  if ( input$nRow == 1 || input$nCol == 1 )
    dim(aDays) <- dim(v$output)[-length(dim(v$output))]
  
  #rearranging dimensions for raster brick
  aDays <- aperm(aDays, c(2, 3, 1))
  brick1 <- brick(aDays) 
  plot(brick1)  
  
})  

###############################
# plot pop map for final day F
output$plotMapFinalDayF <- renderPlot({
  
  #needed to get plot to react when button is pressed
  #i'm not quite sure why, i thought it might react to v changing
  runModel()
  
  cat("in plotMapFinalDayF input$days=",input$days,"\n")
  
  iFinalDay <- dim(v$output)[1]
  aFinalDay <- v$output[iFinalDay,,,]
  
  #to sum the age structures in each cell on each day
  #and give result as [days,x,y]
  mDays <- aaply( aFinalDay, .margins=c(1,2), sum )
  #mDays <- aaply( aFinalDay, .margins=c(1,2), .drop=FALSE, sum )
  
  rast1 <- raster(mDays)
  plot(rast1)
  
  #rearranging dimensions for raster brick
  #aDays <- aperm(aDays, c(2, 3, 1))
  #brick1 <- brick(aDays) 
  #plot(brick1)  
  
})  


#############################
#functions after here are from shintse2
 
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
        
    #rtPlotPop(v$output$dfRecordF + v$output$dfRecordF,"Adult Flies")
    
    rtPlotPopAndPupae(v$output$dfRecordF, v$output$dfRecordM, v$output$dfRecordPupaF, v$output$dfRecordPupaM)
    
  })  

 
  ###############################
  # plot mean age of adults
  output$plotMeanAge <- renderPlot({
    
    runModel()
    
    cat("in plotMeanAge input$days=",input$days,"\n")
    
    rtPlotMeanAge(v$output$dfRecordF, v$output$dfRecordM,title="Mean age of adult flies")
        
  })    
  
  
}) # end of shinyServer()
