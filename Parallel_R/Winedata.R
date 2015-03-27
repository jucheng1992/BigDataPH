library(doParallel)
library(randomForest)

winedata<-read.csv2("winequality-white.csv", header = TRUE)

head(winedata)

curr<-data.matrix(winedata)

prf.time<-system.time({
      cl <- makeCluster(4)
      registerDoParallel(cl)
      ## each cluster, we set 2500 trees
      rf <- foreach(ntree=rep(2500, 4), 
                    .combine=combine,
                    .packages='randomForest') %dopar%
            randomForest(as.factor(quality)~., data=curr, ntree=ntree)
      stopCluster(cl)
})

srf.time<-system.time(
      randomForest(as.factor(quality)~., curr, ntree=1000)
)

prf.time
srf.time
summary(rf)
importance(rf)