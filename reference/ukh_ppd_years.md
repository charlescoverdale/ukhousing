# Price Paid Data across multiple years

Convenience wrapper that calls
[`ukh_ppd()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd.md)
for each year in a vector and row-binds the results. Caches each year
independently.

## Usage

``` r
ukh_ppd_years(years, ...)
```

## Arguments

- years:

  Integer vector. Years to fetch.

- ...:

  Additional arguments passed to
  [`ukh_ppd()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd.md)
  (e.g. `la`, `postcode`, `property_type`).

## Value

A single data frame combining transactions from all requested years.

## See also

Other price paid data:
[`ukh_ppd()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd.md),
[`ukh_ppd_address()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_address.md),
[`ukh_ppd_bulk()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_bulk.md),
[`ukh_ppd_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_summary.md),
[`ukh_ppd_transaction()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_transaction.md)

## Examples

``` r
# \donttest{
op <- options(ukhousing.cache_dir = tempdir())
five_year <- ukh_ppd_years(2020:2024, la = "Westminster",
                           property_type = "flat")
#> ℹ Downloading pp-2020.csv from HM Land Registry...
#> ℹ Downloading pp-2021.csv from HM Land Registry...
#> ℹ Downloading pp-2022.csv from HM Land Registry...
#> ℹ Downloading pp-2023.csv from HM Land Registry...
#> ℹ Loading pp-2024.csv from cache.
nrow(five_year)
#> [1] 0
options(op)
# }
```
