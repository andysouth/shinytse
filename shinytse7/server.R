#shinytse7/server.r
#andy south 15/09/2014

#seeking stability

#to run type this in R console
#library(shiny)
#runApp('shinytse7')
#for me to deploy online
#devtools::install_github('AndySouth/rtsetse')
#library(shinyapps)
#deployApp('shinytse7')

library(rtsetse)


library(shiny)
library(raster)
#library(ggplot2)
#library(reshape2)



## can put functions here


#run the model once just one day before start to set up output structure
#output <- rtPhase1Test2(iDays=1, verbose=FALSE)
bestMorts <- rtMortalityStableSeek(plot=FALSE)
aspatialResults <- rtPhase1Test3(iDays=1, verbose=FALSE)
lNamedArgs <- NULL #to hold argList for aspatial model  

shinyServer(function(input, output) {

  #I only want to run model when a button is pressed
  
  #v <- reactiveValues( output=output ) 
  v <- reactiveValues( bestMorts=bestMorts,
                       aspatialResults=aspatialResults )   

  
  # run mortality seeking  ##########################
  runMortSeek <- reactive({
    
    cat("in runMortSeek\n") #,input$days,"\n")
      
    v$bestMorts <- rtMortalityStableSeek( fMperF = input$fMperF,
                                       iPupDurF = input$iPupDurF,
                                       iPupDurM = input$iPupDurM, 

                                       iFirstLarva = input$iFirstLarva,
                                       iInterLarva = input$iInterLarva,
                                       
                                       pMortPupa = input$pMortPupa,
                                       pMortLarva = input$pMortLarva,    
                               
                                       iMortMinAgeStartF = input$iMortMinAgeStartF,
                                       #leave next as default
                                       #iMortMinAgeStopF = input$iMortMinAgeStopF,
                                       fMortMinPropF = input$fMortMinPropF,
                                       fMortOldPropF = input$fMortOldPropF,
                                       
                                       iMortMinAgeStartM = input$iMortMinAgeStartM,
                                       #leave next as default
                                       #iMortMinAgeStopM = input$iMortMinAgeStopM,
                                       fMortMinPropM = input$fMortMinPropM,
                                       fMortOldPropM = input$fMortOldPropM,
                                       
                                       
                                       #propMortLarvaDD = input$propMortLarvaDD,
                                       #propMortPupaDD = input$propMortPupaDD,
                                       #iStartAges = input$iStartAges,
                                       #iStartAdults = input$iStartAdults,  
                                       #iStartPupae = input$iStartPupae,   
                                       #iMaxAge = input$iMaxAge,
                                       verbose = FALSE )
      
       
  }) #end of runMortSeek

  
  # plot stability seeking  ##########################
  output$plotStableSeek <- renderPlot({
    
    #cat("in plotStableSeek input$fMperF=",input$fMperF,"\n")
    
    #needed to get plot to react when button is pressed
    #i'm not quite sure why, i thought it might react to v changing
    runMortSeek()
       
  })  
 
  # plot mortality by age F  ##########################
  output$plotMortalityF <- renderPlot({
    
    #?needed to get plot to react when button is pressed
    #runMortSeek()
    
    #!BEWARE that I have default max age set to 100 in a couple of places now. 
    #! ideally it should be set in just one place.
    iMaxAge <- 100
    iMortMinAgeStopF <- 60 #left as default, unchangeable in Hat-trick
    
    vpMorts <- rtSetMortRatesByAge( c(1:iMaxAge),
                                    pMortAge1 = v$bestMorts$F,
                                    iMortMinAgeStart = input$iMortMinAgeStartF,
                                    #leave next as default
                                    iMortMinAgeStop = iMortMinAgeStopF,
                                    fMortMinProp = input$fMortMinPropF,
                                    fMortOldProp = input$fMortOldPropF )
    
    rtPlotMortRatesByAge(vpMorts, title="females")
    
  })    
 
# plot mortality by age F  ##########################
output$plotMortalityM <- renderPlot({
  
  #?needed to get plot to react when button is pressed
  #runMortSeek()
  
  #!BEWARE that I have default max age set to 100 in a couple of places now. 
  #! ideally it should be set in just one place.
  iMaxAge <- 100
  iMortMinAgeStopM <- 40 #left as default, unchangeable in Hat-trick
  
  vpMorts <- rtSetMortRatesByAge( c(1:iMaxAge),
                                  pMortAge1 = v$bestMorts$M,
                                  iMortMinAgeStart = input$iMortMinAgeStartM,
                                  #leave next as default
                                  iMortMinAgeStop = iMortMinAgeStopM,
                                  fMortMinProp = input$fMortMinPropM,
                                  fMortOldProp = input$fMortOldPropM )
  
  
  rtPlotMortRatesByAge(vpMorts, title="males", col='blue')
  
})   
  
  ## FUNCTIONS used by aspatial tab   ###############################
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  # run aspatial model   #######################
  runModel <- reactive({
    
    cat("in runModel input$days=",input$days,"\n")
    
    if ( input$days > 0 )
    {
      
      #get mortalities from the stability calculation
      pMortF <- v$bestMorts$F
      pMortM <- v$bestMorts$M
      
      #calling rtPhase1Test3  
      #version below puts args into a list so they can be printed elsewhere
#       v$aspatialResults <- rtPhase1Test3(iDays = input$days,
#                                         pMortF = pMortF,
#                                         pMortM = pMortM, 
#                                         propMortAdultDD = input$propMortAdultDD,
#                                         iCarryCap = input$iCarryCap,
#                                         #iMaxAge = input$iMaxAge,      
#                                         propMortLarvaDD = input$propMortLarvaDD,
#                                         propMortPupaDD = input$propMortPupaDD,
#                                         #iStartAges = input$iStartAges,
#                                         iStartAdults = input$iStartAdults, 
#                                         
#                                         #the params below are taken from page1
#                                         iFirstLarva = input$iFirstLarva,
#                                         iInterLarva = input$iInterLarva,
#                                         pMortLarva = input$pMortLarva,  
#                                         pMortPupa = input$pMortPupa,
#                                         
#                                         verbose=FALSE)

            lNamedArgs <<- list(iDays = input$days,
                                        pMortF = pMortF,
                                        pMortM = pMortM, 
                                        propMortAdultDD = input$propMortAdultDD,
                                        iCarryCap = input$iCarryCap,
                                        #iMaxAge = input$iMaxAge,      
                                        propMortLarvaDD = input$propMortLarvaDD,
                                        propMortPupaDD = input$propMortPupaDD,
                                        #iStartAges = input$iStartAges,
                                        iStartAdults = input$iStartAdults, 
                                        
                                        #the params below are taken from page1
                                        iFirstLarva = input$iFirstLarva,
                                        iInterLarva = input$iInterLarva,
                                        pMortLarva = input$pMortLarva,  
                                        pMortPupa = input$pMortPupa,
                                        
                                        verbose=FALSE)
       v$aspatialResults <- do.call(rtPhase1Test3, lNamedArgs)
      
    }  
  })
  
  
  # plot total adult population  ##########################
  output$plotPop <- renderPlot({
    
    #needed to get plot to react when button is pressed
    runModel()
    
    cat("in plotPop input$days=",input$days,"\n")
    
    rtPlotPopAndPupae(v$aspatialResults$dfRecordF, v$aspatialResults$dfRecordM,
                      v$aspatialResults$dfRecordPupaF, v$aspatialResults$dfRecordPupaM)
    
  })  
  

  # print params used  ###############################
  # to test whether values made it from page1 to 2
  output$printParams <- renderPrint({
    
    #needed to get plot to react when button is pressed
    #runModel()
    
    #cat("in printParams mortF=",v$bestMorts$F,"\n")
    cat("R code to repeat this run of the model locally using rtsetse version",
        packageDescription('rtsetse')$Version,
        "\n\n")    
    
    #Code to repeat this run of the model locally
    #copied from rtReportPhase2fromShiny
    sCommand <- "tst <- rtPhase1Test3"
    #this creates a vector of 'name=value,'
    vArgs <- paste0(names(lNamedArgs),"=",lNamedArgs,", ")
    #to remove the final comma & space in args list
    vArgs[length(vArgs)] <- substr(vArgs[length(vArgs)],0,nchar(vArgs[length(vArgs)])-2)
    
    cat( sCommand,"( ",vArgs," )",sep="")
    
    cat( "\n\nrtPlotPopAndPupae(tst$dfRecordF, tst$dfRecordM, tst$dfRecordPupaF, tst$dfRecordPupaM)" )
    
  })    
   
  # plot female age structure   ###############################
  output$plotAgeStructF <- renderPlot({
        
    #needed to get plot to react when button is pressed
    #i'm not quite sure why, i thought it might react to v changing
    runModel()
    
    cat("in plotAgeStructF input$days=",input$days,"\n")
    
    rtPlotAgeStructure(v$aspatialResults$dfRecordF,"Females")
    
  })  

  # plot male age structure  ###############################
  output$plotAgeStructM <- renderPlot({
    
    #needed to get plot to react when button is pressed
    #i'm not quite sure why, i thought it might react to v changing
    runModel()
    
    cat("in plotAgeStructM input$days=",input$days,"\n")
    
    rtPlotAgeStructure(v$aspatialResults$dfRecordM,"Males")
    
  })    
  

  # plot mean age of adults  ###############################
  output$plotMeanAge <- renderPlot({
    
    runModel()
    
    cat("in plotMeanAge input$days=",input$days,"\n")
    
    rtPlotMeanAge(v$aspatialResults$dfRecordF, v$aspatialResults$dfRecordM,title="Mean age of adult flies")
        
  })    
  
  
}) # end of shinyServer()
