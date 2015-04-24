# sp500_simple_analysis.r
#
# An R "simple" time series analysis of the S&P500 index. Here, we look
# for evidence of variable conditional variance in the returns of the index.
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
symbol.vec = c("^GSPC")
getSymbols(symbol.vec, from ="1990-01-01", to = "2015-04-21")
colnames(GSPC)
start(GSPC)
end(GSPC)
# extract adjusted closing prices
GSPC = GSPC[, "GSPC.Adjusted", drop=F]
# calculate log-returns for GARCH analysis
GSPC.ret = CalculateReturns(GSPC, method="log")
# remove first NA observation
GSPC.ret = GSPC.ret[-1,]
colnames(GSPC.ret) = "GSPC"
# plot prices and returns in the same graph
par(mfrow=c(2,1))
plot(GSPC)
plot(GSPC.ret)
# plot the acf and pacf of returns
acf2(GSPC.ret)

