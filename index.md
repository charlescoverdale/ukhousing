# ukhousing

Access UK housing data from official sources in R. House prices,
individual property transactions, energy performance certificates,
planning data, and rental price indices.

## The UK has world-class housing data. It is also a mess.

The UK publishes some of the richest housing data anywhere in the world.
Every residential transaction in England and Wales since 1995 is public.
Every Energy Performance Certificate since 2008 is queryable by
postcode. Planning applications, brownfield land registers,
affordability ratios, rental price indices, and stamp duty receipts are
all available at no cost, with long back-series, and at local authority
resolution.

The catch is that this data is scattered across roughly ten
institutions, each with its own format, access pattern, and quirks:

- **HM Land Registry** publishes the UK House Price Index via a
  linked-data SPARQL endpoint plus a REST API, and Price Paid Data as
  multi-gigabyte bulk CSVs with no header row
- **MHCLG’s EPC Open Data service** requires a free registered API key
  with HTTP Basic Auth, paginates using `search-after` tokens, and has
  90+ hyphenated fields per record
- **planning.data.gov.uk** (Digital Land) has a clean REST API with JSON
  and GeoJSON output
- **ONS** publishes rental price indices via the Beta API, but
  affordability ratios only as Excel workbooks with multi-row headers
- **DLUHC** publishes housing supply data as ODS live tables with
  hash-based URLs that change on every republication
- **HMRC** publishes Stamp Duty Land Tax statistics as ODS/XLSX
- **VOA** publishes private rental market data separately, also as ODS
- **Registers of Scotland** and **NI Land & Property Services** hold
  equivalent data for those jurisdictions in different formats

`ukhousing` wraps the four stable API-based sources (Land Registry HPI,
Land Registry Price Paid, EPC, planning.data.gov.uk) plus ONS PIPR
rental prices, and exposes them through a consistent R interface. The
flaky Excel/ODS scraping sources are deliberately out of scope: they
change format too often to maintain reliably.

## Installation

``` r
install.packages("ukhousing")

# Or install the development version from GitHub
# install.packages("devtools")
devtools::install_github("charlescoverdale/ukhousing")
```

## Data sources covered

