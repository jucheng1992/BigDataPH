library(doParallel)
library(randomForest)
prf.time<-system.time({
      cl <- makeCluster(4)
      registerDoParallel(cl)
      rf <- foreach(ntree=rep(2500, 4), 
                    .combine=combine,
                    .packages='randomForest') %dopar%
            randomForest(Species~., data=iris, ntree=ntree)
      stopCluster(cl)
})

srf.time<-system.time(
      randomForest(Species~., data=iris, ntree=10000)
)

prf.time
srf.time