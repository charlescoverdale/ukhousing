# Defunct Energy Performance Certificate functions

The Energy Performance Certificate functions were removed in ukhousing
0.2.0. MHCLG retired the EPC Open Data service they wrapped and replaced
it with the Get energy performance of buildings data service
(<https://get-energy-performance-data.communities.gov.uk/>), which needs
a GOV.UK One Login account and a bearer token, has no
per-local-authority bulk files and no property type filter. Every
function below now stops with an error.

## Usage

``` r
ukh_epc_set_key(...)

ukh_epc_search(...)

ukh_epc_certificate(...)

ukh_epc_summary(...)

ukh_epc_bulk(...)

ukh_epc_recommendations_summary(...)
```

## Arguments

- ...:

  Ignored.

## Value

None. Each function signals an error.

## Details

Certificates can be searched and downloaded from the new service
directly.
