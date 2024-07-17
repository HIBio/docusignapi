#' Get a user's metadata
#'
#' @param token authorization token, a `httr2_token`, generated with `get_token()`
#' @param demo use the developer demo sandbox?
#' @param overwrite_account_id store a new account id?
#'
#' @return a parsed JSON structure
#'
#' @export
get_user <- function(
    token = global_token(),
    demo = Sys.getenv("docuSign_demo"),
    overwrite_account_id = FALSE
) {
  domain = ifelse(demo, "account-d", "account")
  base_url <- paste0("https://", domain, ".docusign.com/")
  req <- base_query(token = token,
                    base_url = base_url,
                    "oauth", "userinfo")
  resp <- httr2::resp_body_json(httr2::req_perform(req))
  if (Sys.getenv("docuSign_account_id") == "") store_account_id(resp$accounts[[1]]$account_id)
  resp
}

#' Get Account ID
#'
#' @param token authorization token, a `httr2_token`, generated with `get_token()`
#' @param demo use the developer demo sandbox?
#'
#' @returns account id
#' @export
get_account_id <- function(token = global_token(),
                           demo = Sys.getenv("docuSign_demo")) {
  aid <- Sys.getenv("docuSign_account_id")
  if (!is.null(aid) && aid != "") return(aid)
  aid <- get_user(token = token, demo = demo)$accounts[[1]]$account_id
  store_account_id(aid)
  aid
}

#' Store account id
#'
#' @param aid account id
#' @param overwrite overwrite an existing id?
#'
#' @return nothing
#' @export
store_account_id <- function(aid, overwrite = FALSE) {
  existing_aid <- Sys.getenv("docuSign_account_id")
  if (!is.null(existing_aid) && existing_aid != "" && existing_aid != aid) {
    if (overwrite) {
      Sys.setenv(docuSign_account_id = aid)
    } else {
      stop("Existing docuSign_account_id detected. Maybe set overwrite=TRUE?")
    }
  } else {
    Sys.setenv(docuSign_account_id = aid)
  }
  invisible()
}
