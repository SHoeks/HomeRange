# Windows
Sys.setenv(PATH=paste(Sys.getenv("PATH"),"C:/Program Files/MiKTeX/miktex/bin/x64/",sep=";"))
devtools::document(roclets = c('rd', 'collate', 'namespace', 'vignette'))
devtools::build()
devtools::build(binary = TRUE, args = c('--preclean'))
