# Query planning.data.gov.uk

Fetches records from the Digital Land planning data platform, which
hosts over 100 datasets on planning applications, brownfield land, local
plans, conservation areas, listed buildings, flood risk zones, and more.

## Usage

``` r
ukh_planning(
  dataset,
  la = NULL,
  limit = 1000L,
  format = c("data.frame", "raw", "sf")
)
```

## Arguments

- dataset:

  Character. Dataset slug. Common values: `"planning-application"`,
  `"brownfield-land"`, `"local-plan"`, `"conservation-area"`,
  `"listed-building"`, `"article-4-direction-area"`,
  `"tree-preservation-zone"`, `"flood-risk-zone"`. See
  [`ukh_planning_datasets()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_planning_datasets.md)
  for the full list.

- la:

  Optional character. Local authority name (matched case-insensitively
  against the `organisation` field).

- limit:

  Integer. Maximum records to return. Default `1000`.

- format:

  Character. Response format. `"data.frame"` (default) returns tidy
  data. `"raw"` returns the parsed JSON list.

## Value

A data frame (or list if `format = "raw"`).

## See also

Other planning:
[`ukh_planning_datasets()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_planning_datasets.md)

## Examples

``` r
# \donttest{
op <- options(ukhousing.cache_dir = tempdir())
try({
  bf <- ukh_planning("brownfield-land", limit = 100)
  head(bf)
})
#> Waiting 2s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 2s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 4s for retry backoff ■■■■■■■■                        
#> Waiting 4s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Error in value[[3L]](cond) : Failed to query planning.data.gov.uk.
#> ✖ HTTP 503 Service Unavailable.
options(op)
# }
```
