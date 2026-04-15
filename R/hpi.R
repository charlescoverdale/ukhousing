#' UK House Price Index
#'
#' Fetches monthly UK House Price Index data for a region from the HM
#' Land Registry linked data service. Coverage: 441+ areas (countries,
#' regions, counties, local authorities) from January 1995 (England and
#' Wales), January 2004 (Scotland), January 2005 (Northern Ireland).
#'
#' The returned data frame includes the headline index, average price,
#' monthly and annual percentage change, sales volume, and breakdowns
#' by property type (detached, semi-detached, terraced, flat) and by
#' buyer type (cash, mortgage, first-time buyer, former owner occupier,
#' new build, existing property).
#'
#' Sales volumes lag the headline index by approximately five months
#' because the Land Registry needs the full transaction set to settle.
#'
#' @param region Character. Region slug, GSS code, or common name (e.g.
#'   `"westminster"`, `"Westminster"`, `"E09000033"`). See [ukh_regions()]
#'   for common options.
#' @param from,to Optional character or Date. Start and end dates in
#'   ISO format (YYYY-MM-DD). Default returns the full available
#'   history.
#' @param refresh Logical. Re-download even if cached? Default `FALSE`.
#'
#' @return A data frame with one row per month. Columns include `date`,
#'   `region`, `hpi`, `avg_price`, `pct_change_monthly`,
#'   `pct_change_annual`, `sales_volume`, plus property-type and
#'   buyer-type average prices.
#'
#' @family house price index
#' @export
#' @examples
#' \donttest{
#' op <- options(ukhousing.cache_dir = tempdir())
#'
#' # All UK average house prices
#' uk <- ukh_hpi("united-kingdom")
#' head(uk)
#'
#' # London, last 10 years
#' london <- ukh_hpi("london", from = "2016-01-01")
#' tail(london)
#'
#' options(op)
#' }
ukh_hpi <- function(region, from = NULL, to = NULL, refresh = FALSE) {
  slug <- ukh_region_slug(region)
  dr <- ukh_date_range(from, to)

  cache_key <- paste0(
    "hpi_", slug,
    if (!is.null(dr$from)) paste0("_from_", dr$from) else "",
    if (!is.null(dr$to)) paste0("_to_", dr$to) else "",
    ".csv"
  )
  cache_path <- file.path(ukh_cache_dir(), cache_key)

  if (!file.exists(cache_path) || refresh) {
    cli_inform(c("i" = "Downloading UK HPI for {.val {slug}}..."))
    url <- .hpi_csv_url(slug, dr$from, dr$to)
    ukh_download(url, cache_path)
  } else {
    cli_inform(c("i" = "Loading from cache. Use {.code refresh = TRUE} to re-download."))
  }

  raw <- utils::read.csv(cache_path, stringsAsFactors = FALSE, check.names = FALSE)
  if (nrow(raw) == 0L) {
    cli_warn(c(
      "!" = "UK HPI returned no data for region {.val {slug}}.",
      "i" = "Check the slug is valid. See {.fn ukh_regions} for common slugs.",
      "i" = "Try {.val city-of-westminster} (not {.val westminster})."
    ))
    return(data.frame(date = as.Date(character(0)), region = character(0),
                      stringsAsFactors = FALSE))
  }
  .hpi_tidy(raw, slug)
}

#' Compare UK HPI across multiple regions
#'
#' Fetches the UK House Price Index for several regions and returns a
#' wide data frame with one measure (e.g. average price or annual %
#' change) as a column per region. Useful for regional comparison charts.
#'
#' @param regions Character vector of region slugs, GSS codes, or names.
#' @param measure Character. Which measure to return. One of
#'   `"avg_price"`, `"hpi"`, `"pct_change_annual"`, `"pct_change_monthly"`,
#'   or `"sales_volume"`. Default `"avg_price"`.
#' @param from,to Optional character or Date. Date range.
#' @param refresh Logical. Re-download even if cached? Default `FALSE`.
#'
#' @return A wide data frame with a `date` column and one column per
#'   region.
#'
#' @family house price index
#' @export
#' @examples
#' \donttest{
#' op <- options(ukhousing.cache_dir = tempdir())
#'
#' prices <- ukh_hpi_compare(
#'   c("london", "manchester", "newcastle-upon-tyne"),
#'   measure = "avg_price",
#'   from = "2015-01-01"
#' )
#' head(prices)
#'
#' options(op)
#' }
ukh_hpi_compare <- function(regions, measure = "avg_price",
                           from = NULL, to = NULL, refresh = FALSE) {
  if (!is.character(regions) || length(regions) < 1L) {
    cli_abort("{.arg regions} must be a non-empty character vector.")
  }
  valid <- c("avg_price", "hpi", "pct_change_annual",
             "pct_change_monthly", "sales_volume")
  if (!measure %in% valid) {
    cli_abort("{.arg measure} must be one of {.val {valid}}.")
  }

  results <- lapply(regions, function(r) {
    df <- ukh_hpi(r, from = from, to = to, refresh = refresh)
    data.frame(date = df$date, value = df[[measure]], stringsAsFactors = FALSE)
  })

  # Merge on date
  out <- results[[1L]]
  names(out)[2L] <- ukh_region_slug(regions[1L])
  for (i in seq_along(regions)[-1L]) {
    r <- results[[i]]
    names(r)[2L] <- ukh_region_slug(regions[i])
    out <- merge(out, r, by = "date", all = TRUE)
  }
  out[order(out$date), , drop = FALSE]
}