| Source                                                      | Coverage                                                                                                                   |
|-------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------|
| [HM Land Registry](https://landregistry.data.gov.uk/)       | UK HPI (441+ regions) + Price Paid Data (28M+ transactions since 1995)                                                     |
| [MHCLG EPC Open Data](https://epc.opendatacommunities.org/) | 25M+ domestic certificates, plus non-domestic and display certificates                                                     |
| [planning.data.gov.uk](https://www.planning.data.gov.uk/)   | 100+ datasets: planning applications, brownfield land, local plans, listed buildings, conservation areas, flood risk zones |
| [ONS Beta API](https://developer.ons.gov.uk/)               | Price Index of Private Rents (UK and regional, from January 2015)                                                          |

All sources are free. EPC requires a free registration for an API key. A
SPARQL escape hatch
([`ukh_sparql()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_sparql.md))
is provided for queries the dedicated helpers don’t cover.

## Quick start

``` r
library(ukhousing)

# UK average house prices, monthly
uk <- ukh_hpi("united-kingdom", from = "2020-01-01")
head(uk)
#>         date           region   hpi avg_price pct_change_monthly pct_change_annual
#> 1 2020-01-01   united-kingdom 125.3    232000                0.3              2.1
#> 2 2020-02-01   united-kingdom 125.8    232900                0.4              2.3
#> ...

# All Westminster flats sold in 2024
wm <- ukh_ppd(2024, la = "Westminster", property_type = "flat")
head(wm)

# Energy rating distribution for Westminster
ukh_epc_set_key("you@example.com", "your_api_key")
ukh_epc_summary(la = "E09000033")
```

## House Price Index

``` r
# Compare prices across regions
prices <- ukh_hpi_compare(
  c("london", "manchester", "newcastle-upon-tyne"),
  measure = "avg_price",
  from = "2015-01-01"
)
plot(prices$date, prices$london, type = "l", ylim = range(prices[-1], na.rm = TRUE))
lines(prices$date, prices$manchester, col = "red")
lines(prices$date, prices$`newcastle-upon-tyne`, col = "blue")
```

## Price Paid Data

The Land Registry publishes every residential property sale in England
and Wales since 1995. The yearly file is about 150 MB and contains
~900,000 transactions.

``` r
# Detached houses sold in Manchester for over GBP 1m during 2024
manchester <- ukh_ppd(
  year = 2024,
  la = "Manchester",
  property_type = "detached"
)
manchester[manchester$price > 1e6, c("date", "postcode", "price", "street")]

# Monthly transaction counts nationally
summary <- ukh_ppd_summary(2024, by = "month")
plot(as.Date(paste0(summary$month, "-01")), summary$n, type = "l")
```

## Energy Performance Certificates

``` r
# Search EPCs
epcs <- ukh_epc_search(postcode = "SW1A 1AA")
table(epcs$current_energy_rating)

# Summary for a whole local authority
ukh_epc_summary(la = "E09000033")
#>   rating count percentage mean_floor_area mean_co2_emissions
#> 1      A    12        0.1            85.3               2.1
#> 2      B  1523       13.2            82.6               3.8
#> ...
```

## Planning data

``` r
# Brownfield land register
bf <- ukh_planning("brownfield-land", limit = 500)

# All available datasets
datasets <- ukh_planning_datasets()
```

## Functions

### Land Registry

| Function                                                                                                 | Description                                  |
|----------------------------------------------------------------------------------------------------------|----------------------------------------------|
| [`ukh_hpi()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_hpi.md)                         | UK HPI time series for a region              |
| [`ukh_hpi_compare()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_hpi_compare.md)         | One measure across multiple regions          |
| [`ukh_transactions()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_transactions.md)       | Monthly transaction volumes (shortcut)       |
| [`ukh_ppd()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd.md)                         | Individual property transactions             |
| [`ukh_ppd_bulk()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_bulk.md)               | Download a bulk PPD CSV (yearly or complete) |
| [`ukh_ppd_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_summary.md)         | Aggregated PPD statistics                    |
| [`ukh_ppd_years()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_years.md)             | PPD across multiple years, row-bound         |
| [`ukh_ppd_transaction()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_transaction.md) | Look up a single transaction by ID           |
| [`ukh_ppd_address()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_ppd_address.md)         | Look up transactions by postcode             |

### EPC

All EPC functions accept
`type = c("domestic", "non-domestic", "display")`.

| Function                                                                                                                         | Description                             |
|----------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------|
| [`ukh_epc_set_key()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_set_key.md)                                 | Set API credentials                     |
| [`ukh_epc_search()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_search.md)                                   | Search certificates with filters        |
| [`ukh_epc_certificate()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_certificate.md)                         | Fetch a single certificate              |
| [`ukh_epc_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_summary.md)                                 | Rating distribution for an LA           |
| [`ukh_epc_bulk()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_bulk.md)                                       | Download bulk ZIP for an LA             |
| [`ukh_epc_recommendations_summary()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_recommendations_summary.md) | Most common improvement recommendations |

### Planning

| Function                                                                                                     | Description                                        |
|--------------------------------------------------------------------------------------------------------------|----------------------------------------------------|
| [`ukh_planning()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_planning.md)                   | Query planning entities (supports `format = "sf"`) |
| [`ukh_planning_datasets()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_planning_datasets.md) | List available datasets                            |

### ONS

| Function                                                                           | Description                                            |
|------------------------------------------------------------------------------------|--------------------------------------------------------|
| [`ukh_pipr()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_pipr.md) | Price Index of Private Rents (monthly, UK and regions) |

### Advanced

| Function                                                                               | Description                                                     |
|----------------------------------------------------------------------------------------|-----------------------------------------------------------------|
| [`ukh_sparql()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_sparql.md) | Raw SPARQL query against Land Registry or Open Data Communities |

### Helpers

| Function                                                                                         | Description           |
|--------------------------------------------------------------------------------------------------|-----------------------|
| [`ukh_regions()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_regions.md)         | Region slug lookup    |
| [`ukh_clear_cache()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_clear_cache.md) | Empty the local cache |
| [`ukh_cache_info()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_cache_info.md)   | Show cached files     |

## Caching

Downloads are cached to `tools::R_user_dir("ukhousing", "cache")` by
default. Subsequent calls are instant. Override the location with
`options(ukhousing.cache_dir = "/path/to/dir")`. Use
[`ukh_clear_cache()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_clear_cache.md)
to remove all cached files.

## EPC API registration

The Energy Performance Certificate service requires a free API key.
Register at <https://epc.opendatacommunities.org/> and then:

``` r
ukh_epc_set_key("you@example.com", "your_api_key")

# Or set env vars in .Renviron:
# EPC_EMAIL=you@example.com
# EPC_API_KEY=your_api_key
```

## Data coverage

- UK HPI: 441+ areas, from January 1995 (E&W), 2004 (Scotland), 2005
  (Northern Ireland)
- Price Paid Data: every residential sale in England and Wales since
  1995 (~28 million records)
- EPC: ~25 million domestic certificates, 2008 onwards (England and
  Wales)
- Planning: 100+ datasets covering the full England planning system

## Related packages

| Package                                                      | Description                            |
|--------------------------------------------------------------|----------------------------------------|
| [ons](https://github.com/charlescoverdale/ons)               | UK Office for National Statistics data |
| [hmrc](https://github.com/charlescoverdale/hmrc)             | HM Revenue and Customs data            |
| [obr](https://github.com/charlescoverdale/obr)               | Office for Budget Responsibility data  |
| [boe](https://github.com/charlescoverdale/boe)               | Bank of England data                   |
| [inequality](https://github.com/charlescoverdale/inequality) | Inequality and poverty measurement     |

## Issues

Report bugs or request features at [GitHub
Issues](https://github.com/charlescoverdale/ukhousing/issues).

## Keywords

UK housing, land registry, price paid data, UK HPI, EPC, energy
performance certificate, planning, brownfield land, MHCLG, housing data,
house prices, property, real estate
