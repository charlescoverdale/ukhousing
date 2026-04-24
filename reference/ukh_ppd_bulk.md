# Download a Price Paid Data bulk file

Downloads and caches a yearly (or the complete) Price Paid Data CSV from
HM Land Registry. Returns the path to the cached file. Yearly files are
typically 100-200 MB; the complete file (1995-present) is approximately
5.3 GB.

## Usage

``` r
ukh_ppd_bulk(
  year = as.integer(format(Sys.Date(), "%Y")),
  full = FALSE,
  refresh = FALSE
)
```

## Arguments

- year:

  Integer. Year to download. Ignored when `full = TRUE`. Defaults to the
  current year.

- full:

  Logical. If `TRUE`, download the complete file (`pp-complete.csv`,
  ~5.3 GB) instead of a single year. Default `FALSE`.

- refresh:

  Logical. Re-download even if cached? Default `FALSE`.

## Value

Character. The path to the cached CSV file.

## See also

Other price paid data:
[`ukh_ppd()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd.md),
[`ukh_ppd_address()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_address.md),
[`ukh_ppd_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_summary.md),
[`ukh_ppd_transaction()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_transaction.md),
[`ukh_ppd_years()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_years.md)

## Examples

``` r
# \donttest{
op <- options(ukhousing.cache_dir = tempdir())
path <- ukh_ppd_bulk(2025)
#> ℹ Downloading pp-2025.csv from HM Land Registry...
options(op)
# }
```
