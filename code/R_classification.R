library('MASS')
library('class')
library(e1071)
library(kernlab)
setwd('/Users/LJ/MSOR/NeuralStat/FinalProj/code')

n <- dim(X)[1]
n_test <- floor(.2 * n)

test_rows <- sample(1:n, n_test)
X_test <- X[test_rows,]
X_train <- X[-test_rows,]
Y_test <- Y[test_rows,]
Y_train <- Y[-test_rows,]

lda_model <- lda(X_train, t(Y_train))
lda_pred <- predict(lda_model, X_test)
k_nn_pred <- knn(X_train, X_test, t(Y_train))

svp <- ksvm(X_train,Y_train,type="C-svc",C=100,scaled=c())
