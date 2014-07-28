transmission.default <- list(probe = data.frame("human" = 0.1, "OE" = 0.1), feed = data.frame("human" = 0.1, "OE"= 0.1), mature = data.frame("tsetse" = 0.033, "human" = 0.05, "OE" = 0.05), recover = data.frame("human" = 0.05, "OE" = 0.1))

check.infect <- function(x){
			if(is.finite(x) == FALSE){
				x <- 0
			} 
			return(x)
		}
			
infection <- function(popn, human, OE, probe, feed, transmission = transmission.default, adult){
		
		#### Create list of infected tsetse in each cell ####
		cell.infection <- list()
		human.infect <- list()
		OE.infect <- list()
		for(i in 1:length(popn[[1]])){
			cell.infection[[i]] <- list()
			human.infect[[i]] <- list()
			OE.infect[[i]] <- list()
			for(j in 1:length(popn[[1]])){
				cell.infection[[i]][[j]] <-  matrix(c(rep(0, max(adult))), ncol = 1)
				human.infect[[i]][[j]] <-  matrix(c(rep(0, nrow(human[[1]][[1]]))), ncol = 1)
				OE.infect[[i]][[j]] <- matrix(c(rep(0, nrow(OE[[1]][[1]]))), ncol=1)
			}
		}

		#### Calculate number of infected flies ####
    
    #andy for each cell in the grid
		for(i in 1:length(probe[[1]])){
			for(j in 1:length(probe[[1]])){
        
        #andy - oooo this next line is super tricky!
        
				cell.infection[[i]][[j]] <- (check.infect( sum(human[[i]][[j]])/sum(human[[i]][[j]][,3]) * 
                                                  (sum(probe[["human"]][[i]][[j]]) - sum(feed[["human"]][[i]][[j]])* 
                                                   transmission[["probe"]]$human)) 
                                     
                                   + check.infect( sum(human[[i]][[j]])/sum(human[[i]][[j]][,3]) * 
                                                   sum(feed[["human"]][[i]][[j]]) * 
                                                   transmission[["probe"]]$human) 
                                   
                                   + check.infect(sum(human[[i]][[j]])/sum(OE[[i]][[j]][,3]) * 
                                                  (sum(probe[["OE"]][[i]][[j]]) - sum(feed[["OE"]][[i]][[j]]) * 
                                                   transmission[["probe"]]$OE))
                                     
                                   + check.infect((sum(OE[[i]][[j]])/sum(OE[[i]][[j]][,3]) * 
                                                   sum(feed[["OE"]][[i]][[j]]) * 
                                                   transmission[["probe"]]$OE))) * popn[[i]][[j]][,1]
			}
		}

		#### Update infected and incubating tsetse ####
	for(i in 1:length(popn)){
		for (j in 1:length(popn[[i]])){
			N <- popn[[i]][[j]]
			for(v in min(adult):max(adult)){
				N[v,2] <- N[v,2] + cell.infection[[i]][[j]][v]
				N[v,1] <- N[v,1] - cell.infection[[i]][[j]][v]
				N[v,3] <- N[v,3] + (popn[[i]][[j]][v,2] * transmission[["mature"]]$tsetse)
				N[v,2] <- N[v,2] - (popn[[i]][[j]][v,2] * transmission[["mature"]]$tsetse)
			}
			popn[[i]][[j]] <- N
		}
	}

		

		#### Calculate number of infected humans ####
		for(i in 1:length(human[[1]])){
			for(j in 1:length(human[[1]])){
        #andy oooo another tricky line
				human.infect[[i]][[j]] <- (check.infect((1 - (1 - transmission[["feed"]]$human) ^ (sum(feed[["human"]][[i]][[j]]) * 
                                                          (sum(popn[[i]][[j]][,3])/sum(popn[[i]][[j]]))))) * 
                                   check.infect((1 - (1 - transmission[["probe"]]$human) ^ (sum(probe[["human"]][[i]][[j]]) - 
                                                           sum(feed[["human"]][[i]][[j]]))) * 
                                   (sum(popn[[i]][[j]][,3])/sum(popn[[i]][[j]])))) * human[[i]][[j]][,1]
			}
		}


##### Changed to the proabaility of NOT getting disease via feeding * probability of not getting disease by probe 
##### (i.e. independent events - DOES NOT WORK produces negative numbers and NaNs. 
##### Need to redo this part of the calculation

####Seems like this calculation can still produce negative numbers. 
####Potentially because number of flies biting people * proportion of population infected 
####can be larger than 1 so 1- this  < 1  - both probe and feed should be included in 
####the same probability calculation (i.e. 1 - probability of disease not being transmitted by feeding OR probe)



		#### Update infected/incubating/cured humans ####

		for(i in 1:length(human)){
			for (j in 1:length(human[[i]])){
				N <- human[[i]][[j]]
#				N[1,1] <- N[1,1] + N[1,2] + N[1,3] + N[1,4] # This is wrng for humans- infected children remain infected - need to work out popn matrix 
#				N[1,2] <- 0
#				N[1,3] <- 0
#				N[1,4] <- 0
#				N[2,1] <- N[2,1] + N[2,4] # Add recovered back into popn
#				N[2,4] <- 0				
				for(v in 1:2){
					N[v,2] <- N[v,2] + human.infect[[i]][[j]][v]
					N[v,1] <- N[v,1] - human.infect[[i]][[j]][v]
					N[v,3] <- N[v,3] - (human[[i]][[j]][v,3] * transmission[["recover"]]$human)
					N[v,4] <- N[v,4] + (human[[i]][[j]][v,3] * transmission[["recover"]]$human)
					N[v,3] <- N[v,3] + (human[[i]][[j]][v,2] * transmission[["mature"]]$human)
					N[v,2] <- N[v,2] - (human[[i]][[j]][v,2] * transmission[["mature"]]$human)
					
				}
				human[[i]][[j]] <- N
				}
		}


		#### Calculate number of infected OE ####

		for(i in 1:length(OE[[1]])){
			for(j in length(OE[[1]])){
			  #andy oooo another tricky line
				OE.infect[[i]][[j]] <- (check.infect((1 - (1 - transmission[["feed"]]$OE) ^ (sum(feed[["OE"]][[i]][[j]]) * 
                                            (sum(popn[[i]][[j]][,3])/sum(popn[[i]][[j]]))))) * 
                                check.infect((1 - (1 - transmission[["probe"]]$OE) ^ (sum(probe[["OE"]][[i]][[j]])- 
                                            sum(feed[["OE"]][[i]][[j]]))) * (sum(popn[[i]][[j]][,3])/sum(popn[[i]][[j]])))) * OE[[i]][[j]][,1]
			}
		}

		#### Update infected/incubating/recovered OE ####

		for(i in 1:length(OE)){
			for (j in 1:length(OE[[i]])){
				N <- OE[[i]][[j]]
#				N[,1] <- N[,1] + N[,4] # Add recovered back into popn
#				N[,4] <- 0
				N[,2] <- N[,2] + OE.infect[[i]][[j]]
				N[,1] <- N[,1] - OE.infect[[i]][[j]]
				N[,3] <- N[,3] - (OE[[i]][[j]][,3] * transmission[["recover"]]$OE)
				N[,4] <- N[,4] + (OE[[i]][[j]][,3] * transmission[["recover"]]$OE)
				N[,3] <- N[,3] + (OE[[i]][[j]][,2] * transmission[["mature"]]$OE)
				N[,2] <- N[,2] - (OE[[i]][[j]][,2] * transmission[["mature"]]$OE)
					
			OE[[i]][[j]] <- N
			}
		}


 	return(list(popn = popn, human = human, OE = OE))
}
