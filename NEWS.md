# ukhousing 0.2.0

## `ukh_pipr()` returns data again, and current data

`ukh_pipr()` returned an empty data frame with a warning. The ONS stopped
offering a JSON download for the rental index on its Beta API, so the
function fell back to a metadata link that holds no observations. That
API copy of the series also stopped at January 2024.

The function now reads the ONS monthly workbook, Price Index of Private
Rents, UK: monthly price statistics, which runs to the latest month.
This is a richer source, and the output changes accordingly:

* About 350 areas (UK, countries, English regions and local
  authorities) instead of 15.
* New columns `gss_code`, `parent_region`, `monthly_change_pct`,
  `annual_change_pct` and `rental_price_gbp` (average monthly rent).
* A new `property` argument selects a bedroom count or property type.
  It comes before `refresh`, so pass `refresh` by name.
* The index is on the ONS base, January 2023 = 100.
* The workbook is read with \pkg{readxl}, now in Suggests.

## Monthly series no longer go stale in the cache

`ukh_hpi()`, `ukh_transactions()` and `ukh_pipr()` reused a cached
download indefinitely, so a user who had called them once never saw a
later monthly release unless they passed `refresh = TRUE`. A cached copy
is now fetched again once it is more than 7 days old; set
`options(ukhousing.cache_max_age = <days>)` to change this. Bulk EPC and
Price Paid downloads are unchanged and still only re-fetched on request.

# ukhousing 0.1.0

* Initial CRAN release.

## Land Registry

* `ukh_hpi()` fetches UK House Price Index data for 441+ regions
  (countries, English regions, counties, local authorities) from
  1995 onwards. Includes average prices, index values, percentage
  changes, sales volumes, and breakdowns by property type and
  buyer type.
* `ukh_hpi_compare()` fetches one measure across multiple regions
  in a wide data frame.
* `ukh_transactions()` returns monthly transaction volumes for a
  region (extracts the `sales_volume` series from `ukh_hpi()`,
  noting the ~5-month lag).
* `ukh_ppd()` fetches individual property transactions from Price
  Paid Data, filtered by local authority, postcode, property type,
  tenure, new-build status, and date range.
* `ukh_ppd_bulk()` downloads yearly or complete Price Paid CSVs,
  with automatic fallback to split part files for larger years.
* `ukh_ppd_summary()` returns aggregated statistics (counts,
  median and mean prices) by month, property type, or local
  authority.
* `ukh_ppd_years()` fetches PPD across multiple years in one call
  and row-binds.
* `ukh_ppd_transaction()` looks up a single transaction by its
  GUID via the Land Registry linked-data REST API.
* `ukh_ppd_address()` looks up transactions by postcode via the
  address lookup endpoint, avoiding the full yearly download.

## Energy Performance Certificates (MHCLG)

* `ukh_epc_set_key()` stores EPC API credentials for the session.
* `ukh_epc_search()` queries certificates with filters (postcode,
  local authority, property type, energy rating, built form, date
  range). Pagination handled automatically via `search-after`
  tokens. Supports `type = "domestic"` (default),
  `"non-domestic"`, and `"display"`.
* `ukh_epc_certificate()` fetches a single certificate with all
  90+ fields plus improvement recommendations.
* `ukh_epc_summary()` returns the distribution of energy ratings
  (A-G) for a local authority.
* `ukh_epc_bulk()` downloads and extracts the per-LA bulk ZIP.
* `ukh_epc_recommendations_summary()` aggregates improvement
  recommendations across a local authority.

## Planning data (Digital Land)

* `ukh_planning()` queries planning.data.gov.uk for brownfield
  land, planning applications, local plans, conservation areas,
  listed buildings, and more. Supports `format = "sf"` to return
  simple features for GeoJSON-capable datasets (requires the `sf`
  package, declared in Suggests).
* `ukh_planning_datasets()` lists all 100+ available datasets.

## ONS

* `ukh_pipr()` fetches the ONS Price Index of Private Rents
  (monthly, UK and regional, from January 2015) via the ONS Beta
  API.

## Advanced

* `ukh_sparql()` runs an arbitrary SPARQL query against the Land
  Registry endpoint (HPI + PPD) or the Open Data Communities
  endpoint (300+ MHCLG housing-market datasets).

## Helpers

* `ukh_regions()` returns a lookup table of common UK HPI region
  slugs with their names, GSS codes, and tier.
* `ukh_clear_cache()` empties the local download cache.
* `ukh_cache_info()` reports what is cached and how much space it
  uses.
