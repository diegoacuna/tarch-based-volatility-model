# A-PARCH based volatility models for the analysis of financial time series

This repository contains different resources used during the development of my master thesis in UTFSM. Next is a brief description of my work.

## Abstract

The success in prediction tasks on stochastic process using time series models is mainly attributable to the use of conditional mean of random variables involved in the process itself. Nevertheless, in a considerable number of applications primarily from economy, the modeling of conditional variance's structure is also necessary due to its potential stochastic nature. When the conditional variance changes over time, the underlying process may be classified as a heteroskedastic one. Experts recognize this as the volatility of a particular stochastic phenomenon.

In financial world, conditional variance of an asset's return is considered to be a metric of the risk associated with the asset itself, so the estimation of it is crucial in some pricing models and in value at risk calculations. This reflects the massive interest that actually exists in the topic. In literature, there's a big amount of work and papers on the concept of volatility. As a consequence, have emerged certain stylized facts observed in volatility, such as the persistence effect, mean reversion and asymmetry. Considering this stylized facts it seems clear that a good volatility model should be able to capture those effects in a way near from the observed ones.

In literature, one can find several specifications of volatility, such as the well known ARCH and GARCH models. Nevertheless, this models handle only persistence and mean reversion effects leaving outside the asymmetry effect. To solve this limitation, researchers have proposed extensions such as the E-GARCH and T-GARCH models. T-GARCH model is an interesting approach to asymmetry modeling, this suggest an attractive opportunity to the inclusions of improvements to the model and the asymmetry modeling in general. The main subject of this thesis consist on presenting an extension of T-GARCH model using different filters in the modeling of asymmetry with the objective of improve the accuracy of predictions in the actual model allowing for a better estimation of the risk associated to potential decisions involving assets and critical resources in financial markets.

**Keywords: time series, volatility, aparch, asymmetry.**

## Repository Content

The content of the repository consist mainly of:

 - Data files (CSV in most of the cases) with financial time series (open access). 
 - R scripts from my authority used in the analysis of different financial time series.
 - Pdf and .tex files from my authority that I wrote during the development of my master thesis.
 - Pdf and .tex files of my master thesis.
 
## Copyright notice

You're allowed to use the content of this repo for all purposes always using a strong reference to this work. In strict terms
this work is licensed under a [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/).
