# Set EPC API credentials

Stores the email and API key used to authenticate requests to the MHCLG
Energy Performance Certificate Open Data service. Credentials persist
for the current R session. Alternatively, set the `EPC_EMAIL` and
`EPC_API_KEY` environment variables in your `.Renviron` file.

## Usage

``` r
ukh_epc_set_key(email, key)
```

## Arguments

- email:

  Character. The email you registered with.

- key:

  Character. The API key.

## Value

Invisible `NULL`.

## Details

Register for a free API key at <https://epc.opendatacommunities.org/>.

## See also

Other configuration:
[`ukh_cache_info()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_cache_info.md),
[`ukh_clear_cache()`](https://charlescoverdale.github.io/ukhousing/reference/ukh_clear_cache.md)

## Examples

``` r
if (FALSE) { # \dontrun{
ukh_epc_set_key("you@example.com", "your_api_key_here")
} # }
```
