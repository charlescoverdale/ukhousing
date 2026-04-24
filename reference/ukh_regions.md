# List valid UK HPI region slugs

Returns a data frame of common UK HPI region slugs with their names, GSS
codes, and tier (country, region, county, or local authority). Useful
for looking up the slug to pass to
[`ukh_hpi()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_hpi.md).

## Usage

``` r
ukh_regions(tier = c("all", "country", "region", "county", "la"))
```

## Arguments

- tier:

  Character. Filter by tier: `"all"` (default), `"country"`, `"region"`,
  `"county"`, or `"la"`.

## Value

A data frame with columns `slug`, `name`, `gss_code`, and `tier`.

## Details

This is a selection of the most commonly used regions, not an exhaustive
list. The UK HPI covers 441+ areas total; any valid slug can be passed
to
[`ukh_hpi()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_hpi.md)
directly.

## See also

Other helpers:
[`ukh_sparql()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_sparql.md)

## Examples

``` r
# All regions
head(ukh_regions())
#>               slug             name  gss_code    tier
#> 1   united-kingdom   United Kingdom K02000001 country
#> 2          england          England E92000001 country
#> 3            wales            Wales W92000004 country
#> 4         scotland         Scotland S92000003 country
#> 5 northern-ireland Northern Ireland N92000002 country
#> 6    great-britain    Great Britain K03000001 country

# Just the nine English regions
ukh_regions(tier = "region")
#>                       slug                     name  gss_code   tier
#> 1               north-east               North East E12000001 region
#> 2               north-west               North West E12000002 region
#> 3 yorkshire-and-the-humber Yorkshire and The Humber E12000003 region
#> 4            east-midlands            East Midlands E12000004 region
#> 5            west-midlands            West Midlands E12000005 region
#> 6          east-of-england          East of England E12000006 region
#> 7                   london                   London E12000007 region
#> 8               south-east               South East E12000008 region
#> 9               south-west               South West E12000009 region

# Country-level series
ukh_regions(tier = "country")
#>               slug             name  gss_code    tier
#> 1   united-kingdom   United Kingdom K02000001 country
#> 2          england          England E92000001 country
#> 3            wales            Wales W92000004 country
#> 4         scotland         Scotland S92000003 country
#> 5 northern-ireland Northern Ireland N92000002 country
#> 6    great-britain    Great Britain K03000001 country
```
