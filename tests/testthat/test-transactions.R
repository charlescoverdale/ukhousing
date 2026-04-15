test_that("ukh_transactions returns expected columns", {
  skip_on_cran()
  skip_if_offline()
  df <- ukh_transactions("england", from = "2020-01-01", to = "2020-06-01")
  expect_s3_class(df, "data.frame")
  expect_named(df, c("date", "region", "sales_volume"))
})
