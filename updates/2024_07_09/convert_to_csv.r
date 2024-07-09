setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library( rbibutils)

unique_species = function(id,data){
  data = data[data$Study_ID == id,]
  return(unique(data$Species))
}

# load old and new data
HRold = read.csv("HomeRangeData_2023_11_28_1/HomeRangeData_2023_11_28.csv")
HRoldref = read.csv("HomeRangeData_2023_11_28_1/HomeRangeReferences_2023_11_28.csv")
HRnew = readRDS("newHarmonizedMaarten/HR_data_harmonized_2024-07-04.rds")
HRconv = readRDS("newHarmonizedMaarten/Study_ID_conversion_June2024.rds")

# check if references are still matching correctly
unique_sp_per_id_old = sapply(unique(HRold$Study_ID),unique_species,data=HRold)
unique_sp_per_id_new = sapply(unique(HRnew$Study_ID),unique_species,data=HRnew)
names(unique_sp_per_id_old) = unique(HRold$Study_ID)
names(unique_sp_per_id_new) = unique(HRnew$Study_ID)
idx = match(names(unique_sp_per_id_old),names(unique_sp_per_id_new))
unique_sp_per_id_new2 = unique_sp_per_id_new[idx]
all(names(unique_sp_per_id_new2)==names(unique_sp_per_id_old))
for(i in seq_along(unique_sp_per_id_old)){
  if(!all(unique_sp_per_id_old[[i]]==unique_sp_per_id_new2[[i]])){
    cat(i,": ",unique_sp_per_id_old[[i]],"-->",unique_sp_per_id_new2[[i]],"\n")
  }
}

# see which do not have a ref
idx = match(HRnew$Study_ID,HRold$Study_ID)
check = data.frame(new=HRnew$Study_ID,old=HRold$Study_ID[idx])
check = check[!duplicated(check$new),]
check$screeningID = HRconv$original_study_ID[match(check$new,HRconv$new_study_ID)]
check_noref = check[which(is.na(check$old)),]
#View(check_noref)

# read new refs
newRefs1 = openxlsx::read.xlsx("newReferencesSelwyn/AdditionalPaperList_Marlee_Selwyn_Maarten_Students_2024_02_07_v1.xlsx")
newRefs2 = openxlsx::read.xlsx("newReferencesSelwyn/NewSearchHR_2022-08-01_2024-01-30.xlsx")

# extract new refs 1  (additional papers 2022) and new refs 2 (new search 2024)
check_noref$screeningID2 = NA
check_noref$screeningID2[grep("MaSeStu",check_noref$screeningID)] = check_noref$screeningID[grep("MaSeStu",check_noref$screeningID)]
check_noref$screeningID2_tmp = stringr::str_split(check_noref$screeningID2,"Stu_",simplify=TRUE)[,2]
fixidx = which(nchar(check_noref$screeningID2_tmp)==3)
check_noref$screeningID2[fixidx] = paste0("add_MaSeStu_0",check_noref$screeningID2_tmp[fixidx])
idx_match = rep(NA,nrow(check_noref))
ref_data = rep(NA,nrow(check_noref))
for(i in seq_along(check_noref$screeningID)){
  idx = which(check_noref$screeningID[i]==newRefs1$ID)
  if(length(idx)!=0) ref_data[i] = 1
  if(length(idx)==0) {
    idx = grep(check_noref$screeningID[i],newRefs1$ID)
    if(length(idx)!=0) ref_data[i] = 1
  }
  if(length(idx)==0 & !is.na(check_noref$screeningID2[i])){
    idx = grep(check_noref$screeningID2[i],newRefs1$ID)
    if(length(idx)!=0) ref_data[i] = 1
  }
  if(length(idx)==0) {
    idx = grep(check_noref$screeningID[i],newRefs2$study_id)
    if(length(idx)!=0) ref_data[i] = 2
  }
  if(length(idx)!=0) idx_match[i] = idx
  
}
check_noref$screeningID[which(is.na(idx_match))]
idx_match_ref1 = idx_match[which(ref_data==1)]
idx_match_ref2 = idx_match[which(ref_data==2)]
newRefs1 = newRefs1[idx_match_ref1,]
newRefs2 = newRefs2[idx_match_ref2,]
newRefs1$Study_ID_screening = check_noref$screeningID[which(ref_data==1)]
newRefs1$Study_ID = check_noref$new[which(ref_data==1)]
newRefs2$Study_ID_screening = check_noref$screeningID[which(ref_data==2)]
newRefs2$Study_ID = check_noref$new[which(ref_data==2)]
View(cbind(newRefs1$Study_ID_screening,newRefs1$Ref))

