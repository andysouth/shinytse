#runhat.r
#andy south 26/3/14

#short temp script to run R hattrick outside of shiny
setwd('C:\\Dropbox\\Ian and Andy\\andy\\shinyhat1\\')

size <- 10
days <- 6 #20

input <- data.frame('size'=size,'days'=days)

source("movement.R")
source("feed.R")
source("infected.R")
source("demog.R")

source("HAT_trick_andy.r")




