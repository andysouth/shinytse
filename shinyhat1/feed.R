feeds.default = list("detect.ambush" = data.frame("human" = c(0.06679, 0.08176, 0.09300, 0.10181), "OE" = c(0.26715, 0.32702, 0.37201, 0.40725)), "detect.ranging" = data.frame("human" = c(0.07686, 0.10680, 0.12789, 0.13560), "OE" = c(0.23058, 0.32039, 0.38366, 0.40679)), "visit" = data.frame("human" = c(0.74, 0.79, 0.81, 0.82), "OE" = c(0.74, 0.79, 0.81, 0.82)), "probe" = data.frame("human" = c(0.76, 0.81, 0.84, 0.85), "OE" = c(0.76, 0.81, 0.84, 0.85)), "feed" = data.frame("human" = c(0.92, 0.93, 0.93, 0.93), "OE" = c(0.92, 0.93, 0.93, 0.93)))


#### Need to reduce last feed to proportion of population and repeat asl include max.adult? ####
feed_fun <- function(habitat, 
                     popn, 
                     human, 
                     OE, 
                     feed.cycle = 3, 
                     feeds = feeds.default, 
                     adult,
                     max.age #andy #bug4 max.age is used but wasn't passed
                     ){
  
   #cat("in feed_fun() nrow(habitat) ",nrow(habitat),"\n")  
   #cat("in feed_fun() max.age ",max.age,"\n")
   
    p.list <- list()		
		for(i in 1:nrow(habitat)){
			p.list[[i]] <- list()
      #andy corrected #bug2 from hab.grid to habitat 
			for(j in 1:ncol(habitat)){
				p.list[[i]][[j]] <- matrix(c(rep(0, (max.age * 3))), ncol=3)
			}
		}
		detection.human <- p.list
		visit.human <- p.list
		probe.human <- p.list
		feed.human <- p.list
		detection.OE <- p.list
		visit.OE <- p.list
		probe.OE <- p.list
		feed.OE <- p.list

		for(i in 1:nrow(habitat)){
			for(j in 1:ncol(habitat)){
				### Detection ###

				#browser() #to debug
        
        detection.human[[i]][[j]][min(adult),] <- (popn[[i]][[j]][min(adult),] * (1 - ((1 - feeds[["detect.ambush"]]$human[1]) ^ sum(human[[i]][[j]])))) + (popn[[i]][[j]][min(adult),] * (1 - ((1 - feeds[["detect.ranging"]]$human[1]) ^ sum(human[[i]][[j]]))))

				detection.OE[[i]][[j]][min(adult),] <-(popn[[i]][[j]][min(adult),] * (1 - ((1 - feeds[["detect.ambush"]]$OE[1]) ^ sum(OE[[i]][[j]])))) + (popn[[i]][[j]][min(adult),] * (1 - ((1 - feeds[["detect.ranging"]]$OE[1]) ^ sum(OE[[i]][[j]]))))				
				
				detection.human[[i]][[j]][min(adult) + 1,] <- (popn[[i]][[j]][min(adult) + 1,] * (1 - ((1 - feeds[["detect.ambush"]]$human[2]) ^ sum(human[[i]][[j]])))) + (popn[[i]][[j]][min(adult) + 1,] * (1 - ((1 - feeds[["detect.ranging"]]$human[2]) ^ sum(human[[i]][[j]]))))

				detection.OE[[i]][[j]][min(adult) + 1,] <- (popn[[i]][[j]][min(adult) + 1,] * (1 - ((1 - feeds[["detect.ambush"]]$OE[2]) ^ sum(OE[[i]][[j]])))) + (popn[[i]][[j]][min(adult) + 1,] * (1 - ((1 - feeds[["detect.ranging"]]$OE[2]) ^ sum(OE[[i]][[j]])))) 
				
				detection.human[[i]][[j]][min(adult) + feed.cycle + 1,] <- (popn[[i]][[j]][min(adult) + feed.cycle + 1,] * (1 - ((1 - feeds[["detect.ambush"]]$human[3]) ^ sum(human[[i]][[j]])))) + (popn[[i]][[j]][min(adult) + feed.cycle + 1,] * (1 - ((1 - feeds[["detect.ranging"]]$human[3]) ^ sum(human[[i]][[j]])))) 		

				detection.OE[[i]][[j]][min(adult) + feed.cycle + 1,] <-	(popn[[i]][[j]][min(adult) + feed.cycle + 1,] * (1 - ((1 - feeds[["detect.ambush"]]$OE[3]) ^ sum(OE[[i]][[j]])))) + (popn[[i]][[j]][min(adult) + feed.cycle + 1,] * (1 - ((1 - feeds[["detect.ranging"]]$OE[3]) ^ sum(OE[[i]][[j]]))))				

				detection.human[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,] <- (popn[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,] * (1 - ((1 - feeds[["detect.ambush"]]$human[4]) ^ sum(human[[i]][[j]])))) + (popn[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,] * (1 - ((1 - feeds[["detect.ranging"]]$human[4]) ^ sum(human[[i]][[j]])))) 		

				detection.OE[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,] <- (popn[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,] * (1 - ((1 - feeds[["detect.ambush"]]$OE[4]) ^ sum(OE[[i]][[j]])))) + (popn[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,] * (1 - ((1 - feeds[["detect.ranging"]]$OE[4]) ^ sum(OE[[i]][[j]]))))		

				#### Visit ####

				visit.human[[i]][[j]][min(adult),] <- (detection.human[[i]][[j]][min(adult),] * feeds[["visit"]]$human[1])

				visit.OE[[i]][[j]][min(adult),] <- (detection.OE[[i]][[j]][min(adult),] * feeds[["visit"]]$OE[1]) 
				
				visit.human[[i]][[j]][min(adult) + 1,] <- (detection.human[[i]][[j]][min(adult) + 1,] * feeds[["visit"]]$human[2])

				visit.OE[[i]][[j]][min(adult) + 1,] <- (detection.OE[[i]][[j]][min(adult) + 1,] * feeds[["visit"]]$OE[2])
				
				visit.human[[i]][[j]][min(adult) + feed.cycle + 1,] <- (detection.human[[i]][[j]][min(adult) + feed.cycle + 1,] * feeds[["visit"]]$human[3])

				visit.OE[[i]][[j]][min(adult) + feed.cycle + 1,] <- (detection.OE[[i]][[j]][min(adult) + feed.cycle + 1,] * feeds[["visit"]]$OE[3])

				visit.human[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,] <- (detection.human[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,] * feeds[["visit"]]$human[4])

				visit.OE[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,] <- (detection.OE[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,] * feeds[["visit"]]$OE[4]) 

								
				#### Probing ####	

				probe.human[[i]][[j]][min(adult),] <- (visit.human[[i]][[j]][min(adult),] * feeds[["probe"]]$human[1])

				probe.OE[[i]][[j]][min(adult),] <- (visit.OE[[i]][[j]][min(adult),] * feeds[["probe"]]$OE[1]) 				

				probe.human[[i]][[j]][min(adult) + 1,] <- (visit.human[[i]][[j]][min(adult) + 1,] * feeds[["probe"]]$human[2])

				probe.OE[[i]][[j]][min(adult) + 1,] <- (visit.OE[[i]][[j]][min(adult) + 1,] * feeds[["probe"]]$OE[2])
				
				probe.human[[i]][[j]][min(adult) + feed.cycle + 1,] <- (visit.human[[i]][[j]][min(adult) + feed.cycle + 1,] * feeds[["probe"]]$human[3])

				probe.OE[[i]][[j]][min(adult) + feed.cycle + 1,] <- (visit.OE[[i]][[j]][min(adult) + feed.cycle + 1,] * feeds[["probe"]]$OE[3])

				probe.human[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,] <- (visit.human[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,] * feeds[["probe"]]$human[4])

				probe.OE[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,] <- (visit.OE[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,] * feeds[["probe"]]$OE[4])

				#### Feed ####

				feed.human[[i]][[j]][min(adult),] <- (probe.human[[i]][[j]][min(adult),] * feeds[["feed"]]$human[1]) 

				feed.OE[[i]][[j]][min(adult),] <- (probe.OE[[i]][[j]][min(adult),] * feeds[["feed"]]$OE[1]) 
				
				feed.human[[i]][[j]][min(adult) + 1,] <- (probe.human[[i]][[j]][min(adult) + 1,] * feeds[["feed"]]$human[2])

				feed.OE[[i]][[j]][min(adult) + 1,] <- (probe.OE[[i]][[j]][min(adult) + 1,] * feeds[["feed"]]$OE[2])
				
				feed.human[[i]][[j]][min(adult) + feed.cycle + 1,] <- (probe.human[[i]][[j]][min(adult) + feed.cycle + 1,] * feeds[["feed"]]$human[3])

				feed.OE[[i]][[j]][min(adult) + feed.cycle + 1,] <- (probe.OE[[i]][[j]][min(adult) + feed.cycle + 1,] * feeds[["feed"]]$OE[3])

				feed.human[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,] <- (probe.human[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,] * feeds[["feed"]]$human[4])

				feed.OE[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,] <- (probe.OE[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,] * feeds[["feed"]]$OE[4])

				#### Update population ####

				popn[[i]][[j]][min(adult),] <- (feed.human[[i]][[j]][min(adult),] + feed.OE[[i]][[j]][min(adult),])
				
				popn[[i]][[j]][min(adult) + 1,] <- (feed.human[[i]][[j]][min(adult) + 1,] + feed.OE[[i]][[j]][min(adult) + 1,])
 				
				popn[[i]][[j]][min(adult) + feed.cycle + 1,] <- (feed.human[[i]][[j]][min(adult) + feed.cycle + 1,] + feed.OE[[i]][[j]][min(adult) + feed.cycle + 1,])

				popn[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,] <- (feed.human[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,] + feed.OE[[i]][[j]][min(adult) + (feed.cycle * 2)+ 1,])

			}
		}
	return(list(popn = popn, feed = list("human" = feed.human, "OE" = feed.OE), probe = list("human" = probe.human, "OE" = probe.OE), visit = list("human" = visit.human, "OE" = visit.OE), detect = list("human" = detection.human, "OE" = detection.OE)))
}

