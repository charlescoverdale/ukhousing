# CRAN submission comments: ukhousing 0.2.0

## Resubmission

This is a resubmission. The incoming check flagged
<https://epc.opendatacommunities.org/> as moved. MHCLG retired that
service (and Open Data Communities with it), so the six
Energy Performance Certificate functions that used it had stopped
working. They are now defunct: each stops with an error that points to
the replacement service, and every link to the old site is removed.
The replacement needs a GOV.UK One Login account and a bearer token,
so it is not wrapped. Details in NEWS.md.

## Reason for this submission

`ukh_pipr()` returned no data: the ONS withdrew the download format it
used and stopped updating that copy of the series. It now reads the ONS
monthly workbook. Cached monthly series also now expire after 7 days,
and the retired MHCLG Energy Performance Certificate service is no
longer wrapped.
Details in NEWS.md.

## R CMD check results

0 errors | 0 warnings | 0 notes (`R CMD check --as-cran --run-donttest`
with the incoming and remote URL checks, R 4.5.2, macOS).

The local run also printed two notes about the check machine, not the
package: "checking for future file timestamps ... unable to verify
current time" (it could not reach the time server) and "Skipping
checking HTML validation" (its HTML Tidy is too old).

Tests that need the network are skipped on CRAN, and network examples
are wrapped in `try()` inside `\donttest{}`.

## Downstream dependencies

None on CRAN.
