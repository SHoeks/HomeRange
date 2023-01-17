#' MergeWithCOMBINE
#'
#' @description Function combines the HomeRange and COMBINE dataset into a single data.frame by matching the scientific species names.
#' @return A combined data set, containing all the data of HomeRange merged with COMBINE
#' @param HomeRangeData the HomeRange dataset (can be retrieved by running: GetHomeRangeData())
#' @param COMBINE the combine dataset: https://esajournals.onlinelibrary.wiley.com/action/downloadSupplement?doi=10.1002%2Fecy.3344&file=ecy3344-sup-0001-DataS1.zip
#' @export
#'
#' @examples
#' library(HomeRange)
#'
#' # load files
#' HomeRangeData <- GetHomeRangeData()
#' COMBINE <- read.csv("/path/to/trait_data_imputed.csv")
#'
#' # combine the two datasets
#' MergedData <- MergeWithCOMBINE(HomeRangeData, COMBINE)
#'
#' # example plot of the merged data
#' plot(merged_data$Body_mass_kg*1000,merged_data$COMBINE_adult_mass_g,
#'      log = "xy", pch=21, cex=0.7, bg="grey",
#'      xlab="body mass g HomeRange",ylab="body mass g COMBINE")
#' abline(0,1,col="red")
MergeWithCOMBINE = function(HomeRangeData, COMBINE) {

  colnames(COMBINE) = paste0("COMBINE_",colnames(COMBINE))
  sp_idx = match(HomeRangeData$Species,COMBINE$COMBINE_iucn2020_binomial)
  COMBINE = COMBINE[sp_idx,]
  merged_data = cbind(HomeRangeData,COMBINE)

  return(merged_data)

}
