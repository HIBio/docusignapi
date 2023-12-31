% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/queries.R
\name{list_folder_contents}
\alias{list_folder_contents}
\title{List Folder Contents}
\usage{
list_folder_contents(
  account_id = get_account_id(),
  folder_id = NULL,
  token = global_token(),
  base_url = get_base_url()
)
}
\arguments{
\item{account_id}{account id}

\item{folder_id}{folder id}

\item{token}{a \code{httr2_token} for authentication}

\item{base_url}{base URL for the query}
}
\value{
a parsed JSON structure
}
\description{
List Folder Contents
}
