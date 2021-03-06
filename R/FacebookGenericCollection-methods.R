#' @include generic-methods.R
NULL

#' @title
#'  Returns a summary of a Facebook collection
#'  
#' @description
#' This generic returns a summarized version from various Facebook collections
#' 
#' @param object A valid collection of Facebook elements
#' @param ... not used in this context
#' 
#' @exportMethod summary
#' @rdname summary-methods
#' 
#' @aliases summary,FacebookGenericCollection-method
setMethod("summary",
          signature(object = "FacebookGenericCollection"),
          function (object, ...) 
          {
            cat(paste0(rep_len("-", nchar(class(object))), collapse=""))
            cat(paste0("\n", class(object), "\n"))
            cat(paste0(rep_len("-", nchar(class(object))), collapse=""))
            cat(paste0("\nLength: ", length(object), " element", ifelse(length(object) != 1, "s", "")))
            cat(paste0("\nFields: ", paste(object@fields, collapse=", ")))
            cat(paste0("\nParent Collection: ", 
                       ifelse(!is.null(object@parent.collection), 
                              paste0(class(object@parent.collection),
                                     " (",
                                     length(object@parent.collection),
                                     " element", ifelse(length(object@parent.collection) != 1, "s", ""), ")"), "NA")
            )
            )
            cat(paste0("\n", ifelse(length(object) > 5 , "First 5 IDs: ", "IDs: "), ifelse(length(object) > 0, paste0(head(object@id, 5), collapse=", "), "NONE")))
            cat(paste0("\n", ifelse(length(object) > 5 , "First 5 Parents: ", "Parents: "), ifelse(length(object) > 0,  paste0(head(object@parent, 5), collapse=", "), "NONE")))
            
            if(all(is.na(object@parent)) & is(object@parent.collection, "FacebookGenericCollection")){
              cat("\n\n(Parent informations not available due to many-to-many relationship with", class(object@parent.collection), ")")
            }
            
            cat("\n\nFacebook Application ID:", ifelse(is.character(object@token), "NONE - A token from Graph API Explorer was used", object@token$app$key))
            
            if(length(object) > 0){
              cat("\n\nContent Example (only the first 3 fields are shown):\n")
              separator <- (function(){
                if(length(object@fields) > 1) {
                  return(paste0(rep_len("-", sum(apply(head(as.data.frame(object),5)[,1:min(3, length(object@fields))], MARGIN=2, function(r) { max(nchar(as.character((r))))})) + 4), collapse=""))
                }
                return(paste0(rep_len("-", max(nchar(head(as.data.frame(object),5)[,1])) + 2), collapse = ""))
              })()
              
              cat(paste0(separator, "\n"))
              if(length(object@fields) > 1 & !is.null(object@data)) {
                print(head(as.data.frame(object), 5)[,1:min(3, length(object@fields))])
              } else {
                snap <- as.data.frame(head(as.data.frame(object), 5)[,1])
                colnames(snap) <- object@fields
                print(snap)
              }
              cat(ifelse(length(object) > 5, paste0("\n (", length(object) - 5, " more element", ifelse(length(object) - 5 != 1, "s", ""), ")\n"), ""))
              cat(paste0(separator, "\n"))
            } else {
              cat("\n\n### The collection has no data.")
            }
            invisible(object)
          }
)

#' @title
#'  Return parts of a Facebook collection
#'  
#' @description
#' This generic returns parts of a given Facebook collections
#' 
#' @param x A valid collection of Facebook elements
#' @param i slicing on the first dimension index
#' @param j not used in this context
#' @param ... not used in this context
#' @param drop not used in this context
#' 
#' @rdname square-methods
#' @exportMethod [
#' 
#' @examples \dontrun{
#' ## See examples for fbOAuth to know how token was created.
#'  load("fb_oauth")
#'  
#' ## Getting information about two example Facebook Pages
#'  fb.pages <- FacebookPagesCollection(id = c("9thcirclegames",
#'                                            "NathanNeverSergioBonelliEditore"), 
#'                                      token = fb_oauth)
#'  
#' ## Pull at most 20 albums from each page
#'  fb.albums <- FacebookAlbumscollection(id = fb.pages, token = fb_oauth, n = 20)
#'  
#' ## Create a new collection skipping the first 10 albums
#'  fb.oldest.albums <- fb.albums[11:length(fb.oldest.albums)]
#' }
#' @rdname square-methods
#' @aliases [,FacebookGenericCollection-method
setMethod("[",
          signature(x = "FacebookGenericCollection", i = "ANY", j = "ANY"),
          function(x, i, j, drop){
            
            empty.set <- new(class(x))
            
            slot(empty.set, "fields") <- x@fields
            
            slot(empty.set, "token") <- x@token
            
            slot(empty.set, "id") <- (function(idx){
              if(is.numeric(i)) return(x@id[i])
              return(x@id[x@id %in% as.character(i)])
            })(i)
            
            slot(empty.set, "parent") <- (function(idx){
              if(is.numeric(i)) return(x@parent[i])
              return(x@parent[x@id %in% as.character(i)])
            })(i)
            
            slot(empty.set, "parent.collection") <- (function(idx){
              return(x@parent.collection)
            })(i)
            
            slot(empty.set, "type") <- (function(idx){
              if(is.numeric(i)) return(x@type[i])
              return(x@type[x@id %in% as.character(i)])
            })(i)
            
            slot(empty.set, "data") <- (function(idx){
              if(is.numeric(i)) return(x@data[i])
              return(x@data[x@id %in% as.character(i)])
            })(i)
            
            return(empty.set)
          }
)

