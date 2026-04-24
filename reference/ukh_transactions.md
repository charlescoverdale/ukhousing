# Transaction volumes for a region

Returns monthly residential transaction counts for a UK region. This is
a thin wrapper over
[`ukh_hpi()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_hpi.md)
that extracts the `sales_volume` column with its date. Transaction
volumes lag the headline index by approximately five months because the
Land Registry needs the full transaction set to settle.

## Usage

``` r
ukh_transactions(region, from = NULL, to = NULL, refresh = FALSE)
```

## Arguments

- region:

  Character. Region slug, GSS code, or common name.

- from, to:

  Optional. Date range (YYYY-MM-DD).

- refresh:

  Logical. Re-download? Default `FALSE`.

## Value

A data frame with `date`, `region`, and `sales_volume`.

## See also

Other house price index:
[`ukh_hpi()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_hpi.md),
[`ukh_hpi_compare()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_hpi_compare.md)

## Examples

``` r
# \donttest{
op <- options(ukhousing.cache_dir = tempdir())
tx <- ukh_transactions("england", from = "2020-01-01")
#> ℹ Downloading UK HPI for "england"...
head(tx)
#>         date  region sales_volume
#> 1 2020-01-01 england        56603
#> 2 2020-02-01 england        56568
#> 3 2020-03-01 england        57626
#> 4 2020-04-01 england        23673
#> 5 2020-05-01 england        30798
#> 6 2020-06-01 england        46664
options(op)
# }
```
