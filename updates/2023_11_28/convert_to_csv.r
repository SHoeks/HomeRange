setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
load("HR_data_harmonized_2023-11-28.RData")
head(HR_data)
rownames=NULL
write.csv(HR_data,"HomeRangeData_2023_11_28.csv",row.names = FALSE)
