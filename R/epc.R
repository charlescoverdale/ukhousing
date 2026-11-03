# Energy Performance Certificate functions, defunct since 0.2.0

#' Defunct Energy Performance Certificate functions
#'
#' The Energy Performance Certificate functions were removed in
#' ukhousing 0.2.0. MHCLG retired the EPC Open Data service they wrapped
#' and replaced it with the Get energy performance of buildings data
#' service (\url{https://get-energy-performance-data.communities.gov.uk/}),
#' which needs a GOV.UK One Login account and a bearer token, has no
#' per-local-authority bulk files and no property type filter. Every
#' function below now stops with an error.
#'
#' Certificates can be searched and downloaded from the new service
#' directly.
#'
#' @param ... Ignored.
#'
#' @return None. Each function signals an error.
#'
#' @name ukhousing-defunct
#' @keywords internal
NULL

.epc_defunct <- function(fn) {
  cli_abort(c(
    "{.fn {fn}} is defunct as of ukhousing 0.2.0.",
    "i" = "MHCLG retired the EPC Open Data service this function used.",
    "i" = "Use the Get energy performance of buildings data service instead: {.url https://get-energy-performance-data.communities.gov.uk/}"
  ), call = NULL)
}

#' @rdname ukhousing-defunct
#' @export
ukh_epc_set_key <- function(...) .epc_defunct("ukh_epc_set_key")

#' @rdname ukhousing-defunct
#' @export
ukh_epc_search <- function(...) .epc_defunct("ukh_epc_search")

#' @rdname ukhousing-defunct
#' @export
ukh_epc_certificate <- function(...) .epc_defunct("ukh_epc_certificate")

#' @rdname ukhousing-defunct
#' @export
ukh_epc_summary <- function(...) .epc_defunct("ukh_epc_summary")

#' @rdname ukhousing-defunct
#' @export
ukh_epc_bulk <- function(...) .epc_defunct("ukh_epc_bulk")

#' @rdname ukhousing-defunct
#' @export
ukh_epc_recommendations_summary <- function(...) {
  .epc_defunct("ukh_epc_recommendations_summary")
}
