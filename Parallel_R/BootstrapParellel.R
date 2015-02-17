## using bootstrap to find the variance of median of exponential
library(foreach)
library(doParallel)

data<- rexp(100,rate=3) #generate 100 exponential data

##set the number of bootstraping
B=1000

cl <- makeCluster(2)
registerDoParallel(cl)

ptime<-system.time({
      medians <- foreach(1:B,.combine = c) %dopar% median(sample(data, 100, replace=TRUE))
})

vboot<-sum((medians - mean(medians))^2) / B
sqrt(vboot)


####sequential#####
stime<-system.time({
      medians1<-rep(0,B)
      for(i in 1:B){
      medians1[i]=median(sample(data,100,replace=TRUE))
      }
})

ptime
stime




