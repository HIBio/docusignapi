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
    account_id = get_account_id(),
    from_date = "2020-01-01",
    token = global_token(),
    base_url = get_base_url()
) {
  stopifnot("account_id must not be missing" = !is.null(account_id) && account_id != "",
            "from_date must not be missing" = !is.null(from_date))
  req <- template_query(token = token,
                        base_url = base_url,
                        endpoint = "envelopes",
                        perform = FALSE) %>%
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
    account_id = get_account_id(),
    envelope_id = NULL,
    token = global_token(),
    base_url = get_base_url()
) {
  stopifnot("account_id must not be missing" = !is.null(account_id) && account_id != "",
            "envelope_id must not be missing" = !is.null(envelope_id))
  template_query(token = token,
                 base_url = base_url,
                 endpoint = c("envelopes", envelope_id, "documents"))
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
    account_id = get_account_id(),
    envelope_id = NULL,
    token = global_token(),
    base_url = get_base_url()
) {
  stopifnot("account_id must not be missing" = !is.null(account_id) && account_id != "",
            "envelope_id must not be missing" = !is.null(envelope_id))
  template_query(token = token,
                 base_url = base_url,
                 endpoint = c("envelopes", envelope_id, "custom_fields"))
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
    account_id = get_account_id(),
    envelope_id = NULL,
    document_id = NULL,
    token = global_token(),
    base_url = get_base_url()
) {
  stopifnot("account_id must not be missing" = !is.null(account_id) && account_id != "",
            "envelope_id must not be missing" = !is.null(envelope_id),
            "document_id must not be missing" = !is.null(document_id))
  template_query(token = token,
                 base_url = base_url,
                 endpoint = c("envelopes", envelope_id, "documents", document_id, "fields"))
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
  account_id = get_account_id(),
  envelope_id = NULL,
  document_id = NULL,
  filename = NULL,
  token = global_token(),
  base_url = get_base_url()
) {
  stopifnot("account_id must not be missing" = !is.null(account_id) && account_id != "",
            "envelope_id must not be missing" = !is.null(envelope_id),
            "document_id must not be missing" = !is.null(document_id),
            "filename must not be missing" = !is.null(filename))
  req <- template_query(token = token,
                        base_url = base_url,
                        endpoint = c("envelopes", envelope_id, "documents", document_id),
                        perform = FALSE)
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
    account_id = get_account_id(),
    token = global_token(),
    base_url = get_base_url()
) {
  stopifnot("account_id must not be missing" = !is.null(account_id) && account_id != "")
  template_query(token = token,
                 base_url = base_url,
                 endpoint = "folders")
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
    account_id = get_account_id(),
    folder_id = NULL,
    token = global_token(),
    base_url = get_base_url()
) {
  stopifnot("account_id must not be missing" = !is.null(account_id) && account_id != "",
            "folder_id must not be missing" = !is.null(folder_id))
  template_query(token = token,
                 base_url = base_url,
                 endpoint = c("folders", folder_id))
}

#' Templated Query
#'
#' @param endpoint endpoint to query, e.g. "envelopes" or a field URI
#' @param account_id account id
#' @param token a `httr2_token` for authentication
#' @param base_url base URL for the query
#' @param perform perform the query?
#'
#' @return a parsed JSON structure, or if `perform` is `FALSE`, the request
#'
#' @export
template_query <- function(endpoint = "",
                           account_id = get_account_id(),
                           token = global_token(),
                           base_url = get_base_url(),
                           perform = TRUE) {
  stopifnot("account_id must not be missing" = !is.null(account_id) && account_id != "")
  if (length(endpoint) > 1) {
    endpoint <- paste(endpoint, collapse = "/")
  }
  req <- base_query(token = token,
                    base_url = base_url,
                    "restapi", "v2.1", "accounts", account_id,
                    endpoint)
  if (!perform) return(req)
  httr2::resp_body_json(httr2::req_perform(req))
}
