# EPC API authentication and endpoints

.epc_base <- "https://epc.opendatacommunities.org/api/v1"

#' Set EPC API credentials
#'
#' Stores the email and API key used to authenticate requests to the
#' MHCLG Energy Performance Certificate Open Data service. Credentials
#' persist for the current R session. Alternatively, set the
#' `EPC_EMAIL` and `EPC_API_KEY` environment variables in your
#' `.Renviron` file.
#'
#' Register for a free API key at
#' \url{https://epc.opendatacommunities.org/}.
#'
#' @param email Character. The email you registered with.
#' @param key Character. The API key.
#'
#' @return Invisible `NULL`.
#'
#' @family configuration
#' @export
#' @examples
#' \dontrun{
#' ukh_epc_set_key("you@example.com", "your_api_key_here")
#' }
ukh_epc_set_key <- function(email, key) {
  if (!is.character(email) || length(email) != 1L || !nzchar(email)) {
    cli_abort("{.arg email} must be a non-empty character string.")
  }
  if (!is.character(key) || length(key) != 1L || !nzchar(key)) {
    cli_abort("{.arg key} must be a non-empty character string.")
  }
  ukh_env$epc_email <- email
  ukh_env$epc_api_key <- key
  invisible(NULL)
}

# Retrieve credentials from session store or env vars
.epc_auth <- function() {
  email <- ukh_env$epc_email %||% Sys.getenv("EPC_EMAIL", unset = "")
  key   <- ukh_env$epc_api_key %||% Sys.getenv("EPC_API_KEY", unset = "")
  if (!nzchar(email) || !nzchar(key)) {
    cli_abort(c(
      "No EPC API credentials found.",
      "i" = "Set them with {.fn ukh_epc_set_key} or via {.envvar EPC_EMAIL} and {.envvar EPC_API_KEY}.",
      "i" = "Register for a free key at {.url https://epc.opendatacommunities.org/}."
    ))
  }
  list(user = email, password = key)
}

