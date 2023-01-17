#' MakeStatTable
#'
#' @description Creates a table for the HomeRange dataset using the gridExtra package.
#' @param HomeRangeData the HomeRange dataset (can be retrieved by running: GetHomeRangeData())
#' @param ReturnTable option to return the table with statistics as a data.frame, TRUE or FALSE (default: FALSE)
#' @export
#'
#' @examples
#' library(HomeRange)
#' HomeRangeData <- GetHomeRangeData()
#' MakeStatTable(HomeRangeData)
MakeStatTable = function(HomeRangeData, ReturnTable = FALSE) {

  if(class(ReturnTable)!="logical") stop("ReturnTable needs to be set to TRUE or FALSE")

  # simplify HR level
  HomeRangeData$HR_Level_simple = NA
  HomeRangeData$HR_Level_simple[grep("Population",HomeRangeData$HR_Level)] = "Population"
  HomeRangeData$HR_Level_simple[grep("Group",HomeRangeData$HR_Level)] = "Group"
  HomeRangeData$HR_Level_simple[grep("Individual",HomeRangeData$HR_Level)] = "Individual"
  HomeRangeData$HR_Level_simple[which(is.na(HomeRangeData$HR_Level_simple))] = "Population"

  loc = c("Aerial","Aquatic","Semi-aquatic","Arboreal","Semi-arboreal","Terrestrial","Fossorial")
  lev = c("Individual","Group","Population")
  ndata=data.frame(matrix(NA,nrow=length(loc),ncol=length(lev)))
  colnames(ndata) = lev
  rownames(ndata) = loc
  nspecies=ndata

  HomeRangeData$Overall_Category = paste0(HomeRangeData$HR_Level_simple,"_",HomeRangeData$Locomotion)
  all_catogories = unique(HomeRangeData$Overall_Category)
  all_catogories = grep("NA",all_catogories,value = TRUE, invert = TRUE)
  i=1
  for(i in 1:length(all_catogories)) {
    HR_data_sub = HomeRangeData[which(HomeRangeData$Overall_Category == all_catogories[i]),]
    clname = strsplit(all_catogories[i],"_")[[1]][1]
    rwname = strsplit(all_catogories[i],"_")[[1]][2]
    ndata[rwname,clname] = nrow(HR_data_sub)
    nspecies[rwname,clname] = length(unique(HR_data_sub$Species))
  }

  # alls
  nspecies["All",] = colSums(nspecies)
  ndata["All",] = colSums(ndata)

  # totals
  ndata[,"Total"] = rowSums(ndata)
  nspecies[,"Total"] = NA
  for(i in rownames(nspecies)){
    nspecies[i,"Total"] = length(unique(HomeRangeData$Species[which(HomeRangeData$Locomotion==i)]))
  }
  nspecies["All","Total"] = length(unique(HomeRangeData$Species))

  table1 = nspecies
  table1[] = NA
  for(i in 1:nrow(table1)){
    for(j in 1:ncol(table1)){
      table1[i,j] = paste0(ndata[i,j]," (",nspecies[i,j],")")
    }
  }

  grid::grid.newpage()
  gridExtra::grid.table(table1)

  if(ReturnTable) return(list(ndata=ndata,nspecies=nspecies))

}
