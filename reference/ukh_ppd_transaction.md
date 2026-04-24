# Look up a single Price Paid transaction by ID

Fetches the full metadata for one transaction from the Land Registry
linked data service by its transaction unique identifier.

## Usage

``` r
ukh_ppd_transaction(id)
```

## Arguments

- id:

  Character. A transaction unique identifier (GUID, with or without
  curly braces).

## Value

A one-row data frame with the transaction fields, or an empty data frame
if the transaction is not found.

## See also

Other price paid data:
[`ukh_ppd()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd.md),
[`ukh_ppd_address()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_address.md),
[`ukh_ppd_bulk()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_bulk.md),
[`ukh_ppd_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_summary.md),
[`ukh_ppd_years()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_years.md)

## Examples

``` r
# \donttest{
op <- options(ukhousing.cache_dir = tempdir())
tx <- ukh_ppd_transaction("{A4C5B0C6-4D5D-47E2-E053-6C04A8C07E7C}")
tx
#> data frame with 0 columns and 0 rows
options(op)
# }
```
