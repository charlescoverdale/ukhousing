test_that("ukh_planning validates dataset arg", {
  expect_error(ukh_planning(dataset = NULL))
  expect_error(ukh_planning(dataset = 123))
  expect_error(ukh_planning(dataset = c("a", "b")))
})

test_that("ukh_planning validates limit", {
  expect_error(ukh_planning("planning-application", limit = 0))
  expect_error(ukh_planning("planning-application", limit = "10"))
})

test_that("ukh_planning live query", {
  skip_on_cran()
  skip_if_offline()
  df <- ukh_planning("brownfield-land", limit = 10)
  expect_s3_class(df, "data.frame")
})

test_that("ukh_planning_datasets returns a data frame", {
  skip_on_cran()
  skip_if_offline()
  df <- ukh_planning_datasets()
  expect_s3_class(df, "data.frame")
  expect_true(nrow(df) > 0)
})
