HAT_move <- function(popn, move, move.prob, hab.grid){
  
  
  #andy #bug3 move.un is not used outside of HAT_move() and is not passed to it
  #so instead move this code to within the func
  move.un <- list()
  for(i in 1:nrow(hab.grid)){
    move.un[[i]] <- list()
    for(j in 1:ncol(hab.grid)){
      move.un[[i]][[j]] <- 0
    }
  } 
  move.inc <- move.un
  move.inf <- move.un
  
  
	popn.un <- list()
	popn.inc <- list()
	popn.inf <- list()
	for(i in 1:nrow(hab.grid)){
		popn.un[[i]] <- list()
		popn.inc[[i]] <- list()
		popn.inf[[i]] <- list()
		for(j in 1:ncol(hab.grid)){
			popn.un[[i]][[j]] <- matrix(c(popn[[i]][[j]][,1]), ncol=1)
			popn.inc[[i]][[j]] <- matrix(c(popn[[i]][[j]][,2]), ncol=1)
			popn.inf[[i]][[j]] <- matrix(c(popn[[i]][[j]][,3]), ncol=1)
		}
	}
	popn.orig.un <- popn.un
	popn.orig.inc <- popn.inc
	popn.orig.inf <- popn.inf

####### Uninfected #######
	for(i in 1:nrow(hab.grid)){
		for(j in 1:ncol(hab.grid)){
			if((i-1) <= 0 | (j-1) <=0 | i >= nrow(hab.grid) | j >= ncol(hab.grid)){
				if(i-1 <= 0 & j-1 <= 0){
					move.un[[i]][[j]] <- move.un[[i]][[j]] + ((popn.un[[(i+1)]][[j]] * move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])  + (popn.orig.un[[(i)]][[j+1]]* move.prob) * (hab.grid[i+1,j]/hab.grid[i,j]))
					move.c <- (popn.orig.un[[i]][[j]] * move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])
					move.d <- (popn.orig.un[[i]][[j]] * move.prob) * (hab.grid[i,j+1]/hab.grid[i,j])
					move.un[[(i+1)]][[j]] <- move.un[[(i+1)]][[j]] + move.c
					move.un[[i]][[(j+1)]] <- move.un[[i]][[(j+1)]] + move.d
					popn.un[[i]][[j]] <- popn.un[[i]][[j]] - (move.c + move.d) * 2
				}

				if(i-1 <= 0 & j >= ncol(hab.grid)){
					move.un[[i]][[j]] <- move.un[[i]][[j]] + ((popn.orig.un[[(i+1)]][[j]]* move.prob) * (hab.grid[i+1,j]/hab.grid[i,j]) + (popn.orig.un[[(i)]][[j-1]]* move.prob) * (hab.grid[i,j-1]/hab.grid[i,j]))
					move.c <- (popn.orig.un[[i]][[j]] * move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])
					move.a <- (popn.orig.un[[i]][[j]] * move.prob) * (hab.grid[i,j-1]/hab.grid[i,j])
					move.un[[(i+1)]][[j]] <- move.un[[(i+1)]][[j]] + move.c
					move.un[[i]][[(j-1)]] <- move.un[[i]][[(j-1)]] + move.a 
					popn.un[[i]][[j]] <- popn.un[[i]][[j]] - (move.c + move.a) * 2
				}

				if(i >= nrow(hab.grid) & (j-1) <= 0){
					move.un[[i]][[j]] <- move.un[[i]][[j]] + ((popn.orig.un[[(i-1)]][[j]]* move.prob)* (hab.grid[i-1,j]/hab.grid[i,j]) + (popn.orig.un[[(i)]][[j+1]]* move.prob) * (hab.grid[i,j+1]/hab.grid[i,j]))
					move.b <- (popn.orig.un[[i]][[j]] * move.prob) * (hab.grid[i-1,j]/hab.grid[i,j])	
					move.d <- (popn.orig.un[[i]][[j]] * move.prob) * (hab.grid[i,j+1]/hab.grid[i,j])
					move.un[[(i-1)]][[j]] <- move.un[[(i-1)]][[j]] + move.b
					move.un[[i]][[(j+1)]] <- move.un[[i]][[(j+1)]] + move.d
					popn.un[[i]][[j]] <- popn.un[[i]][[j]] - (move.b + move.d) * 2
				}

				if(i >= nrow(hab.grid) & j >= ncol(hab.grid)){
					move.un[[i]][[j]] <- move.un[[i]][[j]] + ((popn.orig.un[[(i-1)]][[j]]* move.prob) * (hab.grid[i-1,j]/hab.grid[i,j])+ (popn.orig.un[[(i)]][[j-1]]* move.prob) * (hab.grid[i,j-1]/hab.grid[i,j]))
					move.b <- (popn.orig.un[[i]][[j]] * move.prob) * (hab.grid[i-1,j]/hab.grid[i,j])
					move.a <- (popn.orig.un[[i]][[j]] * move.prob) * (hab.grid[i,j-1]/hab.grid[i,j])
					move.un[[(i-1)]][[j]] <- move.un[[(i-1)]][[j]] + move.b
					move.un[[i]][[(j-1)]] <- move.un[[i]][[(j-1)]] + move.a
					popn.un[[i]][[j]] <- popn.un[[i]][[j]] - (move.b + move.a) * 2
				}

				if(i-1 <= 0 & (j-1) > 0 & j < ncol(hab.grid)){
					move.un[[i]][[j]] <- move.un[[i]][[j]] + (popn.orig.un[[(i+1)]][[j]]* move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])
					move.a <- (popn.orig.un[[i]][[j]] * move.prob) * (hab.grid[i,j-1]/hab.grid[i,j])
					move.c <- (popn.orig.un[[i]][[j]] * move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])
					move.d <- (popn.orig.un[[i]][[j]] * move.prob) * (hab.grid[i,j+1]/hab.grid[i,j])
	 				move.un[[i]][[(j-1)]] <- move.un[[i]][[(j-1)]] + move.a
					move.un[[(i+1)]][[j]] <- move.un[[(i+1)]][[j]] + move.c
					move.un[[i]][[(j+1)]] <- move.un[[i]][[(j+1)]] + move.d
					popn.un[[i]][[j]] <- popn.un[[i]][[j]] - (move.a + (move.c * 2) + move.d)
				}

				if(i >= nrow(hab.grid) & (j-1) > 0 & j < ncol(hab.grid)){
					move.un[[i]][[j]] <- move.un[[i]][[j]] + (popn.orig.un[[(i-1)]][[j]] * move.prob)  * (hab.grid[i-1,j]/hab.grid[i,j])
					move.b <- (popn.orig.un[[i]][[j]] * move.prob) * (hab.grid[i-1,j]/hab.grid[i,j])
					move.a <- (popn.orig.un[[i]][[j]] * move.prob) * (hab.grid[i,j-1]/hab.grid[i,j])
					move.d <- (popn.orig.un[[i]][[j]] * move.prob) * (hab.grid[i,j+1]/hab.grid[i,j])
					move.un[[(i-1)]][[j]] <- move.un[[(i-1)]][[j]] + move.b
					move.un[[i]][[(j-1)]] <- move.un[[i]][[(j-1)]] + move.a
					move.un[[i]][[(j+1)]] <- move.un[[i]][[(j+1)]] + move.d
					popn.un[[i]][[j]] <- popn.un[[i]][[j]] - ((move.b *2) + move.a + move.d)
				}

				if(j-1 <= 0 & (i-1) > 0 & i < nrow(hab.grid)){
					move.un[[i]][[j]]	<- move.un[[i]][[j]] + (popn.orig.un[[i]][[(j+1)]] * move.prob) * (hab.grid[i,j+1]/hab.grid[i,j])
					move.b <- (popn.orig.un[[i]][[j]] * move.prob) * (hab.grid[i-1,j]/hab.grid[i,j])
					move.d <- (popn.orig.un[[i]][[j]] * move.prob) * (hab.grid[i,j+1]/hab.grid[i,j])
					move.c <- (popn.orig.un[[i]][[j]] * move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])
					move.un[[(i-1)]][[j]] <- move.un[[(i-1)]][[j]] + move.b
					move.un[[i]][[(j+1)]] <- move.un[[i]][[(j+1)]] + move.d
					move.un[[(i+1)]][[j]] <- move.un[[(i+1)]][[j]] + move.c
					popn.un[[i]][[j]] <- popn.un[[i]][[j]] - (move.b + (move.d * 2) + move.c)
				}

				if(j >= ncol(hab.grid) & (i-1) > 0 & i < nrow(hab.grid)){
					move.un[[i]][[j]]	<- move.un[[i]][[j]] + (popn.orig.un[[i]][[(j-1)]] * move.prob) * (hab.grid[i,j-1]/hab.grid[i,j])
					move.b <- (popn.orig.un[[i]][[j]] * move.prob) * (hab.grid[i-1,j]/hab.grid[i,j])
					move.a <- (popn.orig.un[[i]][[j]] * move.prob) * (hab.grid[i,j-1]/hab.grid[i,j])
					move.c <- (popn.orig.un[[i]][[j]] * move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])
					move.un[[(i-1)]][[j]] <- move.un[[(i-1)]][[j]] + move.b
					move.un[[i]][[(j-1)]] <- move.un[[i]][[(j-1)]] + move.a 
					move.un[[(i+1)]][[j]] <- move.un[[(i+1)]][[j]] + move.c 
					popn.un[[i]][[j]] <- popn.un[[i]][[j]] - (move.b + (move.a * 2) + move.c)
				}
				
			} else {
				move.a <- popn.orig.un[[i]][[j]] * move.prob * (hab.grid[i,j-1]/hab.grid[i,j])
				move.b <- popn.orig.un[[i]][[j]] * move.prob * (hab.grid[i-1,j]/hab.grid[i,j])
				move.c <- popn.orig.un[[i]][[j]] * move.prob * (hab.grid[i+1,j]/hab.grid[i,j])
				move.d <- popn.orig.un[[i]][[j]] * move.prob * (hab.grid[i,j+1]/hab.grid[i,j])
				move.un[[i]][[j-1]] <- move.un[[i]][[(j-1)]] + move.a
	 			move.un[[i-1]][[j]] <- move.un[[(i-1)]][[j]] + move.b
				move.un[[i+1]][[j]] <- move.un[[(i+1)]][[j]] + move.c
				move.un[[i]][[j+1]] <- move.un[[i]][[(j+1)]] + move.d
				popn.un[[i]][[j]] <- popn.un[[i]][[j]] - (move.a + move.b + move.c + move.d)
			}
		}
	}
	move.grid.un <- matrix(0, nrow=nrow(hab.grid), ncol=ncol(hab.grid))
	for(i in 1:nrow(hab.grid)){
		for(j in 1:ncol(hab.grid)){
			move.grid.un[i,j] <- sum(move.un[[i]][[j]])
		}
	}

