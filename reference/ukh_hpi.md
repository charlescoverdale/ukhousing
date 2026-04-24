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

# All UK average house prices
uk <- ukh_hpi("united-kingdom")
#> ℹ Downloading UK HPI for "united-kingdom"...
head(uk)
#>         date         region   hpi avg_price pct_change_monthly
#> 1 2025-03-01 united-kingdom 102.8    268205                 NA
#> 2 2025-04-01 united-kingdom  99.9    260615                 NA
#> 3 2025-05-01 united-kingdom 101.2    263981                 NA
#> 4 2025-06-01 united-kingdom 102.3    267004                 NA
#> 5 2025-07-01 united-kingdom 103.2    269373                 NA
#> 6 2025-08-01 united-kingdom 104.1    271690                 NA
#>   pct_change_annual sales_volume avg_price_detached avg_price_semi
#> 1                NA       133663             430697         269829
#> 2                NA        43449             429276         262652
#> 3                NA        63511             431436         265852
#> 4                NA        69621             434868         269348
#> 5                NA        72184             438688         272360
#> 6                NA        73443             443724         275866
#>   avg_price_terraced avg_price_flat avg_price_cash avg_price_mortgage
#> 1             227302         198905             NA                 NA
#> 2             216495         191988             NA                 NA
#> 3             221867         193460             NA                 NA
#> 4             224773         195615             NA                 NA
#> 5             227505         195868             NA                 NA
#> 6             229519         195619             NA                 NA
#>   avg_price_new_build avg_price_existing avg_price_first_time_buyer
#> 1              342321             264661                         NA
#> 2              342940             256522                         NA
#> 3              341677             260191                         NA
#> 4              339143             263580                         NA
#> 5              344611             265762                         NA
#> 6              350751             267847                         NA
#>   avg_price_former_owner
#> 1                     NA
#> 2                     NA
#> 3                     NA
#> 4                     NA
#> 5                     NA
#> 6                     NA

# London, last 10 years
london <- ukh_hpi("london", from = "2016-01-01")
#> ℹ Downloading UK HPI for "london"...
tail(london)
#>           date region  hpi avg_price pct_change_monthly pct_change_annual
#> 117 2025-09-01 london 99.0    565404                 NA                NA
#> 118 2025-10-01 london 97.2    554713                 NA                NA
#> 119 2025-11-01 london 97.2    554726                 NA                NA
#> 120 2025-12-01 london 96.0    548193                 NA                NA
#> 121 2026-01-01 london 96.9    553066                 NA                NA
#> 122 2026-02-01 london 95.0    542304                 NA                NA
#>     sales_volume avg_price_detached avg_price_semi avg_price_terraced
#> 117         6032            1174549         726573             651795
#> 118         6097            1164536         721600             640030
#> 119         4361            1156870         720605             640685
#> 120         4386            1146891         714155             632537
#> 121           NA            1152149         720797             644842
#> 122           NA            1139541         711970             628230
#>     avg_price_flat avg_price_cash avg_price_mortgage avg_price_new_build
#> 117         443032         605218             557081              498647
#> 118         432409         588291             548013              511780
#> 119         432643         586234             548583              529862
#> 120         427271         579798             541996              490886
#> 121         428747         587389             546158                  NA
#> 122         420635         572371             536426                  NA
#>     avg_price_existing avg_price_first_time_buyer avg_price_former_owner
#> 117             568463                         NA                 710847
#> 118             556614                         NA                 695731
#> 119             555781                         NA                 694427
#> 120             550791                         NA                 686453
#> 121                 NA                         NA                 697108
#> 122                 NA                         NA                 680234

options(op)
# }
```