#' Search domestic Energy Performance Certificates
#'
#' Queries the MHCLG EPC Open Data service for domestic certificates
#' matching the given filters. Results are paginated automatically
#' using `search-after` tokens (not the `from` parameter, which caps
#' at 10,000 records).
#'
#' Registration at \url{https://epc.opendatacommunities.org/} is
#' required and free.
#'
#' @param postcode Optional character. Postcode or partial postcode.
#' @param la Optional character. Local authority GSS code (e.g.
#'   `"E09000033"` for Westminster).
#' @param property_type Optional character. `"House"`, `"Flat"`,
#'   `"Bungalow"`, `"Maisonette"`, `"Park home"`.
#' @param rating Optional character. Current energy rating (`"A"` to
#'   `"G"`).
#' @param built_form Optional character. `"Detached"`, `"Semi-Detached"`,
#'   `"End-Terrace"`, `"Mid-Terrace"`, `"Enclosed End-Terrace"`,
#'   `"Enclosed Mid-Terrace"`.
#' @param from,to Optional. Lodgement date range (YYYY-MM-DD).
#' @param size Integer. Results per page, max 5000. Default 1000.
#' @param max_records Integer. Maximum total records to fetch across
#'   pages. Default 10000. Set higher for bulk analysis.
#' @param type Character. Register to query: `"domestic"` (default,
#'   housing), `"non-domestic"` (commercial buildings), or `"display"`
#'   (DECs for public buildings).
#'
#' @return A data frame of certificates. Columns include `lmk_key`,
#'   `address`, `postcode`, `uprn`, `local_authority`, `constituency`,
#'   `property_type`, `built_form`, `inspection_date`, `lodgement_date`,
#'   `current_energy_rating`, `current_energy_efficiency`,
#'   `potential_energy_rating`, `potential_energy_efficiency`,
#'   `total_floor_area`, `co2_emissions_current`, and more.
#'
#' @family energy performance certificates
#' @export
#' @examples
#' \dontrun{
#' # Requires EPC API credentials
#' certs <- ukh_epc_search(postcode = "SW1A 1AA")
#' head(certs)
#'
#' # All E-rated flats in Westminster lodged since 2020
#' wm <- ukh_epc_search(
#'   la = "E09000033", property_type = "Flat",
#'   rating = "E", from = "2020-01-01"
#' )
#' }
ukh_epc_search <- function(postcode = NULL, la = NULL, property_type = NULL,
                          rating = NULL, built_form = NULL,
                          from = NULL, to = NULL,
                          size = 1000L, max_records = 10000L,
                          type = c("domestic", "non-domestic", "display")) {
  type <- match.arg(type)
  auth <- .epc_auth()

  if (!is.numeric(size) || size < 1L || size > 5000L) {
    cli_abort("{.arg size} must be between 1 and 5000.")
  }
  if (!is.numeric(max_records) || max_records < 1L) {
    cli_abort("{.arg max_records} must be a positive integer.")
  }

  dr <- ukh_date_range(from, to)
  params <- list(size = as.integer(size))
  if (!is.null(postcode))      params[["postcode"]] <- postcode
  if (!is.null(la))            params[["local-authority"]] <- la
  if (!is.null(property_type)) params[["property-type"]] <- property_type
  if (!is.null(rating))        params[["current-energy-rating"]] <- rating
  if (!is.null(built_form))    params[["built-form"]] <- built_form
  if (!is.null(dr$from))       params[["from-year"]] <- substr(dr$from, 1L, 4L)
  if (!is.null(dr$to))         params[["to-year"]] <- substr(dr$to, 1L, 4L)

  rows <- list()
  fetched <- 0L
  search_after <- NULL

  repeat {
    p <- params
    if (!is.null(search_after)) p[["search-after"]] <- search_after

    req <- ukh_request(paste0(.epc_base, "/", type, "/search"))
    req <- httr2::req_auth_basic(req, auth$user, auth$password)
    req <- httr2::req_headers(req, Accept = "application/json")
    req <- httr2::req_url_query(req, !!!p)

    resp <- tryCatch(httr2::req_perform(req), error = function(e) {
      cli_abort(c("Failed to query the EPC API.",
                  "x" = conditionMessage(e)))
    })
    status <- httr2::resp_status(resp)
    if (status == 401L) {
      cli_abort(c("EPC API rejected the credentials (HTTP 401).",
                  "i" = "Check your email and API key."))
    }
    if (status >= 400L) {
      cli_abort("EPC API returned HTTP {status}.")
    }

    body <- httr2::resp_body_json(resp)
    items <- body$rows %||% body$results %||% list()
    if (length(items) == 0L) break

    rows <- c(rows, items)
    fetched <- fetched + length(items)
    if (fetched >= max_records) break

    next_token <- httr2::resp_header(resp, "X-Next-Search-After")
    if (is.null(next_token) || !nzchar(next_token)) break
    search_after <- next_token
  }

  if (fetched > max_records) {
    rows <- rows[seq_len(max_records)]
  }

  df <- ukh_list_to_df(rows)
  if (nrow(df) == 0L) return(df)
  .epc_tidy(df)
}

#' Fetch a single EPC by LMK key
#'
#' Returns all available fields and any improvement recommendations
#' for one Energy Performance Certificate identified by its LMK key.
#'
#' @param lmk_key Character. The certificate's LMK key (found in the
#'   `lmk_key` column of [ukh_epc_search()] results).
#' @param type Character. Register: `"domestic"` (default),
#'   `"non-domestic"`, or `"display"`.
#'
#' @return A list with two elements:
#' \describe{
#'   \item{certificate}{A one-row data frame with all certificate fields.}
#'   \item{recommendations}{A data frame of improvement recommendations
#'     (may be empty).}
#' }
#'
#' @family energy performance certificates
#' @export
#' @examples
#' \dontrun{
#' cert <- ukh_epc_certificate("0000-0000-0000-0000-0000")
#' cert$certificate
#' cert$recommendations
#' }
ukh_epc_certificate <- function(lmk_key,
                                type = c("domestic", "non-domestic", "display")) {
  type <- match.arg(type)
  if (!is.character(lmk_key) || length(lmk_key) != 1L) {
    cli_abort("{.arg lmk_key} must be a single character string.")
  }
  auth <- .epc_auth()
  lmk_enc <- utils::URLencode(lmk_key, reserved = TRUE)

  fetch_one <- function(url) {
    req <- ukh_request(url)
    req <- httr2::req_auth_basic(req, auth$user, auth$password)
    req <- httr2::req_headers(req, Accept = "application/json")
    resp <- tryCatch(httr2::req_perform(req), error = function(e) {
      cli_abort(c("Failed to query the EPC API.",
                  "x" = conditionMessage(e)))
    })
    if (httr2::resp_status(resp) == 404L) return(NULL)
    if (httr2::resp_status(resp) >= 400L) {
      cli_abort("EPC API returned HTTP {httr2::resp_status(resp)}.")
    }
    httr2::resp_body_json(resp)
  }

  cert <- fetch_one(paste0(.epc_base, "/", type, "/certificate/", lmk_enc))
  recs <- fetch_one(paste0(.epc_base, "/", type, "/recommendations/", lmk_enc))

  cert_df <- if (is.null(cert)) data.frame() else ukh_list_to_df(list(cert$rows[[1L]] %||% cert))
  rec_df <- if (is.null(recs)) data.frame() else ukh_list_to_df(recs$rows %||% list())

  list(certificate = cert_df, recommendations = rec_df)
}

