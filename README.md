ImmPortR
================

<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis build status](https://travis-ci.org/RGLab/ImmPortR.svg?branch=master)](https://travis-ci.org/RGLab/ImmPortR) [![Coverage status](https://codecov.io/gh/RGLab/ImmPortR/branch/master/graph/badge.svg)](https://codecov.io/github/RGLab/ImmPortR?branch=master)

**WORK IN PROGRESS**

`ImmPortR` is an R wrapper around [the ImmPort API](http://docs.immport.org/#API/DataQueryAPI/dataqueryapi/) and [its download tool](http://docs.immport.org/#Tool/FileDownloadTool/filedownloadtool/).

What is ImmPort?
----------------

> [ImmPort](http://immport.org) is funded by the NIH, NIAID and DAIT in support of the NIH mission to share data with the public. Data shared through ImmPort has been provided by NIH-funded programs, other research organizations and individual scientists ensuring these discoveries will be the foundation of future research.

Installation
------------

``` r
# install.packages("devtools")
devtools::install_github("RGLab/ImmPortR")
```

Register and set ImmPort credential
-----------------------------------

-   [Register](https://immport-user-admin.niaid.nih.gov:8443/registrationuser/registration)
-   Read [the User Agreement](http://www.immport.org/agreement) for ImmPort
-   On your R console, set environment variables with your credential:

``` r
Sys.setenv(ImmPortUsername = "yourImmPortUsername")
Sys.setenv(ImmPortPassword = "yourImmPortPassword")
```

Usage
-----

### Query datasets

``` r
library(ImmPortR)

elisa <- query_dataset("SDY269", "elisa")
elispot <- query_dataset("SDY269", "elispot")
fcsAnalyzed <- query_dataset("SDY269", "fcsAnalyzed")
hai <- query_dataset("SDY269", "hai")
hlaTyping <- query_dataset("SDY269", "hlaTyping")
kirTyping <- query_dataset("SDY269", "kirTyping")
mbaa <- query_dataset("SDY269", "mbaa")
neutAbTiter <- query_dataset("SDY269", "neutAbTiter")
pcr <- query_dataset("SDY269", "pcr")
```

### Download files

``` r
download_immport("/SDY1/StudyFiles/Casale_Study_Summary_Report.doc")
```
