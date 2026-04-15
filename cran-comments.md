# CRAN submission comments — ukhousing 0.2.0

## New submission

This is a new package providing R access to UK housing data from
four official sources:

* HM Land Registry (UK House Price Index + Price Paid Data)
* MHCLG Energy Performance Certificate Open Data service (domestic,
  non-domestic, and display certificates)
* planning.data.gov.uk (Digital Land planning data, 100+ datasets)
* ONS Beta API (Price Index of Private Rents)

An earlier v0.1.0 was released on GitHub only; this submission is
v0.2.0 after adding non-domestic EPC support, the ONS PIPR series,
a SPARQL escape hatch, several Land Registry REST helpers, and
optional sf integration for GeoJSON planning datasets.

## R CMD check results

0 errors | 0 warnings | 0 notes

## Test suite

100+ expectations. Network-dependent tests are wrapped in
`skip_on_cran()` and `skip_if_offline()`. Tests requiring the EPC
API key are guarded with `skip_if_not(nzchar(Sys.getenv("EPC_EMAIL")))`.
Tests requiring the 150 MB yearly PPD download are guarded with
`skip_if_not(nzchar(Sys.getenv("UKHOUSING_LIVE_TESTS")))`.

## Notes on data access

* UK HPI and PPD data are downloaded from HM Land Registry
  (https://landregistry.data.gov.uk/) and cached via
  `tools::R_user_dir()`.
* EPC API requires free user registration at
  https://epc.opendatacommunities.org/. The package does not bundle
  any certificates.
* Planning data comes from https://www.planning.data.gov.uk/, an
  open service with no auth.
* ONS PIPR data comes from the ONS Beta API at
  https://api.beta.ons.gov.uk/v1/, no auth.
* All `\donttest` examples redirect the cache to `tempdir()` via
  `options(ukhousing.cache_dir = ...)` so that no files are written
  to the user's home filespace.
* `\dontrun` is used only for examples that require EPC API
  credentials, which we cannot safely demonstrate in automated
  checks without a key.

## Downstream dependencies

None.
