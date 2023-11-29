#' Get a user's metadata
#'
#' @param token a `httr2_token` for authentication
#' @param base_url base URL for the query
#'
#' @return a parsed JSON structure
#'
#' @export
get_user <- function(
    token = global_token(),
    demo = Sys.getenv("docuSign_demo")
) {
  domain = ifelse(demo, "account-d", "account")
  base_url <- paste0("https://", domain, ".docusign.com/")
  req <- base_query(token = token, base_url = base_url, "oauth", "userinfo")
  httr2::resp_body_json(httr2::req_perform(req))
}

#' List envelopes
#'
#' @param account_id account id
#' @param from_date earliest date to be searched
#' @param token a `httr2_token` for authentication
#' @param base_url base URL for the query
#'
#' Use `get_user()` to identify the relevant `account_id`
#'
#' @return a parsed JSON structure
#'
#' @export
list_envelopes <- function(
    account_id = NULL,
    from_date = "2020-01-01",
    token = global_token(),
    base_url = get_base_url()
) {
  stopifnot("account_id must not be missing" = !is.null(account_id),
            "from_date must not be missing" = !is.null(from_date))
  req <- base_query(token = token, base_url = base_url,
             "restapi", "v2.1", "accounts", account_id, "envelopes") %>%
    httr2::req_url_query(from_date = from_date)
  httr2::resp_body_json(httr2::req_perform(req))
}

#' List Envelope Documents
#'
#' @param account_id account id
#' @param envelope_id envelope for which documents should be listed
#' @param token a `httr2_token` for authentication
#' @param base_url base URL for the query
#'
#' @return a parsed JSON structure
#'
#' @export
list_documents <- function(
    account_id = NULL,
    envelope_id = NULL,
    token = global_token(),
    base_url = get_base_url()
) {
  stopifnot("account_id must not be missing" = !is.null(account_id),
            "envelope_id must not be missing" = !is.null(envelope_id))
  req <- base_query(token = token,
                    base_url = base_url,
                    "restapi", "v2.1", "accounts", account_id,
                    "envelopes", envelope_id, "documents")
  httr2::resp_body_json(httr2::req_perform(req))
}

#' List Envelope Custom Fields
#'
#' @param account_id account id
#' @param envelope_id envelope for which documents should be listed
#' @param token a `httr2_token` for authentication
#' @param base_url base URL for the query
#'
#' @return a parsed JSON structure
#'
#' @export
list_envelope_custom_fields <- function(
    account_id = NULL,
    envelope_id = NULL,
    token = global_token(),
    base_url = get_base_url()
) {
  stopifnot("account_id must not be missing" = !is.null(account_id),
            "envelope_id must not be missing" = !is.null(envelope_id))
  req <- base_query(token = token,
                    base_url = base_url,
                    "restapi", "v2.1", "accounts", account_id,
                    "envelopes", envelope_id, "custom_fields")
  httr2::resp_body_json(httr2::req_perform(req))
}

#' List Document Fields
#'
#' @param account_id account id
#' @param envelope_id envelope id
#' @param document_id document id
#' @param token a `httr2_token` for authentication
#' @param base_url base URL for the query
#'
#' @return nothing, invisibly
#'
#' @export
list_document_fields <- function(
    account_id = NULL,
    envelope_id = NULL,
    document_id = NULL,
    token = global_token(),
    base_url = get_base_url()
) {
  stopifnot("account_id must not be missing" = !is.null(account_id),
            "envelope_id must not be missing" = !is.null(envelope_id),
            "document_id must not be missing" = !is.null(document_id))
  req <- base_query(token = token,
                    base_url = base_url,
                    "restapi", "v2.1", "accounts",account_id,
                    "envelopes", envelope_id, "documents", document_id, "fields")
  httr2::resp_body_json(httr2::req_perform(req))
}

#' Download a Document from an Envelope
#'
#' @param account_id account id
#' @param envelope_id envelope id
#' @param document_id document id
#' @param filename file name/path to which the file should be written
#' @param token a `httr2_token` for authentication
#' @param base_url base URL for the query
#'
#' @return nothing, invisibly
#'
#' @export
get_document <- function(
  account_id = NULL,
  envelope_id = NULL,
  document_id = NULL,
  filename = NULL,
  token = global_token(),
  base_url = get_base_url()
) {
  stopifnot("account_id must not be missing" = !is.null(account_id),
            "envelope_id must not be missing" = !is.null(envelope_id),
            "document_id must not be missing" = !is.null(document_id),
            "filename must not be missing" = !is.null(filename))
  req <- base_query(token = token,
                    base_url = base_url,
                    "restapi", "v2.1", "accounts",account_id,
                    "envelopes", envelope_id, "documents", document_id)
  message("Writing to file: ", filename)
  writeBin(httr2::resp_body_raw(httr2::req_perform(req)), filename)
  invisible()
}

#' List Folders
#'
#' @param account_id account id
#' @param token a `httr2_token` for authentication
#' @param base_url base URL for the query
#'
#' @return a parsed JSON structure
#'
#' @export
list_folders <- function(
    account_id = NULL,
    token = global_token(),
    base_url = get_base_url()
) {
  stopifnot("account_id must not be missing" = !is.null(account_id))
  req <- base_query(token = token,
                    base_url = base_url,
                    "restapi", "v2.1", "accounts", account_id,
                    "folders")
  httr2::resp_body_json(httr2::req_perform(req))
}

#' List Folder Contents
#'
#' @param account_id account id
#' @param folder_id folder id
#' @param token a `httr2_token` for authentication
#' @param base_url base URL for the query
#'
#' @return a parsed JSON structure
#'
#' @export
list_folder_contents <- function(
    account_id = NULL,
    folder_id = NULL,
    token = global_token(),
    base_url = get_base_url()
) {
  stopifnot("account_id must not be missing" = !is.null(account_id),
            "folder_id must not be missing" = !is.null(folder_id))
  req <- base_query(token = token,
                    base_url = base_url,
                    "restapi", "v2.1", "accounts", account_id,
                    "folders", folder_id)
  httr2::resp_body_json(httr2::req_perform(req))
}
