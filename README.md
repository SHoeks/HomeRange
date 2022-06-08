# HomeRange data and R package repository

This is a temporary and anonymous repository containing the HomeRange data and R package, please do not share the link to this page.

### To download to HomeRange data use the following link

Link: https://anonymous.4open.science/r/TestData-C4A4/HR_data_harmonized_2022-05-30_V2.csv

### The data can be access using the R package, which will be available after publication

To install the package use the following from R
```r
install.packages("https://anonymous.4open.science/r/TestData-C4A4/HomeRange_0.0.0.9000.tar.gz",repos=NULL, method="libcurl")
```

These are some of the functions included in the package

```r

# load package
library('HomeRange')

# package info
?HomeRange

# get the dataset, this function automatically downloads the data
data <- GetData()

# plotting data
PlotMap(data)
PlotHistogram(data)

# get more information
MakeStatTable(data)

# match with the COMBINE imputed dataset
COMBINE <- read.csv("/path/to/combine/trait_data_imputed.csv")
merged_data = MergeWithCOMBINE(data, COMBINE)

# example plot of the merged data
plot(merged_data$Body_mass_kg*1000,merged_data$COMBINE_adult_mass_g,
     log = "xy", pch=21, cex=0.7, bg="grey",
     xlab="body mass g HomeRange",ylab="body mass g COMBINE")
abline(0,1,col="red")


```
