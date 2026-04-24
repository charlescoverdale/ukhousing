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
[`ukh_clear_cache()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_clear_cache.md),
[`ukh_epc_set_key()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_epc_set_key.md)

## Examples

``` r
# \donttest{
op <- options(ukhousing.cache_dir = tempdir())
ukh_cache_info()
#> $dir
#> [1] "/tmp/RtmpbOUQAH"
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
#> 1 bslib-246362e7e3ff6191071d5f9b40ba8d62       4096 2026-04-24 08:18:11
#> 2                                downlit       4096 2026-04-24 08:18:13
#> 
options(op)
# }
```
