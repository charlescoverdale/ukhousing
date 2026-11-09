# List available planning datasets

Returns a data frame of datasets hosted by planning.data.gov.uk, with
their slugs, names, and descriptions.

## Usage

``` r
ukh_planning_datasets()
```

## Value

A data frame with `slug`, `name`, `typology`, and `record_count`.

## See also

Other planning:
[`ukh_planning()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_planning.md)

## Examples

``` r
# \donttest{
op <- options(ukhousing.cache_dir = tempdir())
try({
  ds <- ukh_planning_datasets()
  head(ds)
})
#> Waiting 2s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 4s for retry backoff ■■■■■■■■■■■■■■■■■               
#> Waiting 4s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Error in value[[3L]](cond) : Failed to query planning.data.gov.uk.
#> ✖ HTTP 503 Service Unavailable.
options(op)
# }
```
