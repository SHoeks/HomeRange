# uninstall previous version
if(FALSE){
  detach("package:HomeRange", unload=TRUE)
  remove.packages("HomeRange")
}

# install new version
if(FALSE){
  install.packages("https://github.com/SHoeks/HomeRange/raw/main/HomeRange_1.07.tar.gz",
                   repos=NULL,
                   method="libcurl")
}

# load package
library('HomeRange')

# package info
HomeRangeVersion()
?HomeRange

# test functions
HomeRangeData <- GetHomeRangeData(IncludeReferences = TRUE)
head(HomeRangeData)

# view metadata file
ViewMetaData()

# plotting data
PlotMap(HomeRangeData)
PlotHistogram(HomeRangeData)

# get more information
MakeStatTable(HomeRangeData)

# match with the COMBINE imputed dataset
COMBINE <- read.csv("/Users/osx/Documents/PhD/Paper_EcoMoveR/Data/COMBINE_trait_data_imputed.csv")
merged_data = MergeWithCOMBINE(HomeRangeData, COMBINE)

# example plot of the merged data
plot(merged_data$Body_mass_kg*1000,merged_data$COMBINE_adult_mass_g,
     log = "xy", pch=21, cex=0.7, bg="grey", xlim=c(10^0,10^7), ylim=c(10^0,10^7),
     xlab="body mass g HomeRange",ylab="body mass g COMBINE")
abline(0,1,col="red")

