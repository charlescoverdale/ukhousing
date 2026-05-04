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
#> 1 2025-01  68686       285000   404685.0 27796196252
#> 2 2025-02  77084       285000   390436.1 30096374487
#> 3 2025-03 142426       315000   392548.1 55909058592
#> 4 2025-04  43265       244000   372206.2 16103501080
#> 5 2025-05  63070       263000   367333.1 23167697849
#> 6 2025-06  69356       275000   380548.7 26393334209
options(op)
# }
```