############# Incubating ###################
	for(i in 1:nrow(hab.grid)){
		for(j in 1:ncol(hab.grid)){
			if((i-1) <= 0 | (j-1) <=0 | i >= nrow(hab.grid) | j >= ncol(hab.grid)){
				
				if(i-1 <= 0 & j-1 <= 0){
					move.inc[[i]][[j]]<- move.inc[[i]][[j]] + ((popn.inc[[(i+1)]][[j]] * move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])  + (popn.orig.inc[[(i)]][[j+1]]* move.prob) * (hab.grid[i+1,j]/hab.grid[i,j]))
					move.c <- (popn.orig.inc[[i]][[j]] * move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])
					move.d <- (popn.orig.inc[[i]][[j]] * move.prob) * (hab.grid[i,j+1]/hab.grid[i,j])
					move.inc[[(i+1)]][[j]] <- move.inc[[(i+1)]][[j]] + move.c
					move.inc[[i]][[(j+1)]] <- move.inc[[i]][[(j+1)]] + move.d
					popn.inc[[i]][[j]] <- popn.inc[[i]][[j]] - (move.c + move.d) * 2
				}

				if(i-1 <= 0 & j >= ncol(hab.grid)){
					move.inc[[i]][[j]] <- move.inc[[i]][[j]] + ((popn.orig.inc[[(i+1)]][[j]]* move.prob) * (hab.grid[i+1,j]/hab.grid[i,j]) + (popn.orig.inc[[(i)]][[j-1]]* move.prob) * (hab.grid[i,j-1]/hab.grid[i,j]))
					move.c <- (popn.orig.inc[[i]][[j]] * move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])
					move.a <- (popn.orig.inc[[i]][[j]] * move.prob) * (hab.grid[i,j-1]/hab.grid[i,j])
					move.inc[[(i+1)]][[j]] <- move.inc[[(i+1)]][[j]] + move.c
					move.inc[[i]][[(j-1)]] <- move.inc[[i]][[(j-1)]] + move.a 
					popn.inc[[i]][[j]] <- popn.inc[[i]][[j]] - (move.c + move.a) * 2
				}

				if(i >= nrow(hab.grid) & (j-1) <= 0){
					move.inc[[i]][[j]] <- move.inc[[i]][[j]] + ((popn.orig.inc[[(i-1)]][[j]]* move.prob)* (hab.grid[i-1,j]/hab.grid[i,j]) + (popn.orig.inc[[(i)]][[j+1]]* move.prob) * (hab.grid[i,j+1]/hab.grid[i,j]))
					move.b <- (popn.orig.inc[[i]][[j]] * move.prob) * (hab.grid[i-1,j]/hab.grid[i,j])	
					move.d <- (popn.orig.inc[[i]][[j]] * move.prob) * (hab.grid[i,j+1]/hab.grid[i,j])
					move.inc[[(i-1)]][[j]] <- move.inc[[(i-1)]][[j]] + move.b
					move.inc[[i]][[(j+1)]] <- move.inc[[i]][[(j+1)]] + move.d
					popn.inc[[i]][[j]] <- popn.inc[[i]][[j]] - (move.b + move.d) * 2
				}

				if(i >= nrow(hab.grid) & j >= ncol(hab.grid)){
					move.inc[[i]][[j]] <- move.inc[[i]][[j]] + ((popn.orig.inc[[(i-1)]][[j]]* move.prob) * (hab.grid[i-1,j]/hab.grid[i,j])+ (popn.orig.inc[[(i)]][[j-1]]* move.prob) * (hab.grid[i,j-1]/hab.grid[i,j]))
					move.b <- (popn.orig.inc[[i]][[j]] * move.prob) * (hab.grid[i-1,j]/hab.grid[i,j])
					move.a <- (popn.orig.inc[[i]][[j]] * move.prob) * (hab.grid[i,j-1]/hab.grid[i,j])
					move.inc[[(i-1)]][[j]] <- move.inc[[(i-1)]][[j]] + move.b
					move.inc[[i]][[(j-1)]] <- move.inc[[i]][[(j-1)]] + move.a
					popn.inc[[i]][[j]] <- popn.inc[[i]][[j]] - (move.b + move.a) * 2
				}

				if(i-1 <= 0 & (j-1) > 0 & j < ncol(hab.grid)){
					move.inc[[i]][[j]] <- move.inc[[i]][[j]] + (popn.orig.inc[[(i+1)]][[j]]* move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])
					move.a <- (popn.orig.inc[[i]][[j]] * move.prob) * (hab.grid[i,j-1]/hab.grid[i,j])
					move.c <- (popn.orig.inc[[i]][[j]] * move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])
					move.d <- (popn.orig.inc[[i]][[j]] * move.prob) * (hab.grid[i,j+1]/hab.grid[i,j])
	 				move.inc[[i]][[(j-1)]] <- move.inc[[i]][[(j-1)]] + move.a
					move.inc[[(i+1)]][[j]] <- move.inc[[(i+1)]][[j]] + move.c
					move.inc[[i]][[(j+1)]] <- move.inc[[i]][[(j+1)]] + move.d
					popn.inc[[i]][[j]] <- popn.inc[[i]][[j]] - (move.a + (move.c * 2) + move.d)
				}

				if(i >= nrow(hab.grid) & (j-1) > 0 & j < ncol(hab.grid)){
					move.inc[[i]][[j]] <- move.inc[[i]][[j]] + (popn.orig.inc[[(i-1)]][[j]] * move.prob)  * (hab.grid[i-1,j]/hab.grid[i,j])
					move.b <- (popn.orig.inc[[i]][[j]] * move.prob) * (hab.grid[i-1,j]/hab.grid[i,j])
					move.a <- (popn.orig.inc[[i]][[j]] * move.prob) * (hab.grid[i,j-1]/hab.grid[i,j])
					move.d <- (popn.orig.inc[[i]][[j]] * move.prob) * (hab.grid[i,j+1]/hab.grid[i,j])
					move.inc[[(i-1)]][[j]] <- move.inc[[(i-1)]][[j]] + move.b
					move.inc[[i]][[(j-1)]] <- move.inc[[i]][[(j-1)]] + move.a
					move.inc[[i]][[(j+1)]] <- move.inc[[i]][[(j+1)]] + move.d
					popn.inc[[i]][[j]] <- popn.inc[[i]][[j]] - ((move.b *2) + move.a + move.d)
				}

				if(j-1 <= 0 & (i-1) > 0 & i < nrow(hab.grid)){
					move.inc[[i]][[j]] <- move.inc[[i]][[j]] + (popn.orig.inc[[i]][[(j+1)]] * move.prob) * (hab.grid[i,j+1]/hab.grid[i,j])
					move.b <- (popn.orig.inc[[i]][[j]] * move.prob) * (hab.grid[i-1,j]/hab.grid[i,j])
					move.d <- (popn.orig.inc[[i]][[j]] * move.prob) * (hab.grid[i,j+1]/hab.grid[i,j])
					move.c <- (popn.orig.inc[[i]][[j]] * move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])
					move.inc[[(i-1)]][[j]] <- move.inc[[(i-1)]][[j]] + move.b
					move.inc[[i]][[(j+1)]] <- move.inc[[i]][[(j+1)]] + move.d
					move.inc[[(i+1)]][[j]] <- move.inc[[(i+1)]][[j]] + move.c
					popn.inc[[i]][[j]] <- popn.inc[[i]][[j]] - (move.b + (move.d * 2) + move.c)
				}

				if(j >= ncol(hab.grid) & (i-1) > 0 & i < nrow(hab.grid)){
					move.inc[[i]][[j]] <- move.inc[[i]][[j]] + (popn.orig.inc[[i]][[(j-1)]] * move.prob) * (hab.grid[i,j-1]/hab.grid[i,j])
					move.b <- (popn.orig.inc[[i]][[j]] * move.prob) * (hab.grid[i-1,j]/hab.grid[i,j])
					move.a <- (popn.orig.inc[[i]][[j]] * move.prob) * (hab.grid[i,j-1]/hab.grid[i,j])
					move.c <- (popn.orig.inc[[i]][[j]] * move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])
					move.inc[[(i-1)]][[j]] <- move.inc[[(i-1)]][[j]] + move.b
					move.inc[[i]][[(j-1)]] <- move.inc[[i]][[(j-1)]] + move.a 
					move.inc[[(i+1)]][[j]] <- move.inc[[(i+1)]][[j]] + move.c 
					popn.inc[[i]][[j]] <- popn.inc[[i]][[j]] - (move.b + (move.a * 2) + move.c)
				}
				
			} else {
				move.a <- popn.orig.inc[[i]][[j]] * move.prob * (hab.grid[i,j-1]/hab.grid[i,j])
				move.b <- popn.orig.inc[[i]][[j]] * move.prob * (hab.grid[i-1,j]/hab.grid[i,j])
				move.c <- popn.orig.inc[[i]][[j]] * move.prob * (hab.grid[i+1,j]/hab.grid[i,j])
				move.d <- popn.orig.inc[[i]][[j]] * move.prob * (hab.grid[i,j+1]/hab.grid[i,j])
				move.inc[[i]][[j-1]] <- move.inc[[i]][[(j-1)]] + move.a
	 			move.inc[[i-1]][[j]] <- move.inc[[(i-1)]][[j]] + move.b
				move.inc[[i+1]][[j]] <- move.inc[[(i+1)]][[j]] + move.c
				move.inc[[i]][[j+1]] <- move.inc[[i]][[(j+1)]] + move.d
				popn.inc[[i]][[j]] <- popn.inc[[i]][[j]] - (move.a + move.b + move.c + move.d)
			}
		}
	}
	move.grid.inc <- matrix(0, nrow=nrow(hab.grid), ncol=ncol(hab.grid))
	for(i in 1:nrow(hab.grid)){
		for(j in 1:ncol(hab.grid)){
			move.grid.inc[i,j] <- sum(move.inc[[i]][[j]])
		}
	}

