# CRAN submission comments — ukhousing 0.1.0

## New submission

This is a new package providing R access to UK housing data from three
official sources:

* HM Land Registry: UK House Price Index + Price Paid Data
* MHCLG Energy Performance Certificate Open Data service
* planning.data.gov.uk (Digital Land planning data)

## R CMD check results

0 errors | 0 warnings | 0 notes

## Test suite

100+ expectations. Network-dependent tests are wrapped in
`skip_on_cran()` and `skip_if_offline()`. Tests requiring credentials
(EPC, large PPD downloads) are additionally guarded with
`skip_if_not(nzchar(Sys.getenv("...")))`.

## Notes on data access

* UK HPI and PPD data are downloaded from HM Land Registry
  (https://landregistry.data.gov.uk/) and cached via
  `tools::R_user_dir()`.
* EPC API requires free user registration at
  https://epc.opendatacommunities.org/. The package does not bundle
  any certificates.
* Planning data comes from https://www.planning.data.gov.uk/, an
  open service with no auth.
* All `\donttest` examples redirect the cache to `tempdir()` via
  `options(ukhousing.cache_dir = ...)` so that no files are written
  to the user's home filespace.

## Downstream dependencies

None.
