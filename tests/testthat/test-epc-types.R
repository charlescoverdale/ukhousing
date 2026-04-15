test_that("ukh_epc_search validates type", {
  old_email <- ukh_env$epc_email
  old_key <- ukh_env$epc_api_key
  on.exit({
    ukh_env$epc_email <- old_email
    ukh_env$epc_api_key <- old_key
  })
  ukh_env$epc_email <- "test@example.com"
  ukh_env$epc_api_key <- "testkey"
  expect_error(ukh_epc_search(type = "residential"))
})

test_that("ukh_epc_certificate validates type", {
  old_email <- ukh_env$epc_email
  old_key <- ukh_env$epc_api_key
  on.exit({
    ukh_env$epc_email <- old_email
    ukh_env$epc_api_key <- old_key
  })
  ukh_env$epc_email <- "test@example.com"
  ukh_env$epc_api_key <- "testkey"
  expect_error(ukh_epc_certificate("abc", type = "residential"))
})

test_that("ukh_epc_bulk type parameter accepted", {
  expect_error(ukh_epc_bulk("E09000033", type = "residential"))
})
