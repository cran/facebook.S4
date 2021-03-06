% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/facebook.image.formats.R
\name{facebook.image.formats}
\alias{facebook.image.formats}
\title{Pull the list of image formats available from a set of photos}
\usage{
facebook.image.formats(id, token = NULL, parameters = list(),
  fields = c("source", "height", "width"),
  .progress = create_progress_bar())
}
\arguments{
\item{id}{An existing \code{\link{FacebookPhotosCollection}}.}

\item{token}{Either a temporary access token created at
\url{https://developers.facebook.com/tools/explorer} or the OAuth token 
created with \code{\link{fbOAuth}}. If it's \code{NULL}, the token from \code{id} is used.}

\item{parameters}{A list of parameters to be added to the Facebook Graph API query. For more information on the
accepted parameters, see: \url{https://developers.facebook.com/docs/graph-api/using-graph-api}.}

\item{fields}{A character vector with the fields to get for each \code{id}.}

\item{.progress}{progress_bar object as defined in the plyr package.
By default the \code{none} progress bar is used, which prints nothing to the console. See \link[plyr]{create_progress_bar} for details.}
}
\value{
A named list with all the formats of the given photos. The name of is set to the \code{id} of the photo.
}
\description{
\code{facebook.image.formats} pulls information about the formats of a set of photos 
in a \code{link{FacebookPhotosCollection-class}} and push into a named list.
}
\section{Valid sources}{

\itemize{
 \item{\code{\link{FacebookPhotosCollection-class}} will build a collection with 
 the formats available for the photos in the source collection.}
}
}

\examples{
\dontrun{
## See examples for fbOAuth to know how token was created.
 load("fb_oauth")
 
## Getting information about two example Facebook Pages
 fb.pages <- FacebookPagesCollection(id = c("9thcirclegames",
                                           "NathanNeverSergioBonelliEditore"), 
                                     token = fb_oauth)
 
## Pull at most 10 albums from each page
 fb.albums <- FacebookAlbumscollection(id = fb.pages, token = fb_oauth, n = 10)
 
## Pull all the available photos from each album
 fb.photos.inf <- FacebookPhotoscollection(id = fb.albums, n = Inf)
 
## Pull all the available formats for those photos
 fb.images.inf <- FacebookImagescollection(id = fb.photos.inf, n = Inf)
}

}
\seealso{
\code{\link{FacebookAlbumsCollection}}, \code{\link{FacebookPhotosCollection}}
}
\author{
Gabriele Baldassarre \url{https://gabrielebaldassarre.com}
}
