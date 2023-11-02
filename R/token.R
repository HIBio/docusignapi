#' Create or refresh authorization token
#'
#' A copy of the token is stored in `.GlobalEnv` as `.docusign_token`
#' and is searched for when required
#'
#' @return a `httr2_token` to be used for authentication
#' @export
get_token <- function() {
  client <- httr2::oauth_client(
    id = Sys.getenv("docuSign_integrator_key"),
    secret = Sys.getenv("docuSign_secret_key"),
    token_url = "https://account-d.docusign.com/oauth/token",
    name = "docusign",
    auth = "header"
  )

  token <- httr2::oauth_flow_auth_code(client,
                                       auth_url = "https://account-d.docusign.com/oauth/auth",
                                       pkce = FALSE,
                                       port = 16000,
                                       scope = "signature",
                                       token_params = list(grant_type = "authorization_code")
  )
  store_token(token)
  token
}

#' Retrieve the global token
#'
#' @export
global_token <- function() {
  if (exists(".docusign_token", envir = .GlobalEnv)) {
    return(get(".docusign_token", envir = .GlobalEnv))
  }
  stop("No global authentication token found - perhaps you need to run `get_token()`?")
}

#' Store an authentication token as a hidden object
#'
#' @param token `httr2_token` to be saved
#'
#' @return nothing, invisibly
#'
#' @export
store_token <- function(token = NULL) {
  stopifnot("token must be provided" = !is.null(token))
  message("Storing token in .GlobalEnv as .docusign_token")
  assign(".docusign_token", token, envir = .GlobalEnv)
  invisible()
}