#' @noRd
.hpi_csv_url <- function(slug, from = NULL, to = NULL) {
  loc <- paste0("http://landregistry.data.gov.uk/id/region/", slug)
  params <- list(location = loc)
  if (!is.null(from)) params$from <- from
  if (!is.null(to))   params$to <- to
  q <- paste(paste0(names(params), "=", vapply(params, utils::URLencode, character(1), reserved = TRUE)),
             collapse = "&")
  paste0("https://landregistry.data.gov.uk/app/ukhpi/download/new.csv?", q)
}

#' @noRd
.hpi_tidy <- function(raw, slug) {
  # The download CSV has mixed column names across publications.
  # We standardise the subset we care about.
  n <- names(raw)

  pick <- function(patterns) {
    for (p in patterns) {
      hit <- n[tolower(n) == tolower(p)]
      if (length(hit) > 0L) return(hit[1L])
      hit <- n[grepl(p, n, ignore.case = TRUE)]
      if (length(hit) > 0L) return(hit[1L])
    }
    NA_character_
  }

  get_col <- function(df, patterns) {
    col <- pick(patterns)
    if (is.na(col)) return(rep(NA_real_, nrow(df)))
    v <- df[[col]]
    if (is.character(v)) suppressWarnings(as.numeric(v)) else as.numeric(v)
  }

  date_col <- pick(c("Date", "^Period$", "Month", "RefMonth"))
  if (is.na(date_col)) {
    cli_abort("Could not find a date column in the UK HPI response.")
  }

  date_vals <- .parse_hpi_date(raw[[date_col]])

  data.frame(
    date = date_vals,
    region = slug,
    hpi = get_col(raw, c("House price index", "HousePriceIndex", "^HPI$")),
    avg_price = get_col(raw, c("Average price$", "Average price All property",
                               "AveragePrice")),
    pct_change_monthly = get_col(raw, c("Monthly change", "PercentageChange",
                                        "% change monthly")),
    pct_change_annual = get_col(raw, c("Annual change", "PercentageAnnualChange",
                                       "% change annual")),
    sales_volume = get_col(raw, c("Sales volume", "SalesVolume")),
    avg_price_detached = get_col(raw, c("Average price Detached",
                                        "AveragePriceDetached")),
    avg_price_semi = get_col(raw, c("Average price Semi-Detached",
                                    "AveragePriceSemiDetached")),
    avg_price_terraced = get_col(raw, c("Average price Terraced",
                                        "AveragePriceTerraced")),
    avg_price_flat = get_col(raw, c("Average price Flat",
                                    "AveragePriceFlat")),
    avg_price_cash = get_col(raw, c("Average price Cash",
                                    "AveragePriceCash")),
    avg_price_mortgage = get_col(raw, c("Average price Mortgage",
                                        "AveragePriceMortgage")),
    avg_price_new_build = get_col(raw, c("Average price New build",
                                         "AveragePriceNewBuild")),
    avg_price_existing = get_col(raw, c("Average price Existing",
                                        "AveragePriceExistingProperty")),
    avg_price_first_time_buyer = get_col(raw, c("Average price First time buyer",
                                                "AveragePriceFirstTimeBuyer")),
    avg_price_former_owner = get_col(raw, c("Average price Former owner",
                                            "AveragePriceFormerOwnerOccupier")),
    stringsAsFactors = FALSE
  )
}

#' @noRd
.parse_hpi_date <- function(x) {
  x <- as.character(x)
  try_fmt <- function(input, format = NULL) {
    tryCatch({
      d <- if (is.null(format)) as.Date(input) else as.Date(input, format = format)
      if (!all(is.na(d))) d else NULL
    }, error = function(e) NULL)
  }

  d <- try_fmt(x)
  if (!is.null(d)) return(d)
  d <- try_fmt(paste0(x, "-01"))
  if (!is.null(d)) return(d)
  for (fmt in c("%d/%m/%Y", "%m/%d/%Y", "%Y/%m/%d")) {
    d <- try_fmt(x, format = fmt)
    if (!is.null(d)) return(d)
  }
  for (fmt in c("%b %Y", "%B %Y")) {
    d <- try_fmt(paste("01", x), format = paste("%d", fmt))
    if (!is.null(d)) return(d)
  }
  cli_abort("Could not parse date column in UK HPI response (first value: {.val {x[1L]}}).")
}

#' Transaction volumes for a region
#'
#' Returns monthly residential transaction counts for a UK region.
#' This is a thin wrapper over [ukh_hpi()] that extracts the
#' `sales_volume` column with its date. Transaction volumes lag the
#' headline index by approximately five months because the Land
#' Registry needs the full transaction set to settle.
#'
#' @param region Character. Region slug, GSS code, or common name.
#' @param from,to Optional. Date range (YYYY-MM-DD).
#' @param refresh Logical. Re-download? Default `FALSE`.
#'
#' @return A data frame with `date`, `region`, and `sales_volume`.
#'
#' @family house price index
#' @export
#' @examples
#' \donttest{
#' op <- options(ukhousing.cache_dir = tempdir())
#' tx <- ukh_transactions("england", from = "2020-01-01")
#' head(tx)
#' options(op)
#' }
ukh_transactions <- function(region, from = NULL, to = NULL, refresh = FALSE) {
  df <- ukh_hpi(region, from = from, to = to, refresh = refresh)
  df[, c("date", "region", "sales_volume"), drop = FALSE]
}
