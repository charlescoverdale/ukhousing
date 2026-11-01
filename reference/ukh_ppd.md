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

  Optional character. Local authority name, matched against the
  `district` field ignoring case, spacing and a leading "City of" or
  "The", so `"Westminster"` finds "CITY OF WESTMINSTER" and
  `"Vale of Glamorgan"` finds "THE VALE OF GLAMORGAN". The City of
  London keeps its prefix, so `"London"` does not match it.

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
try({
  # Westminster flats sold in 2024
  wm <- ukh_ppd(2024, la = "Westminster", property_type = "flat")
  head(wm)
})
#> ℹ Downloading pp-2024.csv from HM Land Registry...
#>                           transaction_id   price       date postcode
#> 1 {1EAE3DF6-CA9C-9EB1-E063-4704A8C09D02} 1200000 2024-03-25   W2 2SN
#> 2 {2131FCF5-ADC7-86E8-E063-4804A8C0372B}  600000 2024-07-12 SW1P 4RL
#> 3 {2131FCF5-ADC8-86E8-E063-4804A8C0372B}  475000 2024-04-05   W2 5SX
#> 4 {2131FCF5-ADCA-86E8-E063-4804A8C0372B}  700000 2024-07-31  NW6 5FZ
#> 5 {2131FCF5-ADCC-86E8-E063-4804A8C0372B} 5300000 2024-03-27  W1G 9XE
#> 6 {2131FCF5-ADCE-86E8-E063-4804A8C0372B}  585000 2024-03-08 SW1P 2BW
#>   property_type new_build tenure               paon    saon             street
#> 1             F         N      L                 17    <NA>      CLIFTON PLACE
#> 2             F         N      L                 50  FLAT 3           MILLBANK
#> 3             F         N      L PRINCETHORPE HOUSE FLAT 63 WOODCHESTER SQUARE
#> 4             F         N      L   ST. DAVIDS HOUSE FLAT 13   TOLLGATE GARDENS
#> 5             F         N      L  WELBECK HOUSE, 62 FLAT 12     WELBECK STREET
#> 6             F         N      L    VESTRY COURT, 5  FLAT 9       MONCK STREET
#>   locality   town            district         county category record_status
#> 1     <NA> LONDON CITY OF WESTMINSTER GREATER LONDON        A             A
#> 2     <NA> LONDON CITY OF WESTMINSTER GREATER LONDON        A             A
#> 3     <NA> LONDON CITY OF WESTMINSTER GREATER LONDON        A             A
#> 4     <NA> LONDON CITY OF WESTMINSTER GREATER LONDON        A             A
#> 5     <NA> LONDON CITY OF WESTMINSTER GREATER LONDON        A             A
#> 6     <NA> LONDON CITY OF WESTMINSTER GREATER LONDON        A             A
options(op)
# }
```
