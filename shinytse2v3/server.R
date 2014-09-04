#shinytse2v3/server.r
#andy south 03/09/2014

#seeking stability

#to run type this in R console
#library(shiny)
#runApp('shinytse2v3')
#for me to deploy online
#devtools::install_github('AndySouth/rtsetse')
#library(shinyapps)
#deployApp('shinytse2v3')

library(rtsetse)


library(shiny)
library(raster)
#library(ggplot2)
#library(reshape2)



## can put functions here


#run the model once just one day before start to set up output structure
#output <- rtPhase1Test2(iDays=1, verbose=FALSE)
bestMorts <- rtMortalityStableSeek()


shinyServer(function(input, output) {

  #I only want to run model when a button is pressed
  
  #v <- reactiveValues( output=output ) 
  v <- reactiveValues( bestMorts=bestMorts )   
  
  
  runMortSeek <- reactive({
    
    cat("in runMortSeek\n") #,input$days,"\n")
      
    v$bestMorts <- rtMortalityStableSeek( fMperF = input$fMperF,
                                       iPupDurF = input$iPupDurF,
                                       iPupDurM = input$iPupDurM, 

                                       iFirstLarva = input$iFirstLarva,
                                       iInterLarva = input$iInterLarva,
                                       
                                       pMortPupa = input$pMortPupa,
                                       pMortLarva = input$pMortLarva,    
                               
                                       #todo: add more mortality parameters in here
                                       
                                       #propMortLarvaDD = input$propMortLarvaDD,
                                       #propMortPupaDD = input$propMortPupaDD,
                                       #iStartAges = input$iStartAges,
                                       #iStartAdults = input$iStartAdults,  
                                       #iStartPupae = input$iStartPupae,   
                                       #iMaxAge = input$iMaxAge,
                                       verbose = FALSE )
      
       
  }) #end of runMortSeek
  

  ###############################
  # plot female age structure
  output$plotStableSeek <- renderPlot({
    
    #cat("in plotStableSeek input$fMperF=",input$fMperF,"\n")
    
    #needed to get plot to react when button is pressed
    #i'm not quite sure why, i thought it might react to v changing
    runMortSeek()
       
    
  })  
 
  
 ########################################
 ## OLD FUNCTIONS FROM HERE
 ########################################
 
 
  
  
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
