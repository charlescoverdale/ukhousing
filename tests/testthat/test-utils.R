test_that("ukh_region_slug normalises names", {
  expect_equal(ukh_region_slug("Westminster"), "westminster")
  expect_equal(ukh_region_slug("City of London"), "city-of-london")
  expect_equal(ukh_region_slug("  LONDON  "), "london")
  expect_equal(ukh_region_slug("newcastle-upon-tyne"), "newcastle-upon-tyne")
})

test_that("ukh_region_slug strips URL wrapping", {
  expect_equal(
    ukh_region_slug("http://landregistry.data.gov.uk/id/region/westminster"),
    "westminster"
  )
  expect_equal(
    ukh_region_slug("http://landregistry.data.gov.uk/id/region/westminster/"),
    "westminster"
  )
})

test_that("ukh_region_slug rejects invalid input", {
  expect_error(ukh_region_slug(""))
  expect_error(ukh_region_slug(NA_character_))
  expect_error(ukh_region_slug(123))
  expect_error(ukh_region_slug(c("london", "manchester")))
})

test_that("ukh_date_range parses dates", {
  dr <- ukh_date_range("2020-01-01", "2020-12-31")
  expect_equal(dr$from, "2020-01-01")
  expect_equal(dr$to, "2020-12-31")

  dr <- ukh_date_range(as.Date("2020-01-01"), as.Date("2020-12-31"))
  expect_equal(dr$from, "2020-01-01")
})

test_that("ukh_date_range accepts NULL", {
  dr <- ukh_date_range(NULL, NULL)
  expect_null(dr$from)
  expect_null(dr$to)
})

test_that("ukh_date_range rejects invalid dates", {
  expect_error(ukh_date_range("not-a-date"))
})

test_that("format_bytes handles common sizes", {
  expect_equal(format_bytes(500), "500 B")
  expect_equal(format_bytes(1500), "1.5 KB")
  expect_equal(format_bytes(1.5e6), "1.4 MB")
  expect_equal(format_bytes(1.5e9), "1.4 GB")
})

test_that("ukh_list_to_df handles empty input", {
  expect_equal(nrow(ukh_list_to_df(list())), 0)
})

test_that("ukh_list_to_df handles heterogeneous records", {
  items <- list(
    list(a = 1, b = "x"),
    list(a = 2, c = "y")
  )
  df <- ukh_list_to_df(items)
  expect_equal(nrow(df), 2L)
  expect_true(all(c("a", "b", "c") %in% names(df)))
})

test_that("ukh_cache_dir creates directory", {
  op <- options(ukhousing.cache_dir = tempfile("ukh_cache_"))
  on.exit(options(op))
  d <- ukh_cache_dir()
  expect_true(dir.exists(d))
})
