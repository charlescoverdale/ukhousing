# Changelog

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

- [`ukh_epc_set_key()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_set_key.md)
  stores EPC API credentials for the session.
- [`ukh_epc_search()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_search.md)
  queries certificates with filters (postcode, local authority, property
  type, energy rating, built form, date range). Pagination handled
  automatically via `search-after` tokens. Supports `type = "domestic"`
  (default), `"non-domestic"`, and `"display"`.
- [`ukh_epc_certificate()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_certificate.md)
  fetches a single certificate with all 90+ fields plus improvement
  recommendations.
- [`ukh_epc_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_summary.md)
  returns the distribution of energy ratings (A-G) for a local
  authority.
- [`ukh_epc_bulk()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_bulk.md)
  downloads and extracts the per-LA bulk ZIP.
- [`ukh_epc_recommendations_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_recommendations_summary.md)
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
