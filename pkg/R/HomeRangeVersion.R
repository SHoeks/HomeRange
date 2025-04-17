#' HomeRangeVersion
#'
#' @description This function lists the version of the package and database.
#' @export
#'
#' @examples
#' library(HomeRange)
#'
#' # view HomeRange metadata
#' HomeRangeVersion()
HomeRangeVersion = function() {
  info <- packageDescription("HomeRange")
  message("HomeRange pkg version: ",info$Version)
  message("HomeRange database version: ","2025_04_11")
}
