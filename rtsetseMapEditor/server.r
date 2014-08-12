#rtsetseMapEditor/ui.r
#andy south 12/08/2014

library(shiny)
library(raster)

shinyServer(function(input, output) {
  
  cachedEditable <- NULL
  
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
    
    inFile <- input$layer
    
    if (is.null(inFile)) return(NULL)
    
    map <- read.table(inFile$datapath, as.is=TRUE)
    
    #all these steps do seem to be necessary to convert to a numeric matrix then raster
    mapMatrix <- as.matrix(map)
    mapFactor <- as.factor(mapMatrix)
    mapNumeric <- as.numeric(mapFactor)
    mapMatrixNumeric <- matrix(mapNumeric,nrow=nrow(mapMatrix))
    mapRaster <- raster(mapMatrixNumeric)
    
    plot(mapRaster)    
    
  }) #end of plotTxtChar  
  
  ###############################
  # plot table of output results
  output$tableTxtChar <- renderTable({
    
    inFile <- input$layer
    
    if (is.null(inFile)) return(NULL)
    
    map <- read.table(inFile$datapath, as.is=TRUE)
    
    map
    
  }) #end of tableTxtChar      


  #################################
  # plot an editable table ########
  output$tbl <- renderHtable({
  
    inFile <- input$layer
    
    if (is.null(inFile)) return(NULL)
    
    map <- read.table(inFile$datapath, as.is=TRUE)
    
    cachedEditable <- map
    
    map
  }) #end of output$tbl  
  
})