rowMads <- function(x, center=NULL, constant=1.4826, na.rm=FALSE, dim.=dim(x), centers=NULL, ...) {
  ## BACKWARD COMPATIBILITY:
  ## - Added to matrixStats 0.14.0.
  ## - Remove in matrixStats (>= 0.15.0)
  if (!is.null(centers)) {
    center <- centers
    .Deprecated(msg="Argument 'centers' for matrixStats::rowMads() has been renamed to 'center'. Please update code accordingly.")
  }

  if (is.null(center)) {
    dim. <- as.integer(dim.)
    na.rm <- as.logical(na.rm)
    constant = as.numeric(constant)
    hasNAs <- TRUE
    x <- .Call("rowMads", x, dim., constant, na.rm, hasNAs, TRUE, PACKAGE="matrixStats")
  } else {
    x <- x - center
    x <- abs(x)
    x <- rowMedians(x, na.rm=na.rm, ...)
    x <- constant*x
  }
  x
} # rowMads()


colMads <- function(x, center=NULL, constant=1.4826, na.rm=FALSE, dim.=dim(x), centers=NULL, ...) {
  ## BACKWARD COMPATIBILITY:
  ## - Added to matrixStats 0.14.0.
  ## - Remove in matrixStats (>= 0.15.0)
  if (!is.null(centers)) {
    center <- centers
    .Deprecated(msg="Argument 'centers' for matrixStats::colMads() has been renamed to 'center'. Please update code accordingly.")
  }

  if (is.null(center)) {
    dim. <- as.integer(dim.)
    na.rm <- as.logical(na.rm)
    constant = as.numeric(constant)
    hasNAs <- TRUE
    x <- .Call("rowMads", x, dim., constant, na.rm, hasNAs, FALSE, PACKAGE="matrixStats")
  } else {
    ## SLOW:
    ## for (cc in seq(length=ncol(x))) {
    #    x[,cc] <- x[,cc] - center[cc]
    #  }
    x <- t_tx_OP_y(x, center, OP="-", na.rm=FALSE)
    x <- abs(x)
    x <- colMedians(x, na.rm=na.rm, ...)
    x <- constant*x
  }
  x
} # colMads()


############################################################################
# HISTORY:
# 2015-02-10 [HB]
# o CONSISTENCY: Renamed argument 'centers' of col- and rowMads() to
#   'center'.  This is consistent with col- and rowVars().  Added
#   backward compatibility code/test for the migration.
# 2014-11-17 [HB]
# o SPEEDUP: Implemented (col|row)Mads(..., centers=NULL) in native code.
# 2012-03-19 [HJ]
# o Changed default value of centers to row/colMedians(x,...)
# 2012-03-04 [HC]
# o BUG FIX: colMads() would return the incorrect estimates. This bug
#   was introduced in matrixStats v0.4.0 (2011-11-11).
# 2011-11-11 [HB]
# o Dropped the previously introduced expansion of 'center' in rowMads()
#   and colMads().  It added unnecessary overhead if not needed.
# 2011-10-13 [HJ]
# o Implemented colMads() as rowMads() by using the improved colMedians().
# o Now rowMads() expands 'center' to a matrix of the same dimensions as
#   'x'.  This is not actually necessary, but it enforces that 'x' must be
#   a matrix.
# 2008-03-26 [HB]
# o Created.
############################################################################
