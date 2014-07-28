#shinyddtest/server.r
#andy south 19/05/2014

#to look at aspatial density dependence

#to run type this in R console
#setwd('C:\\Dropbox\\Ian and Andy\\andy\\shiny\\')
#library(shiny)
#runApp('shinyddtest')

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

#output <- rtPhase1Test(verbose=FALSE)


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
    
    #cat("in runModel input$days=",input$days,"\n")
    
    #without mention of input$ params in here
    #this doesn't run even when the Run button is pressed
    #so this is a temporary workaround
    if ( input$days > 0 )
    {   

#       v$output <- rtPhase1Test(iDays = input$days,
#                                pMortF = input$pMortF,
#                                pMortM = input$pMortM, 
#                                propMortAdultDD = input$propMortAdultDD,
#                                iCarryCap = input$iCarryCap,
#                                iStartAdults = input$iStartAdults)

      #create empty vector
      #v$output <- rep(NA,input$days)
      #v$output <- c(1:input$days)  
      vPop <- c(1:input$days)        
      
      vPop[1] <- input$iStartAdults

      #density dependent
      #slopeb <- (abs(log(input$pBirth)-log(input$pMortF)))/input$iCarryCap 
      #slopeb <- (log(input$pBirth)-log(input$pMortF))/input$iCarryCap 
      slopeb <- (input$pBirth-input$pMortF)/input$iCarryCap       
      
      #if the slopeb param is not set correctly the popn doesn't stabilise at K
      #slopeb <- input$pBirth/input$iCarryCap         
      
      cat("birth-mort=",(input$pBirth-input$pMortF)," slopeb=",slopeb,"\n")
      
      for( day in 2:input$days ) {
        
        
        #density independent growth
        #vPop[day] <- vPop[day-1] +
        #             vPop[day-1]*input$pBirth -
        #             vPop[day-1]*input$pMortF
        
        #density dependent mortality
        pMortFDD <- input$pMortF + slopeb*vPop[day-1]
        
        #density dependent births
        #pBirthDD <- input$pBirth - slopeb/2*vPop[day-1]
        pBirthDD <- input$pBirth
        
        vPop[day] <- vPop[day-1] +
          vPop[day-1]*pBirthDD -
          vPop[day-1]*pMortFDD
        
        
        
      }
      
      v$output <- vPop 

    }
    
       
  })
    
  
  ###############################
  # plot total adult population
  output$plotPop <- renderPlot({
    
    #needed to get plot to react when button is pressed
    #i'm not quite sure why, i thought it might react to v changing
    runModel()
    
    #cat("in plotPop input$days=",input$days,"\n")
    
    plot(v$output)
    
    #rtPlotPop(v$output$dfRecordF)
    
    #rtPlotPop(v$output$dfRecordF + v$output$dfRecordM,"Adult Flies")
    #rtPlotPopAndPupae(v$output$dfRecordF, v$output$dfRecordM, v$output$dfRecordPupaF, v$output$dfRecordPupaM)
    
  })  

 
  
  
}) # end of shinyServer()
