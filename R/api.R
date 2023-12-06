#' Get Base URL for queries
#'
#' @return base URL from environment
#' @export
get_base_url <- function() {
  Sys.getenv("docuSign_base_url")
}

#' Base query to docusign
#'
#' @param token authorization token, a `httr2_token`, generated with `get_token()`
#' @param base_url base URL for queries
#' @param ... additional paths to append via `req_url_path_append()`
#'
#' @return the JSON response from the query
#' @export
base_query <- function(token = global_token(), base_url = get_base_url(),...) {
  httr2::request(base_url) %>%
    httr2::req_url_path_append(...) %>%
    httr2::req_auth_bearer_token(token$access_token)
}
