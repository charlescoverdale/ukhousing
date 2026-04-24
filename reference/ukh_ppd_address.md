# Look up Price Paid transactions by postcode address

Uses the Land Registry linked data address lookup to find all
transactions at a given postcode. Faster than downloading the yearly
bulk file when you only want a single postcode.

## Usage

``` r
ukh_ppd_address(postcode)
```

## Arguments

- postcode:

  Character. Full UK postcode (e.g. `"SW1A 1AA"`).

## Value

A data frame of transactions at addresses matching the postcode.

## See also

Other price paid data:
[`ukh_ppd()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd.md),
[`ukh_ppd_bulk()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_bulk.md),
[`ukh_ppd_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_summary.md),
[`ukh_ppd_transaction()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_transaction.md),
[`ukh_ppd_years()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_years.md)

## Examples

``` r
# \donttest{
op <- options(ukhousing.cache_dir = tempdir())
tx <- ukh_ppd_address("SW1A 1AA")
head(tx)
#> data frame with 0 columns and 0 rows
options(op)
# }
```
