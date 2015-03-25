library(doParallel)

#making cluster. Here we set the number of clusters equal to 2.
cl <- makeCluster(2)
registerDoParallel(cl)


## iris dataset 
x<- iris[which(iris[,5]!='setosa'),c(1,5)]
trials<- 1e5
# Parallel Computing
ptime<- system.time({
      ## icount count number of times that the iterator will fire. 
      r1<- foreach(icount(trials), .combine=cbind) %dopar% {
            ## Do sample from index 1 to 100. Sample 100 times with repalcement.
            ind<- sample(100,100,replace=T)
            ## Here we use logistic model. We use glm function used sampled data
            result1<- glm(x[ind,2]~x[ind,1],family=binomial(logit))
            coefficients(result1)
      }
})
## Compared with Sequatial Computing
stime<- system.time({
      r2<- foreach(icount(trials), .combine=cbind) %do% {
            ind<- sample(100,100,replace=T)
            result1<- glm(x[ind,2]~x[ind,1],family=binomial(logit))
            coefficients(result1)
      }
})

ptime
stime