# CRAN submission comments: ukhousing 0.2.0

## Reason for this submission

`ukh_pipr()` returned no data: the ONS withdrew the download format it
used and stopped updating that copy of the series. It now reads the ONS
monthly workbook. Cached monthly series also now expire after 7 days.
Details in NEWS.md.

## R CMD check results

0 errors | 0 warnings | 0 notes (CRAN settings, R 4.5.2, macOS).

Tests that need the network are skipped on CRAN, and network examples
are wrapped in `try()` inside `\donttest{}`.

## Downstream dependencies

None on CRAN.
