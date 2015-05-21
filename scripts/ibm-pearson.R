library(quantmod)
library(devtools)
library(PerformanceAnalytics)
library(car)

#we set dev_mode to not interfere with previously installed fGarch package
dev_mode()
setwd("~/Downloads/fGarch")
load_all("./")

# download data from yahoo
symbol.vec = c("IBM")
getSymbols(symbol.vec, from ="1990-01-01", to = "2015-01-01")
# extract adjusted closing prices
IBM = IBM[, "IBM.Adjusted", drop=F]
# calculate log-returns for GARCH analysis
IBM.ret = CalculateReturns(IBM, method="log")
# remove first NA observation
IBM.ret = IBM.ret[-1,]
colnames(IBM.ret) = "IBM"

fit_norm <- garchFit(~aparch(1, 1), data = IBM.ret, trace = FALSE, algorithm = "nlminb", cond.dist = "norm")
fit_std <- garchFit(~aparch(1, 1), data = IBM.ret, trace = FALSE, algorithm = "nlminb", cond.dist = "std")
fit_ged <- garchFit(~aparch(1, 1), data = IBM.ret, trace = FALSE, algorithm = "nlminb", cond.dist = "ged")
fit_pearsonIV <- garchFit(~aparch(1, 1), data = IBM.ret, trace = FALSE, algorithm = "nlminb", cond.dist = "pearsonIV")
fit_sstd <- garchFit(~arma(1,0)+aparch(1, 1), data = IBM.ret, trace = FALSE, algorithm = "nlminb", cond.dist = "sstd")

library(TTR)
library(Metrics)
#get data to produce forecast comparisions
IBM_OUT = getSymbols("IBM", from ="2014-12-18", to = "2015-05-12", auto.assign = FALSE)
colnames(IBM_OUT) <- c("Open", "High", "Low", "Close", "Volume", "Adjusted")
gk_volatility <- TTR::volatility(IBM_OUT, calc = "garman.klass", N = 1)
gk_volatility <- gk_volatility[!is.na(gk_volatility[,1])] #remove the NA's

#preparing for the MSE calculation
vector_gk <- as.vector(gk_volatility)
vector_gk.month <- vector_gk[1:30]

norm_predict <- predict(fit_norm, n.ahead = 30)
norm_predict <- norm_predict$standardDeviation
std_predict <- predict(fit_std, n.ahead = 30)
std_predict <- std_predict$standardDeviation
ged_predict <- predict(fit_ged, n.ahead = 30)
ged_predict <- ged_predict$standardDeviation
pearsonIV_predict <- predict(fit_pearsonIV, n.ahead = 30)
pearsonIV_predict <- pearsonIV_predict$standardDeviation
sstd_predict <- predict(fit_sstd, n.ahead = 30)
sstd_predict <- sstd_predict$standardDeviation

#create a data frame to show results
measures <- c("MSE", "MAE", "Log Loss")
norm <- c(mse(vector_gk.month, norm_predict), mae(vector_gk.month, norm_predict), logLoss(vector_gk.month, norm_predict))
std <- c(mse(vector_gk.month, std_predict), mae(vector_gk.month, std_predict), logLoss(vector_gk.month, std_predict))
ged <- c(mse(vector_gk.month, ged_predict), mae(vector_gk.month, ged_predict), logLoss(vector_gk.month, ged_predict))
pearsonIV <- c(mse(vector_gk.month, pearsonIV_predict), mae(vector_gk.month, pearsonIV_predict), logLoss(vector_gk.month, pearsonIV_predict))
sstd <- c(mse(vector_gk.month, sstd_predict), mae(vector_gk.month, sstd_predict), logLoss(vector_gk.month, sstd_predict))

loss <- data.frame(measures, norm, std, ged, pearsonIV, sstd)
#print data frame on latex
library(xtable)
loss.table <- xtable(loss, digits = 10)
print(loss.table)
#shutdown dev mode
dev_mode()