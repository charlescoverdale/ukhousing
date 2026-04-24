# Compare UK HPI across multiple regions

Fetches the UK House Price Index for several regions and returns a wide
data frame with one measure (e.g. average price or annual % change) as a
column per region. Useful for regional comparison charts.

## Usage

``` r
ukh_hpi_compare(
  regions,
  measure = "avg_price",
  from = NULL,
  to = NULL,
  refresh = FALSE
)
```

## Arguments

- regions:

  Character vector of region slugs, GSS codes, or names.

- measure:

  Character. Which measure to return. One of `"avg_price"`, `"hpi"`,
  `"pct_change_annual"`, `"pct_change_monthly"`, or `"sales_volume"`.
  Default `"avg_price"`.

- from, to:

  Optional character or Date. Date range.

- refresh:

  Logical. Re-download even if cached? Default `FALSE`.

## Value

A wide data frame with a `date` column and one column per region.

## See also

Other house price index:
[`ukh_hpi()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_hpi.md),
[`ukh_transactions()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_transactions.md)

## Examples

``` r
# \donttest{
op <- options(ukhousing.cache_dir = tempdir())

prices <- ukh_hpi_compare(
  c("london", "manchester", "newcastle-upon-tyne"),
  measure = "avg_price",
  from = "2015-01-01"
)
#> ℹ Downloading UK HPI for "london"...
#> ℹ Downloading UK HPI for "manchester"...
#> ℹ Downloading UK HPI for "newcastle-upon-tyne"...
head(prices)
#>         date london manchester newcastle-upon-tyne
#> 1 2015-01-01     NA     128873                  NA
#> 2 2015-02-01     NA     128736                  NA
#> 3 2015-03-01     NA     128771                  NA
#> 4 2015-04-01     NA     128869                  NA
#> 5 2015-05-01     NA     131114                  NA
#> 6 2015-06-01     NA     131653                  NA

options(op)
# }
```