#' EPC rating distribution for a local authority
#'
#' Summarises the distribution of current energy ratings (A-G) for
#' domestic certificates in a local authority. Useful for area-level
#' comparisons of housing stock efficiency.
#'
#' @param la Character. Local authority GSS code.
#' @param from,to Optional. Lodgement date range.
#' @param type Character. Register: `"domestic"` (default),
#'   `"non-domestic"`, or `"display"`.
#'
#' @return A data frame with one row per rating (A-G) and columns
#'   `rating`, `count`, `percentage`, `mean_floor_area`,
#'   `mean_co2_emissions`.
#'
#' @family energy performance certificates
#' @export
#' @examples
#' \dontrun{
#' ukh_epc_summary(la = "E09000033")
#' }
ukh_epc_summary <- function(la, from = NULL, to = NULL,
                            type = c("domestic", "non-domestic", "display")) {
  type <- match.arg(type)
  if (missing(la) || !is.character(la) || length(la) != 1L) {
    cli_abort("{.arg la} must be a single GSS code.")
  }
  df <- ukh_epc_search(la = la, from = from, to = to, max_records = 100000L, type = type)
  if (nrow(df) == 0L) {
    return(data.frame(rating = character(0), count = integer(0),
                      percentage = numeric(0), mean_floor_area = numeric(0),
                      mean_co2_emissions = numeric(0),
                      stringsAsFactors = FALSE))
  }
  ratings <- c("A", "B", "C", "D", "E", "F", "G")
  total <- nrow(df)
  out <- data.frame(
    rating = ratings,
    count = vapply(ratings, function(r) sum(df$current_energy_rating == r, na.rm = TRUE), integer(1L)),
    stringsAsFactors = FALSE
  )
  out$percentage <- round(out$count / total * 100, 1)
  out$mean_floor_area <- vapply(ratings, function(r) {
    sub <- df$total_floor_area[df$current_energy_rating == r]
    if (length(sub) == 0L) return(NA_real_)
    mean(suppressWarnings(as.numeric(sub)), na.rm = TRUE)
  }, numeric(1L))
  out$mean_co2_emissions <- vapply(ratings, function(r) {
    sub <- df$co2_emissions_current[df$current_energy_rating == r]
    if (length(sub) == 0L) return(NA_real_)
    mean(suppressWarnings(as.numeric(sub)), na.rm = TRUE)
  }, numeric(1L))
  out
}

