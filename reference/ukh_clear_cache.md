# Clear the ukhousing cache

Deletes all locally cached UK housing data files. The next call to any
data function will re-download fresh data.

## Usage

``` r
ukh_clear_cache()
```

## Value

Invisibly returns `NULL`.

## See also

Other configuration:
[`ukh_cache_info()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_cache_info.md),
[`ukh_epc_set_key()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_set_key.md)

## Examples

``` r
# \donttest{
op <- options(ukhousing.cache_dir = tempdir())
ukh_clear_cache()
#> Removed 2 cached files from /tmp/RtmpbOUQAH.
options(op)
# }
```
