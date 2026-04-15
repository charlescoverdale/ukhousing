# ukhousing 0.2.0

## New functions

### Land Registry

* `ukh_transactions()` returns monthly transaction volumes for a
  region (shortcut over `ukh_hpi()`, noting the ~5-month sales-volume
  lag).
* `ukh_ppd_years()` fetches Price Paid Data across multiple years in
  one call and row-binds.
* `ukh_ppd_transaction()` looks up a single transaction by its GUID
  via the Land Registry linked-data REST API.
* `ukh_ppd_address()` looks up transactions by postcode via the
  address lookup endpoint, avoiding the yearly bulk download.
* `ukh_ppd_bulk()` now falls back to split part files
  (`pp-YYYY-part1.csv`, `pp-YYYY-part2.csv`, ...) when the single
  yearly file is unavailable.

### Energy Performance Certificates

* `ukh_epc_search()`, `ukh_epc_certificate()`, `ukh_epc_summary()`,
  and `ukh_epc_bulk()` now accept a `type` argument:
  `"domestic"` (default), `"non-domestic"`, or `"display"`.
* `ukh_epc_recommendations_summary()` aggregates improvement
  recommendations across a local authority's certificates.

### ONS

* `ukh_pipr()` fetches the ONS Price Index of Private Rents (monthly,
  UK and regional, from January 2015) via the ONS Beta API.

### Advanced

* `ukh_sparql()` runs an arbitrary SPARQL query against the Land
  Registry endpoint (HPI + PPD) or the Open Data Communities endpoint
  (300+ MHCLG housing-market datasets).

### Planning

* `ukh_planning()` now supports `format = "sf"` to return simple
  features for GeoJSON-capable datasets (requires the `sf` package
  as a soft suggest).

## Other changes

* Added `jsonlite` to Imports (required by `ukh_pipr()`).
* Added `sf` to Suggests.

# ukhousing 0.1.0

* Initial release.

## Land Registry

* `ukh_hpi()` fetches UK House Price Index data for 441+ regions
  (countries, English regions, counties, local authorities) from 1995
  onwards. Includes average prices, index values, percentage changes,
  sales volumes, and breakdowns by property type and buyer type.
* `ukh_hpi_compare()` fetches one measure across multiple regions in a
  wide data frame.
* `ukh_ppd()` fetches individual property transactions from Price Paid
  Data, filtered by local authority, postcode, property type, tenure,
  new build status, and date range.
* `ukh_ppd_bulk()` downloads the yearly CSV or the complete Price Paid
  file (~5.3 GB).
* `ukh_ppd_summary()` returns aggregated statistics (counts, median
  and mean prices) by month, property type, or local authority.

## Energy Performance Certificates (MHCLG)

* `ukh_epc_set_key()` stores EPC API credentials for the session.
* `ukh_epc_search()` queries domestic certificates with filters
  (postcode, local authority, property type, energy rating, built
  form, date range). Pagination handled automatically via
  `search-after` tokens.
* `ukh_epc_certificate()` fetches a single certificate with all 90+
  fields plus improvement recommendations.
* `ukh_epc_summary()` returns the distribution of energy ratings
  (A-G) for a local authority.
* `ukh_epc_bulk()` downloads and extracts the per-LA bulk ZIP.

## Planning data (Digital Land)

* `ukh_planning()` queries planning.data.gov.uk for brownfield land,
  planning applications, local plans, conservation areas, listed
  buildings, and more.
* `ukh_planning_datasets()` lists all 100+ available datasets.

## Helpers

* `ukh_regions()` returns a lookup table of common UK HPI region
  slugs with their names, GSS codes, and tier.
* `ukh_clear_cache()` empties the local download cache.
* `ukh_cache_info()` reports what is cached and how much space it
  uses.
