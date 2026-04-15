test_that("ukh_pipr live fetch works", {
  skip_on_cran()
  skip_if_offline()
  df <- ukh_pipr()
  expect_s3_class(df, "data.frame")
  expect_true(all(c("date", "region", "index") %in% names(df)))
})
