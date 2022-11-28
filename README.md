# HomeRange data and R package repository

This repository contains the latest version of the HomeRange data and R package. The HomeRange data contains mammal home-ranges estimates, species names, methodological information on data collection, home-range estimation method, period of data collection, study coordinates and name of location, as well as species traits derived from the studies, such as body mass, life stage, reproductive status and locomotor habit. 

## Access the HomeRange data

- <u>Access online</u>: the HomeRange data (formatted as a CSV) can be downloaded from this repository, please download the zip contained in this repository using this [link](https://github.com/SHoeks/HomeRange/raw/main/HomeRangeData_2022_11_11_1.zip)
- <u>R package</u>: the R package can be used to download and import the HomeRange data all from within R using a single function call ```GetHomeRangeData()``` (see example code below). 

## Metadata

- <u>Access online</u>: the metadata PDF for the HomeRage data can be accessed using this [link](https://shoeks.github.io/HomeRange/HomeRangeMetadata_2022_11_11.pdf). 
- <u>R package</u>: the metadata can be viewed from the R package using ```ViewMetaData()``` or ```vignette(package="HomeRange","Metadata")``` (see example code below).

## Reference list

- <u>Access online</u>: all references for the home-range values contained in the HomeRange dataset can be found in the ```HomeRangeReferences_2022_11_11.csv``` file included in the ```HomeRangeData_2022_11_11_1.zip``` available from this repository ([link](https://github.com/SHoeks/HomeRange/raw/main/HomeRangeData_2022_11_11_1.zip)). 
- <u>R package</u>: by setting the ```IncludeReferences``` agrument to ```TRUE``` in the ```GetHomeRangeData()``` function of the R package (```GetHomeRangeData(IncludeReferences = TRUE)```) all references are downloaded and merged with the HomeRange dataset directly.

## Interactive map with data points

Visit the interactive HomeRange map using this [link](https://shoeks.github.io/HomeRange/InteractiveMap.html).

<a href="https://shoeks.github.io/HomeRange/InteractiveMap.html">
<img src="figs/int_map_s2.png" style="float: left; margin-right: 10px; padding-bottom: 20px; width: 80%; padding-left: 10%; padding-right:10%;" />
</a>

## HomeRange R package

The HomeRange dataset can be downloaded and imported directly using the HomeRange R pacakge

```r
# install the HomeRange R package
install.packages("https://github.com/SHoeks/HomeRange/blob/main/HomeRange_1.00.tar.gz", 
                 repos=NULL, 
                 method="libcurl")

# load package into R
library('HomeRange')

# package information and HomeRange metadata
?HomeRange

# view HomeRange metadata directly as PDF in the browser
ViewMetaData()

# Or access the metadata from the HomeRange vignettes
vignette(package="HomeRange","Metadata")

# get the dataset, this function automatically downloads and imports the data
HomeRangeData <- GetHomeRangeData() # by default IncludeReferences is set to FALSE

# get data with the references attached
HomeRangeDataWithRefs <- GetHomeRangeData(IncludeReferences = TRUE) 

# some information on the HomeRange data
head(HomeRangeData)
head(HomeRangeDataWithRefs)
summary(HomeRangeData)
str(HomeRangeData)
```

## Explore HomeRange data further

```r
# plotting data
PlotMap(HomeRangeData)
PlotHistogram(HomeRangeData)
```

<img src="figs/map3.png" style="float: left; margin-right: 10px; padding-bottom: 20px; width: 80%; padding-left: 10%; padding-right:10%;" />
<img src="figs/barplot_2022_08_18.png" style="float: left; margin-right: 10px; padding-bottom: 20px; width: 80%; padding-left: 10%; padding-right:10%;" />

```r
# get more information
MakeStatTable(HomeRangeData)
```

<img src="figs/table2_2022_11_10.svg" style="float: left; margin-right: 10px; padding-bottom: 20px; width: 80%; padding-left: 10%; padding-right:10%;" />

```r
# match with the COMBINE imputed dataset
# https://esajournals.onlinelibrary.wiley.com/doi/10.1002/ecy.3344
COMBINE <- read.csv("/path/to/combine/trait_data_imputed.csv")
merged_data = MergeWithCOMBINE(HomeRangeData, COMBINE)

# example plot of the merged data
plot(merged_data$Body_mass_kg*1000, 
     merged_data$COMBINE_adult_mass_g,
     log = "xy", pch=21, 
     cex=0.7, bg="grey",
     xlim=c(10^0,10^7), ylim=c(10^0,10^7),
     xlab="body mass g HomeRange",
     ylab="body mass g COMBINE")

abline(0,1,col="red")
```

<img src="figs/scatter.png" style="float: left; margin-right: 10px; padding-bottom: 20px; width: 80%; padding-left: 10%; padding-right:10%;" />