#' Download a bulk EPC ZIP for a local authority
#'
#' Downloads and extracts the MHCLG bulk ZIP containing all domestic
#' certificates and recommendations for one local authority. The ZIP
#' is typically 5 to 50 MB and contains `certificates.csv`,
#' `recommendations.csv`, and a licence file.
#'
#' @param la Character. Local authority GSS code (e.g. `"E09000033"`).
#' @param refresh Logical. Re-download even if cached? Default `FALSE`.
#' @param type Character. Register: `"domestic"` (default),
#'   `"non-domestic"`, or `"display"`.
#'
#' @return A list with elements `certificates` and `recommendations`,
#'   each giving the path to the extracted CSV.
#'
#' @family energy performance certificates
#' @export
#' @examples
#' \dontrun{
#' paths <- ukh_epc_bulk("E09000033")
#' certs <- read.csv(paths$certificates)
#' }
ukh_epc_bulk <- function(la, refresh = FALSE,
                         type = c("domestic", "non-domestic", "display")) {
  type <- match.arg(type)
  if (missing(la) || !is.character(la) || length(la) != 1L) {
    cli_abort("{.arg la} must be a single GSS code.")
  }
  auth <- .epc_auth()

  type_slug <- switch(type,
    "domestic" = "all-domestic-certificates",
    "non-domestic" = "all-non-domestic-certificates",
    "display" = "all-display-certificates"
  )

  zip_path <- file.path(ukh_cache_dir(), paste0("epc_", type, "_", la, ".zip"))
  extract_dir <- file.path(ukh_cache_dir(), paste0("epc_", type, "_", la))

  if (file.exists(zip_path) && dir.exists(extract_dir) && !refresh) {
    cli_inform(c("i" = "Loading EPC bulk for {.val {la}} from cache."))
  } else {
    url <- paste0("https://epc.opendatacommunities.org/files/", type_slug, "/", la, ".zip")
    cli_inform(c("i" = "Downloading EPC {type} bulk for {.val {la}}..."))
    ukh_download(url, zip_path, auth = auth)
    if (dir.exists(extract_dir)) unlink(extract_dir, recursive = TRUE)
    utils::unzip(zip_path, exdir = extract_dir)
  }

  list(
    certificates = file.path(extract_dir, "certificates.csv"),
    recommendations = file.path(extract_dir, "recommendations.csv")
  )
}

#' @noRd
.epc_tidy <- function(df) {
  # Rename from API's hyphenated field names to snake_case
  rename_map <- c(
    "lmk-key" = "lmk_key",
    "address1" = "address_1",
    "address2" = "address_2",
    "address3" = "address_3",
    "postcode" = "postcode",
    "building-reference-number" = "building_reference_number",
    "current-energy-rating" = "current_energy_rating",
    "potential-energy-rating" = "potential_energy_rating",
    "current-energy-efficiency" = "current_energy_efficiency",
    "potential-energy-efficiency" = "potential_energy_efficiency",
    "property-type" = "property_type",
    "built-form" = "built_form",
    "inspection-date" = "inspection_date",
    "local-authority" = "local_authority",
    "constituency" = "constituency",
    "county" = "county",
    "lodgement-date" = "lodgement_date",
    "transaction-type" = "transaction_type",
    "environment-impact-current" = "environment_impact_current",
    "environment-impact-potential" = "environment_impact_potential",
    "energy-consumption-current" = "energy_consumption_current",
    "energy-consumption-potential" = "energy_consumption_potential",
    "co2-emissions-current" = "co2_emissions_current",
    "co2-emissions-potential" = "co2_emissions_potential",
    "co2-emiss-curr-per-floor-area" = "co2_emiss_curr_per_floor_area",
    "lighting-cost-current" = "lighting_cost_current",
    "heating-cost-current" = "heating_cost_current",
    "hot-water-cost-current" = "hot_water_cost_current",
    "total-floor-area" = "total_floor_area",
    "energy-tariff" = "energy_tariff",
    "mains-gas-flag" = "mains_gas_flag",
    "floor-level" = "floor_level",
    "flat-top-storey" = "flat_top_storey",
    "flat-storey-count" = "flat_storey_count",
    "main-heating-controls" = "main_heating_controls",
    "multi-glaze-proportion" = "multi_glaze_proportion",
    "glazed-type" = "glazed_type",
    "glazed-area" = "glazed_area",
    "extension-count" = "extension_count",
    "number-habitable-rooms" = "number_habitable_rooms",
    "number-heated-rooms" = "number_heated_rooms",
    "low-energy-lighting" = "low_energy_lighting",
    "main-fuel" = "main_fuel",
    "windows-description" = "windows_description",
    "walls-description" = "walls_description",
    "roof-description" = "roof_description",
    "mainheat-description" = "mainheat_description",
    "tenure" = "tenure",
    "uprn" = "uprn"
  )

  old <- names(df)
  new <- old
  for (i in seq_along(new)) {
    if (new[i] %in% names(rename_map)) {
      new[i] <- rename_map[[new[i]]]
    } else {
      # Default: replace hyphens with underscores
      new[i] <- gsub("-", "_", new[i])
    }
  }
  names(df) <- new

  # Coerce obvious numerics
  num_fields <- c("current_energy_efficiency", "potential_energy_efficiency",
                  "total_floor_area", "co2_emissions_current",
                  "co2_emissions_potential", "environment_impact_current",
                  "environment_impact_potential", "energy_consumption_current",
                  "number_habitable_rooms", "number_heated_rooms")
  for (f in intersect(num_fields, names(df))) {
    df[[f]] <- suppressWarnings(as.numeric(df[[f]]))
  }

  df
}

