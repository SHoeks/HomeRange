setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(rbibutils)
library(tidyr)
library(stringr)

unique_species = function(id,data){
  data = data[data$Study_ID == id,]
  return(unique(data$Species))
}

# load old and new data
HRold = read.csv("HomeRangeData_2024_07_09_1/HomeRangeData_2024_07_09.csv")
HRoldref = read.csv("HomeRangeData_2024_07_09_1/HomeRangeReferences_2024_07_09.csv")
HRnew = readRDS("newHarmonizedMaarten/HR_data_harmonized_2025-04-11.rds")
HRconv = readRDS("newHarmonizedMaarten/Study_ID_conversion_April2025.rds")
HRconvOld = readRDS("newReferencesSelwyn/old/Study_ID_conversion_June2024.rds")
idx = which(!HRnew$Study_ID%in%HRconv$new_study_ID)
HRnew$Study_ID[idx] |> unique()
max(HRconv$new_study_ID)
max(HRnew$Study_ID)

# check if references are still matching correctly
unique_sp_per_id_old = sapply(unique(HRold$Study_ID),unique_species,data=HRold)
unique_sp_per_id_new = sapply(unique(HRnew$Study_ID),unique_species,data=HRnew)
names(unique_sp_per_id_old) = unique(HRold$Study_ID)
names(unique_sp_per_id_new) = unique(HRnew$Study_ID)
idx = match(names(unique_sp_per_id_old),names(unique_sp_per_id_new))
unique_sp_per_id_new2 = unique_sp_per_id_new[idx]
all(names(unique_sp_per_id_new2)==names(unique_sp_per_id_old))
idx_to_replace = c()
for(i in seq_along(unique_sp_per_id_old)){
  if(!all(unique_sp_per_id_old[[i]]==unique_sp_per_id_new2[[i]])){
    cat(i,": ",unique_sp_per_id_old[[i]],"-->",unique_sp_per_id_new2[[i]],"\n")
    idx_to_replace = c(idx_to_replace,i)
  }
}

# see which do not have a ref
idx = match(HRnew$Study_ID,HRold$Study_ID)
check = data.frame(new=HRnew$Study_ID,old=HRold$Study_ID[idx])
check = check[!duplicated(check$new),]
check$screeningID = HRconv$original_study_ID[match(check$new,HRconv$new_study_ID)]
check_noref = check[which(is.na(check$old)),]
nrow(check_noref)

# read new refs
newRefs1 = openxlsx::read.xlsx("newReferencesSelwyn/new/Additional_papers_2024_list.xlsx")
newRefs2 = openxlsx::read.xlsx("newReferencesSelwyn/new/AdditionalPaperList_Marlee_Selwyn_Maarten_Students_2024_02_07.xlsx")
newRefs3 = openxlsx::read.xlsx("newReferencesSelwyn/new/NewSearchHR_2022-08-01_2024-01-30_screeningComplete.xlsx")

# check for matches
check_noref$newRefs1_idx = match(check_noref$screeningID, newRefs1$Study_ID)
check_noref$newRefs2_idx = match(check_noref$screeningID, newRefs2$ID)
check_noref$newRefs3_idx = match(check_noref$screeningID, newRefs3$study_id)

# simplify old refs
#dput(names(HRoldref))
keepCols0 = c("Study_ID", "AUTHORS", "TITLE", "JOURNAL", "YEAR", "DOI_OR_LINK", "PUBLICATION_TYPE")
HRoldref = HRoldref[,keepCols0]

# check+reformat newRefs1
names(newRefs1)
newRefs1 = newRefs1[check_noref$newRefs1_idx[!is.na(check_noref$newRefs1_idx)],]
check_noref$newRefs1_idx = match(check_noref$screeningID, newRefs1$Study_ID)

# reformat newRefs2
#dput(names(newRefs2))
keepCols2 = c("ID", "Ref", "DOI")
newRefs2 = newRefs2[,keepCols2]
names(newRefs2) = c("Study_ID", "Reference", "DOI_OR_LINK")
newRefs2 = newRefs2[check_noref$newRefs2_idx[!is.na(check_noref$newRefs2_idx)],]
check_noref$newRefs2_idx = match(check_noref$screeningID, newRefs2$Study_ID)

# reformat newRefs3
#dput(names(newRefs3))
keepCols3 = c("study_id", "Authors", "Article.Title", "Source.Title", "Publication.Year", "DOI", "Publication.Type")
newRefs3 = newRefs3[,keepCols3]
names(newRefs3) = c("Study_ID", "AUTHORS", "TITLE", "JOURNAL", "YEAR", "DOI_OR_LINK", "PUBLICATION_TYPE")
newRefs3 = newRefs3[check_noref$newRefs3_idx[!is.na(check_noref$newRefs3_idx)],]
check_noref$newRefs3_idx = match(check_noref$screeningID, newRefs3$Study_ID)

