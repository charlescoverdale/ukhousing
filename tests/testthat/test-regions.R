test_that("ukh_regions returns a data.frame", {
  r <- ukh_regions()
  expect_s3_class(r, "data.frame")
  expect_true(nrow(r) > 20)
  expect_named(r, c("slug", "name", "gss_code", "tier"))
})

test_that("ukh_regions includes the big three countries", {
  r <- ukh_regions(tier = "country")
  expect_true("united-kingdom" %in% r$slug)
  expect_true("england" %in% r$slug)
  expect_true("scotland" %in% r$slug)
  expect_true("wales" %in% r$slug)
})

test_that("ukh_regions filters by tier", {
  regions <- ukh_regions(tier = "region")
  expect_equal(nrow(regions), 9L)  # 9 English ITL1 regions
  expect_true(all(regions$tier == "region"))

  la <- ukh_regions(tier = "la")
  expect_true(nrow(la) > 0)
  expect_true(all(la$tier == "la"))
})

test_that("ukh_regions rejects invalid tier", {
  expect_error(ukh_regions(tier = "invalid"))
})
