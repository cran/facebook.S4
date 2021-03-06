% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FacebookMessagesCollection-class.R
\docType{class}
\name{FacebookMessagesCollection-class}
\alias{FacebookMessagesCollection-class}
\title{Class for representing a collection of Facebook messages between users or users and pages}
\description{
This class is used to collect Facebook inbox messages in a convenient structure.
}
\section{Slots}{

\describe{
\item{\code{data}}{The raw data in a list form and as pulled from Facebook}

\item{\code{id}}{A character vector with the \code{id} of the items included in the collection}

\item{\code{fields}}{A character vector with the fields included for each ID in the collection. Ie. \code{id, name, created_time}...}

\item{\code{token}}{Either a temporary access token created at
\url{https://developers.facebook.com/tools/explorer} or the OAuth token 
created with \code{fbOAuth} used to fill the collection.}

\item{\code{parent}}{A character vector of the parent \code{id} of the items included in the collection or \code{NA} if the items have
no valid inheritance}

\item{\code{parent.collection}}{The collection used to build this one, or \code{NA} if the collection was built from a character vectors of \code{ids}.}

\item{\code{type}}{A character vector with the type of each element of the collection. It's set only if the collection has been built with \code{metadata=TRUE}}
}}

\seealso{
Other Facebook Collections: \code{\link{FacebookAlbumsCollection-class}},
  \code{\link{FacebookCommentsCollection-class}},
  \code{\link{FacebookConversationsCollection-class}},
  \code{\link{FacebookEventsCollection-class}},
  \code{\link{FacebookGenericCollection-class}},
  \code{\link{FacebookGroupsCollection-class}},
  \code{\link{FacebookLikesCollection-class}},
  \code{\link{FacebookMixedCollection-class}},
  \code{\link{FacebookPagesCollection-class}},
  \code{\link{FacebookPhotosCollection-class}},
  \code{\link{FacebookPostsCollection-class}},
  \code{\link{FacebookReactionsCollection-class}},
  \code{\link{FacebookVideosCollection-class}}
}
\author{
Gabriele Baldassarre \url{https://gabrielebaldassarre.com}
}
