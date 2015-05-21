# garch_simulation.r
#
# Script showing how to simulate a GARCH process using the rugarch package
#
# Diego Acuña <diego.acuna@usm.cl>
# April 28, 2015

library(rugarch)

# A basic mu-GARCH(1,1) model with normal innovations
spec.norm <- ugarchspec(variance.model=list(model="sGARCH", garchOrder=c(1,1)),
                        mean.model=list(armaOrder=c(0,0), include.mean=TRUE), 
                        distribution.model="norm",
                        fixed.pars=list(mu=0.001,omega=0.00001, alpha1=0.05, beta1=0.90))
norm.data <- ugarchpath(spec.norm, n.sim=3000, n.start=1, m.sim=1)
norm.rawdata <- fitted(norm.data)
plot.ts(norm.rawdata) # a plot of the return series
# fit the same model to the simulated data, we should get similar parameters to the fixed ones
norm.spec <- ugarchspec(variance.model=list(model="sGARCH", garchOrder=c(1,1)),
                        mean.model=list(armaOrder=c(0,0), include.mean=TRUE), 
                        distribution.model="norm")
norm.fit <- ugarchfit(norm.spec, norm.rawdata)