.planning_base <- "https://www.planning.data.gov.uk"

#' Query planning.data.gov.uk
#'
#' Fetches records from the Digital Land planning data platform,
#' which hosts over 100 datasets on planning applications, brownfield
#' land, local plans, conservation areas, listed buildings, flood risk
#' zones, and more.
#'
#' @param dataset Character. Dataset slug. Common values:
#'   `"planning-application"`, `"brownfield-land"`, `"local-plan"`,
#'   `"conservation-area"`, `"listed-building"`,
#'   `"article-4-direction-area"`, `"tree-preservation-zone"`,
#'   `"flood-risk-zone"`. See [ukh_planning_datasets()] for the full
#'   list.
#' @param la Optional character. Local authority name (matched
#'   case-insensitively against the `organisation` field).
#' @param limit Integer. Maximum records to return. Default `1000`.
#' @param format Character. Response format. `"data.frame"` (default)
#'   returns tidy data. `"raw"` returns the parsed JSON list.
#'
#' @return A data frame (or list if `format = "raw"`).
#'
#' @family planning
#' @export
#' @examples
#' \donttest{
#' op <- options(ukhousing.cache_dir = tempdir())
#' bf <- ukh_planning("brownfield-land", limit = 100)
#' head(bf)
#' options(op)
#' }
ukh_planning <- function(dataset, la = NULL, limit = 1000L,
                        format = c("data.frame", "raw", "sf")) {
  format <- match.arg(format)
  if (!is.character(dataset) || length(dataset) != 1L) {
    cli_abort("{.arg dataset} must be a single character string.")
  }
  if (!is.numeric(limit) || limit < 1L) {
    cli_abort("{.arg limit} must be a positive integer.")
  }

  ext <- if (format == "sf") "geojson" else "json"
  url <- paste0(.planning_base, "/entity.", ext)
  params <- list(dataset = dataset, limit = as.integer(limit))
  if (!is.null(la)) {
    params[["organisation-entity"]] <- la
  }

  req <- ukh_request(url)
  req <- httr2::req_url_query(req, !!!params)
  resp <- tryCatch(httr2::req_perform(req), error = function(e) {
    cli_abort(c("Failed to query planning.data.gov.uk.",
                "x" = conditionMessage(e)))
  })
  if (httr2::resp_status(resp) >= 400L) {
    cli_abort("planning.data.gov.uk returned HTTP {httr2::resp_status(resp)}.")
  }

  if (format == "sf") {
    if (!requireNamespace("sf", quietly = TRUE)) {
      cli_abort(c(
        "The {.pkg sf} package is required for {.code format = \"sf\"}.",
        "i" = "Install it with {.code install.packages(\"sf\")}."
      ))
    }
    txt <- httr2::resp_body_string(resp)
    return(sf::st_read(txt, quiet = TRUE))
  }

  body <- httr2::resp_body_json(resp)
  items <- body$entities %||% body$results %||% list()

  if (format == "raw") return(items)
  df <- ukh_list_to_df(items)
  df
}

#' List available planning datasets
#'
#' Returns a data frame of datasets hosted by planning.data.gov.uk,
#' with their slugs, names, and descriptions.
#'
#' @return A data frame with `slug`, `name`, `typology`, and
#'   `record_count`.
#'
#' @family planning
#' @export
#' @examples
#' \donttest{
#' op <- options(ukhousing.cache_dir = tempdir())
#' ds <- ukh_planning_datasets()
#' head(ds)
#' options(op)
#' }
ukh_planning_datasets <- function() {
  url <- paste0(.planning_base, "/dataset.json")
  req <- ukh_request(url)
  resp <- tryCatch(httr2::req_perform(req), error = function(e) {
    cli_abort(c("Failed to query planning.data.gov.uk.",
                "x" = conditionMessage(e)))
  })
  if (httr2::resp_status(resp) >= 400L) {
    cli_abort("planning.data.gov.uk returned HTTP {httr2::resp_status(resp)}.")
  }
  body <- httr2::resp_body_json(resp)
  items <- body$datasets %||% body %||% list()
  ukh_list_to_df(items)
}
