#rtsetseMapEditor/ui.r
#andy south 12/08/2014

library(shiny)
library(raster)

shinyServer(function(input, output) {
  
  #global cached table of raster values
  #to be populated from input file
  #printed & editable in one tab
  #used to update raster plot in another tab
  v <- reactiveValues( cachedTbl = NULL ) 
  #cachedTbl <- NULL
  
  #####################################
  ### plot raster from a loaded gridAscii file ###
  output$plotAsc <- renderPlot({
    
    inFile <- input$layer
    
    if (is.null(inFile)) return(NULL)
    
    rast <- raster(inFile$datapath)
    
    plot(rast) 
  }) #end of plotAsc

  ################################################
  ### plot raster from a loaded text matrix of characters ###
  output$plotTxtChar <- renderPlot({
    
    mapDF <- readTxtChar()
    
    if (is.null(mapDF)) return(NULL)
    
    #all these steps do seem to be necessary to convert to a numeric matrix then raster
    mapMatrix <- as.matrix(mapDF)
    mapFactor <- as.factor(mapMatrix)
    mapNumeric <- as.numeric(mapFactor)
    mapMatrixNumeric <- matrix(mapNumeric,nrow=nrow(mapMatrix))
    mapRaster <- raster(mapMatrixNumeric)
    
    plot(mapRaster)    
    
  }) #end of plotTxtChar  

  ################################################
  ### read a file of a text matrix of characters return dataframe ###
  readTxtChar <- function(){
    
    inFile <- input$layer
    
    if (is.null(inFile)) return(NULL)
    
    mapDF <- read.table(inFile$datapath, as.is=TRUE)
    
    #save to global
    v$cachedTbl <<- mapDF
    
    mapDF  
    
  } #end of readTxtChar    
  
  
  ###############################
  # table (not editable) of output results
  output$tableTxtChar <- renderTable({
   
#     mapDF <- readTxtChar()
#     mapDF
    v$cachedTbl
    
  }) #end of tableTxtChar      


  #################################
  # plot an editable table ########
  output$tbl <- renderHtable({
  
    #if no changes have been made to the table
    #read the chosen input file
    
    #browser()
    
    if (is.null(input$tbl)){
      #mapDF <- readTxtChar()
      #temp test
      mapDF <- data.frame((1:5))
      
    } else {
      #save edited table changes 
      mapDF <- input$tbl
    }
    
    #save changes back to global
    v$cachedTbl <<- mapDF
    #to display table in plot tab
    mapDF
  }) #end of output$tbl  
  
})