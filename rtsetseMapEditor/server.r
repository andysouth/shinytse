#rtsetseMapEditor/ui.r
#andy south 12/08/2014

#for me to deploy online
#library(shinyapps)
#deployApp('rtsetseMapEditor')

library(shiny)
library(raster)

shinyServer(function(input, output) {
  
  #global cached table of raster values
  #to be populated from input file
  #printed & editable in one tab
  #used to update raster plot in another tab
  v <- reactiveValues( cachedTbl = NULL ) 
  #try loading the example data to start
  inFile <- "mapVeg50Text.txt" 
  v$cachedTbl <- read.table(inFile, as.is=TRUE)  
  
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

  
  #read in the input file ####################################################
  readFileConductor <- reactive({ 
    
    inFile <- input$layer
    
    cat("in readFileConductor() inFile:",inFile$datapath,"\n")
    
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


  ### plot raster from loaded text matrix of characters ######
  output$plotTxtChar <- renderPlot({
  
    #making sure of dependency
    v$cachedTbl
    
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
    
    if( is.null(input$layer) & is.null(v$cachedTbl) ) return(NULL)
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
  
  
  
  # table (not editable) of output results ###############
  output$tableTxtChar <- renderTable({
   
#     mapDF <- readTxtChar()
#     mapDF
    v$cachedTbl
    
  }) #end of tableTxtChar      


  # plot an editable table ######################
  output$tbl <- renderHtable({
  
    #browser()
    #making sure of dependency
    v$cachedTbl
    
    cat(paste("in output$tbl class of cachedTbl=",class(v$cachedTbl),"\n"))
    print(v$cachedTbl)
    cat("\n")
    
    #if no changes have been made to the table
    #read the chosen input file
    #check input$layer just to make it reactive to file changes
    #if ( is.null(input$tbl) & !is.null(input$layer) ){
    #check v$cachedTable just to make it reactive to file changes
    #if ( is.null(input$tbl) & !is.null(v$cachedTbl) ){
    if ( is.null(input$tbl) ) {  
      
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
     
    #to plot table    
    v$cachedTbl
  }) #end of output$tbl  


# save file ###########################################
output$saveFile <- downloadHandler(
  
  filename = 'modifiedMap.txt',
  contentType = "text/plain",
  content = function(file) {
    write.table(v$cachedTbl, file, row.names=FALSE, col.names=FALSE, quote=FALSE)
    }
  
  ) #end of output$saveFile


# to load example data
# BUT it doesn't get triggered ????
# loadExData <- reactive( {  
# #loadExData <- function() { 
#   
#   #this is needed for dependency on button
#   input$loadExDataButton
#   
#   #cat("in loadExData exDataLoaded=",exDataLoaded,"\n")
#   #cat("in loadExData input$loadExData=",input$loadExData," exDataLoaded=", exDataLoaded,"\n")
#   cat("in loadExData input$loadExDataButton=",input$loadExDataButton,"\n")
#   
#   
#   #only load if not loaded already
# #   if (input$loadExData) # && !exDataLoaded )
# #   {
#     inFile <- "mapVeg50Text.txt" 
#     
#     v$cachedTbl <<- read.table(inFile, as.is=TRUE)
#     
#     #exDataLoaded <- TRUE
# #   }
#   
#   #cat("in loadExData returning exDataLoaded as", exDataLoaded,"\n")
#   
#   #return(exDataLoaded)
# }) #end of load ex data if a reactive
# #} #end of load ex data if a func


## this is just to test the loadExData button
## this works where the previous one doesn't
# output$testButton <- renderText({
#   
#   #temp test to see if this works in here
#   #it didn't! the data do get loaded, but other listeners don't respond for some reason
#   inFile <- "mapVeg50Text.txt" 
#   v$cachedTbl <<- read.table(inFile, as.is=TRUE)  
#   
#   cat(paste("inoutput$testButton cachedTbl:\n",v$cachedTbl,"\n"))
#   
#   #this sets up a dependency on the button 
#   #& just prints out the num times the button has been pressed
#   input$loadExDataButton
# })

})