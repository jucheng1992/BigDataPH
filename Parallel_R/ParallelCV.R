library(doParallel)
library(randomForest)


winedata<-read.csv2("winequality-white.csv", header = TRUE)
curr<-data.matrix(winedata)


dataSplit = function(data, k, random.seed = NULL) {
      # Set seed to reproduce the same result
      if (!is.null(random.seed)) 
            set.seed(random.seed)
      
      n = nrow(data)
      m = n%/%k
      index = 1:n
      
      # Split into k folds
      ans = vector(k, mode = "list")
      for (i in 1:(k - 1)) {
            ans[[i]] = sample(index, m)
            # move index out of our candidate index set
            index = setdiff(index, ans[[i]])
      }
      ans[[k]] = index
      return(ans)
}

crossValidation = function(data, cv.index, i, formula.text) {
      n = nrow(data)
      # Use k_th fold as test set
      test.ind = cv.index[[i]]
      # Use the rest of data as training set
      train.ind = setdiff(1:n, test.ind)
      train.data = data[train.ind, ]
      test.data = data[test.ind, ]
      
      rp.model = randomForest(as.formula(formula.text), data = train.data,ntree=1000)
      rp.model
}

cv.index = dataSplit(data = winedata, k = 5, random.seed = 128)
k = 5
cv.model = vector(k, mode = "list")
scv.time<-system.time({
      for (i in 1:k) {
            cv.model[[i]] = crossValidation(curr, cv.index, i, "as.factor(quality)~.")
      }
})


cl <- makeCluster(4)
registerDoParallel(cl)
pcv.time<-system.time({
      cv.model <- foreach(i = 1:k, .packages = c("randomForest")) %dopar% {
            crossValidation(curr, cv.index, i, "as.factor(quality)~.")
      }
})
stopCluster(cl)


cv.model
scv.time
pcv.time


