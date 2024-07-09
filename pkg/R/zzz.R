.onLoad <- function(libname, pkgname) {
  # info <- packageDescription("HomeRange")
  # packageStartupMessage("HomeRange version: ",info$Version)
}

.onAttach <- function(libname, pkgname) {
  info <- packageDescription("HomeRange")
  packageStartupMessage("HomeRange pkg version: ",info$Version)
  packageStartupMessage("HomeRange database version: ","2024_07_09")
}
