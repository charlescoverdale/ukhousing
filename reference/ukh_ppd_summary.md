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
try({
  # Monthly transaction counts and medians, nationally
  s <- ukh_ppd_summary(2025, by = "month")
  head(s)
})
#> ℹ Loading pp-2025.csv from cache.
#>     month      n median_price mean_price total_value
#> 1 2025-01  69481       285000   407817.3 28335552464
#> 2 2025-02  78000       285000   394563.9 30775987613
#> 3 2025-03 145188       315000   395793.4 57464454597
#> 4 2025-04  44714       245000   372326.7 16648215067
#> 5 2025-05  66237       265000   370829.7 24562645645
#> 6 2025-06  79133       280000   389748.2 30841943671
options(op)
# }
```
