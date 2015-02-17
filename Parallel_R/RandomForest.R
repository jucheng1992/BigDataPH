library(randomForest)
system.time({
      cl <- makeCluster(4)
      registerDoParallel(cl)
      rf <- foreach(ntree=rep(2500, 4), 
                    .combine=combine,
                    .packages='randomForest') %dopar%
            randomForest(Species~., data=iris, ntree=ntree)
      stopCluster(cl)
})

system.time(
      randomForest(Species~., data=iris, ntree=10000)
)

