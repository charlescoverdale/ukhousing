.sparql_land_registry <- "http://landregistry.data.gov.uk/landregistry/query"
.sparql_opendatacommunities <- "http://opendatacommunities.org/sparql"

#' Run a SPARQL query
#'
#' Runs a SPARQL query against one of the supported endpoints and
#' returns the result as a data frame. Useful for queries that aren't
#' covered by the dedicated helpers, including custom HPI aggregations
#' and Price Paid Data lookups by postcode.
#'
#' Both endpoints are free and require no authentication. The Land
#' Registry endpoint covers HPI and Price Paid Data; the Open Data
#' Communities endpoint covers 300+ housing-market datasets published
#' by MHCLG.
#'
#' @param query Character. A SPARQL query string.
#' @param endpoint Character. One of `"land-registry"` (default),
#'   `"opendatacommunities"`, or a full URL to any SPARQL endpoint.
#' @param timeout Integer. Request timeout in seconds. Default `60`.
#'
#' @return A data frame of bindings. Column names match the SELECT
#'   variables in the query.
#'
#' @family helpers
#' @export
#' @examples
#' \donttest{
#' op <- options(ukhousing.cache_dir = tempdir())
#'
#' # All HPI observations for Westminster in January 2020
#' q <- '
#' PREFIX ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>
#' SELECT ?hpi ?avgPrice WHERE {
#'   <http://landregistry.data.gov.uk/data/ukhpi/region/city-of-westminster/month/2020-01>
#'     ukhpi:housePriceIndex ?hpi ;
#'     ukhpi:averagePrice    ?avgPrice .
#' }'
#' ukh_sparql(q)
#'
#' options(op)
#' }
ukh_sparql <- function(query,
                       endpoint = c("land-registry", "opendatacommunities"),
                       timeout = 60L) {
  if (!is.character(query) || length(query) != 1L || !nzchar(query)) {
    cli_abort("{.arg query} must be a non-empty character string.")
  }

  if (is.character(endpoint) && length(endpoint) == 1L &&
      grepl("^https?://", endpoint)) {
    url <- endpoint
  } else {
    endpoint <- match.arg(endpoint)
    url <- switch(endpoint,
      "land-registry" = .sparql_land_registry,
      "opendatacommunities" = .sparql_opendatacommunities
    )
  }

  req <- ukh_request(url)
  req <- httr2::req_headers(req, Accept = "application/sparql-results+json")
  req <- httr2::req_timeout(req, timeout)
  req <- httr2::req_body_form(req, query = query)

  resp <- tryCatch(httr2::req_perform(req), error = function(e) {
    cli_abort(c("Failed to query SPARQL endpoint {.url {url}}.",
                "x" = conditionMessage(e)))
  })
  if (httr2::resp_status(resp) >= 400L) {
    cli_abort("SPARQL endpoint returned HTTP {httr2::resp_status(resp)}.")
  }

  body <- httr2::resp_body_json(resp)
  bindings <- body$results$bindings %||% list()
  if (length(bindings) == 0L) return(data.frame())

  vars <- body$head$vars %||% unique(unlist(lapply(bindings, names)))
  cols <- lapply(vars, function(v) {
    vapply(bindings, function(b) {
      val <- b[[v]]
      if (is.null(val) || is.null(val$value)) NA_character_ else as.character(val$value)
    }, character(1L))
  })
  names(cols) <- unlist(vars)
  as.data.frame(cols, stringsAsFactors = FALSE)
}
