.ons_pipr_landing <- "https://www.ons.gov.uk/economy/inflationandpriceindices/datasets/priceindexofprivaterentsukmonthlypricestatistics"

.pipr_measures <- c(
  "all", "one bed", "two bed", "three bed", "four or more bed",
  "detached", "semidetached", "terraced", "flat maisonette"
)

#' ONS Price Index of Private Rents
#'
#' Downloads the ONS Price Index of Private Rents (PIPR), UK: monthly
#' price statistics. PIPR replaced the Index of Private Housing Rental
#' Prices in 2024 and is published monthly from January 2015 for the UK,
#' its countries, the English regions and local authorities (around 350
#' areas in all), including average rents in pounds.
#'
#' The ONS stopped updating the rental index on its Beta API at January
#' 2024, so this function reads the monthly workbook from the ONS website
#' instead. The cached copy is refreshed once it is more than
#' `getOption("ukhousing.cache_max_age", 7)` days old.
#'
#' @param property Which series to return: `"all"` (default, all
#'   private rented property), a bedroom count (`"one bed"`, `"two bed"`,
#'   `"three bed"`, `"four or more bed"`) or a property type
#'   (`"detached"`, `"semidetached"`, `"terraced"`, `"flat maisonette"`).
#' @param refresh Logical. Re-download even if cached? Default `FALSE`.
#'
#' @return A data frame with columns `date` (first of the month),
#'   `gss_code`, `region` (area name), `parent_region` (the region or
#'   country an area belongs to; `NA` for the UK and its countries),
#'   `index` (January 2023 = 100), `monthly_change_pct`,
#'   `annual_change_pct` and `rental_price_gbp` (average monthly rent,
#'   rounded to the nearest pound). Values the ONS marks as unavailable
#'   or not applicable are `NA`. Requires the \pkg{readxl} package.
#'
#' @source Office for National Statistics, Price Index of Private Rents,
#'   UK: monthly price statistics. Official statistics in development.
#'   \url{https://www.ons.gov.uk/economy/inflationandpriceindices/datasets/priceindexofprivaterentsukmonthlypricestatistics}
#'
#' @family ons
#' @export
#' @examples
#' \donttest{
#' op <- options(ukhousing.cache_dir = tempdir())
#' try({
#'   rents <- ukh_pipr()
#'   tail(rents[rents$region == "United Kingdom", ])
#'   flats <- ukh_pipr(property = "flat maisonette")
#' })
#' options(op)
#' }
ukh_pipr <- function(property = "all", refresh = FALSE) {
  property <- match.arg(property, .pipr_measures)
  if (!requireNamespace("readxl", quietly = TRUE)) {
    cli_abort("The {.pkg readxl} package is required to read the ONS rents workbook.")
  }
  cache_path <- file.path(ukh_cache_dir(), "pipr.xlsx")

  if (ukh_cache_stale(cache_path, refresh)) {
    cli_inform(c("i" = "Downloading ONS Price Index of Private Rents..."))
    ukh_download(.pipr_xlsx_url(), cache_path)
  } else {
    cli_inform(c("i" = "Loading PIPR from cache. Use {.code refresh = TRUE} to re-download."))
  }

  raw <- as.data.frame(readxl::read_excel(cache_path, sheet = "Table 1",
                                          skip = 2, col_types = "text",
                                          .name_repair = "minimal"))
  .pipr_tidy(raw, property)
}

# The dataset landing page lists every release, newest first; each
# release lists its download file. Both are read through the ONS
# website's JSON view (append /data to a page path).
#' @noRd
.pipr_xlsx_url <- function() {
  get_json <- function(url) {
    resp <- tryCatch(httr2::req_perform(ukh_request(url)), error = function(e) {
      cli_abort(c("Failed to query the ONS website.", "x" = conditionMessage(e)))
    })
    httr2::resp_body_json(resp)
  }
  landing <- get_json(paste0(.ons_pipr_landing, "/data"))
  release <- landing$datasets[[1]]$uri
  if (is.null(release)) {
    cli_abort("The ONS rents page lists no releases.")
  }
  file <- get_json(paste0("https://www.ons.gov.uk", release, "/data"))$downloads[[1]]$file
  if (is.null(file)) {
    cli_abort("The latest ONS rents release has no download file.")
  }
  paste0("https://www.ons.gov.uk/file?uri=", release, "/", file)
}

#' @noRd
.pipr_tidy <- function(raw, property = "all") {
  suffix <- if (property == "all") "" else paste0(" ", property)
  cols <- c(
    index              = paste0("Index", suffix),
    monthly_change_pct = paste0("Monthly change", suffix),
    annual_change_pct  = paste0("Annual change", suffix),
    rental_price_gbp   = paste0("Rental price", suffix)
  )
  needed <- c("Time period", "Area code", "Area name",
              "Region or country name", cols)
  missing <- setdiff(needed, names(raw))
  if (length(missing) > 0L) {
    cli_abort(c(
      "Unexpected layout in the ONS rents workbook.",
      "x" = "Missing column{?s}: {.val {missing}}.",
      "i" = "The ONS may have changed the table. Please file an issue at https://github.com/charlescoverdale/ukhousing/issues."
    ))
  }
  raw <- raw[!is.na(raw[["Area code"]]), , drop = FALSE]

  # Read as text so "[x]" and "[z]" markers can be dropped explicitly.
  # Dates are Excel serial numbers once read as text.
  num <- function(v) suppressWarnings(as.numeric(ifelse(grepl("^\\[", v), NA, v)))
  serial <- num(raw[["Time period"]])
  date <- as.Date(serial, origin = "1899-12-30")
  parent <- raw[["Region or country name"]]
  parent[grepl("^\\[", parent)] <- NA_character_

  out <- data.frame(
    date               = date,
    gss_code           = raw[["Area code"]],
    region             = raw[["Area name"]],
    parent_region      = parent,
    index              = num(raw[[cols[["index"]]]]),
    monthly_change_pct = num(raw[[cols[["monthly_change_pct"]]]]),
    annual_change_pct  = num(raw[[cols[["annual_change_pct"]]]]),
    rental_price_gbp   = num(raw[[cols[["rental_price_gbp"]]]]),
    stringsAsFactors = FALSE
  )
  if (anyNA(out$date)) {
    cli_abort("Could not read the time period column of the ONS rents workbook.")
  }
  out <- out[order(out$region, out$date), , drop = FALSE]
  rownames(out) <- NULL
  out
}
