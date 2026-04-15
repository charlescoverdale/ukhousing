.ons_pipr_base <- "https://api.beta.ons.gov.uk/v1/datasets/index-private-housing-rental-prices"

#' ONS Index of Private Housing Rental Prices / Price Index of Private Rents
#'
#' Fetches the UK's official private-rental price index from the ONS
#' Beta API. The dataset replaced the Index of Private Housing Rental
#' Prices (IPHRP) with the Price Index of Private Rents (PIPR) in
#' January 2024, but the same dataset slug covers both.
#'
#' Coverage: UK aggregate plus countries (England, Scotland, Wales,
#' Northern Ireland) and English regions, monthly from January 2015.
#'
#' @param refresh Logical. Re-download even if cached? Default `FALSE`.
#'
#' @return A data frame with columns `date`, `region`, and `index`.
#'
#' @family ons
#' @export
#' @examples
#' \donttest{
#' op <- options(ukhousing.cache_dir = tempdir())
#' rents <- ukh_pipr()
#' head(rents)
#' options(op)
#' }
ukh_pipr <- function(refresh = FALSE) {
  cache_path <- file.path(ukh_cache_dir(), "pipr.json")

  if (!file.exists(cache_path) || refresh) {
    cli_inform(c("i" = "Downloading ONS Price Index of Private Rents..."))

    versions_url <- paste0(.ons_pipr_base, "/editions/time-series/versions")
    req <- ukh_request(versions_url)
    resp <- tryCatch(httr2::req_perform(req), error = function(e) {
      cli_abort(c("Failed to query the ONS API.",
                  "x" = conditionMessage(e)))
    })
    if (httr2::resp_status(resp) >= 400L) {
      cli_abort("ONS API returned HTTP {httr2::resp_status(resp)}.")
    }
    versions <- httr2::resp_body_json(resp)
    items <- versions$items %||% list()
    if (length(items) == 0L) {
      cli_abort("No ONS PIPR versions available.")
    }
    vnums <- vapply(items, function(x) as.integer(x$version %||% 0L), integer(1L))
    latest <- items[[which.max(vnums)]]
    data_url <- latest$downloads$json$href %||% latest$links$self$href
    if (is.null(data_url)) {
      cli_abort("Could not locate a data URL for the latest PIPR version.")
    }

    ukh_download(data_url, cache_path)
  } else {
    cli_inform(c("i" = "Loading PIPR from cache. Use {.code refresh = TRUE} to re-download."))
  }

  body <- jsonlite::fromJSON(cache_path, simplifyVector = FALSE)
  obs <- body$observations %||% body$items %||% list()
  if (length(obs) == 0L) {
    cli_warn("No observations returned from ONS PIPR.")
    return(data.frame(date = as.Date(character(0)),
                      region = character(0),
                      index = numeric(0),
                      stringsAsFactors = FALSE))
  }

  .pipr_tidy(obs)
}

#' @noRd
.pipr_tidy <- function(obs) {
  dates <- vapply(obs, function(x) {
    as.character(x$dimensions$time$id %||% x$time %||% NA_character_)
  }, character(1L))
  regions <- vapply(obs, function(x) {
    as.character(x$dimensions$geography$label %||% x$geography %||% NA_character_)
  }, character(1L))
  values <- vapply(obs, function(x) {
    v <- x$observation %||% NA
    suppressWarnings(as.numeric(v))
  }, numeric(1L))

  d <- suppressWarnings(as.Date(paste0(dates, "-01")))
  if (all(is.na(d))) d <- suppressWarnings(as.Date(dates))

  data.frame(date = d, region = regions, index = values,
             stringsAsFactors = FALSE)
}
