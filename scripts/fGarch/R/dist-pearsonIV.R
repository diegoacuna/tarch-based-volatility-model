
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Library General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Library General Public License for more details.
#
# You should have received a copy of the GNU Library General
# Public License along with this library; if not, write to the
# Free Foundation, Inc., 59 Temple Place, Suite 330, Boston,
# MA  02111-1307  USA


################################################################################
# FUNCTION:              DESCRIPTION:
#  dpearsonIV             Density for the Pearson IV type Distribution
################################################################################


dpearsonIV <-
function(x, mean = 0, sd = 1, nu = 1, m = 2.01, log = FALSE)
{
    # A function implemented by Diego Acuna

    # Description:
    #   Compute the density for the
    #   Pearson IV type Distribution

    # FUNCTION:

    # Params:
    if (length(mean) == 4) {
        m = mean[4]
        nu = mean[3]
        sd = mean[2]
        mean = mean[1]
    }  

    #set normalized elements (see "Econometric modeling and value-at-risk 
    #using the Pearson type-IV distribution" by Stavroyiannis et. al.)
    sigma_hat <- sqrt((1/(m-2))*(1+(nu^2)/(m-1)^2))
    mu_hat <- -nu/(m-1)
    z <- sigma_hat * x + mu_hat #here we use z but it should be x and x -> z
    m_fact <- (m+1)/2

    #check if we have the gsl r package to compute gamma function
    .hasGSL <- suppressWarnings(suppressPackageStartupMessages(require(gsl)))
    if (.hasGSL) {
        #we use logarithms to avoid floating problems
        log_k <- log(sigma_hat) - lgamma(m_fact) - 0.5*log(pi) - lgamma(m/2) + 
                 2*Re(gsl::lngamma_complex(m_fact+nu/2*1i))
        log_dist <- -nu*atan(z) - m_fact*log(1+z^2)
        if (log) {
            log_k + log_dist
        } else {
            exp(log_k + log_dist)
        }
    } else {
        stop("You need GSL package to use Pearson IV Distribution. Install with install.packages(gsl)") 
    }
}

################################################################################

