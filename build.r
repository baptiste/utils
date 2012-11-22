#!/usr/bin/Rscript

require(optparse)
library(devtools)
library(roxygen2)


build_vignettes <- function(pkg = NULL) {
  
  pkg <- as.package(pkg)
  message("Building ", pkg$package, " vignettes")
  vig_pat <- "\\.(Rnw|Snw|Rtex|Stex)$"
  
  ## look in vignettes and in deprecated inst/doc
  path_vig <- file.path(pkg$path, "vignettes")
  old_path_vig <- file.path(pkg$path, "inst", "doc")

  ## list files in both directories
  vigs <- dir(pattern = vig_pat, path = path_vig, full.names = FALSE)
  old_vigs <- dir(pattern = vig_pat, path = old_path_vig, full.names = FALSE)

  ## if nothing, exit
  if (!length(vigs) && !length(old_vigs)) return()

  ## check for identical names in both directories
  duplicates <- intersect(vigs, old_vigs)
  if(length(duplicates)){
    warning("The following duplicates were ignored in inst/doc/: ", paste(duplicates, collapse=" "))
    old_vigs <- setdiff(old_vigs, duplicates)
  }
  ## process vignettes
  if(length(vigs)){
    in_dir(path_vig, {
      capture.output(lapply(vigs, Sweave))
      tex <- dir(pattern = "\\.tex$", full.names = FALSE)
      lapply(tex, tools::texi2dvi, pdf = TRUE, quiet = TRUE)
    })
  }
  
  ## process inst/doc
  if(length(old_vigs)){
    in_dir(old_path_vig, {
      capture.output(lapply(old_vigs, Sweave))
      tex <- dir(pattern = "\\.tex$", full.names = FALSE)
      lapply(tex, tools::texi2dvi, pdf = TRUE, quiet = TRUE)
    })
  }
    
  invisible(TRUE)
}

all <- commandArgs(trailingOnly = TRUE)
args <- all[-length(all)] # remove the package name
pkg <- all[length(all)]

option_list <- list(
    make_option(c("-d", "--document"), action="store_true", default=FALSE,
                help="run roxygen2 through document()"),
    make_option(c("-b", "--build"), action="store_true", default=FALSE,
                help="run R CMD build through build()"),
    make_option(c("-v", "--vignettes"), action="store_true", default=FALSE,
                help="builds vignettes with build_vignettes()"), 
    make_option(c("-i", "--install"), action="store_true", default=FALSE,
                help="install package with install()")
                    )
                    
opt <- parse_args(OptionParser(option_list=option_list),
                  args = args)


if(opt$document){
  message("documenting...", pkg)
  roxygenize(pkg)
  }
if(opt$build){
  message("building...", pkg)
  build(pkg)
  }
if(opt$install){
  message("installing...", pkg)
  install(pkg)
  }
if(opt$vignettes){
  message("vignetting...", pkg)
  build_vignettes(pkg)
  }

str(opt)
