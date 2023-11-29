
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
    docuSign_dmeo=TRUE

The secret can be created in settings for the developer account, where
you will also need to set the redirect URI to
“<https://localhost:16000>”.

# Authentication

Running `get_token()` will authenticate via a browser and save the token
as `.docusign_token` in the global environment. This will be used for
all queries.

``` r
library(docusignapi)

get_token()
```

To load a saved token into this object, use `store_token(token)`.

# Example

With the token available, queries can be made to the docuSign API

``` r
me <- get_user()
me$name
#> [1] "Service Account"

envelopes <- list_envelopes(me$accounts[[1]]$account_id)
envelopes$envelopes[[1]]$status
#> [1] "completed"

folders <- list_folders(me$accounts[[1]]$account_id)
sapply(folders$folders, \(x) x$name)
#> [1] "Draft"         "Inbox"         "Deleted Items" "Sent Items"
```

Current capabilities:

- `get_user` - user metadata
- `list_envelopes` - list available envelopes
- `list_envelope_custom_fields` - list custom fields on an envelope
- `list_documents` - list available documents within an envelope
- `list_document_fields` - list available fields on a document
- `get_document` - download a document from an envelope (PDF)
- `list_folders` - list available folders
- `list_folder_contents` - list content of a folder

# Promoting to Production

In order to promote the app to a production account you will need to
satisfy the go-live requirements, which includes performing 20
successful API calls which do not violate the docuSign terms, including
polling (requesting the same envelope more than once in a 15 minute
window). In order to accomplish this, I suggest creating two envelopes
in the developer sandbox, then performing the following queries two
times, separated by 20 minutes. Store the names of the uploaded files in
the variables below

``` r
file_1_name <- "nameoffirstfile.pdf"
file_2_name <- "nameofsecondfile.pdf" 

library(docusignapi)
get_token()
me <- get_user()
envelopes <- list_envelopes(me$accounts[[1]]$account_id)
list_envelope_custom_fields(me$accounts[[1]]$account_id, envelopes$envelopes[[1]]$envelopeId)
list_document_fields(me$accounts[[1]]$account_id, envelopes$envelopes[[1]]$envelopeId, 1)
list_document_fields(me$accounts[[1]]$account_id, envelopes$envelopes[[2]]$envelopeId, 1)
list_documents(me$accounts[[1]]$account_id, envelopes$envelopes[[1]]$envelopeId)
list_documents(me$accounts[[1]]$account_id, envelopes$envelopes[[2]]$envelopeId)
get_document(me$accounts[[1]]$account_id, envelopes$envelopes[[1]]$envelopeId, 1, file_1_name)
get_document(me$accounts[[1]]$account_id, envelopes$envelopes[[2]]$envelopeId, 1, file_2_name)
folders <- list_folders(me$accounts[[1]]$account_id)
sapply(folders$folders, \(x) x$name)
list_folder_contents(me$accounts[[1]]$account_id, folders$folders[[1]]$folderId)
```

Once that is successful, the app can be sent for go-live review. On
success, it can be promoted to a production account, at which point you
will need to set a redirect URI and create a new secret to be stored in
your .Rprofile. Set `docuSign_demo=FALSE` to use the production API.
