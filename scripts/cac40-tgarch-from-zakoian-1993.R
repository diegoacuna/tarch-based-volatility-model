#
# Fit a TGARCH model to CAC40 series
#
library(xts)
library(rugarch)
library(PerformanceAnalytics)
library(car)
setwd("~/Dropbox/MII/Tesis/tarch-based-volatility-model/data/CAC40-1990-1999")
inputfile <- "cac40-1990-1999-full.csv"
file <- read.csv(inputfile)
file$Date <- strptime(file$Date, format = "%Y-%m-%d")
CAC40.xts <- xts(file[, c(2:7)], order.by = file[, "Date"])
#
#select only a subset on the data to aprox. work by Zakoian (1993)
#
CAC40.xts.AdjClose <- CAC40.xts[,"Adj.Close"]["1990-03-01/1991-12-12"]
CAC40.xts.dailyReturns <- 100*(diff(log(CAC40.xts.AdjClose), na.pad = FALSE))
#
#Plot the daily Returns
#
chart.TimeSeries(CAC40.xts.dailyReturns, main="Continously compounded rate of returns CAC40",
                 col="blue", lwd=1, ylab="CAC40")
#
# compute descriptive statistics
#
CAC40.xts.dailyReturns.coredata <- coredata(CAC40.xts.dailyReturns)
sample_mean <- apply(CAC40.xts.dailyReturns.coredata, 2, mean)
sample_sd <- apply(CAC40.xts.dailyReturns.coredata, 2, sd)
sample_skewness <- apply(CAC40.xts.dailyReturns.coredata, 2, skewness)
sample_kurtosis <- apply(CAC40.xts.dailyReturns.coredata, 2, kurtosis)
#
# histograms with normal density overlayed
#
hist(CAC40.xts.dailyReturns, main="CAC40 Daily Returns with Calibrated Normal curve", probability=T, col="slateblue1",,ylim=c(0,0.4),breaks=20)
x.vals = seq(-5, 5, length=100)
lines(x.vals, dnorm(x.vals, mean=sample_mean, sd=sample_sd), col="orange", lwd=2)
#
# Test normality of series
#
qqnorm(CAC40.xts.dailyReturns)
qqline(CAC40.xts.dailyReturns,col=2)
shapiro.test(CAC40.xts.dailyReturns.coredata)
qqPlot(CAC40.xts.dailyReturns.coredata)
#
# ACF and PACF of CC returns
#
chart.ACFplus(CAC40.xts.dailyReturns)
#
# Fit an AR(1) model to dailyReturns
#
CAC40.AR1 <- arima(as.ts(CAC40.xts.dailyReturns), order = c(1, 0, 0))
CAC40.AR1
#p-values
(1-pnorm(abs(CAC40.AR1$coef)/sqrt(diag(CAC40.AR1$var.coef))))*2
#it seems that p-values reject the AR(1) model, for daily returns we're only going to
#use a model like: x_t = \mu(x_t) + \epsilon_t
CAC40.resid <- CAC40.xts.dailyReturns - sample_mean
# Test the residuals for GARCH effects
chart.ACFplus(CAC40.resid) # no significant correlation for residuals
chart.ACFplus(CAC40.resid^2) # dependency in square!
chart.ACFplus(abs(CAC40.resid)) # dependency in absolute value!
# Fit a TGARCH(1,1) model
tgarch.spec <- ugarchspec(variance.model = list(model = "apARCH", garchOrder = c(1,1)), 
                          mean.model = list(armaOrder = c(0,0), include.mean = FALSE),
                          fixed.pars=list(delta=1))
CAC40.resid.fit <- ugarchfit(tgarch.spec, CAC40.resid)
# news impact curve
CAC40.resid.fit.nic <- newsimpact(CAC40.resid.fit)
plot(CAC40.resid.fit.nic$zx, CAC40.resid.fit.nic$zy, ylab=CAC40.resid.fit.nic$yexpr, xlab=CAC40.resid.fit.nic$xexpr, type="l", main = "News Impact Curve")
abline(v=0)
# examine standarized residuals
CAC40.resid.fit.zt <- residuals(CAC40.resid.fit)/sigma(CAC40.resid.fit)
CAC40.resid.fit.zt <- xts(CAC40.resid.fit.zt, order.by=index(CAC40.resid.fit.zt[,0]))
qqPlot(coredata(CAC40.resid.fit.zt))
plot(CAC40.resid.fit, which=8)
plot(CAC40.resid.fit, which=9)
