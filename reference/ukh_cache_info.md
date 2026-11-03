# Inspect the local ukhousing cache

Returns information about the local cache: where it lives, how many
files it contains, and how much disk space they take. Useful when
debugging stale results or deciding whether to call
[`ukh_clear_cache()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_clear_cache.md).

## Usage

``` r
ukh_cache_info()
```

## Value

A list with elements `dir`, `n_files`, `size_bytes`, `size_human`, and
`files` (a data frame).

## See also

Other configuration:
[`ukh_clear_cache()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_clear_cache.md)

## Examples

``` r
# \donttest{
op <- options(ukhousing.cache_dir = tempdir())
try({
  ukh_cache_info()
})
#> $dir
#> [1] "/tmp/RtmpvSBJid"
#> 
#> $n_files
#> [1] 2
#> 
#> $size_bytes
#> [1] 8192
#> 
#> $size_human
#> [1] "8.0 KB"
#> 
#> $files
#>                                     name size_bytes            modified
#> 1 bslib-7db53ff92ec092c0dbca0588320fd109       4096 2026-11-03 08:39:36
#> 2                                downlit       4096 2026-11-03 08:39:38
#> 
options(op)
# }
```
