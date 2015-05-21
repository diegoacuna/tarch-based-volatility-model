# innovations_distribution_assumptions.r
#
# We test what is the effect on changing the underlying distribution of the
# innovation process in GARCH modeling and in the parameter estimation phase. We use
# IBM stock data and the rugarch package for the analysis.
#
# Diego Acuña <diego.acuna@usm.cl>
# April 27, 2015

# load libraries
library(PerformanceAnalytics)
library(quantmod)
library(rugarch)
library(car)
library(FinTS)

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

# Adjustment of a GARCH model to the data, for the conditional mean we fit an AR(1)
# model with mean just like in Tsay, Analysis of Financial Time Series (2010)

# The first model to adjust is a AR(1)-GARCH(1,1) with normal innovations
garch.norm <- ugarchspec(variance.model = list(model = "sGARCH", garchOrder = c(1,1)), 
                          mean.model = list(armaOrder = c(1,0), include.mean = TRUE),
                          distribution.model = "norm")
IBM.norm <- ugarchfit(garch.norm, IBM.ret)

# Now a AR(1)-GARCH(1,1) with student innovations
garch.std <- ugarchspec(variance.model = list(model = "sGARCH", garchOrder = c(1,1)), 
                         mean.model = list(armaOrder = c(1,0), include.mean = TRUE),
                         distribution.model = "std")
IBM.std <- ugarchfit(garch.std, IBM.ret)

# Now a AR(1)-GARCH(1,1) with generalized error innovations
garch.ged <- ugarchspec(variance.model = list(model = "sGARCH", garchOrder = c(1,1)), 
                         mean.model = list(armaOrder = c(1,0), include.mean = TRUE),
                         distribution.model = "ged")
IBM.ged <- ugarchfit(garch.ged, IBM.ret)

# Now a AR(1)-GARCH(1,1) with skewed normal innovations
garch.snorm <- ugarchspec(variance.model = list(model = "sGARCH", garchOrder = c(1,1)), 
                        mean.model = list(armaOrder = c(1,0), include.mean = TRUE),
                        distribution.model = "snorm")
IBM.snorm <- ugarchfit(garch.snorm, IBM.ret)

# Now a AR(1)-GARCH(1,1) with skewed student innovations
garch.sstd <- ugarchspec(variance.model = list(model = "sGARCH", garchOrder = c(1,1)), 
                          mean.model = list(armaOrder = c(1,0), include.mean = TRUE),
                          distribution.model = "sstd")
IBM.sstd <- ugarchfit(garch.sstd, IBM.ret)

# now check each fit object
IBM.norm
IBM.std
IBM.ged
IBM.snorm
IBM.sstd

