test_that("ukh_pipr live fetch is current and complete", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("readxl")
  df <- ukh_pipr()
  expect_s3_class(df, "data.frame")
  expect_named(df, c("date", "gss_code", "region", "parent_region", "index",
                     "monthly_change_pct", "annual_change_pct",
                     "rental_price_gbp"))
  uk <- df[df$region == "United Kingdom", ]
  expect_gt(nrow(uk), 100L)
  # The Beta API copy of this series stopped at January 2024. A source
  # that silently stops updating should fail here, not pass.
  expect_gt(max(uk$date), Sys.Date() - 150)
  expect_true(all(uk$rental_price_gbp > 0, na.rm = TRUE))
})

test_that(".pipr_tidy drops ONS markers and converts Excel dates", {
  raw <- data.frame(
    "Time period" = c("42005", "45901"),
    "Area code" = c("K02000001", "E09000001"),
    "Area name" = c("United Kingdom", "City of London"),
    "Region or country name" = c("[z]", "London"),
    "Index" = c("81.2", "130.1"),
    "Monthly change" = c("[x]", "0.4"),
    "Annual change" = c("[x]", "3.1"),
    "Rental price" = c("700", "2500"),
    check.names = FALSE, stringsAsFactors = FALSE
  )
  out <- .pipr_tidy(raw)
  expect_equal(out$date[out$region == "United Kingdom"], as.Date("2015-01-01"))
  expect_equal(out$date[out$region == "City of London"], as.Date("2025-09-01"))
  expect_true(is.na(out$monthly_change_pct[out$region == "United Kingdom"]))
  expect_true(is.na(out$parent_region[out$region == "United Kingdom"]))
  expect_equal(out$parent_region[out$region == "City of London"], "London")
  expect_error(.pipr_tidy(raw, "one bed"), "Missing column")
})

test_that("ukh_pipr rejects an unknown property type", {
  expect_error(ukh_pipr(property = "castle"))
})