#' Summarise EPC improvement recommendations for a local authority
#'
#' Aggregates the improvement recommendations across certificates in a
#' local authority, returning the frequency of each recommendation and
#' the mean estimated cost and savings where available.
#'
#' This uses the bulk per-LA ZIP download rather than the paginated
#' API, which is much faster for this aggregation. Requires EPC API
#' credentials.
#'
#' @param la Character. Local authority GSS code.
#' @param type Character. `"domestic"` (default), `"non-domestic"`, or
#'   `"display"`.
#' @param refresh Logical. Re-download bulk ZIP? Default `FALSE`.
#'
#' @return A data frame with columns `improvement_id`,
#'   `improvement_summary`, `count`, `mean_indicative_cost` (where
#'   numeric costs are reported), ordered by `count` descending.
#'
#' @family energy performance certificates
#' @export
#' @examples
#' \dontrun{
#' recs <- ukh_epc_recommendations_summary("E09000033")
#' head(recs)
#' }
ukh_epc_recommendations_summary <- function(la, type = c("domestic", "non-domestic", "display"),
                                            refresh = FALSE) {
  type <- match.arg(type)
  paths <- ukh_epc_bulk(la = la, refresh = refresh, type = type)
  if (!file.exists(paths$recommendations)) {
    cli_abort("Recommendations file not found at {.path {paths$recommendations}}.")
  }
  recs <- utils::read.csv(paths$recommendations, stringsAsFactors = FALSE)
  if (nrow(recs) == 0L) {
    return(data.frame(improvement_id = character(0),
                      improvement_summary = character(0),
                      count = integer(0),
                      mean_indicative_cost = numeric(0),
                      stringsAsFactors = FALSE))
  }

  id_col <- .pick_col(recs, c("IMPROVEMENT_ID", "improvement_id"))
  text_col <- .pick_col(recs, c("IMPROVEMENT_SUMMARY_TEXT", "improvement_summary_text",
                                "IMPROVEMENT_DESCR_TEXT", "improvement_descr_text"))
  cost_col <- .pick_col(recs, c("INDICATIVE_COST", "indicative_cost"))

  if (is.na(id_col)) {
    cli_abort("Could not find improvement identifier column in recommendations file.")
  }

  ids <- recs[[id_col]]
  uniq <- sort(unique(ids))
  out <- data.frame(
    improvement_id = uniq,
    improvement_summary = vapply(uniq, function(u) {
      if (is.na(text_col)) return(NA_character_)
      txt <- recs[[text_col]][ids == u]
      txt <- txt[!is.na(txt) & nzchar(txt)]
      if (length(txt) == 0L) NA_character_ else txt[1L]
    }, character(1L)),
    count = vapply(uniq, function(u) sum(ids == u), integer(1L)),
    mean_indicative_cost = vapply(uniq, function(u) {
      if (is.na(cost_col)) return(NA_real_)
      costs <- suppressWarnings(as.numeric(
        gsub("[^0-9.-]", "", recs[[cost_col]][ids == u])
      ))
      if (all(is.na(costs))) NA_real_ else mean(costs, na.rm = TRUE)
    }, numeric(1L)),
    stringsAsFactors = FALSE
  )
  out <- out[order(-out$count), , drop = FALSE]
  rownames(out) <- NULL
  out
}

#' @noRd
.pick_col <- function(df, candidates) {
  for (c in candidates) {
    if (c %in% names(df)) return(c)
  }
  NA_character_
}
