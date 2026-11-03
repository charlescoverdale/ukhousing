test_that("EPC functions are defunct and point to the new service", {
  fns <- list(ukh_epc_set_key, ukh_epc_search, ukh_epc_certificate,
              ukh_epc_summary, ukh_epc_bulk, ukh_epc_recommendations_summary)
  for (f in fns) {
    expect_error(f(), "defunct")
    expect_error(f("E09000033", type = "domestic"), "get-energy-performance-data")
  }
})
