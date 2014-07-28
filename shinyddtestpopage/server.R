#shinyddtestpopage/server.r
#andy south 19/05/2014

#to look at aspatial density dependence

#to run type this in R console
#setwd('C:\\Dropbox\\Ian and Andy\\andy\\shiny\\')
#library(shiny)
#runApp('shinyddtestpopage')

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

      #create empty vector
      #v$output <- rep(NA,input$days)
      #v$output <- c(1:input$days)  
      vPop <- c(1:input$days)  
      #now make a matrix so it can be age structured
      #iMaxAge <- 3
      
      mPop <- matrix(0, ncol=input$iMaxAge, nrow=input$days)
          
      
      #vPop[1] <- input$iStartAdults
      #fill all ages
      mPop[1,] <- input$iStartAdults
      
      
      #density dependent using input params
      #slopeb <- (input$pBirth-input$pMortF)/input$iCarryCap       
      
      #if the slopeb param is not set correctly the popn doesn't stabilise at K      
      
      #cat("birth-mort=",(input$pBirth-input$pMortF)," slopeb=",slopeb,"\n")
      
      for( day in 2:input$days ) {
               
        #density independent growth
        #gets replaced later

        
        #ageing
        vAges <- mPop[day-1,]
        mPop[day,] <- c( 0, vAges[-length(vAges)] )
        
        #births only happen at age 1 !
        mPop[day,1] <- sum(mPop[day-1,])*input$pBirth

        #mortality including on newborns
        mPop[day,] <- mPop[day,]*(1-input$pMortF)        
          
          
        #calculate slope of density dependence
        #based on pop growth from previous day
        fPopNow <- sum(mPop[day,])
        fPopPre <- sum(mPop[day-1,])
        fGrowthRate <- ((fPopNow-fPopPre)/fPopPre)
        slopeb <- fGrowthRate /input$iCarryCap 
             
                
        #density dependent mortality
        pMortFDDBit <- slopeb*fPopPre
        pMortFDDTot <- input$pMortF + pMortFDDBit    
        
        #trying to get it to work when mort just applied to 1 age class
        #I could try to stabilise by multiplying dd component by the number of age classes
        #pMortFDDBit <- input$iMaxAge*pMortFDDBit  
        
        #pMortFDD can't be alllowed to be >1
        if( pMortFDDTot > 1 ){
          
          pMortFDDBit <- 1-input$pMortF
          cat("pMortFDDBit after age correction ",pMortFDDBit,"\n")
        } 
        
        
        #cat("day",day,"birth-mort=",(input$pBirth-input$pMortF),"pop growth ",((vPop[day]-vPop[day-1])/vPop[day-1])," slopeb=",slopeb,"pMort bef,aft:",input$pMortF,",",pMortFDD,"\n")
        cat("day",day,"popPre:",fPopPre,"growth=",fGrowthRate," slopeb=",slopeb,"pMort bef,aft:",input$pMortF,",",pMortFDDTot,"\n")
        #cat("day",day,"birth-mort=",(input$pBirth-input$pMortF),"mPop",mPop,"\n")#,"pop growth ",((vPop[day]-vPop[day-1])/vPop[day-1])," slopeb=",slopeb,"pMort bef,aft:",input$pMortF,",",pMortFDD,"\n")
        
        
        #applying density dependent mortality
        
        #just subtracting the extra DD mortality
        mPop[day,] <- mPop[day,] - mPop[day,]*pMortFDDBit  
        #the above works !

        #what happens if dd mortality is applied to just one age class
        #mPop[day,1] <- mPop[day,1] - mPop[day,1]*pMortFDDBit     
        #it now does control the popn but not in the same way

        #Will it still stabilise at the given K if mortality varies by age ??
        


        #perhaps calculating proportion of pop in the regulated age class would help
        #fProp <- mPop[day-1,1] / sum(mPop[day-1,])
        #cat("Proportion age1:",fProp,"\n")



        
        
        
      }
      
      #summed pop for each day
      v$output <- apply(mPop,1,sum)
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
