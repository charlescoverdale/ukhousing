# Changelog

## ukhousing 0.2.0

### Energy Performance Certificate functions are defunct

MHCLG retired the EPC Open Data service (`epc.opendatacommunities.org`)
that
[`ukh_epc_search()`](https://charlescoverdale.github.io/ukhousing/reference/ukhousing-defunct.md),
[`ukh_epc_certificate()`](https://charlescoverdale.github.io/ukhousing/reference/ukhousing-defunct.md),
[`ukh_epc_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukhousing-defunct.md),
[`ukh_epc_bulk()`](https://charlescoverdale.github.io/ukhousing/reference/ukhousing-defunct.md),
[`ukh_epc_recommendations_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukhousing-defunct.md)
and
[`ukh_epc_set_key()`](https://charlescoverdale.github.io/ukhousing/reference/ukhousing-defunct.md)
used. Its API and bulk downloads now redirect to the home page of the
replacement, the Get energy performance of buildings data service, so
every one of these functions failed in 0.1.0.

The replacement is not a drop-in: it needs a GOV.UK One Login account
and a bearer token, offers no per-local-authority bulk files and no
property type or built form filters, and returns far fewer fields from a
search. Rather than ship a thinner, credential-bound version, the six
functions now stop with an error that points to the new service:
<https://get-energy-performance-data.communities.gov.uk/>.

### `ukh_sparql()` no longer offers the Open Data Communities endpoint

MHCLG also retired Open Data Communities. `opendatacommunities.org` now
redirects to a site with no SPARQL service, so
`ukh_sparql(endpoint = "opendatacommunities")` returned an error. It now
says the endpoint has been retired. The Land Registry endpoint and
custom endpoint URLs work as before.

### `ukh_pipr()` returns data again, and current data

[`ukh_pipr()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_pipr.md)
returned an empty data frame with a warning. The ONS stopped offering a
JSON download for the rental index on its Beta API, so the function fell
back to a metadata link that holds no observations. That API copy of the
series also stopped at January 2024.

The function now reads the ONS monthly workbook, Price Index of Private
Rents, UK: monthly price statistics, which runs to the latest month.
This is a richer source, and the output changes accordingly:

- About 350 areas (UK, countries, English regions and local authorities)
  instead of 15.
- New columns `gss_code`, `parent_region`, `monthly_change_pct`,
  `annual_change_pct` and `rental_price_gbp` (average monthly rent).
- A new `property` argument selects a bedroom count or property type. It
  comes before `refresh`, so pass `refresh` by name.
- The index is on the ONS base, January 2023 = 100.
- The workbook is read with , now in Suggests.

### `ukh_hpi()` percentage changes were always missing

Land Registry now labels the change columns “Percentage change (monthly)
All property types” and “Percentage change (yearly) All property types”,
which none of the package’s column patterns matched, so
`pct_change_monthly` and `pct_change_annual` were `NA` for every region
and month, and `ukh_hpi_compare(measure = "pct_change_annual")` returned
nothing but `NA`. First-time-buyer prices were missing for the same
reason (“First-time buyers” is now hyphenated). Both are mapped again.
Cash, mortgage and buyer-type prices remain `NA` for `"united-kingdom"`
because Land Registry does not publish those splits for the UK
aggregate.

### `ukh_ppd(la = )` matches the names people use

Land Registry records some districts with a prefix (“CITY OF
WESTMINSTER”, “CITY OF BRISTOL”, “THE VALE OF GLAMORGAN”), and `la` had
to match exactly, so the documented example
`ukh_ppd(2024, la = "Westminster")` returned no rows. `la` now ignores a
leading “City of” or “The” (except for the City of London, so `"London"`
does not quietly return the Square Mile alone). When nothing matches, a
warning suggests the closest district names. This also applies to
[`ukh_ppd_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_summary.md)
and
[`ukh_ppd_years()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_years.md).

### Monthly series no longer go stale in the cache

[`ukh_hpi()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_hpi.md),
[`ukh_transactions()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_transactions.md)
and
[`ukh_pipr()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_pipr.md)
reused a cached download indefinitely, so a user who had called them
once never saw a later monthly release unless they passed
`refresh = TRUE`. A cached copy is now fetched again once it is more
than 7 days old; set `options(ukhousing.cache_max_age = <days>)` to
change this. Price Paid bulk downloads are unchanged and still only
re-fetched on request.

## ukhousing 0.1.0

CRAN release: 2026-04-21

- Initial CRAN release.

### Land Registry

- [`ukh_hpi()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_hpi.md)
  fetches UK House Price Index data for 441+ regions (countries, English
  regions, counties, local authorities) from 1995 onwards. Includes
  average prices, index values, percentage changes, sales volumes, and
  breakdowns by property type and buyer type.
- [`ukh_hpi_compare()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_hpi_compare.md)
  fetches one measure across multiple regions in a wide data frame.
- [`ukh_transactions()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_transactions.md)
  returns monthly transaction volumes for a region (extracts the
  `sales_volume` series from
  [`ukh_hpi()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_hpi.md),
  noting the ~5-month lag).
- [`ukh_ppd()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd.md)
  fetches individual property transactions from Price Paid Data,
  filtered by local authority, postcode, property type, tenure,
  new-build status, and date range.
- [`ukh_ppd_bulk()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_bulk.md)
  downloads yearly or complete Price Paid CSVs, with automatic fallback
  to split part files for larger years.
- [`ukh_ppd_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_summary.md)
  returns aggregated statistics (counts, median and mean prices) by
  month, property type, or local authority.
- [`ukh_ppd_years()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_years.md)
  fetches PPD across multiple years in one call and row-binds.
- [`ukh_ppd_transaction()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_transaction.md)
  looks up a single transaction by its GUID via the Land Registry
  linked-data REST API.
- [`ukh_ppd_address()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_address.md)
  looks up transactions by postcode via the address lookup endpoint,
  avoiding the full yearly download.

### Energy Performance Certificates (MHCLG)

- [`ukh_epc_set_key()`](https://charlescoverdale.github.io/ukhousing/reference/ukhousing-defunct.md)
  stores EPC API credentials for the session.
- [`ukh_epc_search()`](https://charlescoverdale.github.io/ukhousing/reference/ukhousing-defunct.md)
  queries certificates with filters (postcode, local authority, property
  type, energy rating, built form, date range). Pagination handled
  automatically via `search-after` tokens. Supports `type = "domestic"`
  (default), `"non-domestic"`, and `"display"`.
- [`ukh_epc_certificate()`](https://charlescoverdale.github.io/ukhousing/reference/ukhousing-defunct.md)
  fetches a single certificate with all 90+ fields plus improvement
  recommendations.
- [`ukh_epc_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukhousing-defunct.md)
  returns the distribution of energy ratings (A-G) for a local
  authority.
- [`ukh_epc_bulk()`](https://charlescoverdale.github.io/ukhousing/reference/ukhousing-defunct.md)
  downloads and extracts the per-LA bulk ZIP.
- [`ukh_epc_recommendations_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukhousing-defunct.md)
  aggregates improvement recommendations across a local authority.

### Planning data (Digital Land)

- [`ukh_planning()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_planning.md)
  queries planning.data.gov.uk for brownfield land, planning
  applications, local plans, conservation areas, listed buildings, and
  more. Supports `format = "sf"` to return simple features for
  GeoJSON-capable datasets (requires the `sf` package, declared in
  Suggests).
- [`ukh_planning_datasets()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_planning_datasets.md)
  lists all 100+ available datasets.

### ONS

- [`ukh_pipr()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_pipr.md)
  fetches the ONS Price Index of Private Rents (monthly, UK and
  regional, from January 2015) via the ONS Beta API.

### Advanced

- [`ukh_sparql()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_sparql.md)
  runs an arbitrary SPARQL query against the Land Registry endpoint
  (HPI + PPD) or the Open Data Communities endpoint (300+ MHCLG
  housing-market datasets).

### Helpers

- [`ukh_regions()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_regions.md)
  returns a lookup table of common UK HPI region slugs with their names,
  GSS codes, and tier.
- [`ukh_clear_cache()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_clear_cache.md)
  empties the local download cache.
- [`ukh_cache_info()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_cache_info.md)
  reports what is cached and how much space it uses.
