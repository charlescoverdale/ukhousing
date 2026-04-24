# EPC rating distribution for a local authority

Summarises the distribution of current energy ratings (A-G) for domestic
certificates in a local authority. Useful for area-level comparisons of
housing stock efficiency.

## Usage

``` r
ukh_epc_summary(
  la,
  from = NULL,
  to = NULL,
  type = c("domestic", "non-domestic", "display")
)
```

## Arguments

- la:

  Character. Local authority GSS code.

- from, to:

  Optional. Lodgement date range.

- type:

  Character. Register: `"domestic"` (default), `"non-domestic"`, or
  `"display"`.

## Value

A data frame with one row per rating (A-G) and columns `rating`,
`count`, `percentage`, `mean_floor_area`, `mean_co2_emissions`.

## See also

Other energy performance certificates:
[`ukh_epc_bulk()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_bulk.md),
[`ukh_epc_certificate()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_certificate.md),
[`ukh_epc_recommendations_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_recommendations_summary.md),
[`ukh_epc_search()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_search.md)

## Examples

``` r
if (FALSE) { # \dontrun{
ukh_epc_summary(la = "E09000033")
} # }
```
