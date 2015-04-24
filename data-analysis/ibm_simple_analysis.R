# ibm_simple_analysis.r
#
# An R "simple" time series analysis of the IBM stock. Here, we look
# for evidence of variable conditional variance in the returns of the stock.
#
# Diego Acuña <diego.acuna@usm.cl>
# April 22, 2015

# load libraries
library(PerformanceAnalytics)
library(quantmod)
library(rugarch)
library(car)
library(FinTS)
library(astsa)

# download data from yahoo
symbol.vec = c("IBM")
getSymbols(symbol.vec, from ="1990-01-01", to = "2015-04-21")
colnames(IBM)
start(IBM)
end(IBM)
# extract adjusted closing prices
IBM = IBM[, "IBM.Adjusted", drop=F]
# calculate log-returns for GARCH analysis
IBM.ret = CalculateReturns(IBM, method="log")
# remove first NA observation
IBM.ret = IBM.ret[-1,]
colnames(IBM.ret) = "IBM"
# plot prices and returns in the same graph
par(mfrow=c(2,1))
plot(IBM)
plot(IBM.ret)
# plot the acf and pacf of returns
acf2(IBM.ret)
