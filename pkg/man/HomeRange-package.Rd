\name{HomeRange-package}
\alias{HomeRange-package}
\alias{HomeRange}
\docType{package}

\title{HomeRange package}

\description{
\bold{HomeRange R package} \cr
The HomeRange R package is intended to download and load the latest HomeRange dataset. In provides some basic functions for plotting as well as merging with other trait datasets. However, its main use is to provide an easy start for more advanced analysis or modeling applications in R. The example code below shows the use of most of the functions included in the package. More information can be found on: \url{https://shoeks.github.io/HomeRange/}.

# load package \cr
library('HomeRange') \cr

# get package info, opens this help file\cr
?HomeRange \cr

# download the latest HomeRange data\cr
HomeRangeData <- GetHomeRangeData()\cr

# plotting functions\cr
PlotMap(HomeRangeData)\cr
PlotHistogram(HomeRangeData)\cr
MakeStatTable(HomeRangeData)\cr

# match with the COMBINE imputed dataset\cr
COMBINE <- read.csv('/path/to/trait_data_imputed.csv')\cr
merged_data = MergeWithCOMBINE(HomeRangeData, COMBINE)\cr

\bold{HomeRange metadata} \cr
Each heading in the metadata file describes a column of the HomeRange dataset. The metadata file can called from R using one of the two methods decribed below:\cr

# view HomeRange metadata directly as PDF in the browser\cr
ViewMetaData()\cr

# Or access the metadata from the HomeRange vignettes using\cr
vignette(package="HomeRange","Metadata")\cr

Alternatively the following link could be used to access the metadata:\cr
\url{https://shoeks.github.io/HomeRange/HomeRangeMetadata_2023_03_07.pdf}.\cr

}
