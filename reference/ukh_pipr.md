# ONS Price Index of Private Rents

Downloads the ONS Price Index of Private Rents (PIPR), UK: monthly price
statistics. PIPR replaced the Index of Private Housing Rental Prices in
2024 and is published monthly from January 2015 for the UK, its
countries, the English regions and local authorities (around 350 areas
in all), including average rents in pounds.

## Usage

``` r
ukh_pipr(property = "all", refresh = FALSE)
```

## Source

Office for National Statistics, Price Index of Private Rents, UK:
monthly price statistics. Official statistics in development.
<https://www.ons.gov.uk/economy/inflationandpriceindices/datasets/priceindexofprivaterentsukmonthlypricestatistics>

## Arguments

- property:

  Which series to return: `"all"` (default, all private rented
  property), a bedroom count (`"one bed"`, `"two bed"`, `"three bed"`,
  `"four or more bed"`) or a property type (`"detached"`,
  `"semidetached"`, `"terraced"`, `"flat maisonette"`).

- refresh:

  Logical. Re-download even if cached? Default `FALSE`.

## Value

A data frame with columns `date` (first of the month), `gss_code`,
`region` (area name), `parent_region` (the region or country an area
belongs to; `NA` for the UK and its countries), `index` (January 2023 =
100), `monthly_change_pct`, `annual_change_pct` and `rental_price_gbp`
(average monthly rent, rounded to the nearest pound). Values the ONS
marks as unavailable or not applicable are `NA`. Requires the readxl
package.

## Details

The ONS stopped updating the rental index on its Beta API at January
2024, so this function reads the monthly workbook from the ONS website
instead. The cached copy is refreshed once it is more than
`getOption("ukhousing.cache_max_age", 7)` days old.

## Examples

``` r
# \donttest{
op <- options(ukhousing.cache_dir = tempdir())
try({
  rents <- ukh_pipr()
  tail(rents[rents$region == "United Kingdom", ])
  flats <- ukh_pipr(property = "flat maisonette")
})
#> ℹ Downloading ONS Price Index of Private Rents...
#> ℹ Loading PIPR from cache. Use `refresh = TRUE` to re-download.
options(op)
# }
```
