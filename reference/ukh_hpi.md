# UK House Price Index

Fetches monthly UK House Price Index data for a region from the HM Land
Registry linked data service. Coverage: 441+ areas (countries, regions,
counties, local authorities) from January 1995 (England and Wales),
January 2004 (Scotland), January 2005 (Northern Ireland).

## Usage

``` r
ukh_hpi(region, from = NULL, to = NULL, refresh = FALSE)
```

## Arguments

- region:

  Character. Region slug, GSS code, or common name (e.g.
  `"westminster"`, `"Westminster"`, `"E09000033"`). See
  [`ukh_regions()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_regions.md)
  for common options.

- from, to:

  Optional character or Date. Start and end dates in ISO format
  (YYYY-MM-DD). Default returns the full available history.

- refresh:

  Logical. Re-download even if cached? Default `FALSE`.

## Value

A data frame with one row per month. Columns include `date`, `region`,
`hpi`, `avg_price`, `pct_change_monthly`, `pct_change_annual`,
`sales_volume`, plus property-type and buyer-type average prices.

## Details

The returned data frame includes the headline index, average price,
monthly and annual percentage change, sales volume, and breakdowns by
property type (detached, semi-detached, terraced, flat) and by buyer
type (cash, mortgage, first-time buyer, former owner occupier, new
build, existing property).

Sales volumes lag the headline index by approximately five months
because the Land Registry needs the full transaction set to settle.

## See also

Other house price index:
[`ukh_hpi_compare()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_hpi_compare.md),
[`ukh_transactions()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_transactions.md)

## Examples

``` r
# \donttest{
op <- options(ukhousing.cache_dir = tempdir())
try({
  # All UK average house prices
  uk <- ukh_hpi("united-kingdom")
  head(uk)

  # London, last 10 years
  london <- ukh_hpi("london", from = "2016-01-01")
  tail(london)
})
#> ℹ Downloading UK HPI for "united-kingdom"...
#> ℹ Downloading UK HPI for "london"...
#>           date region  hpi avg_price pct_change_monthly pct_change_annual
#> 123 2026-03-01 london 95.7    546111               -0.1              -1.4
#> 124 2026-04-01 london 97.1    554363                1.5              -1.8
#> 125 2026-05-01 london 96.3    549535               -0.9              -2.8
#> 126 2026-06-01 london 96.6    551440                0.3              -2.9
#> 127 2026-07-01 london 96.4    550340               -0.2              -3.2
#> 128 2026-08-01 london 97.1    554430                0.7              -2.2
#>     sales_volume avg_price_detached avg_price_semi avg_price_terraced
#> 123         5756            1141255         711909             636033
#> 124         4994            1151715         715518             639025
#> 125         4595            1143843         715020             635865
#> 126         4309            1164245         719184             640835
#> 127           NA            1165827         725964             643659
#> 128           NA            1164439         730580             648650
#>     avg_price_flat avg_price_cash avg_price_mortgage avg_price_new_build
#> 123         423495         580263             539163              498050
#> 124         433842         592969             546336              502524
#> 125         428068         583879             542549              514075
#> 126         427683         585517             544526              475340
#> 127         423766         583899             543551                  NA
#> 128         427310         583137             548866                  NA
#>     avg_price_existing avg_price_first_time_buyer avg_price_former_owner
#> 123             548268                     464865                 686945
#> 124             556693                     471544                 697842
#> 125             551118                     468822                 689699
#> 126             554928                     469886                 692925
#> 127                 NA                     467737                 693355
#> 128                 NA                     473051                 695762
options(op)
# }
```
