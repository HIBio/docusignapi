
<!-- README.md is generated from README.Rmd. Please edit that file -->

# docusignapi <img src="man/figures/logo.png" align="right" height="120" />

<!-- badges: start -->
<!-- badges: end -->

The goal of docusignapi is to connect to docuSign and query the API

## Installation

You can install the development version of docusignapi like so:

``` r
# install.packages("remotes")
remotes::install_github("HIBio/docusignapi")
```

# Prerequisites

You will initially need a docuSign developer account (free). From there,
you can find your `integrator_key`, and create an app secret. Store
these in your `.Renviron` with `usethis::edit_r_environ()`. You will
also need to store the base URL for the environment you are using -
initially, this is the developer sandbox

    docuSign_integrator_key=f123abc8-4e42-1abc-92c9-0e1d233d4567
    docuSign_secret_key=f4f123d4-d5b6-4123-bf42-8492a12345e2
    docuSign_base_url=https://demo.docusign.net/

# Authentication

Running `get_token()` will authenticate via a browser and save the token
as `.docusign_token` in the global environment. This will be used for
all queries.

``` r
library(docusignapi)

get_token()
```

To load a saved token into this object, use `store_token(token)`.

## Example

With the token available, queries can be made to the docuSign API

``` r
me <- get_user()
me$name
#> [1] "Jonathan Carroll"

envelopes <- list_envelopes(me$accounts[[1]]$account_id)
envelopes$envelopes[[1]]$status
#> [1] "sent"
```

Current capabilities:

- `get_user()` - user metadata
- `list_envelopes` - list available envelopes
- `list_envelope_documents` - list available documents within an
  envelope
- `get_envelope_document` - download a document from an envelope (PDF)
