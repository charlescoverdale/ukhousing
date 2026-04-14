test_that("ukh_hpi fetches data for united-kingdom", {
  skip_on_cran()
  skip_if_offline()

  df <- ukh_hpi("united-kingdom", from = "2020-01-01", to = "2020-12-01")
  expect_s3_class(df, "data.frame")
  expect_true(nrow(df) > 0)
  expect_true(all(c("date", "region", "hpi", "avg_price") %in% names(df)))
  expect_true(all(df$region == "united-kingdom"))
})

test_that("ukh_hpi accepts different case", {
  skip_on_cran()
  skip_if_offline()

  d1 <- ukh_hpi("England", from = "2020-01-01", to = "2020-06-01")
  d2 <- ukh_hpi("england", from = "2020-01-01", to = "2020-06-01")
  expect_equal(d1$region[1], "england")
  expect_equal(d2$region[1], "england")
})

test_that("ukh_hpi caches results", {
  skip_on_cran()
  skip_if_offline()

  d1 <- ukh_hpi("england", from = "2020-01-01", to = "2020-03-01")
  d2 <- ukh_hpi("england", from = "2020-01-01", to = "2020-03-01")
  expect_identical(d1, d2)
})

test_that("ukh_hpi_compare merges multiple regions", {
  skip_on_cran()
  skip_if_offline()

  df <- ukh_hpi_compare(
    c("england", "wales"),
    measure = "avg_price",
    from = "2020-01-01", to = "2020-03-01"
  )
  expect_s3_class(df, "data.frame")
  expect_true(all(c("date", "england", "wales") %in% names(df)))
})

test_that("ukh_hpi_compare validates measure", {
  expect_error(ukh_hpi_compare(c("england"), measure = "invalid"))
})

test_that("ukh_hpi_compare validates regions arg", {
  expect_error(ukh_hpi_compare(character(0)))
  expect_error(ukh_hpi_compare(NULL))
})
