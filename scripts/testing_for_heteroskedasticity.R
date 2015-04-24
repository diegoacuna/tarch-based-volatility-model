#Apply Ljung-Box test

random_data <- rnorm(500, 0, 1)
box.test <- Box.test(random_data, lag=10, type = "Ljung-Box")
box.test$p.value #below 0.05 = evidence of dependece, above = lack of evidence of dependence

#If you fit an ARIMA model on your data, use astsa:sarima:
library(astsa)
library(quantmod)
library(PerformanceAnalytics)

getSymbols("MSFT", from ="2000-01-03", to = "2012-04-03")
MSFT = MSFT[, "MSFT.Adjusted", drop=F]
MSFT.ret = CalculateReturns(MSFT, method="log") #log-returns
MSFT.ret = MSFT.ret[-1,] #the first obs. is NA, remove it
chart.TimeSeries(MSFT.ret)
MSFT.coredata <- coredata(MSFT.ret)
acf2(MSFT.coredata)
#looks like an AR(1-3-5), test the data with Box.test
Box.test(MSFT.coredata, lag=5, type = "Ljung-Box") # <-- small p-values
#Adjust an AR(5) model using sarima function, we get Ljung-Box p-values for free!
MSFT.adjusted <- sarima(MSFT.coredata, 5, 0, 0) 
# doesn't look so bad, Normal Q-Q plot show big evidence of ARCH effects
acf2(MSFT.adjusted$fit$residuals) #mm little evidence of dependence, maybe white noise?
acf2(MSFT.adjusted$fit$residuals^2)  #not!
#End of Ljung-Box test.

#Testing using Engle's LM test
library(FinTS)
#we're going to test if the residuals show evidence of ARCH disturbances
MSFT.at <- ArchTest(MSFT.adjusted$fit$residuals)
MSFT.at  #a p-value below 0.05 <-  evidence of ARCH effects, above = no evidence
#in this case there's stronge evidence of ARCH effects.

#Macleod-Li Test
library(TSA)
McLeod.Li.test(object = MSFT.adjusted$fit, gof.lag = 20)
#p-value below 0.05 reflects dependences on the square residuals, this is evidence
#of conditional variance

#Conclusion: residuals of MSFT show ARCH effects.