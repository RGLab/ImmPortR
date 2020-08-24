ImmPortR
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![R build
status](https://github.com/RGLab/ImmPortR/workflows/R-CMD-check/badge.svg)](https://github.com/RGLab/ImmPortR/actions)
[![Coverage
status](https://codecov.io/gh/RGLab/ImmPortR/branch/master/graph/badge.svg)](https://codecov.io/github/RGLab/ImmPortR?branch=master)
[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
<!-- badges: end -->

`ImmPortR` is an R wrapper around [the ImmPort
API](http://docs.immport.org/#API/DataQueryAPI/dataqueryapi/) to query
datasets from [ImmPort Shared Data](https://www.immport.org/shared/home)
and upload data to [ImmPort Private
Data](https://immport.niaid.nih.gov/home), and it also utilizes [the
Aspera CLI](https://downloads.asperasoft.com/en/documentation/62) to
download files from ImmPort Shared Data.

## What is ImmPort?

> [ImmPort](http://immport.org) is funded by the NIH, NIAID and DAIT in
> support of the NIH mission to share data with the public. Data shared
> through ImmPort has been provided by NIH-funded programs, other
> research organizations and individual scientists ensuring these
> discoveries will be the foundation of future research.

## Installation

### ImmPortR

``` r
# install.packages("remotes")
remotes::install_github("RGLab/ImmPortR")
```

### The Aspera CLI

> The IBM Aspera Command-Line Interface (the Aspera CLI) is a collection
> of Aspera tools for performing high-speed, secure data transfers from
> the command line. The Aspera CLI is for users and organizations who
> want to automate their transfer workflows.

  - [Download](https://downloads.asperasoft.com/en/downloads/62)
  - [Documentation](https://downloads.asperasoft.com/en/documentation/62)

## Register and set ImmPort credentials

  - [Register](https://immport-user-admin.niaid.nih.gov:8443/registrationuser/registration)
  - Read [the User Agreement](http://www.immport.org/agreement) for
    ImmPort
  - Set environment variables with your ImmPort credentials, on your R
    console:

<!-- end list -->

``` r
Sys.setenv(ImmPortUsername = "yourImmPortUsername")
Sys.setenv(ImmPortPassword = "yourImmPortPassword")
```

  - Or in `.Renviron` file in your home directory:

<!-- end list -->

    ImmPortUsername=yourImmPortUsername
    ImmPortPassword=yourImmPortPassword

## Usage

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

### Validate data

``` r
validate_zip("yourStudyData.zip", workspace_id = 99999, upload_notes = "for SDY9999")
```
