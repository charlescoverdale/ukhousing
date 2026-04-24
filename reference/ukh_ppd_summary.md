# Price Paid Data summary

Returns summary statistics from Price Paid Data for a given year,
aggregated by month, property type, or local authority. Useful when the
user wants counts and median prices without loading 150 MB of individual
transactions.

## Usage

``` r
ukh_ppd_summary(
  year = as.integer(format(Sys.Date(), "%Y")),
  by = c("month", "property_type", "la"),
  la = NULL,
  refresh = FALSE
)
```

## Arguments

- year:

  Integer. Year to summarise.

- by:

  Character. Aggregation dimension: `"month"`, `"property_type"`, or
  `"la"`. Default `"month"`.

- la:

  Optional character. Restrict to one local authority.

- refresh:

  Logical. Re-download even if cached? Default `FALSE`.

## Value

A data frame with one row per group and columns `n`, `median_price`,
`mean_price`, `total_value`.

## See also

Other price paid data:
[`ukh_ppd()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd.md),
[`ukh_ppd_address()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_address.md),
[`ukh_ppd_bulk()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_bulk.md),
[`ukh_ppd_transaction()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_transaction.md),
[`ukh_ppd_years()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_years.md)

## Examples

``` r
# \donttest{
op <- options(ukhousing.cache_dir = tempdir())
# Monthly transaction counts and medians, nationally
s <- ukh_ppd_summary(2025, by = "month")
#> ℹ Loading pp-2025.csv from cache.
head(s)
#>     month      n median_price mean_price total_value
#> 1 2025-01  68314       285000   402558.7 27500397986
#> 2 2025-02  76255       285000   387726.9 29566114571
#> 3 2025-03 137411       315000   389497.8 53521277782
#> 4 2025-04  39117       242000   361101.6 14125209828
#> 5 2025-05  55968       265000   361543.9 20234888132
#> 6 2025-06  61709       275000   372241.0 22970616884
options(op)
# }
```
