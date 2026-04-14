test_that("ukh_epc_set_key validates inputs", {
  expect_error(ukh_epc_set_key("", "key"))
  expect_error(ukh_epc_set_key("email", ""))
  expect_error(ukh_epc_set_key(NULL, "key"))
  expect_error(ukh_epc_set_key(c("a", "b"), "key"))
})

test_that("ukh_epc_set_key stores credentials", {
  old_email <- ukh_env$epc_email
  old_key <- ukh_env$epc_api_key
  on.exit({
    ukh_env$epc_email <- old_email
    ukh_env$epc_api_key <- old_key
  })
  ukh_epc_set_key("test@example.com", "testkey123")
  expect_equal(ukh_env$epc_email, "test@example.com")
  expect_equal(ukh_env$epc_api_key, "testkey123")
})

test_that(".epc_auth fails without credentials", {
  old_email <- ukh_env$epc_email
  old_key <- ukh_env$epc_api_key
  old_email_env <- Sys.getenv("EPC_EMAIL")
  old_key_env <- Sys.getenv("EPC_API_KEY")
  on.exit({
    ukh_env$epc_email <- old_email
    ukh_env$epc_api_key <- old_key
    Sys.setenv(EPC_EMAIL = old_email_env)
    Sys.setenv(EPC_API_KEY = old_key_env)
  })
  ukh_env$epc_email <- NULL
  ukh_env$epc_api_key <- NULL
  Sys.setenv(EPC_EMAIL = "")
  Sys.setenv(EPC_API_KEY = "")
  expect_error(.epc_auth(), "credentials")
})

test_that("ukh_epc_search validates size", {
  old_email <- ukh_env$epc_email
  old_key <- ukh_env$epc_api_key
  on.exit({
    ukh_env$epc_email <- old_email
    ukh_env$epc_api_key <- old_key
  })
  ukh_env$epc_email <- "test@example.com"
  ukh_env$epc_api_key <- "testkey"
  expect_error(ukh_epc_search(size = 0))
  expect_error(ukh_epc_search(size = 99999))
})

test_that("ukh_epc_search live query", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not(nzchar(Sys.getenv("EPC_EMAIL")) && nzchar(Sys.getenv("EPC_API_KEY")),
              "Set EPC_EMAIL and EPC_API_KEY to run live EPC tests.")
  df <- ukh_epc_search(postcode = "SW1A 1AA", size = 10, max_records = 10)
  expect_s3_class(df, "data.frame")
})