# construct new refs 
HRnewref = data.frame(Study_ID_screening = check_noref$screeningID,
                      Study_ID = check_noref$new, 
                      Study_ID_check = NA,
                      check2 = NA,
                      AUTHORS     = NA,
                      TITLE       = NA,
                      JOURNAL     = NA,
                      YEAR      = NA,
                      VOLUME      = NA,
                      NUMBER      = NA,
                      PAGES     = NA,
                      PUBLISHER   = NA,
                      ADDRESS   = NA,
                      ISSN     = NA,
                      DOI_OR_LINK  = NA, 
                      PUBLICATION_TYPE = NA)
idx_insert_ref1 = match(newRefs1$Study_ID_screening,HRnewref$Study_ID_screening)
idx_insert_ref2 = match(newRefs2$Study_ID_screening,HRnewref$Study_ID_screening)

# ref 1 (additional papers 2022)
HRnewref$Study_ID_check[idx_insert_ref1] = newRefs1$Study_ID
HRnewref$check2[idx_insert_ref1] = newRefs1$Ref
HRnewref$DOI_OR_LINK[idx_insert_ref1] = newRefs1$DOI
for(i in 1:length(newRefs1$Study_ID_screening)){
  print(newRefs1$Study_ID_screening[i])
  bib = readBib(paste0("newReferencesSelwyn/bib/",newRefs1$Study_ID_screening[i],".txt"))
  HRnewref$AUTHORS[idx_insert_ref1[i]] = paste0(bib[[1]]$author,collapse="; ")
  HRnewref$TITLE[idx_insert_ref1[i]] = bib[[1]]$title
  if(length(bib[[1]]$journal)!=0) HRnewref$JOURNAL[idx_insert_ref1[i]] = bib[[1]]$journal
  HRnewref$YEAR[idx_insert_ref1[i]] = bib[[1]]$year
  if(length(bib[[1]]$publisher)!=0) HRnewref$PUBLISHER[idx_insert_ref1[i]] = bib[[1]]$publisher
  HRnewref$PUBLICATION_TYPE[idx_insert_ref1[i]] = bib[[1]]$bibtype
}

# ref 2 (new search 2024)
HRnewref$Study_ID_check[idx_insert_ref2] = newRefs2$Study_ID
HRnewref$AUTHORS[idx_insert_ref2] = newRefs2$Authors
HRnewref$TITLE[idx_insert_ref2] = newRefs2$Article.Title
HRnewref$PUBLICATION_TYPE[idx_insert_ref2] = newRefs2$Publication.Type
HRnewref$PUBLICATION_TYPE[idx_insert_ref2] = newRefs2$Publication.Type
HRnewref$DOI_OR_LINK[idx_insert_ref2] = newRefs2$DOI
HRnewref$JOURNAL[idx_insert_ref2] = newRefs2$Source.Title
HRnewref$VOLUME[idx_insert_ref2] = newRefs2$Volume            
HRnewref$PAGES[idx_insert_ref2] = NA
HRnewref$ISSN[idx_insert_ref2] = newRefs2$ISSN              
HRnewref$YEAR[idx_insert_ref2] = newRefs2$Publication.Year    

# add snider 2021 ref 
bib = readBib(paste0("newReferencesSelwyn/bib/","snideretal2021",".txt"))
idx = which(HRnewref$Study_ID_screening=="Snider et al. 2021. Journal of Mammalogy")
HRnewref$AUTHORS[idx] = paste0(bib[[1]]$author,collapse="; ")
HRnewref$TITLE[idx] = bib[[1]]$title
if(length(bib[[1]]$journal)!=0) HRnewref$JOURNAL[idx] = bib[[1]]$journal
HRnewref$YEAR[idx] = bib[[1]]$year
if(length(bib[[1]]$publisher)!=0) HRnewref$PUBLISHER[idx] = bib[[1]]$publisher
HRnewref$PUBLICATION_TYPE[idx] = bib[[1]]$bibtype
HRnewref$DOI_OR_LINK[idx] = "https://doi.org/10.1093/jmammal/gyab068"

# clean up new refs
HRnewref$Study_ID_screening = NULL
HRnewref$Study_ID_check = NULL
HRnewref$check2 = NULL

# rbind with HRoldref
HRnewref2 = rbind(HRoldref,HRnewref)
rownames(HRnewref2) = NULL

# write refs
write.csv(HRnewref2,"HomeRangeReferences_2024_07_09.csv",row.names = FALSE)

# write new data
rownames(HRnew)=NULL
head(HRnew)
write.csv(HRnew,"HomeRangeData_2024_07_09.csv",row.names = FALSE)
