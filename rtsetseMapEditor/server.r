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
#   output$plotAsc <- renderPlot({
#     
#     inFile <- input$layer
#     
#     if (is.null(inFile)) return(NULL)
#     
#     rast <- raster(inFile$datapath)
#     
#     plot(rast) 
#   }) #end of plotAsc

  ####################################################
  #a conductor to read in the input file
  readFileConductor <- reactive({ 
    
    inFile <- input$layer
    
    if (is.null(inFile)) return(NULL)
    
    v$cachedTbl <<- read.table(inFile$datapath, as.is=TRUE)
        
    #  v$cachedTbl <<- readTxtChar()
    
    })

#   ################################################
#   ### read a file of a text matrix of characters return dataframe ###
#   readTxtChar <- function(){
#     
#     inFile <- input$layer
#     
#     if (is.null(inFile)) return(NULL)
#     
#     mapDF <- read.table(inFile$datapath, as.is=TRUE)
#     
#     #save to global
#     v$cachedTbl <<- mapDF
#     
#     mapDF  
#     
#   } #end of readTxtChar  


  ################################################
  ### plot raster from a loaded text matrix of characters ###
  output$plotTxtChar <- renderPlot({
        
#     mapDF <- readTxtChar()   
#     if (is.null(mapDF)) return(NULL)

    
    # BEWARE reactivity here is tricky
    #I only want to reload the file if the input has changed
    #a change in v$cachedTbl will also trigger this function
    #in that case I don't want to call readTxtChar()
    
    #?is there a hasChanged type method in shiny ?
    #seems not.

    #this line stopped loading of a 2nd map
    #if (is.null(v$cachedTbl)) {
    
    #browser()
    
    if( is.null(input$layer)) return(NULL)
      #else v$cachedTbl <<- readTxtChar() #read from the inputFile
      else readFileConductor() #read from the inputFile if it hasn't been read yet
    #}
    
    #all these steps do seem to be necessary to convert to a numeric matrix then raster
    #mapMatrix <- as.matrix(mapDF)
    mapMatrix <- as.matrix(v$cachedTbl)
    mapFactor <- as.factor(mapMatrix)
    mapNumeric <- as.numeric(mapFactor)
    mapMatrixNumeric <- matrix(mapNumeric,nrow=nrow(mapMatrix))
    mapRaster <- raster(mapMatrixNumeric)
    
    plot(mapRaster)    
    
  }) #end of plotTxtChar  
  
  
  
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
  
    #browser()
    
    cat(paste("in output$tbl\n",input$tbl,"\n"))
    
 
    #if no changes have been made to the table
    #read the chosen input file
    #check input$layer just to make it reactive to file changes
    if ( is.null(input$tbl) & !is.null(input$layer) ){
    #check v$cachedTable just to make it reactive to file changes
    #if ( is.null(input$tbl) & !is.null(v$cachedTbl) ){
      
      readFileConductor()
      #mapDF <- readTxtChar()
      #temp test
      #mapDF <- data.frame((1:5))
      
    } else {
      #save edited table changes 
      #mapDF <- input$tbl
      v$cachedTbl <<- input$tbl
    }
    
#     #save changes back to global
#     v$cachedTbl <<- mapDF
#     #to display table in plot tab
#     mapDF
        
    v$cachedTbl
  }) #end of output$tbl  

###########################################
# to save file
output$saveFile <- downloadHandler(
  
  filename = 'modifiedMap.txt',
  contentType = "text/plain",
  content = function(file) {
    write.table(v$cachedTbl, file, row.names=FALSE, col.names=FALSE, quote=FALSE)
    }
  
  ) #end of output$saveFile

})