# merge newRefs data
newRefs1$DOI_OR_LINK = NA
names(newRefs1)
names(newRefs2)
newRefs12 = rbind(newRefs1, newRefs2)
newCols = c("AUTHORS", "TITLE", "JOURNAL", "YEAR", "PUBLICATION_TYPE")
newRefs12[,newCols] = NA
newRefs12 = newRefs12[,c(keepCols0,"Reference")]
i = 1
for(i in 1:nrow(newRefs12)){
  r = newRefs12$Reference[i]
  year = regmatches(r, gregexpr("[[:digit:]]+", r))[[1]] |> as.numeric()
  year = year[which(year>1900 & year<2025)]
  year = year[1]
  message("Year: ", year)
  if(length(year)>0){
    if(year>1900 & year<2025)  newRefs12$YEAR[i] = year
  }
  link = str_split(r, "https")[[1]]
  if(length(link)!=1){
    link = paste0("https",link[2])
    message("Link: ", link)
    newRefs12$DOI_OR_LINK[i] = link
  }
}
newRefs12$AUTHORS = newRefs12$Reference
newRefs12$TITLE = newRefs12$Reference
newRefs12$Reference = NULL
newRefs123 = rbind(newRefs12, newRefs3)
newRefs123$Study_ID = check_noref$new[match(newRefs123$Study_ID,check_noref$screeningID)]

# bind with original refs
HRref = rbind(HRoldref, newRefs123)
duplicated(HRref$Study_ID) |> which()

# read newRefs2 (again)
newRefs2 = openxlsx::read.xlsx("newReferencesSelwyn/new/AdditionalPaperList_Marlee_Selwyn_Maarten_Students_2024_02_07.xlsx")

# check which refs need replacement
idx_to_replace = c(744, 1360, 1365, 1453, 2184)
print(HRref[HRref$Study_ID%in%idx_to_replace,])
check_replaceref = HRconv[HRconv$new_study_ID%in%idx_to_replace,]
print(check_replaceref)
replRefs = newRefs2[match(check_replaceref$original_study_ID,newRefs2$ID),]
replRefs = replRefs[,c("ID","Ref")] 
names(replRefs) = c("Study_ID", "Reference")
replRefs$DOI_OR_LINK = NA
replRefs[,newCols] = NA
i = 1
for(i in 1:nrow(replRefs)){
  r = replRefs$Reference[i]
  year = regmatches(r, gregexpr("[[:digit:]]+", r))[[1]] |> as.numeric()
  year = year[which(year>1900 & year<2025)]
  year = year[1]
  message("Year: ", year)
  if(length(year)>0){
    if(year>1900 & year<2025)  replRefs$YEAR[i] = year
  }
  link = str_split(r, "https")[[1]]
  if(length(link)!=1){
    link = paste0("https",link[2])
    message("Link: ", link)
    replRefs$DOI_OR_LINK[i] = link
  }
}
replRefs$AUTHORS = replRefs$Reference
replRefs$TITLE = replRefs$Reference
replRefs$Reference = NULL
replRefs$Study_ID = idx_to_replace
HRref = HRref[!HRref$Study_ID%in%idx_to_replace,]
HRref = rbind(HRref,replRefs)
tail(HRref,n=10)
rownames(HRref) = NULL
HRref = HRref[order(HRref$Study_ID),]
head(HRref)

# something missing?
nrow(HRref)
HRnew$Study_ID |> unique() |> length()
Study_ID_missing = HRnew$Study_ID[which(is.na(match(HRnew$Study_ID,HRref$Study_ID)))] |> unique()
if(length(Study_ID_missing)>0){
  refMissing = data.frame(Study_ID=Study_ID_missing,AUTHORS=NA,
                          TITLE=NA,JOURNAL=NA,YEAR=NA,
                          DOI_OR_LINK=NA,PUBLICATION_TYPE=NA)
  HRnew[which(HRnew$Study_ID==Study_ID_missing[1]),]
  HRref = rbind(HRref,refMissing)
}

# check
idx = which(!HRnew$Study_ID%in%HRconv$new_study_ID)
if(length(idx)==0) {
  print("All new data have been converted successfully")
}else{
  print(paste0("Some new data have not been matched successfully: ", length(idx), " records"))
}
  
# write refs
write.csv(HRref,"HomeRangeReferences_2025_04_11.csv",row.names = FALSE)

# write new data
rownames(HRnew)=NULL
head(HRnew)
write.csv(HRnew,"HomeRangeData_2025_04_11.csv",row.names = FALSE)

