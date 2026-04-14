#' List valid UK HPI region slugs
#'
#' Returns a data frame of common UK HPI region slugs with their names,
#' GSS codes, and tier (country, region, county, or local authority).
#' Useful for looking up the slug to pass to [ukh_hpi()].
#'
#' This is a selection of the most commonly used regions, not an
#' exhaustive list. The UK HPI covers 441+ areas total; any valid slug
#' can be passed to [ukh_hpi()] directly.
#'
#' @param tier Character. Filter by tier: `"all"` (default), `"country"`,
#'   `"region"`, `"county"`, or `"la"`.
#'
#' @return A data frame with columns `slug`, `name`, `gss_code`, and
#'   `tier`.
#'
#' @family helpers
#' @export
#' @examples
#' # All regions
#' head(ukh_regions())
#'
#' # Just the nine English regions
#' ukh_regions(tier = "region")
#'
#' # Country-level series
#' ukh_regions(tier = "country")
ukh_regions <- function(tier = c("all", "country", "region", "county", "la")) {
  tier <- match.arg(tier)
  out <- ukh_regions_data
  if (tier != "all") {
    out <- out[out$tier == tier, , drop = FALSE]
    rownames(out) <- NULL
  }
  out
}

# Built-in region lookup. Countries, English regions, and the most
# commonly referenced LAs. Not exhaustive; users can pass any valid
# UK HPI slug directly to ukh_hpi().
ukh_regions_data <- data.frame(
  slug = c(
    # Countries
    "united-kingdom", "england", "wales", "scotland", "northern-ireland",
    "great-britain",
    # English regions (ITL1)
    "north-east", "north-west", "yorkshire-and-the-humber",
    "east-midlands", "west-midlands", "east-of-england",
    "london", "south-east", "south-west",
    # Major English LAs (cities)
    "city-of-westminster", "city-of-london", "camden", "islington", "hackney",
    "tower-hamlets", "southwark", "lambeth", "wandsworth",
    "kensington-and-chelsea", "hammersmith-and-fulham",
    "birmingham", "manchester", "liverpool", "leeds", "sheffield",
    "bristol-city-of", "newcastle-upon-tyne", "nottingham", "leicester",
    "coventry", "bradford", "wolverhampton", "plymouth",
    "cambridge", "oxford", "brighton-and-hove", "cardiff", "edinburgh",
    "glasgow-city", "belfast"
  ),
  name = c(
    "United Kingdom", "England", "Wales", "Scotland", "Northern Ireland",
    "Great Britain",
    "North East", "North West", "Yorkshire and The Humber",
    "East Midlands", "West Midlands", "East of England",
    "London", "South East", "South West",
    "Westminster", "City of London", "Camden", "Islington", "Hackney",
    "Tower Hamlets", "Southwark", "Lambeth", "Wandsworth",
    "Kensington and Chelsea", "Hammersmith and Fulham",
    "Birmingham", "Manchester", "Liverpool", "Leeds", "Sheffield",
    "Bristol, City of", "Newcastle upon Tyne", "Nottingham", "Leicester",
    "Coventry", "Bradford", "Wolverhampton", "Plymouth",
    "Cambridge", "Oxford", "Brighton and Hove", "Cardiff", "Edinburgh",
    "Glasgow City", "Belfast"
  ),
  gss_code = c(
    "K02000001", "E92000001", "W92000004", "S92000003", "N92000002",
    "K03000001",
    "E12000001", "E12000002", "E12000003",
    "E12000004", "E12000005", "E12000006",
    "E12000007", "E12000008", "E12000009",
    "E09000033", "E09000001", "E09000007", "E09000019", "E09000012",
    "E09000030", "E09000028", "E09000022", "E09000032",
    "E09000020", "E09000013",
    "E08000025", "E08000003", "E08000012", "E08000035", "E08000019",
    "E06000023", "E08000021", "E06000018", "E06000016",
    "E08000026", "E08000032", "E08000031", "E06000026",
    "E07000008", "E07000178", "E06000043", "W06000015", "S12000036",
    "S12000049", "N09000003"
  ),
  tier = c(
    rep("country", 6L),
    rep("region", 9L),
    rep("la", 31L)
  ),
  stringsAsFactors = FALSE
)
