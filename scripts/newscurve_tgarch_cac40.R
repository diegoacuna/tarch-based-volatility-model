library("quantmod")
library("rugarch")

#get CAC40 data from yahoo
getSymbols("FCHI",src="yahoo")
#now we have a symbol in the workspace called FCHI with CAC40 data

#we need to work with continously compounded returns, so...
ccr <- function(x) 100 * (log(x[-1]) - log(x[-length(x)]))
FCHI.CCR <- FCHI[,1]
FCHI.CCR <- apply(FCHI.CCR, 2, ccr)

#set a AR(1) + TGARCH(1,1) model
spec <- ugarchspec(variance.model = list(model = "apARCH", garchOrder = c(1,1)),
          mean.model = list(armaOrder = c(1,0), include.mean=T), fixed.pars=list(delta=1))
FCHI.CCR.fit_tgarch <- ugarchfit(spec, FCHI.CCR) 
#create and plot the news impact curve
ni <- newsimpact(z = NULL, FCHI.CCR.fit_tgarch)
par(mai=c(0.65, 0.560000, 0.5, 0.560000))
plot(ni$zx, ni$zy, ylab='', xlab='', type="l", main = "News Impact Curve", axes=FALSE)
axis(2, las=2, pos=0, mgp=c(1,0.5,0), tcl=0.25, lwd=0, lwd.ticks=1)
axis(2, las=2, pos=0, tcl=-0.25, labels=F, lwd=0, lwd.ticks=1)
abline(v=0)
axis(1)
mtext(ni$yexpr, line=-1, at=1.5)
mtext(ni$xexpr,side=1,adj=1,padj=0,line=-1)