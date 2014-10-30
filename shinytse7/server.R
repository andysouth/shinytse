#shinytse7/server.r
#andy south 15/09/2014


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


## can put functions here


#run the model once just one day before start to set up output structure
#output <- rtPhase1Test2(iDays=1, verbose=FALSE)
bestMorts <- rtMortalityStableSeek(plot=FALSE)
aspatialResults <- rtPhase1Test3(iDays=1, verbose=FALSE)
lNamedArgsAspatial <- NULL #to hold argList for aspatial model  
gridResults <- rtPhase2Test3(nRow=1,nCol=1,iDays=1,report = NULL)
lNamedArgsGrid <- NULL #to hold argList for grid model  

#shinyServer(function(input, output) {
#10/10/14 adding session arg for progress bar experiments
shinyServer(function(input, output, session) {
  
  #I only want to run model when a button is pressed
  
  #v <- reactiveValues( output=output ) 
  v <- reactiveValues( bestMorts=bestMorts,
                       aspatialResults=aspatialResults,
                       gridResults=gridResults,
                       cachedTbl = NULL, 
                       dfRasterAtts = NULL) 
  
  #load an example CC map to start
  #inFile <- "mapVeg50Text.txt" 
  #inFile <- "exampleCCmap4x4.txt"
  #now needs to be a character, changed to one of the veg maps
  inFile <- "vegUgandaSETorr1km.txt"
  v$cachedTbl <- read.table(inFile, as.is=TRUE)  
  
  #vegetation names & mortalities could be read from a file
  v$dfRasterAtts <- data.frame( code = c("D","T","O","S","B","G","N"), 
                              name = c("Dense Forest","Thicket","Open Forest","Savannah","Bush","Grass","No-go area"),
                              mortality = c(100,200,300,300,300,300,999),
                              stringsAsFactors = FALSE )
  
  
  # run mortality seeking  ##########################
  runMortSeek <- reactive({
 
    cat("in runMortSeek button=",input$aButtonMortality,"\n")
    
    #changing from a submitButton to an actionButton
    #add dependency on the button
    if ( input$aButtonMortality == 0 ) return()
    #isolate reactivity of other objects
    isolate({
    
    #cat("in runMortSeek\n") #,input$days,"\n")
      
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
    }) #end isolate            
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
    
    cat("in runModel button=",input$aButtonAspatial,"\n")
    
    #changing from a submitButton to an actionButton
    #add dependency on the button
    if ( input$aButtonAspatial == 0 ) return()
    #isolate reactivity of other objects
    isolate({
      
    
    if ( input$days > 0 )
    {
      
      #get mortalities from the stability calculation
      pMortF <- v$bestMorts$F
      pMortM <- v$bestMorts$M
      
      #put args into a global list (<<-) so they can also be printed elsewhere
      lNamedArgsAspatial <<- list(iDays = input$days,
                                  pMortF = pMortF,
                                  pMortM = pMortM, 
                                  iCarryCap = input$iCarryCap,
                                  fStartPopPropCC = input$fStartPopPropCC,
                                  propMortAdultDD = input$propMortAdultDD,
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

       #run the model with the list of args
       v$aspatialResults <- do.call(rtPhase1Test3, lNamedArgsAspatial)

      #old way of doing before args were put into a list  
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
      
    } 
    }) #end isolate 
  })
  
  
  # plot total adult population  ##########################
  output$plotPop <- renderPlot({
    
    #needed to get plot to react when button is pressed
    runModel()
    
    cat("in plotPop input$days=",input$days,"\n")
    
    rtPlotPopAndPupae(v$aspatialResults$dfRecordF, v$aspatialResults$dfRecordM,
                      v$aspatialResults$dfRecordPupaF, v$aspatialResults$dfRecordPupaM)
    
  })  
  

  # print params used in aspatial model ###############################
  output$printParamsAspatial <- renderPrint({
    
    #needed to get plot to react when button is pressed
    runModel()
    
    cat("R code to repeat this run of the model locally using rtsetse version",
        packageDescription('rtsetse')$Version,
        "\n\n")    
    
    #Code to repeat this run of the model locally
    #copied from rtReportPhase2fromShiny
    sCommand <- "tst <- rtPhase1Test3"
    #this creates a vector of 'name=value,'
    vArgs <- paste0(names(lNamedArgsAspatial),"=",lNamedArgsAspatial,", ")
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


## FUNCTIONS used by file loading tab   ###############################
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#these functions came from rtsetseMapEditor

# read input file -----
readFileConductor <- reactive({ 

  
  if (is.null(input$fileMap)) return(NULL)
  
  #an internal file will be a character
  if ( class(input$fileMap )=='character')
    inFile <- input$fileMap
  #if a local file it will be a dataframe and need to get datapath
  else
    inFile <- input$fileMap$datapath    
  
  cat("in readFileConductor() inFile:",inFile,"\n")
  
  
  #v$cachedTbl <<- read.table(inFile$datapath, as.is=TRUE)

  #converting to a matrix and modifying dimenions so columns aren't labelled V1 etc
  #problems with reactivity so trying to load as a local var first
  mat <- as.matrix( read.table(inFile, as.is=TRUE) )
  #sort dimnames that appear in file table
  #reverse y so that 1 is at lower left
  #I could use this to make the lables correspond to latlons in future
  dimnames(mat)[[1]] <- c(nrow(mat):1)
  dimnames(mat)[[2]] <- c(1:ncol(mat))    
  
  #set the global var
  v$cachedTbl <<- mat
  
   
  #  v$cachedTbl <<- readTxtChar()
})

# getStoredMapNames NOT currently used----
output$getStoredMapNames <- reactive({
  
  filenames <- list.files() 
  #only return text files
  names(filenames) <- gsub("\\.txt", "", filenames)
  return(filenames)
})



### plot raster from a loaded text matrix of characters -----
output$plotLoadedMap <- renderPlot({
  
  #browser()
  #cat("in plotLoadedMap fileMap$datapath=",input$fileMap$datapath)
  
  if( is.null(input$fileMap) & is.null(v$cachedTbl) ) return(NULL)
  #else v$cachedTbl <<- readTxtChar() #read from the inputFile
  else readFileConductor() #read from the inputFile if it hasn't been read yet
  #}
  
  
  #changing from a submitButton to an actionButton
  #add dependency on the button
  if ( input$aButtonMap < 0 ) return()
  #isolate reactivity of other objects
  isolate({
  
  
  mapMatrix <- as.matrix(v$cachedTbl)
  
  rtPlotMapVeg(mapMatrix, cex=1.2, labels=v$dfRasterAtts$name)
  
  }) #end isolate 
  
  #old way
  #all these steps do seem to be necessary to convert to a numeric matrix then raster
  #mapMatrix <- as.matrix(v$cachedTbl)
  #mapRaster <- raster(mapMatrix)    
  #set extents for plotting (otherwise they go from 0-1)
  #this also ensures that cells maintain square aspect ratio 
  #extent(mapRaster) <- extent(c(0, ncol(mapRaster), 0, nrow(mapRaster))) 
  #   plot(mapRaster)    
  
  #will spplot work with shiny ? YES
  #spplot(mapRaster)
    
}) #end of plotLoadedMap  


# table of raster attributes (vegetation) -----
output$tableRasterAtts <- renderTable({
  
  #create a test dataframe
#   dF <- data.frame( code = c("D","T"),
#                     name = c("Dense Forest","Thicket"),
#                     mortality = c(100,200)
#                     )
#   dF
  
  cat("in tableRasterAtts\n")
  
  v$dfRasterAtts
  
}) #end tableRasterAtts 


# editable raster attributes ######################
output$editableRasterAtts <- renderHtable({

  #browser()
  
  #if no changes have been made to the table
  #then how did we get here ?
  #I might need to check the loaded grid
  if ( is.null(input$editableRasterAtts) ) {  
    
    #readFileConductor()
    cat("in editableRasterAtts null\n")
    
  } else {
    #save edited table changes 
    cat("in editableRasterAtts saving changes\n",unlist(input$editableRasterAtts),"\n")
    v$dfRasterAtts <<- input$editableRasterAtts
  }
  
  v$dfRasterAtts
  
}) #end editableRasterAtts 
  

# table of inFile (not editable) -----
output$tableNonEdit <- renderTable({
  
  if( is.null(input$fileMap) & is.null(v$cachedTbl) ) return(NULL)
  #else v$cachedTbl <<- readTxtChar() #read from the inputFile
  else readFileConductor() #read from the inputFile if it hasn't been read yet
  #}
  
  #     mapDF <- readTxtChar()
  #     mapDF
  v$cachedTbl
  
}) #end of tableNonEdit 


## FUNCTIONS used by simple grid tab   ###############################
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#these functions came from shinytse4

  # run grid model  ##########################  
  runGridModel <- reactive({
    
    cat("in runModel button=",input$aButtonGrid,"\n")
    
    #changing from a submitButton to an actionButton
    #add dependency on the button
    if ( input$aButtonGrid == 0 ) return()
    #isolate reactivity of other objects
    isolate({
    
    
    #cat("in runGridModel input$daysGridModel=",input$daysGridModel,"\n")
    
    #without mention of input$ params in here
    #this doesn't run even when the Run button is pressed
    if ( input$daysGridModel > 0 )
    {
      
      #get mortalities from the stability calculation
      pMortF <- v$bestMorts$F
      pMortM <- v$bestMorts$M
      
      #put args into a global list (<<-) so they can also be printed elsewhere
      lNamedArgsGrid <<- list(
                              #nRow = input$nRow,
                              #nCol = input$nCol,
                              pMove = input$pMove,
                              iDays = input$daysGridModel,
                              pMortF = pMortF,
                              pMortM = pMortM, 
                              pMortPupa = input$pMortPupa,
                              fStartPopPropCC = input$fStartPopPropCC,
                              iCarryCap = input$iCarryCap,
                              #iStartAges = input$iStartAges,
                              #iStartAdults = input$iStartAdults )    
                              propMortAdultDD = input$propMortAdultDD,
                              #iMaxAge = input$iMaxAge,
                              iFirstLarva = input$iFirstLarva,
                              iInterLarva = input$iInterLarva,
                              pMortLarva = input$pMortLarva,        
                              propMortLarvaDD = input$propMortLarvaDD,
                              propMortPupaDD = input$propMortPupaDD )                        
                              #verbose=FALSE)
      
      #run the model with the list of args
      #v$gridResults <- do.call(rtPhase2Test3, lNamedArgsGrid)
      
      #now I want to change what is run according to checkbox
      #but difficulty that the args for the functions are different
      #as a temporary workaround can use formals to get the arg of a function
      
      if ( input$testSpread )
        v$gridResults <- do.call(rtPhase2Test3, lNamedArgsGrid)
      else
      {
        #just use those args that are in the arg list for rtPhase5Test
        #!!BEWARE this is a temporary hack !!
        lNamedArgsGrid <- lNamedArgsGrid[ which(names(lNamedArgsGrid) %in% names(formals("rtPhase5Test")))]
        
        #add the matrix containing CCs to the arg list
        lArgsToAdd <- list(mCarryCapF=as.matrix(v$cachedTbl))
        #lArgsToAdd <- list(mCarryCapF=deparse(as.matrix(v$cachedTbl)))        
        
        #!BEWARE 
        #For some reason necessary to assign first then globally assigning after
        lNamedArgsGrid <- c(lArgsToAdd,lNamedArgsGrid)
        lNamedArgsGrid <<- lNamedArgsGrid
        
        cat("in runGridModel() calling rtPhase5Test with args:",unlist(lNamedArgsGrid))
        
        v$gridResults <- do.call(rtPhase5Test, lNamedArgsGrid) 
        
        #now deparse (conv to text) the first arg (the matrix) for potential pasting by user later
        #!BEWARE deparse has max width.cutoff of 500, if this is exceeded the var gets put
        #into multiple elements of a vector and the pasted command doesn't work
        #default width.cutoff is 60
        lArgsToAdd <- list(mCarryCapF=deparse(as.matrix(v$cachedTbl), width.cutoff=500 ))
        #lArgsToAdd <- list(mCarryCapF=eval(parse(text=deparse(as.matrix(v$cachedTbl)))))
        lNamedArgsGrid[1] <- lArgsToAdd
        lNamedArgsGrid <<- lNamedArgsGrid
        
      }
        
        
        
      
#       #old way of doing before args put into a list
#       v$gridResults <- rtPhase2Test3(nRow = input$nRow,
#                                      nCol = input$nCol,
#                                      pMove = input$pMove,
#                                      iDays = input$daysGridModel,
#                                      pMortF = pMortF,
#                                      pMortM = pMortM, 
#                                      pMortPupa = input$pMortPupa,
#                                      fStartPopPropCC = input$fStartPopPropCC,
#                                      iCarryCap = input$iCarryCap,
#                                      #iStartAges = input$iStartAges,
#                                      #iStartAdults = input$iStartAdults )    
#                                      propMortAdultDD = input$propMortAdultDD,
#                                      #iMaxAge = input$iMaxAge,
#                                      iFirstLarva = input$iFirstLarva,
#                                      iInterLarva = input$iInterLarva,
#                                      pMortLarva = input$pMortLarva,        
#                                      propMortLarvaDD = input$propMortLarvaDD,
#                                      propMortPupaDD = input$propMortPupaDD )                        
#                                      #verbose=FALSE)
      
    }
    
    }) #end isolate     
  }) # end runGridModel 
  
  
  
  # plotting pop maps for MF ###############################
  output$plotMapDays <- renderPlot({
    
    #8/10/14 trying adding a dependency on new action button
    #input$actionGridModel
    
    #experimenting with progress bar
    #this is the trickier way of doing via the API
    #because I may be able to pass the object to external functions
    progress <- shiny::Progress$new(session, min=1, max=15)
    on.exit(progress$close())   
    progress$set(message = 'Calculation in progress')#,
    #             detail = 'This may take a while...')
    progress$set(value = 15) #setting progress bar to max just to show it's doing something
    #ideally I might pass the progress object to the rtsetse functions that are taking the time
    
    
    #needed to get plot to react when button is pressed
    runGridModel()
    
    cat("in plotMapDays input$daysGridModel=",input$daysGridModel,"\n")
    
    rtPlotMapPop(v$gridResults, days='all', ifManyDays = 'spread', sex='MF')
  })  
  
  
  # plotting pop maps for F ###############################
  # (not used currently)
  output$plotMapDaysF <- renderPlot({
    
    #needed to get plot to react when button is pressed
    runGridModel()
    
    cat("in plotMapDaysF input$daysGridModel=",input$daysGridModel,"\n")
    
    rtPlotMapPop(v$gridResults, days='all', ifManyDays = 'spread', sex='F')
  })  
  
  
  # plot pop map for final day ###############################
  output$plotMapFinalDay <- renderPlot({
    
    #needed to get plot to react when button is pressed
    runGridModel()
    
    cat("in plotMapFinalDay input$daysGridModel=",input$daysGridModel,"\n")
    
    rtPlotMapPop(v$gridResults, days='final', sex='MF')
    
  })  
  
  
  # plot adult popn & M&F for whole grid ###############################
  output$plotPopGrid <- renderPlot({
    
    #needed to get plot to react when button is pressed
    #i'm not quite sure why, i thought it might react to v changing
    runGridModel()
    
    cat("in plotPopGrid input$daysGridModel=",input$daysGridModel,"\n")
    
    rtPlotPopGrid(v$gridResults,"Adults") 
    #print( rtPlotPopGrid(v$gridResults,"Adult Flies") )
    
    
  })  
  
  
  # plot mean age of adults ###############################
  output$plotMeanAgeGrid <- renderPlot({
    
    runGridModel()
    
    cat("in plotMeanAgeGrid input$daysGridModel=",input$daysGridModel,"\n")
    
    rtPlotMeanAgeGrid(v$gridResults)
    
  })  
  
  
  # download a report #########################################
  # code from: http://shiny.rstudio.com/gallery/download-knitr-reports.html
  # the report format is set by a Rmd file in the shiny app folder
  # note this doesn't use the reporting function from rtsetse
  output$downloadReport <- downloadHandler(
    #this was how to allow user to choose file
    #   filename = function() {
    #     paste('my-report', sep = '.', switch(
    #       input$format, PDF = 'pdf', HTML = 'html', Word = 'docx'
    #     ))
    #   },
    
    # name of the report file to create
    filename = "rtsetsePhase2Report.html",
    
    content = function(file) {
      
      #name of the Rmd file that sets what's in the report
      filenameRmd <- 'rtReportPhase2fromShinytse7.Rmd'
      
      src <- normalizePath(filenameRmd)
      
      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, filenameRmd)
      
      library(rmarkdown)
      
      #this allowed rendering in pdf,html or doc
      #     out <- render(filenameRmd, switch(
      #       input$format,
      #       PDF = pdf_document(), HTML = html_document(), Word = word_document()
      #     ))
      
      #rendering in html only
      out <- render(filenameRmd, html_document())    
      
      file.rename(out, file)
    }
  ) #end downloadReport
  
  
  # test plotting of inputs ###############################
  #not currently used
  output$testInputs <- renderText({
    
    #needed to get plot to react when button is pressed
    runGridModel()
    
    cat("in testInputs() input$daysGridModel=",input$daysGridModel,"\n")
    
    #this gets all of the reactive values
    #problem with that is that not all of them apply to the grid model
    lNamedArgs <- isolate(reactiveValuesToList(input))
    
    #names(lNamedArgs)[ names(lNamedArgs)!='iStartAges' ]
    #below works to omit 2 sets of vars, can use similar code in the report Rmd
    names(lNamedArgs)[ substring(names(lNamedArgs),1,2)!='iS' & substring(names(lNamedArgs),1,2)!='pM' ]
    
  })  
  
  
  # plot age struct summed M&F whole grid ###############################
  output$plotAgeStructGrid <- renderPlot({
    
    #needed to get plot to react when button is pressed
    runGridModel()
    
    cat("in plotAgeStructGrid input$daysGridModel=",input$daysGridModel,"\n")
    
    rtPlotAgeStructure(v$gridResults,"M & F summed for whole grid")
    
  })  

# print params used in simple grid model ###############################
output$printParamsGrid <- renderPrint({
  
  #needed to get plot to react when button is pressed
  runGridModel()
  
  cat("R code to repeat this run of the model locally using rtsetse version",
      packageDescription('rtsetse')$Version,
      "\n\n")    
  
  
  #different function is run if the test spread checkbox is selected
  if ( input$testSpread )
  {
    sCommand <- "tst <- rtPhase2Test3"
    #this creates a vector of 'name=value,'
    vArgs <- paste0(names(lNamedArgsGrid),"=",lNamedArgsGrid,", ")    
  } else
  {
    sCommand <- "tst <- rtPhase5Test"
    
    #lArgsToAdd <- list(mCarryCapF=deparse(as.matrix(v$cachedTbl)))        
    #lNamedArgsGrid <- c(lArgsToAdd,lNamedArgsGrid)
    
    #hack to add parse to the first argument
    lNamedArgsGrid[1] <- paste0("eval(parse(text=\'",lNamedArgsGrid[1],"\'))")
    
    #browser()
    
    #this creates a vector of 'name=value,'
    vArgs <- paste0(names(lNamedArgsGrid),"=",lNamedArgsGrid,", ") 
    #when functions start using map files
    #it's less easy to make the code reproducible
    #use dput() to pass a copy of the matrix from a file
    #ugly but functional
    #toAdd <- paste0("mCarryCapF=",dput(v$cachedTbl))
    #vArgs <- paste0(toAdd, ",", vArgs)  


  }

  #to remove the final comma & space in args list
  vArgs[length(vArgs)] <- substr(vArgs[length(vArgs)],0,nchar(vArgs[length(vArgs)])-2)
  
  cat( sCommand,"( ",vArgs," )",sep="")
  
  cat( "\n\n#to plot some results \nrtPlotMapPop(tst)" )
  
})    

# display values of input for testing ###############################
output$testInputVals <- renderText({

  #needed to get plot to react when button is pressed
  runGridModel()
  
  #browser()
  lNamedArgs <- isolate(reactiveValuesToList(input))   
  namedArgs <- unlist(lNamedArgs) 
  paste0(names(namedArgs),"=",namedArgs)
  
  
}) #end of testInputVals 

  
}) # end of shinyServer()
