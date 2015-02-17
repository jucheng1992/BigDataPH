## Collatz conjecture
## If it is even, divided by 2. else, times 3 and plus 1. All numers will become one.
func <- function(x) {
      n = 1
      raw <- x
      while (x > 1) {
            x <- ifelse(x%%2==0,x/2,3*x+1)
            n = n + 1
      }
      return(c(raw,n))
}

library(parallel)
## Use system.time to calculate our time
system.time({
      x <- 1:1e5
      cl <- makeCluster(4)   #set number of cluster equals 4
      results <- parLapply(cl,x,func) # parallel version of lapply
      res.df <- do.call('rbind',results) # combine this result into total result
      stopCluster(cl) # close cluster
})
## Find the number with most number of iteration.
res.df[which.max(res.df[,2]),1]

###################Package: foreach#############

library(foreach)
# do is for non-parallel(similar to sapply)
system.time(
      x <- foreach(x=1:1000,.combine='rbind') %do% func(x)
)

library(doParallel)
#  parallel
system.time({
      cl <- makeCluster(4)
      registerDoParallel(cl)
      x <- foreach(x=1:1000,.combine='rbind') %dopar% func(x)
      stopCluster(cl)
})