############# Infected ###################
	for(i in 1:nrow(hab.grid)){
		for(j in 1:ncol(hab.grid)){
			if((i-1) <= 0 | (j-1) <=0 | i >= nrow(hab.grid) | j >= ncol(hab.grid)){
				
				if(i-1 <= 0 & j-1 <= 0){
					move.inf[[i]][[j]]<- move.inf[[i]][[j]] + ((popn.inf[[(i+1)]][[j]] * move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])  + (popn.orig.inf[[(i)]][[j+1]]* move.prob) * (hab.grid[i+1,j]/hab.grid[i,j]))
					move.c <- (popn.orig.inf[[i]][[j]] * move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])
					move.d <- (popn.orig.inf[[i]][[j]] * move.prob) * (hab.grid[i,j+1]/hab.grid[i,j])
					move.inf[[(i+1)]][[j]] <- move.inf[[(i+1)]][[j]] + move.c
					move.inf[[i]][[(j+1)]] <- move.inf[[i]][[(j+1)]] + move.d
					popn.inf[[i]][[j]] <- popn.inf[[i]][[j]] - (move.c + move.d) * 2
				}

				if(i-1 <= 0 & j >= ncol(hab.grid)){
					move.inf[[i]][[j]] <- move.inf[[i]][[j]] + ((popn.orig.inf[[(i+1)]][[j]]* move.prob) * (hab.grid[i+1,j]/hab.grid[i,j]) + (popn.orig.inf[[(i)]][[j-1]]* move.prob) * (hab.grid[i,j-1]/hab.grid[i,j]))
					move.c <- (popn.orig.inf[[i]][[j]] * move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])
					move.a <- (popn.orig.inf[[i]][[j]] * move.prob) * (hab.grid[i,j-1]/hab.grid[i,j])
					move.inf[[(i+1)]][[j]] <- move.inf[[(i+1)]][[j]] + move.c
					move.inf[[i]][[(j-1)]] <- move.inf[[i]][[(j-1)]] + move.a 
					popn.inf[[i]][[j]] <- popn.inf[[i]][[j]] - (move.c + move.a) * 2
				}

				if(i >= nrow(hab.grid) & (j-1) <= 0){
					move.inf[[i]][[j]] <- move.inf[[i]][[j]] + ((popn.orig.inf[[(i-1)]][[j]]* move.prob)* (hab.grid[i-1,j]/hab.grid[i,j]) + (popn.orig.inf[[(i)]][[j+1]]* move.prob) * (hab.grid[i,j+1]/hab.grid[i,j]))
					move.b <- (popn.orig.inf[[i]][[j]] * move.prob) * (hab.grid[i-1,j]/hab.grid[i,j])	
					move.d <- (popn.orig.inf[[i]][[j]] * move.prob) * (hab.grid[i,j+1]/hab.grid[i,j])
					move.inf[[(i-1)]][[j]] <- move.inf[[(i-1)]][[j]] + move.b
					move.inf[[i]][[(j+1)]] <- move.inf[[i]][[(j+1)]] + move.d
					popn.inf[[i]][[j]] <- popn.inf[[i]][[j]] - (move.b + move.d) * 2
				}

				if(i >= nrow(hab.grid) & j >= ncol(hab.grid)){
					move.inf[[i]][[j]] <- move.inf[[i]][[j]] + ((popn.orig.inf[[(i-1)]][[j]]* move.prob) * (hab.grid[i-1,j]/hab.grid[i,j])+ (popn.orig.inf[[(i)]][[j-1]]* move.prob) * (hab.grid[i,j-1]/hab.grid[i,j]))
					move.b <- (popn.orig.inf[[i]][[j]] * move.prob) * (hab.grid[i-1,j]/hab.grid[i,j])
					move.a <- (popn.orig.inf[[i]][[j]] * move.prob) * (hab.grid[i,j-1]/hab.grid[i,j])
					move.inf[[(i-1)]][[j]] <- move.inf[[(i-1)]][[j]] + move.b
					move.inf[[i]][[(j-1)]] <- move.inf[[i]][[(j-1)]] + move.a
					popn.inf[[i]][[j]] <- popn.inf[[i]][[j]] - (move.b + move.a) * 2
				}

				if(i-1 <= 0 & (j-1) > 0 & j < ncol(hab.grid)){
					move.inf[[i]][[j]] <- move.inf[[i]][[j]] + (popn.orig.inf[[(i+1)]][[j]]* move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])
					move.a <- (popn.orig.inf[[i]][[j]] * move.prob) * (hab.grid[i,j-1]/hab.grid[i,j])
					move.c <- (popn.orig.inf[[i]][[j]] * move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])
					move.d <- (popn.orig.inf[[i]][[j]] * move.prob) * (hab.grid[i,j+1]/hab.grid[i,j])
	 				move.inf[[i]][[(j-1)]] <- move.inf[[i]][[(j-1)]] + move.a
					move.inf[[(i+1)]][[j]] <- move.inf[[(i+1)]][[j]] + move.c
					move.inf[[i]][[(j+1)]] <- move.inf[[i]][[(j+1)]] + move.d
					popn.inf[[i]][[j]] <- popn.inf[[i]][[j]] - (move.a + (move.c * 2) + move.d)
				}

				if(i >= nrow(hab.grid) & (j-1) > 0 & j < ncol(hab.grid)){
					move.inf[[i]][[j]] <- move.inf[[i]][[j]] + (popn.orig.inf[[(i-1)]][[j]] * move.prob)  * (hab.grid[i-1,j]/hab.grid[i,j])
					move.b <- (popn.orig.inf[[i]][[j]] * move.prob) * (hab.grid[i-1,j]/hab.grid[i,j])
					move.a <- (popn.orig.inf[[i]][[j]] * move.prob) * (hab.grid[i,j-1]/hab.grid[i,j])
					move.d <- (popn.orig.inf[[i]][[j]] * move.prob) * (hab.grid[i,j+1]/hab.grid[i,j])
					move.inf[[(i-1)]][[j]] <- move.inf[[(i-1)]][[j]] + move.b
					move.inf[[i]][[(j-1)]] <- move.inf[[i]][[(j-1)]] + move.a
					move.inf[[i]][[(j+1)]] <- move.inf[[i]][[(j+1)]] + move.d
					popn.inf[[i]][[j]] <- popn.inf[[i]][[j]] - ((move.b *2) + move.a + move.d)
				}

				if(j-1 <= 0 & (i-1) > 0 & i < nrow(hab.grid)){
					move.inf[[i]][[j]] <- move.inf[[i]][[j]] + (popn.orig.inf[[i]][[(j+1)]] * move.prob) * (hab.grid[i,j+1]/hab.grid[i,j])
					move.b <- (popn.orig.inf[[i]][[j]] * move.prob) * (hab.grid[i-1,j]/hab.grid[i,j])
					move.d <- (popn.orig.inf[[i]][[j]] * move.prob) * (hab.grid[i,j+1]/hab.grid[i,j])
					move.c <- (popn.orig.inf[[i]][[j]] * move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])
					move.inf[[(i-1)]][[j]] <- move.inf[[(i-1)]][[j]] + move.b
					move.inf[[i]][[(j+1)]] <- move.inf[[i]][[(j+1)]] + move.d
					move.inf[[(i+1)]][[j]] <- move.inf[[(i+1)]][[j]] + move.c
					popn.inf[[i]][[j]] <- popn.inf[[i]][[j]] - (move.b + (move.d * 2) + move.c)
				}

				if(j >= ncol(hab.grid) & (i-1) > 0 & i < nrow(hab.grid)){
					move.inf[[i]][[j]] <- move.inf[[i]][[j]] + (popn.orig.inf[[i]][[(j-1)]] * move.prob) * (hab.grid[i,j-1]/hab.grid[i,j])
					move.b <- (popn.orig.inf[[i]][[j]] * move.prob) * (hab.grid[i-1,j]/hab.grid[i,j])
					move.a <- (popn.orig.inf[[i]][[j]] * move.prob) * (hab.grid[i,j-1]/hab.grid[i,j])
					move.c <- (popn.orig.inf[[i]][[j]] * move.prob) * (hab.grid[i+1,j]/hab.grid[i,j])
					move.inf[[(i-1)]][[j]] <- move.inf[[(i-1)]][[j]] + move.b
					move.inf[[i]][[(j-1)]] <- move.inf[[i]][[(j-1)]] + move.a 
					move.inf[[(i+1)]][[j]] <- move.inf[[(i+1)]][[j]] + move.c 
					popn.inf[[i]][[j]] <- popn.inf[[i]][[j]] - (move.b + (move.a * 2) + move.c)
				}
				
			} else {
				move.a <- popn.orig.inf[[i]][[j]] * move.prob * (hab.grid[i,j-1]/hab.grid[i,j])
				move.b <- popn.orig.inf[[i]][[j]] * move.prob * (hab.grid[i-1,j]/hab.grid[i,j])
				move.c <- popn.orig.inf[[i]][[j]] * move.prob * (hab.grid[i+1,j]/hab.grid[i,j])
				move.d <- popn.orig.inf[[i]][[j]] * move.prob * (hab.grid[i,j+1]/hab.grid[i,j])
				move.inf[[i]][[j-1]] <- move.inf[[i]][[(j-1)]] + move.a
	 			move.inf[[i-1]][[j]] <- move.inf[[(i-1)]][[j]] + move.b
				move.inf[[i+1]][[j]] <- move.inf[[(i+1)]][[j]] + move.c
				move.inf[[i]][[j+1]] <- move.inf[[i]][[(j+1)]] + move.d
				popn.inf[[i]][[j]] <- popn.inf[[i]][[j]] - (move.a + move.b + move.c + move.d)
			}
		}
	}
	move.grid.inf <- matrix(0, nrow=nrow(hab.grid), ncol=ncol(hab.grid))
	for(i in 1:nrow(hab.grid)){
		for(j in 1:ncol(hab.grid)){
			move.grid.inf[i,j] <- sum(move.inf[[i]][[j]])
		}
	}

###### Combine movements to produce popn list ##############
	for(i in 1:nrow(hab.grid)){
		for(j in 1:ncol(hab.grid)){
		popn[[i]][[j]][,1] <- popn.un[[i]][[j]]
		popn[[i]][[j]][,2] <- popn.inc[[i]][[j]]
		popn[[i]][[j]][,3] <- popn.inf[[i]][[j]]
		move[[i]][[j]][,1] <- move.un[[i]][[j]]
		move[[i]][[j]][,3] <- move.inc[[i]][[j]]
		move[[i]][[j]][,3] <- move.inf[[i]][[j]]
		}
	}


	return(list(new.pop = popn, movements = move, move.grid = list("uninfected"=move.grid.un, 
"incubating" = move.grid.inc, "infected"=move.grid.inf)))
}
				
			

