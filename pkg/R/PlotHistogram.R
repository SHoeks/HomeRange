#' PlotHistogram
#'
#' @description Plot HomeRange data specially on a global map.
#' @param HomeRangeData the HomeRange dataset (can be retrieved by running: GetHomeRangeData())
#' @param Labelvjust value to adjust the labeling of the histogram panels, default is 2
#' @param PanelLabelSize value to adjust the size of the panel labeling, default is 4
#' @export
#'
#' @examples
#' library(HomeRange)
#' HomeRangeData <- GetHomeRangeData()
#' PlotHistogram(HomeRangeData)
PlotHistogram = function(HomeRangeData, Labelvjust = 2, PanelLabelSize = 4) {

  Locomotion = unique(HomeRangeData$Locomotion)
  Level = unique(HomeRangeData$HR_Level)
  HomeRangeData$HR_Level2 = NA
  HomeRangeData$HR_Level2[grep("Population",HomeRangeData$HR_Level)] = "Population"
  HomeRangeData$HR_Level2[grep("Individual",HomeRangeData$HR_Level)] = "Individual"
  HomeRangeData = HomeRangeData[!is.na(HomeRangeData$HR_Level2),]

  # colors
  grey = "#999999"
  purple = "#816fb5"
  yellow = "#E69F00"
  green = "#41bb7b"
  green2 = "#1b8233"
  red = "#ac4c26"
  blue = "#4ea5c5"
  colors = c(grey, purple, blue, green, green2,  yellow, red)

  # filter Isopleth_Size > 75%
  iso75 = c("95", "100","80", "75", "77", "85", "90", "86.5", "96",
            "99", "97.5", "Home range", "97", "94", "92", "70 - 100", "88", "79", "82",
            "76", "60 - 90", "65 - 90", "50-95", "75-95", "95-99", "85.7", ">95", "98")

  # filter Isopleth_Size > 90%
  iso90 = c("95", "100", "90", "96","99", "97.5", "97", "94",
            "75-95", "95-99", ">95", "98")

  #HomeRangeData = HomeRangeData[HomeRangeData$Isopleth_Size%in%iso75,]
  HomeRangeData = HomeRangeData[HomeRangeData$Isopleth_Size%in%iso90,]

  # factorize Locomotion column, sets order of locomotion categories
  #print(Locomotion)
  HomeRangeData$Locomotion_f = factor(HomeRangeData$Locomotion, levels=c("Aerial","Aquatic","Semi-aquatic","Arboreal","Semi-arboreal","Terrestrial","Fossorial"))

  plott = ggplot2::ggplot(HomeRangeData, ggplot2::aes(x=log10(Home_Range_km2), fill=Locomotion_f,color=Locomotion_f)) +
    ggplot2::geom_histogram(position="identity",alpha=0.9, bins = 30) +
    ggplot2::scale_color_manual(values=colors) +
    ggplot2::scale_fill_manual(values=colors) +
    ggplot2::facet_grid(ggplot2::vars(Locomotion_f), ggplot2::vars(HR_Level2), scales = "free_y") +
    ggplot2::xlab(expression("Log10( home range km"^2~")")) +
    ggplot2::ylab("Number of home ranges") +
    ggplot2::theme_light() +
    ggplot2::theme(legend.position="none") +
    ggplot2::theme(strip.background = ggplot2::element_rect(fill="#D9D9D9")) +
    ggplot2::theme(strip.text = ggplot2::element_text(colour = 'black')) +
    ggplot2::theme(panel.spacing.y = ggplot2::unit(0.7, "lines")) +
    ggplot2::theme(panel.spacing.x = ggplot2::unit(0.5, "lines")) +
    ggplot2::theme(text = ggplot2::element_text(size = 12))

  gb <- ggplot2::ggplot_build(plott)
  lay <- gb$layout$layout
  tag_pool = letters
  tags <- cbind(lay, label = paste0(tag_pool[lay$PANEL], ")"), x = -6, y = Inf)
  plott + ggplot2::geom_text(data = tags, ggplot2::aes(x = x, y = y, label = label),
                             inherit.aes = FALSE,
                             vjust = Labelvjust, size = 4)

}
