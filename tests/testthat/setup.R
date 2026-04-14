# Redirect cache to a temp dir for all tests so nothing is written to
# the user's home filespace during R CMD check.
options(ukhousing.cache_dir = tempfile("ukhousing_test_cache_"))
