#andyHatTrickPlaying.r

#andy south 21/3/14

#plays with & visualises the outputs from Alex's Hat-trick code

library(raster)

#can easily create a single raster layer
rst <- raster(pop.grid[[2]])
plot(rst)

#fails trying to create a rasterStack from a list of matrices
#rasterStack <- stack(pop.grid)
#Error in .local(x, ...) : 
#  Arguments should be Raster* objects or filenames

#probably I need to convert each element to a raster first

#lapply returns a list of the same length as X, each element of 
#which is the result of applying FUN to the corresponding element of X

listRast <- lapply(pop.grid, raster)
rasterStack <- stack(listRast)
# coolio works !
x11()
plot(rasterStack)
#plot(rasterStack,legend=FALSE)

#find a way to keep the colourschemes the same for all layers
library(rasterVis)
levelplot(rasterStack)

#shows very negative values in layer 11??

#function to create a raster stack from a list of matrices
rStackCreate <- function( matrixList )
{
  library(raster)
  listRast <- lapply( matrixList, raster)
  rasterStack <- stack(listRast)
  invisible(rasterStack)
}

#these are the flies i think
rsPop <- rStackCreate(pop.grid)
rsInfection <- rStackCreate(infection.grid)

plot(rsPop)
plot(rsInfection)

  
image(hab.grid) #the habitat map

#getting at data from cell.popn
#list[x]of lists[y] of matrices[max.age][3]
#note it's only for current day
#so I couldn't use it to look at pop over time
#but maybe I could use it to record pop over time

#to give pop by age & infection in one cell
#note they are not integers ?
cell.popn[[1]][[1]]
#how to sum uninfected for the whole grid
#uninfected for 1 cell by age
cell.popn[[1]][[1]][,2]
#infected for 1 cell by age
cell.popn[[1]][[1]][,3]

#To get at Un,Inc,Inf
popByAgeUn <- popByAgeInc <- popByAgeInf <- 0

for(i in 1:length(cell.popn)){
  for(j in 1:length(cell.popn)){
    popByAgeUn <- popByAgeUn + cell.popn[[i]][[j]][,1]
    popByAgeInc <- popByAgeInc + cell.popn[[i]][[j]][,2]
    popByAgeInf <- popByAgeInf + cell.popn[[i]][[j]][,3]
  }
}
popSumUn <- sum(popByAgeUn)
popSumInc <- sum(popByAgeInc)    
popSumInf <- sum(popByAgeInf)

#how would I like it summarised ?
#if I output by Age & day I can sum
#I could create a dF with day rows allowing me to save a bunch of stuff
#dFdaily$popSumUn
#& even maybe#dFdaily$popAgeXUn


print(dFdaily)

#plot(dFdaily$popSumUn)
#plot(dFdaily$popSumUn[1:6])

#ggplot( data = dFdaily,
#        aes(day,popSumUn,popSumInc,popSumInf) ) + 
#        geom_line(aes(day,popSumUn),color = "green",linetype='dashed') +
#        geom_line(aes(day,popSumInc),color = "orange",linetype='dashed') +
#        geom_line(aes(day,popSumInf),color = "red",linetype='dashed')

ggplot( data = dFdaily,
        aes(day,popSumUn,popSumInc,popSumInf) ) + 
  geom_line(aes(day,popSumUn),color = "green",linetype='dashed') +
  geom_line(aes(day,popSumInc),color = "orange",linetype='dashed') +
  geom_line(aes(day,popSumInf),color = "red",linetype='dashed')

#but that doesn't give me a scale
#may need to melt, puts the other column names into a column called variable
dFm <- melt(dFdaily, id.var = c("day"))

#this does produce vaguely what I want
ggplot( data = dFm,
        aes(day,value, colour = variable) ) + 
        geom_line() 

#thinking about variable names
probTranFly2Hum
probTranFly2Oxe


