# List available planning datasets

Returns a data frame of datasets hosted by planning.data.gov.uk, with
their slugs, names, and descriptions.

## Usage

``` r
ukh_planning_datasets()
```

## Value

A data frame with `slug`, `name`, `typology`, and `record_count`.

## See also

Other planning:
[`ukh_planning()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_planning.md)

## Examples

``` r
# \donttest{
op <- options(ukhousing.cache_dir = tempdir())
ds <- ukh_planning_datasets()
head(ds)
#>   entry.date start.date end.date                       collection
#> 1                                                                
#> 2 2024-06-26                     agricultural-land-classification
#> 3 2025-01-31                          air-quality-management-area
#> 4                                                ancient-woodland
#> 5                                                ancient-woodland
#> 6 2025-02-04                         archaeological-priority-area
#>                            dataset
#> 1                          address
#> 2 agricultural-land-classification
#> 3      air-quality-management-area
#> 4                 ancient-woodland
#> 5          ancient-woodland-status
#> 6     archaeological-priority-area
#>                                                                                                         description
#> 1                                                                                                                  
#> 2                                                                   land graded by its quality for agricultural use
#> 3                                Areas where air pollution levels have exceeded the national air quality objectives
#> 4                                                    An area that’s been wooded continuously since at least 1600 AD
#> 5                                                                                                                  
#> 6 Areas of Greater London where there is significant known archaeological interest or potential for new discoveries
#>                               name                            plural prefix
#> 1                          Address                         addresses   uprn
#> 2 Agricultural land classification Agricultural land classifications       
#> 3      Air quality management area      Air quality management areas       
#> 4                 Ancient woodland                 Ancient woodlands       
#> 5          Ancient woodland status          Ancient woodlands status       
#> 6     Archaeological priority area     Archaeological priority areas       
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                         text
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
#> 3                                                                                                                                                                                                                                                                                                                                          An area designated by DEFRA.\n\nThese areas are taken into consideration in both plan-making and development management decisions
#> 4                                                                                                                                                                                                                               An area designated as ancient woodland by Natural England.\n\nNatural England and Forestry Commission [Guidance](https://www.gov.uk/guidance/ancient-woodland-and-veteran-trees-protection-surveys-licences)  is used in planning decisions.
#> 5                                                                                                                                                                                                                                                                                                                                                                        The status assigned to an area of [ancient woodland](/dataset/ancient-woodland) by Natural England.
#> 6 The Greater London Archaeological Priority Areas (APAs) are areas in London that have significant archaeological interest or potential for new discoveries\n\nThe APAs are based on evidence in the Greater London Historic Environment Record (GLHER)\nThey were created in the 1970s and 1980s by boroughs and local museums\nThey are being updated using new evidence and standards\nThe new system assigns all land to one of four tiers based on archaeological risk
#>    typology wikidata                        wikipedia entities
#> 1 geography                                                   
#> 2 geography          Agricultural_Land_Classification         
#> 3 geography                                                   
#> 4 geography Q3078732                 Ancient_woodland         
#> 5  category                          Ancient_woodland         
#> 6 geography                                                   
#>                 themes entity.count paint.options      attribution
#> 1       administrative            0                crown-copyright
#> 2          environment          585   #00703c;0.2  natural-england
#> 3          environment          498   #87823A;0.3            defra
#> 4          environment        44373   #00703c;0.2  natural-england
#> 5          environment            2                natural-england
#> 6 environment;heritage          796  #b54405;0.35 historic-england
#>                                                                                                                                                                                                                                                                                                                       attribution.text
#> 1                                                                                                                                                                                                                                                                                            © Crown copyright and database right 2026
#> 2                                                                                                                                                                                                                                © Natural England copyright. Contains Ordnance Survey data © Crown copyright and database right 2026.
#> 3                                                                                                                                                                                       © Crown copyright and database rights 2026 licenced under Defra's Public Sector Mapping Agreement with Ordnance Survey (licence No. 100022861)
#> 4                                                                                                                                                                                                                                © Natural England copyright. Contains Ordnance Survey data © Crown copyright and database right 2026.
#> 5                                                                                                                                                                                                                                © Natural England copyright. Contains Ordnance Survey data © Crown copyright and database right 2026.
#> 6 © Historic England 2026. Contains Ordnance Survey data © Crown copyright and database right 2026.\nThe Historic England GIS Data contained in this material was obtained on [date].\nThe most publicly available up to date Historic England GIS Data can be obtained from [HistoricEngland.org.uk](https://historicengland.org.uk).
#>   licence
#> 1    ogl3
#> 2    ogl3
#> 3    ogl3
#> 4    ogl3
#> 5    ogl3
#> 6    ogl3
#>                                                                                                                      licence.text
#> 1 Licensed under the [Open Government Licence v.3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).
#> 2 Licensed under the [Open Government Licence v.3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).
#> 3 Licensed under the [Open Government Licence v.3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).
#> 4 Licensed under the [Open Government Licence v.3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).
#> 5 Licensed under the [Open Government Licence v.3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).
#> 6 Licensed under the [Open Government Licence v.3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).
#>                                  consideration github.discussion entity.minimum
#> 1                                                                         1e+13
#> 2             agricultural-land-classification                67          32000
#> 3                 air-quality-management-areas                55          35000
#> 4                            ancient-woodlands                32      110000000
#> 5                            ancient-woodlands                32       29100000
#> 6 greater-london-archaeological-priority-areas                89          40000
#>   entity.maximum phase   realm replacement.dataset version
#> 1 19999999999999 alpha dataset                            
#> 2          34999 alpha dataset                            
#> 3          39999  live dataset                            
#> 4      129999999  live dataset                            
#> 5       30099999  beta dataset                            
#> 6          59999  live dataset                            
options(op)
# }
```
