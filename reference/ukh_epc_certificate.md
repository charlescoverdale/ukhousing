# Fetch a single EPC by LMK key

Returns all available fields and any improvement recommendations for one
Energy Performance Certificate identified by its LMK key.

## Usage

``` r
ukh_epc_certificate(lmk_key, type = c("domestic", "non-domestic", "display"))
```

## Arguments

- lmk_key:

  Character. The certificate's LMK key (found in the `lmk_key` column of
  [`ukh_epc_search()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_search.md)
  results).

- type:

  Character. Register: `"domestic"` (default), `"non-domestic"`, or
  `"display"`.

## Value

A list with two elements:

- certificate:

  A one-row data frame with all certificate fields.

- recommendations:

  A data frame of improvement recommendations (may be empty).

## See also

Other energy performance certificates:
[`ukh_epc_bulk()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_bulk.md),
[`ukh_epc_recommendations_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_recommendations_summary.md),
[`ukh_epc_search()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_search.md),
[`ukh_epc_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_summary.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cert <- ukh_epc_certificate("0000-0000-0000-0000-0000")
cert$certificate
cert$recommendations
} # }
```
