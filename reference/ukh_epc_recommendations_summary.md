# Summarise EPC improvement recommendations for a local authority

Aggregates the improvement recommendations across certificates in a
local authority, returning the frequency of each recommendation and the
mean estimated cost and savings where available.

## Usage

``` r
ukh_epc_recommendations_summary(
  la,
  type = c("domestic", "non-domestic", "display"),
  refresh = FALSE
)
```

## Arguments

- la:

  Character. Local authority GSS code.

- type:

  Character. `"domestic"` (default), `"non-domestic"`, or `"display"`.

- refresh:

  Logical. Re-download bulk ZIP? Default `FALSE`.

## Value

A data frame with columns `improvement_id`, `improvement_summary`,
`count`, `mean_indicative_cost` (where numeric costs are reported),
ordered by `count` descending.

## Details

This uses the bulk per-LA ZIP download rather than the paginated API,
which is much faster for this aggregation. Requires EPC API credentials.

## See also

Other energy performance certificates:
[`ukh_epc_bulk()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_bulk.md),
[`ukh_epc_certificate()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_certificate.md),
[`ukh_epc_search()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_search.md),
[`ukh_epc_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_summary.md)

## Examples

``` r
if (FALSE) { # \dontrun{
recs <- ukh_epc_recommendations_summary("E09000033")
head(recs)
} # }
```
