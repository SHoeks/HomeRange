setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
load("HR_data_harmonized_2023-03-07.RData")
head(HR_data)
write.csv(HR_data,"HomeRangeData_2023_03_07.csv",row.names = FALSE)
