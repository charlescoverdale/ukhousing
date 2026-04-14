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