#' @title
#' Return the number of items in a given Facebook collection
#' 
#' @description
#' This method returns the number of members in a given Facebook collection.
#' 
#' @param x a valid not-null Facebook collection
#' 
#' @rdname generic-length
#' @aliases length,FacebookGenericCollection-method
setMethod("length",
          signature(x = "FacebookGenericCollection"),
          function(x){
            return(length(x@id))
          }
)

#' @title
#' Return a comma-separated string of all the IDs of the given Facebook collection
#' 
#' @description
#' This method serializes a Facebook collection extracting all the IDs of its member into a
#' comma-separated string. This could be useful for lazy chaining into other Facebook queries
#' or for debugging purposes.
#' 
#' @param x a valid not-null Facebook Collection
#' 
#' @rdname generic-character
#' @aliases as.character,FacebookGenericCollection-method
setMethod("as.character",
          signature(x = "FacebookGenericCollection"),
          function(x){
            return(paste0(x@id, collapse=","))
          }
)

#' @title
#' Combine two or more Facebook collections
#' 
#' @description
#' This method combines two or more Facebook collections of the same kind. Please note that duplicates are removed unless they have
#' different parents.
#' 
#' @param x the first collection to chain into
#' @param ... the other collections to chain from
#' @param recursive not used in this context
#' 
#' @rdname generic-c
#' @aliases c,FacebookGenericCollection-method
setMethod("c",
          signature(x = "FacebookGenericCollection"),
          function (x, ..., recursive = FALSE) 
          {
            optional.elems <- list(...)
            
            empty.set <- new(class(x), fields = x@fields)
            
            # Only bind collections of the same kind
            lapply(optional.elems, function(list.elem) {
              if(!is(list.elem, class(x))){
                stop(paste0("Cannot bind collection of different kinds. Found: ", class(list.elem), ". Expected: ", class(x)))
              }
            })
            
            id <- (do.call(c, list(x@id,
                                   do.call(c,lapply(optional.elems, slot, "id"))
            )
            ))
            
            parent <- (do.call(c, list(x@parent,
                                       do.call(c,lapply(optional.elems, slot, "parent"))
            )
            ))
            
            duplicated.idx <- duplicated(id)
            
            empty.set@id <- id[!duplicated.idx]
            
            empty.set@data <- (do.call(c, list(x@data,
                                               do.call(c,lapply(optional.elems, slot, "data"))
            )
            ))[!duplicated.idx]
            
            empty.set@fields <- unique(do.call(c, list(x@fields,
                                                       do.call(c,lapply(optional.elems, slot, "fields"))
            )
            ))
            
            empty.set@parent <- parent[!duplicated.idx]
            
            empty.set@type <- (do.call(c, list(x@type,
                                               do.call(c,lapply(optional.elems, function(x){ as.character(slot(x, "type"))}))
            )
            ))[!duplicated.idx]
            
            secondary.collection <-
              lapply(
                optional.elems, function(p) {
                  p@parent.collection
                })
            
            # TODO: Workaround because I cannot unlist this stupid secondary.collection
            empty.set@parent.collection <- (function(){
              if(length(secondary.collection) == 0){
                return(x@parent.collection)
              }
              return(c(x@parent.collection, do.call(c, secondary.collection)))
            })()
            
            empty.set@token <- x@token
            
            return(empty.set)
          }
)

#' @title
#' Returns a data frame from a Facebook collection
#' 
#' @description
#' This generic return a valid data frame representation of various Facebook collections
#' 
#' @param x A valid collection of Facebook elements
#' @param row.names If set to \code{TRUE}, names the rows of the returned data frame with IDs of the elements
#' @param optional Not used in this context.
#' @rdname as.data.frame
#' 
#' @keywords internal
#' @export
#' @method as.data.frame FacebookGenericCollection
as.data.frame.FacebookGenericCollection <- function (x, row.names = FALSE, optional = FALSE, ...) {
  df <- detailsDataToDF(x@data, x@fields)
  
  numeric.cols <- which(grepl("(total|count)", colnames(df), perl=TRUE))
  logical.cols <- which(grepl("(has|can)", colnames(df), perl=TRUE))
  datetime.cols <- which(grepl("time", colnames(df), perl=TRUE))
  
  for(n in names(df)[numeric.cols]){df[[n]] <- as.numeric(df[[n]])}
  for(n in names(df)[datetime.cols]){df[[n]] <- formatFbDate(df[[n]])}
  for(n in names(df)[logical.cols]){df[[n]] <- as.logical(df[[n]])}
  
  if(row.names == TRUE){
    row.names(df) <- x@id
  }
  
  return(df)
}
setAs("FacebookGenericCollection", "data.frame", function(from) as.data.frame.FacebookGenericCollection(from))
setMethod("as.data.frame", signature(x = "FacebookGenericCollection", row.names = "logical", optional = "logical"), as.data.frame.FacebookGenericCollection)

#' @title
#' Returns a list from a Facebook collection
#'  
#' @description
#' This generic return a valid list representation of various Facebook collections
#' 
#' @param x A valid collection of Facebook elements
#' 
#' @rdname as.list
#' @method as.list FacebookGenericCollection 
#' @keywords internal
#' @export
as.list.FacebookGenericCollection <- function (x, ...) 
{
  optional.elems <- list(...)
  
  # Only bind Collections of the same types
  lapply(optional.elems, function(list.elem) {
    stopifnot(class(x) != class(list.elem))
  })
  
  return(do.call(c, list(x@data,
                         do.call(c,lapply(optional.elems, slot, "data"))
  )
  ))
}
setAs("FacebookGenericCollection", "list", function(from) as.list.FacebookGenericCollection(from))
setMethod("as.list", signature(x = "FacebookGenericCollection"), as.list.FacebookGenericCollection)
