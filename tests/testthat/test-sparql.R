test_that("ukh_sparql rejects invalid query", {
  expect_error(ukh_sparql(""))
  expect_error(ukh_sparql(NULL))
  expect_error(ukh_sparql(c("a", "b")))
  expect_error(ukh_sparql(123))
})

test_that("ukh_sparql accepts a full URL endpoint", {
  skip_on_cran()
  skip_if_offline()
  # Trivial query against Land Registry
  q <- "ASK { ?s ?p ?o }"
  expect_error(ukh_sparql(q, endpoint = "http://not-a-real-endpoint.example/sparql"))
})

test_that("ukh_sparql returns a data frame for a simple query", {
  skip_on_cran()
  skip_if_offline()
  q <- 'PREFIX ukhpi: <http://landregistry.data.gov.uk/def/ukhpi/>
        SELECT ?hpi ?avg WHERE {
          <http://landregistry.data.gov.uk/data/ukhpi/region/united-kingdom/month/2020-01>
            ukhpi:housePriceIndex ?hpi ;
            ukhpi:averagePrice ?avg .
        } LIMIT 1'
  df <- ukh_sparql(q)
  expect_s3_class(df, "data.frame")
})
