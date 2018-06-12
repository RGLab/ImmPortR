ImmPortR
================

<!-- README.md is generated from README.Rmd. Please edit that file -->
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
options(ImmPortUsername = "yourImmPortUsername")
options(ImmPortPassword = "yourImmPortPassword")
```

Usage
-----

``` r
library(ImmPortR)

elisa <- query_dataset("elisa", "SDY269")
elispot <- query_dataset("SDY269")
fcsAnalyzed <- query_dataset("fcsAnalyzed", "SDY269")
hai <- query_dataset("hai", "SDY269")
hlaTyping <- query_dataset("hlaTyping", "SDY269")
kirTyping <- query_dataset("kirTyping", "SDY269")
mbaa <- query_dataset("mbaa", "SDY269")
neutAbTiter <- query_dataset("neutAbTiter", "SDY269")
pcr <- query_dataset("pcr", "SDY269")
```
