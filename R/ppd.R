# Price Paid Data (PPD) field names, in fixed order. The bulk CSV has
# no header row.
.ppd_cols <- c(
  "transaction_id", "price", "date", "postcode", "property_type",
  "new_build", "tenure", "paon", "saon", "street", "locality",
  "town", "district", "county", "category", "record_status"
)

.ppd_property_types <- c(
  "detached"    = "D",
  "semi"        = "S",
  "terraced"    = "T",
  "flat"        = "F",
  "other"       = "O"
)

#' Price Paid Data
#'
#' Fetches individual property transaction records from the HM Land
#' Registry Price Paid Data, filtered by local authority, postcode,
#' property type, and other criteria.
#'
#' The full yearly CSV is ~150 MB (about 900,000 transactions). This
#' function downloads the yearly file, caches it, and then filters in
#' memory. Subsequent queries against the same year use the cache.
#' For multi-year queries, call the function once per year and bind
#' the results.
#'
#' @param year Integer. Year of transactions to fetch. Defaults to the
#'   current calendar year.
#' @param la Optional character. Local authority name (matched
#'   case-insensitively against the `district` field).
#' @param postcode Optional character. Postcode or postcode prefix.
#' @param property_type Optional character. One of `"detached"`,
#'   `"semi"`, `"terraced"`, `"flat"`, or `"other"`. Also accepts the
#'   single-letter codes `"D"`, `"S"`, `"T"`, `"F"`, `"O"`.
#' @param new_build Optional logical. If `TRUE`, only newly built
#'   properties. If `FALSE`, only established properties.
#' @param tenure Optional character. `"freehold"` or `"leasehold"`.
#' @param from,to Optional character or Date. Date range within the
#'   year (YYYY-MM-DD).
#' @param refresh Logical. Re-download the yearly file even if cached?
#'   Default `FALSE`.
#'
#' @return A data frame of individual transactions with columns
#'   `transaction_id`, `price`, `date`, `postcode`, `property_type`,
#'   `new_build`, `tenure`, `paon`, `saon`, `street`, `locality`,
#'   `town`, `district`, `county`, `category`, `record_status`.
#'
#' @family price paid data
#' @export
#' @examples
#' \donttest{
#' op <- options(ukhousing.cache_dir = tempdir())
#'
#' # Westminster flats sold in 2024
#' wm <- ukh_ppd(2024, la = "Westminster", property_type = "flat")
#' head(wm)
#'
#' options(op)
#' }
ukh_ppd <- function(year = as.integer(format(Sys.Date(), "%Y")),
                   la = NULL, postcode = NULL, property_type = NULL,
                   new_build = NULL, tenure = NULL,
                   from = NULL, to = NULL, refresh = FALSE) {
  if (!is.numeric(year) || length(year) != 1L || year < 1995L ||
      year > as.integer(format(Sys.Date(), "%Y"))) {
    cli_abort("{.arg year} must be a single integer between 1995 and the current year.")
  }
  year <- as.integer(year)

  path <- ukh_ppd_bulk(year = year, refresh = refresh)
  df <- utils::read.csv(path, header = FALSE, stringsAsFactors = FALSE,
                        col.names = .ppd_cols, quote = "\"", na.strings = "")

  # Parse date
  df$date <- as.Date(substr(df$date, 1L, 10L))
  df$price <- as.numeric(df$price)

  # Apply filters
  if (!is.null(la)) {
    la_norm <- tolower(trimws(la))
    df <- df[tolower(df$district) == la_norm, , drop = FALSE]
  }
  if (!is.null(postcode)) {
    pc <- toupper(gsub("[[:space:]]+", " ", trimws(postcode)))
    df <- df[!is.na(df$postcode) & startsWith(df$postcode, pc), , drop = FALSE]
  }
  if (!is.null(property_type)) {
    pt <- .ppd_type_code(property_type)
    df <- df[df$property_type == pt, , drop = FALSE]
  }
  if (!is.null(new_build)) {
    if (!is.logical(new_build) || length(new_build) != 1L) {
      cli_abort("{.arg new_build} must be a single logical value.")
    }
    code <- if (new_build) "Y" else "N"
    df <- df[df$new_build == code, , drop = FALSE]
  }
  if (!is.null(tenure)) {
    tenure <- match.arg(tenure, c("freehold", "leasehold"))
    code <- if (tenure == "freehold") "F" else "L"
    df <- df[df$tenure == code, , drop = FALSE]
  }
  dr <- ukh_date_range(from, to)
  if (!is.null(dr$from)) df <- df[df$date >= as.Date(dr$from), , drop = FALSE]
  if (!is.null(dr$to))   df <- df[df$date <= as.Date(dr$to), , drop = FALSE]

  rownames(df) <- NULL
  df
}

