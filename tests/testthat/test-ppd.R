test_that(".ppd_type_code maps names to letters", {
  expect_equal(.ppd_type_code("detached"), "D")
  expect_equal(.ppd_type_code("flat"), "F")
  expect_equal(.ppd_type_code("D"), "D")
  expect_equal(.ppd_type_code("FLAT"), "F")
})

test_that(".ppd_type_code rejects unknown types", {
  expect_error(.ppd_type_code("bungalow"))
  expect_error(.ppd_type_code(""))
})

test_that(".ppd_type_label maps letters back to names", {
  expect_equal(.ppd_type_label("D"), "detached")
  expect_equal(.ppd_type_label("F"), "flat")
  expect_equal(.ppd_type_label(c("D", "S", "T", "F", "O")),
               c("detached", "semi", "terraced", "flat", "other"))
})

test_that("ukh_ppd rejects invalid year", {
  expect_error(ukh_ppd(1900))
  expect_error(ukh_ppd(3000))
  expect_error(ukh_ppd("2024"))
  expect_error(ukh_ppd(c(2020, 2021)))
})

test_that("ukh_ppd_bulk builds the expected filename", {
  op <- options(ukhousing.cache_dir = tempfile("ukh_cache_"))
  on.exit(options(op))
  # Do not actually download; test URL construction by checking
  # the cache path that would be produced.
  dir.create(getOption("ukhousing.cache_dir"), recursive = TRUE)
  fake <- file.path(getOption("ukhousing.cache_dir"), "pp-2024.csv")
  file.create(fake)
  expect_equal(normalizePath(ukh_ppd_bulk(2024)), normalizePath(fake))
})

test_that(".summarise_by computes stats per group", {
  price <- c(100, 200, 300, 400, 500)
  key <- c("A", "A", "B", "B", "B")
  out <- .summarise_by(price, key, "grp")
  expect_equal(out$n, c(2L, 3L))
  expect_equal(out$median_price, c(150, 400))
  expect_equal(out$mean_price, c(150, 400))
  expect_equal(out$total_value, c(300, 1200))
  expect_equal(names(out)[1], "grp")
})

test_that("ukh_ppd live fetch and filter works", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not(nzchar(Sys.getenv("UKHOUSING_LIVE_TESTS")),
              "Set UKHOUSING_LIVE_TESTS=1 to run live PPD tests (150MB download).")
  df <- ukh_ppd(2024, la = "Westminster", property_type = "flat")
  expect_s3_class(df, "data.frame")
  expect_true(nrow(df) > 0)
  expect_true(all(toupper(df$district) == "WESTMINSTER"))
})
