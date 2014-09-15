#shinytse4/server.r
#andy south 16/06/2014

#2nd test of phase2 grid & movement

#to run type this in R console
#setwd('C:\\Dropbox\\Ian and Andy\\andy\\shiny\\')
#library(shiny)
#runApp('shinytse4')

library(rtsetse)

library(shiny)
library(raster)
#i don't see why these are needed when they are imported by rtsetse but seems they are
library(ggplot2) 
library(reshape2)
library(plyr)
#library(dplyr)
library(abind) 

#to read in a csv
#inFile <- "top5000.csv" 
#dFglobList <- read.csv(inFile,as.is=TRUE)

## can put functions here


#run the model once before start with minimal params
#to initiate the global gridResults object
#also accessed from rtReportPhase2fromShiny.Rmd
gridResults <- rtPhase2Test3(nRow=1,nCol=1,iDays=1,report = NULL)

#the gridResults is structured like this
#num [1:5, 1:100, 1:100, 1:2, 1:7] 0 0 0 0 0 0 0 0 0 0 ...
#..$ : chr [1:5] "day0" "day1" "day2" "day3" ...
#..$ : chr [1:100] "x1" "x2" "x3" "x4" ...
#..$ : chr [1:100] "y1" "y2" "y3" "y4" ...
#..$ : chr [1:2] "F" "M"
#..$ : chr [1:7] "age1" "age2" "age3" "age4" ...


shinyServer(function(input, output) {

  
  #in shinytse3 the output is different to shinytse2
  #it's now a multi-dimensional array
  #[day,x,y,ages] just for F to start
  v <- reactiveValues( gridResults=gridResults ) 
  
  # run grid model  ##########################  
  runGridModel <- reactive({
    
    cat("in runGridModel input$iDays=",input$iDays,"\n")
    
    #without mention of input$ params in here
    #this doesn't run even when the Run button is pressed
    #so this is a temporary workaround
    if ( input$iDays > 0 )
    {

      v$gridResults <- rtPhase2Test3(nRow = input$nRow,
                               nCol = input$nCol,
                               pMove = input$pMove,
                               iDays = input$iDays,
                               pMortF = input$pMortF,
                               pMortM = input$pMortM, 
                               pMortPupa = input$pMortPupa,
                               #iPupaDensThresh = input$iPupaDensThresh,
                               #fSlopeDD = input$fSlopeDD,
                               iCarryCap = input$iCarryCap,
                               iStartAges = input$iStartAges,
                               iStartAdults = input$iStartAdults )   
                               #iStartPupae = "sameAsAdults",
                               #iMaxAge = 120,
                               #report = NULL )
                               
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
  


# plotting pop maps for MF ###############################
output$plotMapDays <- renderPlot({
  
  #needed to get plot to react when button is pressed
  runGridModel()
  
  cat("in plotMapDays input$iDays=",input$iDays,"\n")
  
  rtPlotMapPop(v$gridResults, days='all', ifManyDays = 'spread', sex='MF')
})  


# plotting pop maps for F ###############################
# (not used currently)
output$plotMapDaysF <- renderPlot({
  
  #needed to get plot to react when button is pressed
  runGridModel()
  
  cat("in plotMapDaysF input$iDays=",input$iDays,"\n")
  
  rtPlotMapPop(v$gridResults, days='all', ifManyDays = 'spread', sex='F')
})  


# plot pop map for final day ###############################
output$plotMapFinalDay <- renderPlot({
  
  #needed to get plot to react when button is pressed
  runGridModel()
  
  cat("in plotMapFinalDay input$iDays=",input$iDays,"\n")
  
  rtPlotMapPop(v$gridResults, days='final', sex='MF')
   
})  


# plot adult popn & M&F for whole grid ###############################
output$plotPopGrid <- renderPlot({
  
  #needed to get plot to react when button is pressed
  #i'm not quite sure why, i thought it might react to v changing
  runGridModel()
  
  cat("in plotPopGrid input$iDays=",input$iDays,"\n")

  rtPlotPopGrid(v$gridResults,"Adults") 
  #print( rtPlotPopGrid(v$gridResults,"Adult Flies") )
  
  
})  


# plot mean age of adults ###############################
output$plotMeanAgeGrid <- renderPlot({
  
  runGridModel()
  
  cat("in plotMeanAgeGrid input$iDays=",input$iDays,"\n")
  
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
    filenameRmd <- 'rtReportPhase2fromShiny.Rmd'
    
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
output$testInputs <- renderText({
  
  #needed to get plot to react when button is pressed
  #i'm not quite sure why, i thought it might react to v changing
  runGridModel()
  
  cat("in testInputs() input$iDays=",input$iDays,"\n")
  
  lNamedArgs <- isolate(reactiveValuesToList(input))
  
  #print(unlist())
  
  #names(lNamedArgs)[ names(lNamedArgs)!='iStartAges' ]
  #cool the below works to omit 2 sets of vars, can use similar code in the report Rmd
  names(lNamedArgs)[ substring(names(lNamedArgs),1,2)!='iS' & substring(names(lNamedArgs),1,2)!='pM' ]
  
})  


# plot age struct summed M&F whole grid ###############################
output$plotAgeStruct <- renderPlot({
  
  #needed to get plot to react when button is pressed
  runGridModel()
  
  cat("in plotAgeStruct input$iDays=",input$iDays,"\n")
  
  rtPlotAgeStructure(v$gridResults,"M & F")
  
})  


  
  
}) # end of shinyServer()
