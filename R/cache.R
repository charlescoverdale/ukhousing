#' Clear the ukhousing cache
#'
#' Deletes all locally cached UK housing data files. The next call to
#' any data function will re-download fresh data.
#'
#' @return Invisibly returns `NULL`.
#'
#' @family configuration
#' @export
#' @examples
#' \donttest{
#' op <- options(ukhousing.cache_dir = tempdir())
#' ukh_clear_cache()
#' options(op)
#' }
ukh_clear_cache <- function() {
  d <- ukh_cache_dir()
  files <- list.files(d, full.names = TRUE)
  n <- length(files)
  if (n > 0L) {
    unlink(files, recursive = TRUE)
  }
  cli_inform("Removed {n} cached file{?s} from {.path {d}}.")
  invisible(NULL)
}

#' Inspect the local ukhousing cache
#'
#' Returns information about the local cache: where it lives, how many
#' files it contains, and how much disk space they take. Useful when
#' debugging stale results or deciding whether to call [ukh_clear_cache()].
#'
#' @return A list with elements `dir`, `n_files`, `size_bytes`,
#'   `size_human`, and `files` (a data frame).
#'
#' @family configuration
#' @export
#' @examples
#' \donttest{
#' op <- options(ukhousing.cache_dir = tempdir())
#' ukh_cache_info()
#' options(op)
#' }
ukh_cache_info <- function() {
  d <- ukh_cache_dir()
  empty_files <- data.frame(
    name = character(0L),
    size_bytes = numeric(0L),
    modified = as.POSIXct(character(0L)),
    stringsAsFactors = FALSE
  )
  paths <- list.files(d, full.names = TRUE)
  if (length(paths) == 0L) {
    return(list(dir = d, n_files = 0L, size_bytes = 0,
                size_human = "0 B", files = empty_files))
  }
  info <- file.info(paths)
  files <- data.frame(
    name = basename(paths),
    size_bytes = info$size,
    modified = info$mtime,
    stringsAsFactors = FALSE
  )
  files <- files[order(-files$size_bytes), , drop = FALSE]
  rownames(files) <- NULL
  total <- sum(files$size_bytes)
  list(dir = d, n_files = nrow(files), size_bytes = total,
       size_human = format_bytes(total), files = files)
}
