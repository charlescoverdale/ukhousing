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
[`ukh_cache_info()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_cache_info.md)

## Examples

``` r
# \donttest{
op <- options(ukhousing.cache_dir = tempdir())
try({
  ukh_clear_cache()
})
#> Removed 2 cached files from /tmp/RtmpvSBJid.
options(op)
# }
```
