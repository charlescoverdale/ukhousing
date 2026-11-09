# Run a SPARQL query

Runs a SPARQL query against one of the supported endpoints and returns
the result as a data frame. Useful for queries that aren't covered by
the dedicated helpers, including custom HPI aggregations and Price Paid
Data lookups by postcode.

## Usage

``` r
ukh_sparql(query, endpoint = "land-registry", timeout = 60L)
```

## Arguments

- query:

  Character. A SPARQL query string.

- endpoint:

  Character. `"land-registry"` (default), or a full URL to any SPARQL
  endpoint.

- timeout:

  Integer. Request timeout in seconds. Default `60`.

## Value

A data frame of bindings. Column names match the SELECT variables in the
query.

## Details

The Land Registry endpoint is free, requires no authentication, and
covers HPI and Price Paid Data. MHCLG's Open Data Communities endpoint
was retired in 2026, so `endpoint = "opendatacommunities"` now stops
with an error.

## See also

Other helpers:
[`ukh_regions()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_regions.md)

## Examples

``` r
# \donttest{
op <- options(ukhousing.cache_dir = tempdir())
try({
  # All HPI observations for Westminster in January 2020
  q <- '
  PREFIX ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>
  SELECT ?hpi ?avgPrice WHERE {
    <http://landregistry.data.gov.uk/data/ukhpi/region/city-of-westminster/month/2020-01>
      ukhpi:housePriceIndex ?hpi ;
      ukhpi:averagePrice    ?avgPrice .
  }'
  ukh_sparql(q)
})
#>     hpi avgPrice
#> 1 87.50  1072220
options(op)
# }
```