#' Download a Price Paid Data bulk file
#'
#' Downloads and caches a yearly (or the complete) Price Paid Data CSV
#' from HM Land Registry. Returns the path to the cached file. Yearly
#' files are typically 100-200 MB; the complete file (1995-present) is
#' approximately 5.3 GB.
#'
#' @param year Integer. Year to download. Ignored when `full = TRUE`.
#'   Defaults to the current year.
#' @param full Logical. If `TRUE`, download the complete file
#'   (`pp-complete.csv`, ~5.3 GB) instead of a single year. Default
#'   `FALSE`.
#' @param refresh Logical. Re-download even if cached? Default `FALSE`.
#'
#' @return Character. The path to the cached CSV file.
#'
#' @family price paid data
#' @export
#' @examples
#' \donttest{
#' op <- options(ukhousing.cache_dir = tempdir())
#' path <- ukh_ppd_bulk(2025)
#' options(op)
#' }
ukh_ppd_bulk <- function(year = as.integer(format(Sys.Date(), "%Y")),
                        full = FALSE, refresh = FALSE) {
  if (isTRUE(full)) {
    filename <- "pp-complete.csv"
  } else {
    if (!is.numeric(year) || length(year) != 1L) {
      cli_abort("{.arg year} must be a single integer.")
    }
    filename <- sprintf("pp-%d.csv", as.integer(year))
  }
  cache_path <- file.path(ukh_cache_dir(), filename)
  if (file.exists(cache_path) && !refresh) {
    cli_inform(c("i" = "Loading {.file {filename}} from cache."))
    return(cache_path)
  }

  url <- paste0("https://price-paid-data.publicdata.landregistry.gov.uk/", filename)
  if (isTRUE(full)) {
    cli_warn(c(
      "!" = "Downloading the complete Price Paid file (~5.3 GB).",
      "i" = "This may take several minutes."
    ))
  } else {
    cli_inform(c("i" = "Downloading {.file {filename}} from HM Land Registry..."))
  }
  ukh_download(url, cache_path)
  cache_path
}

#' Price Paid Data summary
#'
#' Returns summary statistics from Price Paid Data for a given year,
#' aggregated by month, property type, or local authority. Useful when
#' the user wants counts and median prices without loading 150 MB of
#' individual transactions.
#'
#' @param year Integer. Year to summarise.
#' @param by Character. Aggregation dimension: `"month"`,
#'   `"property_type"`, or `"la"`. Default `"month"`.
#' @param la Optional character. Restrict to one local authority.
#' @param refresh Logical. Re-download even if cached? Default `FALSE`.
#'
#' @return A data frame with one row per group and columns `n`,
#'   `median_price`, `mean_price`, `total_value`.
#'
#' @family price paid data
#' @export
#' @examples
#' \donttest{
#' op <- options(ukhousing.cache_dir = tempdir())
#' # Monthly transaction counts and medians, nationally
#' s <- ukh_ppd_summary(2025, by = "month")
#' head(s)
#' options(op)
#' }
ukh_ppd_summary <- function(year = as.integer(format(Sys.Date(), "%Y")),
                           by = c("month", "property_type", "la"),
                           la = NULL, refresh = FALSE) {
  by <- match.arg(by)
  df <- ukh_ppd(year = year, la = la, refresh = refresh)
  if (nrow(df) == 0L) {
    return(data.frame(group = character(0L), n = integer(0L),
                      median_price = numeric(0L), mean_price = numeric(0L),
                      total_value = numeric(0L), stringsAsFactors = FALSE))
  }

  key <- switch(by,
    month         = format(df$date, "%Y-%m"),
    property_type = .ppd_type_label(df$property_type),
    la            = df$district
  )

  .summarise_by(df$price, key, by)
}

#' @noRd
.ppd_type_code <- function(type) {
  if (!is.character(type) || length(type) != 1L) {
    cli_abort("{.arg property_type} must be a single character string.")
  }
  t <- tolower(trimws(type))
  # Accept letter codes
  if (toupper(t) %in% c("D", "S", "T", "F", "O")) return(toupper(t))
  if (!t %in% names(.ppd_property_types)) {
    cli_abort(c(
      "Unknown {.arg property_type}: {.val {type}}.",
      "i" = "Valid options: {.val {names(.ppd_property_types)}}."
    ))
  }
  unname(.ppd_property_types[t])
}

#' @noRd
.ppd_type_label <- function(codes) {
  lookup <- setNames(names(.ppd_property_types), unname(.ppd_property_types))
  out <- unname(lookup[codes])
  out[is.na(out)] <- "unknown"
  out
}

#' @noRd
.summarise_by <- function(price, key, by_label) {
  groups <- sort(unique(key))
  n <- length(groups)
  out <- data.frame(
    group = groups,
    n = integer(n),
    median_price = numeric(n),
    mean_price = numeric(n),
    total_value = numeric(n),
    stringsAsFactors = FALSE
  )
  for (i in seq_len(n)) {
    subset <- price[key == groups[i]]
    out$n[i] <- length(subset)
    out$median_price[i] <- stats::median(subset, na.rm = TRUE)
    out$mean_price[i] <- mean(subset, na.rm = TRUE)
    out$total_value[i] <- sum(subset, na.rm = TRUE)
  }
  names(out)[1L] <- by_label
  out
}
