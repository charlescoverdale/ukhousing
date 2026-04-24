# Download a bulk EPC ZIP for a local authority

Downloads and extracts the MHCLG bulk ZIP containing all domestic
certificates and recommendations for one local authority. The ZIP is
typically 5 to 50 MB and contains `certificates.csv`,
`recommendations.csv`, and a licence file.

## Usage

``` r
ukh_epc_bulk(
  la,
  refresh = FALSE,
  type = c("domestic", "non-domestic", "display")
)
```

## Arguments

- la:

  Character. Local authority GSS code (e.g. `"E09000033"`).

- refresh:

  Logical. Re-download even if cached? Default `FALSE`.

- type:

  Character. Register: `"domestic"` (default), `"non-domestic"`, or
  `"display"`.

## Value

A list with elements `certificates` and `recommendations`, each giving
the path to the extracted CSV.

## See also

Other energy performance certificates:
[`ukh_epc_certificate()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_certificate.md),
[`ukh_epc_recommendations_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_recommendations_summary.md),
[`ukh_epc_search()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_search.md),
[`ukh_epc_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_summary.md)

## Examples

``` r
if (FALSE) { # \dontrun{
paths <- ukh_epc_bulk("E09000033")
certs <- read.csv(paths$certificates)
} # }
```
