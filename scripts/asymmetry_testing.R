#GMM Test for model specification. Main interest in this script is to get the 'fit' 
#variable, if we do show(fit) we can get a series of interesting tests about the 
#correct specification of ARCH disturbances and of the Sign Bias Test for asymmetry from
#Engle's and Ng work.
library(rugarch)
data(dji30ret)
spec = ugarchspec(mean.model = list(armaOrder = c(1,1), include.mean = TRUE),
                  variance.model = list(model = "gjrGARCH"), distribution.model = "sstd")
fit = ugarchfit(spec, data = dji30ret[, 1, drop = FALSE])
z = residuals(fit)/sigma(fit)
skew = dskewness("sstd",skew = coef(fit)["skew"], shape= coef(fit)["shape"])
# add back 3 since dkurtosis returns the excess kurtosis
kurt = 3+dkurtosis("sstd",skew = coef(fit)["skew"], shape= coef(fit)["shape"])
print(GMMTest(z, lags = 1, skew=skew, kurt=kurt))