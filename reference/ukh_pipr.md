# ONS Index of Private Housing Rental Prices / Price Index of Private Rents

Fetches the UK's official private-rental price index from the ONS Beta
API. The dataset replaced the Index of Private Housing Rental Prices
(IPHRP) with the Price Index of Private Rents (PIPR) in January 2024,
but the same dataset slug covers both.

## Usage

``` r
ukh_pipr(refresh = FALSE)
```

## Arguments

- refresh:

  Logical. Re-download even if cached? Default `FALSE`.

## Value

A data frame with columns `date`, `region`, and `index`.

## Details

Coverage: UK aggregate plus countries (England, Scotland, Wales,
Northern Ireland) and English regions, monthly from January 2015.

## Examples

``` r
# \donttest{
op <- options(ukhousing.cache_dir = tempdir())
rents <- ukh_pipr()
#> ℹ Downloading ONS Price Index of Private Rents...
#> Warning: No observations returned from ONS PIPR.
head(rents)
#> [1] date   region index 
#> <0 rows> (or 0-length row.names)
options(op)
# }
```
