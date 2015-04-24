# ipsa_simple_analysis.r
#
# An R "simple" time series analysis of the chilean index IPSA. Here, we look
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
symbol.vec = c("^IPSA")
getSymbols(symbol.vec, from ="2002-01-02", to = "2015-04-21")
colnames(IPSA)
start(IPSA)
end(IPSA)
# extract adjusted closing prices
IPSA = IPSA[, "IPSA.Adjusted", drop=F]
# calculate log-returns for GARCH analysis
IPSA.ret = CalculateReturns(IPSA, method="log")
# remove first NA observation
IPSA.ret = IPSA.ret[-1,]
colnames(IPSA.ret) = "IPSA"
# plot prices and returns in the same graph
par(mfrow=c(2,1))
plot(IPSA)
plot(IPSA.ret)
# plot the acf and pacf of returns
acf2(IPSA.ret)