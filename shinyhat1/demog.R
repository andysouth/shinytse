# Default Leslie matrix for Tsetse
tsetse.mat <- matrix(c(rep(0, 10), rep(0.5, 6), rep(0, 240)), nrow=16, ncol=16, byrow=T)
for(i in 2:16){
	for(j in 1:15){
		tsetse.mat[i,j] <- 0.95
	}
}
tsetse.mat[16,16] <- 0.95

# Tsetse deographic function
demog.tsetse <- function(popn, mat = tsetse.mat, hab = matrix(rep(1, 100), nrow=10, ncol=10), adult = 8){
	for(i in 1:nrow(hab)){
		for(j in 1:ncol(hab)){
			popn[[i]][[j]] <-  mat %*% matrix(popn[[i]][[j]], ncol=ncol(popn[[i]][[j]]))
			for(p in 1:(adult-1)){
				popn[[i]][[j]][p,1] <- popn[[i]][[j]][p,1] + popn[[i]][[j]][p,2] + popn[[i]][[j]][p,3] 
				popn[[i]][[j]][p,2] <- 0
				popn[[i]][[j]][p,3] <- 0
			}
		}
	}
	return(popn)
}

# Default human Lefkovitch matrix - rates estimated from Uganda - children become adults at 16 (1/ (16*365))

h.mat  <- matrix(c(0.99997, 0.0001, 0.00017, 0.99997), nrow=2, ncol=2, byrow=T)

# Human demographic function
demog.human <- function(popn, mat = h.mat, hab= matrix(rep(1, 100), nrow=10, ncol=10)){
	for(i in 1:nrow(hab)){
		for(j in 1:ncol(hab)){
			
			breed.mat <- h.mat
			breed.mat[2:nrow(popn[[i]][[j]]),] <- 0
			
			surv.mat <- h.mat
			surv.mat[1,] <- 0
			
			pop.breed <- breed.mat %*% matrix(popn[[i]][[j]], ncol=ncol(popn[[i]][[j]]))

			pop.new <- surv.mat %*% matrix(popn[[i]][[j]], ncol=ncol(popn[[i]][[j]]))
			
			pop.new[1,1] <- sum(pop.breed[1,])

			popn[[i]][[j]] <- pop.new
		}
	}
	return(popn)
}
