# Internal helpers (not exported)

`%||%` <- function(a, b) if (is.null(a)) b else a

# Package-level env for runtime state (API keys, etc.)
ukh_env <- new.env(parent = emptyenv())

# Cache directory (configurable via options(), fallback to R_user_dir)
ukh_cache_dir <- function() {
  d <- getOption("ukhousing.cache_dir", default = tools::R_user_dir("ukhousing", "cache"))
  if (!dir.exists(d)) dir.create(d, recursive = TRUE)
  d
}

# Normalise a region name, GSS code, or slug into the canonical slug
# used by the UK HPI endpoint (lowercase, hyphenated).
ukh_region_slug <- function(region) {
  if (!is.character(region) || length(region) != 1L || is.na(region)) {
    cli_abort("{.arg region} must be a single character string.")
  }
  s <- tolower(trimws(region))
  # Strip any URL/URI wrapping
  s <- sub("^.*/region/", "", s)
  s <- sub("/.*$", "", s)
  # Replace spaces with hyphens
  s <- gsub("[[:space:]]+", "-", s)
  # Remove anything that isn't alphanumeric or hyphen
  s <- gsub("[^a-z0-9-]", "", s)
  if (nchar(s) == 0L) {
    cli_abort("{.arg region} is empty after normalisation.")
  }
  s
}

# Normalise and validate a date range; returns ISO date strings or NULL
ukh_date_range <- function(from = NULL, to = NULL) {
  parse_one <- function(x, name) {
    if (is.null(x)) return(NULL)
    d <- tryCatch(as.Date(x), error = function(e) NA)
    if (is.na(d)) {
      cli_abort("{.arg {name}} must be a date or a character string in ISO format (YYYY-MM-DD).")
    }
    format(d, "%Y-%m-%d")
  }
  list(from = parse_one(from, "from"), to = parse_one(to, "to"))
}

# Build a standard httr2 request with user agent and retry behaviour
ukh_request <- function(url) {
  req <- httr2::request(url)
  req <- httr2::req_user_agent(req, "ukhousing R package (https://github.com/charlescoverdale/ukhousing)")
  req <- httr2::req_retry(
    req,
    max_tries = 3L,
    is_transient = function(resp) httr2::resp_status(resp) %in% c(429L, 503L),
    backoff = ~ min(60, 2 ^ .x)
  )
  req <- httr2::req_throttle(req, rate = 2)
  req
}

# Download a URL to a file (streaming, with retry)
ukh_download <- function(url, dest, progress = TRUE, auth = NULL) {
  req <- ukh_request(url)
  if (!is.null(auth)) {
    req <- httr2::req_auth_basic(req, auth$user, auth$password)
  }
  resp <- tryCatch(
    httr2::req_perform(req, path = dest),
    error = function(e) {
      cli_abort(c(
        "Failed to download {.url {url}}.",
        "x" = conditionMessage(e)
      ))
    }
  )
  status <- httr2::resp_status(resp)
  if (status >= 400L) {
    cli_abort("Download failed with HTTP {status}: {.url {url}}")
  }
  dest
}

# Format bytes as human-readable string
format_bytes <- function(x) {
  if (is.na(x) || x < 1024) return(paste0(x, " B"))
  units <- c("KB", "MB", "GB", "TB")
  for (i in seq_along(units)) {
    x <- x / 1024
    if (x < 1024 || i == length(units)) {
      return(sprintf("%.1f %s", x, units[i]))
    }
  }
}

# Convert a list of parsed JSON records to a data.frame. Coerces all
# values to character to avoid rbind class-mismatch errors when
# different records have different types for the same field.
ukh_list_to_df <- function(items) {
  if (length(items) == 0L) return(data.frame())
  cols <- unique(unlist(lapply(items, names)))
  cols_data <- lapply(cols, function(col) {
    vals <- lapply(items, function(item) {
      v <- item[[col]]
      if (is.null(v) || length(v) == 0L) return(NA_character_)
      if (is.list(v)) return(paste(unlist(v), collapse = ";"))
      if (length(v) > 1L) return(paste(as.character(v), collapse = ";"))
      as.character(v)
    })
    unlist(vals, use.names = FALSE)
  })
  names(cols_data) <- cols
  as.data.frame(cols_data, stringsAsFactors = FALSE)
}
