test_that("ukh_ppd_transaction rejects invalid input", {
  expect_error(ukh_ppd_transaction(""))
  expect_error(ukh_ppd_transaction(NULL))
  expect_error(ukh_ppd_transaction(c("a", "b")))
})

test_that("ukh_ppd_address rejects invalid input", {
  expect_error(ukh_ppd_address(""))
  expect_error(ukh_ppd_address(NULL))
})

test_that("ukh_ppd_years rejects invalid input", {
  expect_error(ukh_ppd_years(character(0)))
  expect_error(ukh_ppd_years(integer(0)))
})
