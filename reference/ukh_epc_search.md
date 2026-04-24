# Search domestic Energy Performance Certificates

Queries the MHCLG EPC Open Data service for domestic certificates
matching the given filters. Results are paginated automatically using
`search-after` tokens (not the `from` parameter, which caps at 10,000
records).

## Usage

``` r
ukh_epc_search(
  postcode = NULL,
  la = NULL,
  property_type = NULL,
  rating = NULL,
  built_form = NULL,
  from = NULL,
  to = NULL,
  size = 1000L,
  max_records = 10000L,
  type = c("domestic", "non-domestic", "display")
)
```

## Arguments

- postcode:

  Optional character. Postcode or partial postcode.

- la:

  Optional character. Local authority GSS code (e.g. `"E09000033"` for
  Westminster).

- property_type:

  Optional character. `"House"`, `"Flat"`, `"Bungalow"`, `"Maisonette"`,
  `"Park home"`.

- rating:

  Optional character. Current energy rating (`"A"` to `"G"`).

- built_form:

  Optional character. `"Detached"`, `"Semi-Detached"`, `"End-Terrace"`,
  `"Mid-Terrace"`, `"Enclosed End-Terrace"`, `"Enclosed Mid-Terrace"`.

- from, to:

  Optional. Lodgement date range (YYYY-MM-DD).

- size:

  Integer. Results per page, max 5000. Default 1000.

- max_records:

  Integer. Maximum total records to fetch across pages. Default 10000.
  Set higher for bulk analysis.

- type:

  Character. Register to query: `"domestic"` (default, housing),
  `"non-domestic"` (commercial buildings), or `"display"` (DECs for
  public buildings).

## Value

A data frame of certificates. Columns include `lmk_key`, `address`,
`postcode`, `uprn`, `local_authority`, `constituency`, `property_type`,
`built_form`, `inspection_date`, `lodgement_date`,
`current_energy_rating`, `current_energy_efficiency`,
`potential_energy_rating`, `potential_energy_efficiency`,
`total_floor_area`, `co2_emissions_current`, and more.

## Details

Registration at <https://epc.opendatacommunities.org/> is required and
free.

## See also

Other energy performance certificates:
[`ukh_epc_bulk()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_bulk.md),
[`ukh_epc_certificate()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_certificate.md),
[`ukh_epc_recommendations_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_recommendations_summary.md),
[`ukh_epc_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_summary.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Requires EPC API credentials
certs <- ukh_epc_search(postcode = "SW1A 1AA")
head(certs)

# All E-rated flats in Westminster lodged since 2020
wm <- ukh_epc_search(
  la = "E09000033", property_type = "Flat",
  rating = "E", from = "2020-01-01"
)
} # }
```
