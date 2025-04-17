#' PlotMap
#'
#' @description Plot HomeRange data specially on a global map.
#' @param HomeRangeData the HomeRange dataset (can be retrieved by running: GetHomeRangeData())
#' @param DotColor string to set to color of the home-range locations, default is "red"
#' @export
#'
#' @examples
#' library(HomeRange)
#' HomeRangeData <- GetHomeRangeData()
#' PlotMap(HomeRangeData)
PlotMap = function(HomeRangeData, DotColor="red") {

  # proj
  WGS84Proj<-"+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"

  # get map with polygons of countries
  world.sf <- sf::st_as_sf(rnaturalearth::ne_countries(scale = "medium"))

  # convert and subset data
  HomeRangeData$marker_subset <- paste(HomeRangeData$Study_ID, HomeRangeData$Species, HomeRangeData$subspecies,
                                       HomeRangeData$Longitude, HomeRangeData$Latitude)
  HomeRangeData_plot <- HomeRangeData[!duplicated(HomeRangeData$marker_subset),]

  keep = !is.na(HomeRangeData_plot$Longitude) & !is.na(HomeRangeData_plot$Latitude)
  HomeRangeData_plot <- HomeRangeData_plot[keep,]
  HomeRangeData_plot <- HomeRangeData_plot[HomeRangeData_plot$Longitude > -180 & HomeRangeData_plot$Longitude < 180,]
  HomeRangeData_plot <- HomeRangeData_plot[HomeRangeData_plot$Latitude > -90 & HomeRangeData_plot$Latitude < 90,]
  HR_data_sf <- sf::st_as_sf(HomeRangeData_plot, coords = c("Longitude", "Latitude"), crs = WGS84Proj)

  # make plot
  ggplot2::ggplot() +
    ggplot2::geom_sf(data = world.sf) +
    ggplot2::geom_sf(data = HR_data_sf, col = DotColor, size=0.6) +
    ggplot2::theme_bw() +
    ggplot2::theme(axis.text.x = ggplot2::element_blank(),
                   axis.text.y = ggplot2::element_blank(),
                   axis.ticks = ggplot2::element_blank(),
                   axis.title = ggplot2::element_blank(),
                   panel.border = ggplot2::element_blank(),
                   panel.grid = ggplot2::element_blank(),
                   plot.margin = ggplot2::unit(c(0,0,0,0), unit = "cm"))

}
