
# rosmosis

[![CRAN
status](https://www.r-pkg.org/badges/version/rosmosis)](https://CRAN.R-project.org/package=rosmosis)
[![B
status](https://github.com/dhersz/rosmosis/workflows/check/badge.svg)](https://github.com/dhersz/rosmosis/actions?query=workflow%3Acheck)
[![Codecov test
coverage](https://codecov.io/gh/dhersz/rosmosis/branch/main/graph/badge.svg)](https://app.codecov.io/gh/dhersz/rosmosis?branch=main)
[![Repo
status](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)

**rosmosis** allows one to download and run
[Osmosis](https://wiki.openstreetmap.org/wiki/Osmosis) from R. Osmosis
is a command line application for processing OpenStreetMap data which
consists of several different pluggable components that can be chained
to perform large operations. The package currently does not aim to offer
functions that covers the entirety of Osmosis’ API, and instead offers
limited support to running Osmosis through the `run_osmosis()` function.

## Installation

Development version:

``` r
# install.packages("remotes")
remotes::install_github("dhersz/rosmosis")
```
