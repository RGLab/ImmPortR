ImmPortR
================

<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis build status](https://travis-ci.org/juyeongkim/ImmPortR.svg?branch=master)](https://travis-ci.org/juyeongkim/ImmPortR)

An R wrapper around [the ImmPort API](http://docs.immport.org/#API/DataQueryAPI/dataqueryapi/).

Installation
------------

``` r
# install.packages("devtools")
devtools::install_github("juyeongkim/ImmPortR")
```

Set ImmPort credential
----------------------

``` r
Sys.setenv(ImmPortUsername = "yourImmPortUsername")
Sys.setenv(ImmPortPassword = "yourImmPortPassword")
```

Usage
-----

### Query datasets

``` r
library(ImmPortR)

elisa <- query_dataset("elisa", "SDY269")
elispot <- query_dataset("elispot", "SDY269")
fcsAnalyzed <- query_dataset("fcsAnalyzed", "SDY269")
hai <- query_dataset("hai", "SDY269")
hlaTyping <- query_dataset("hlaTyping", "SDY269")
kirTyping <- query_dataset("kirTyping", "SDY269")
mbaa <- query_dataset("mbaa", "SDY269")
neutAbTiter <- query_dataset("neutAbTiter", "SDY269")
pcr <- query_dataset("pcr", "SDY269")
```

### Download files

``` r
download_immport("/SDY1/StudyFiles/Casale_Study_Summary_Report.doc")
```
