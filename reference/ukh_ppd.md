# Price Paid Data

Fetches individual property transaction records from the HM Land
Registry Price Paid Data, filtered by local authority, postcode,
property type, and other criteria.

## Usage

``` r
ukh_ppd(
  year = as.integer(format(Sys.Date(), "%Y")),
  la = NULL,
  postcode = NULL,
  property_type = NULL,
  new_build = NULL,
  tenure = NULL,
  from = NULL,
  to = NULL,
  refresh = FALSE
)
```

## Arguments

- year:

  Integer. Year of transactions to fetch. Defaults to the current
  calendar year.

- la:

  Optional character. Local authority name (matched case-insensitively
  against the `district` field).

- postcode:

  Optional character. Postcode or postcode prefix.

- property_type:

  Optional character. One of `"detached"`, `"semi"`, `"terraced"`,
  `"flat"`, or `"other"`. Also accepts the single-letter codes `"D"`,
  `"S"`, `"T"`, `"F"`, `"O"`.

- new_build:

  Optional logical. If `TRUE`, only newly built properties. If `FALSE`,
  only established properties.

- tenure:

  Optional character. `"freehold"` or `"leasehold"`.

- from, to:

  Optional character or Date. Date range within the year (YYYY-MM-DD).

- refresh:

  Logical. Re-download the yearly file even if cached? Default `FALSE`.

## Value

A data frame of individual transactions with columns `transaction_id`,
`price`, `date`, `postcode`, `property_type`, `new_build`, `tenure`,
`paon`, `saon`, `street`, `locality`, `town`, `district`, `county`,
`category`, `record_status`.

## Details

The full yearly CSV is ~150 MB (about 900,000 transactions). This
function downloads the yearly file, caches it, and then filters in
memory. Memory footprint during the call is roughly 1 GB because R data
frames are considerably larger than the source CSV; on
memory-constrained machines, prefer
[`ukh_ppd_address()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_address.md)
for postcode lookups or
[`ukh_ppd_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_summary.md)
for aggregated stats. Subsequent queries against the same year use the
cache. For multi-year queries, call the function once per year or use
[`ukh_ppd_years()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_years.md).

## See also

Other price paid data:
[`ukh_ppd_address()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_address.md),
[`ukh_ppd_bulk()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_bulk.md),
[`ukh_ppd_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_summary.md),
[`ukh_ppd_transaction()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_transaction.md),
[`ukh_ppd_years()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_years.md)

## Examples

``` r
# \donttest{
op <- options(ukhousing.cache_dir = tempdir())

# Westminster flats sold in 2024
wm <- ukh_ppd(2024, la = "Westminster", property_type = "flat")
#> ℹ Downloading pp-2024.csv from HM Land Registry...
head(wm)
#>  [1] transaction_id price          date           postcode       property_type 
#>  [6] new_build      tenure         paon           saon           street        
#> [11] locality       town           district       county         category      
#> [16] record_status 
#> <0 rows> (or 0-length row.names)

options(op)
# }
```
