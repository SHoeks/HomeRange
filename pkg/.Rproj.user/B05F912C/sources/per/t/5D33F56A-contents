#' GetHomeRangeData
#'
#' @description Downloads the latest HomeRange dataset and loads it as a data.frame into R.
#' @param IncludeReferences option to include the source references directly to the HomeRange data, can be set to TRUE or FALSE (default: FALSE)
#' @return The HomeRange dataset
#' @export
#'
#' @examples
#' library(HomeRange)
#' HomeRangeData <- GetHomeRangeData()
GetHomeRangeData = function(IncludeReferences=FALSE) {

  if(class(IncludeReferences)!="logical") stop("IncludeReferences needs to be set to TRUE or FALSE")
  date = "2022_11_11"
  zip_version = "1"

  # url to get csv from
  url <- paste0("https://github.com/SHoeks/HomeRange/raw/main/HomeRangeData_",date,"_",zip_version,".zip")

  # os specific seperator
  switch(Sys.info()[['sysname']],Windows= {sep = '\\'}, Linux  = {sep = '/'}, Darwin = {sep = '/'})

  # download HomeRange data as zip
  download.file(url,paste0(tempdir(),sep,'HomeRangeData.zip'),method = "libcurl")

  # unzip file to csv
  unzip(zipfile=paste0(tempdir(),sep,'HomeRangeData.zip'),exdir=tempdir())
  #system(paste("open",tempdir()))

  # read HR data
  HR_data = read.csv(paste0(tempdir(),sep,'HomeRangeData_',date,'.csv'),sep=',')

  if(IncludeReferences){

    # read HR references
    HR_refs = read.csv(paste0(tempdir(),sep,'HomeRangeReferences_',date,'.csv'),sep=',')

    # match data and references
    index = match(HR_data$Study_ID,HR_refs$Study_ID)

    # merge HR data + HR references
    HR_refs = HR_refs[index,]
    HR_refs$Study_ID = NULL
    HR_data = cbind(HR_data,HR_refs)

  }

  # return HR data
  return(HR_data)

}
