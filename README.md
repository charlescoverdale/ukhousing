# ukhousing

<!-- badges: start -->
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

Access UK housing data from official sources in R. House prices, individual property transactions, energy performance certificates, and planning data.


## Installation

```r
# install.packages("devtools")
devtools::install_github("charlescoverdale/ukhousing")
```


## Why this package?

The only previous CRAN package for UK housing data (`uklr`) was archived in March 2026. It covered only part of the Land Registry and never supported Energy Performance Certificates or planning data.

`ukhousing` pulls from three official data sources and exposes them through a consistent R interface:

| Source | What it provides |
|---|---|
| [HM Land Registry](https://landregistry.data.gov.uk/) | UK House Price Index + Price Paid Data |
| [MHCLG EPC Open Data](https://epc.opendatacommunities.org/) | 25 million Energy Performance Certificates |
| [planning.data.gov.uk](https://www.planning.data.gov.uk/) | Planning applications, brownfield land, local plans |

All three are free to use. EPC requires a free registration for an API key.


## Quick start

```r
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

```r
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

The Land Registry publishes every residential property sale in England and Wales since 1995. The yearly file is about 150 MB and contains ~900,000 transactions.

```r
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

```r
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

```r
# Brownfield land register
bf <- ukh_planning("brownfield-land", limit = 500)

# All available datasets
datasets <- ukh_planning_datasets()
```


## Functions

### Land Registry

| Function | Description |
|---|---|
| `ukh_hpi()` | UK HPI time series for a region |
| `ukh_hpi_compare()` | One measure across multiple regions |
| `ukh_ppd()` | Individual property transactions |
| `ukh_ppd_bulk()` | Download a bulk PPD CSV |
| `ukh_ppd_summary()` | Aggregated PPD statistics |

### EPC

| Function | Description |
|---|---|
| `ukh_epc_set_key()` | Set API credentials |
| `ukh_epc_search()` | Search certificates with filters |
| `ukh_epc_certificate()` | Fetch a single certificate |
| `ukh_epc_summary()` | Rating distribution for an LA |
| `ukh_epc_bulk()` | Download bulk ZIP for an LA |

### Planning

| Function | Description |
|---|---|
| `ukh_planning()` | Query planning entities |
| `ukh_planning_datasets()` | List available datasets |

### Helpers

| Function | Description |
|---|---|
| `ukh_regions()` | Region slug lookup |
| `ukh_clear_cache()` | Empty the local cache |
| `ukh_cache_info()` | Show cached files |


## Caching

Downloads are cached to `tools::R_user_dir("ukhousing", "cache")` by default. Subsequent calls are instant. Override the location with `options(ukhousing.cache_dir = "/path/to/dir")`. Use `ukh_clear_cache()` to remove all cached files.


## EPC API registration

The Energy Performance Certificate service requires a free API key. Register at [https://epc.opendatacommunities.org/](https://epc.opendatacommunities.org/) and then:

```r
ukh_epc_set_key("you@example.com", "your_api_key")

# Or set env vars in .Renviron:
# EPC_EMAIL=you@example.com
# EPC_API_KEY=your_api_key
```


## Data coverage

- UK HPI: 441+ areas, from January 1995 (E&W), 2004 (Scotland), 2005 (Northern Ireland)
- Price Paid Data: every residential sale in England and Wales since 1995 (~28 million records)
- EPC: ~25 million domestic certificates, 2008 onwards (England and Wales)
- Planning: 100+ datasets covering the full England planning system


## Related packages

| Package | Description |
|---------|-------------|
| [ons](https://github.com/charlescoverdale/ons) | UK Office for National Statistics data |
| [hmrc](https://github.com/charlescoverdale/hmrc) | HM Revenue and Customs data |
| [obr](https://github.com/charlescoverdale/obr) | Office for Budget Responsibility data |
| [boe](https://github.com/charlescoverdale/boe) | Bank of England data |
| [inequality](https://github.com/charlescoverdale/inequality) | Inequality and poverty measurement |


## Issues

Report bugs or request features at [GitHub Issues](https://github.com/charlescoverdale/ukhousing/issues).


## Keywords

UK housing, land registry, price paid data, UK HPI, EPC, energy performance certificate, planning, brownfield land, MHCLG, housing data, house prices, property, real estate
