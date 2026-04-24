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
bf <- ukh_planning("brownfield-land", limit = 100)
head(bf)
#>   entry.date start.date   end.date  entity   name         dataset  typology
#> 1 2024-12-16 2017-11-01            1700000 BFR001 brownfield-land geography
#> 2 2024-12-16 2017-11-01            1700001 BFR002 brownfield-land geography
#> 3 2024-12-16 2017-11-01 2019-07-24 1700002 BFR003 brownfield-land geography
#> 4 2024-12-16 2017-11-01 2018-03-16 1700003 BFR004 brownfield-land geography
#> 5 2024-12-16 2017-11-01 2020-06-16 1700004 BFR005 brownfield-land geography
#> 6 2024-12-16 2017-11-01 2018-08-28 1700005 BFR006 brownfield-land geography
#>   reference          prefix organisation.entity geometry
#> 1    BFR001 brownfield-land                 336         
#> 2    BFR002 brownfield-land                 336         
#> 3    BFR003 brownfield-land                 336         
#> 4    BFR004 brownfield-land                 336         
#> 5    BFR005 brownfield-land                 336         
#> 6    BFR006 brownfield-land                 336         
#>                         point       quality
#> 1 POINT (-3.493786 50.549744) authoritative
#> 2 POINT (-3.626255 50.533836) authoritative
#> 3   POINT (-3.510666 50.5399) authoritative
#> 4  POINT (-3.466788 50.58151) authoritative
#> 5 POINT (-3.620686 50.520592) authoritative
#> 6 POINT (-3.474219 50.563331) authoritative
#>                                                                                                         notes
#> 1                    Part of this site was started in 2002, no progress since so remaining as brownfield land
#> 2 Groundworks commenced keeping this live, so this remains on the brownfield register - 2 have been completed
#> 3                                                                                              Site completed
#> 4                                                                                              Site completed
#> 5                                                                                              Site completed
#> 6                                                                                              Site completed
#>   hectares deliverable
#> 1     0.26         yes
#> 2     0.12         yes
#> 3     0.47         yes
#> 4     0.04         yes
#> 5     1.14         yes
#> 6     0.73         yes
#>                                                         site.address
#> 1                    Glendaragh, Barn Park Road, Teignmouth TQ14 8PN
#> 2                             Rosemary Avenue, Newton Abbot TQ12 1SB
#> 3                      Platway House, Torquay Road, Shaldon TQ14 0AU
#> 4                        Shapters Yard, Strand Hill, Dawlish EX7 9PS
#> 5 Former Wolborough Hospital, Old Totnes Road, Newton Abbot TQ12 6AA
#> 6                     Holcombe Hall, Holcombe Drive, Dawlish EX7 0JW
#>                                                                                                                                                                                                                            site.plan.url
#> 1                                                                                                                    http://www.teignbridge.gov.uk/planning/forms/planning-application-details/?Type=Application&Refval=01%2f03478%2fCOU
#> 2                                                                                                                    http://www.teignbridge.gov.uk/planning/forms/planning-application-details/?Type=Application&Refval=05%2f04278%2fFUL
#> 3                                                                                                                    http://www.teignbridge.gov.uk/planning/forms/planning-application-details/?Type=Application&Refval=08%2f01449%2fMAJ
#> 4                                                                                                                    http://www.teignbridge.gov.uk/planning/forms/planning-application-details/?Type=Application&Refval=12%2f01811%2fFUL
#> 5 http://www.teignbridge.gov.uk/planning/forms/planning-application-details/?Type=Application&Refval=13%2f01497%2fMAJhttp://www.teignbridge.gov.uk/planning/forms/planning-application-details/?Type=Application&Refval=19%2f01439%2fFUL
#> 6                                                                                                                    http://www.teignbridge.gov.uk/planning/forms/planning-application-details/?Type=Application&Refval=13%2f02517%2fFUL
#>                  ownership.status maximum.net.dwellings minimum.net.dwellings
#> 1 not-owned-by-a-public-authority                    15                    15
#> 2 not-owned-by-a-public-authority                     6                     6
#> 3 not-owned-by-a-public-authority                     9                     9
#> 4 not-owned-by-a-public-authority                     9                     9
#> 5 not-owned-by-a-public-authority                    18                    18
#> 6 not-owned-by-a-public-authority                     7                     7
#>   planning.permission.date planning.permission.type planning.permission.status
#> 1               2001-10-26 full-planning-permission               permissioned
#> 2               2006-03-22 full-planning-permission               permissioned
#> 3               2008-07-01 full-planning-permission               permissioned
#> 4               2012-07-31 full-planning-permission               permissioned
#> 5               2013-01-21 full-planning-permission               permissioned
#> 6               2014-10-10 full-planning-permission               permissioned
#>   planning.permission.history
#> 1                        <NA>
#> 2                        <NA>
#> 3                        <NA>
#> 4                        <NA>
#> 5                        <NA>
#> 6                        <NA>
options(op)
# }
```
