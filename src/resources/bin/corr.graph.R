#!/usr/bin/env Rscript
packages      <- c("getopt", "ggplot2", "rjson", "ggpubr")
not.installed <- setdiff(packages, rownames(installed.packages()))
if (length(not.installed) > 0) {
  suppressMessages(suppressWarnings(try({
    if (!requireNamespace("BiocManager", quietly = TRUE))
      install.packages("BiocManager")
    BiocManager::install(not.installed, quiet = TRUE)
  }, silent=TRUE)))
}
rm(not.installed, packages)
library(getopt, quietly = TRUE)
library(ggplot2, quietly = TRUE)
library(rjson, quietly = TRUE)
library(ggpubr, quietly = TRUE)
# get options, using the spec as defined by the enclosed list.
# we read the options from the default: commandArgs(TRUE).
spec <- matrix(c(
  'help',         'h', 0, "logical",
  'row.id',       'r', 1, "character",
  'col.id',       'c', 1, "character",
  'dataset.file', 'd', 1, "character",
  'trf.file',     't', 1, "character",
  'cor.method',   'm', 1, "character",
  'output.file',  'o', 1, "character"
), byrow=TRUE, ncol=4)
opt = getopt(spec)
# if help was asked for print a friendly message
# and exit with a non-zero error code
if (!is.null(opt$help)) {
  cat(getopt(spec, usage=TRUE))
  q(status=1)
}

if (is.null(opt$dataset.file) || !file.exists(opt$dataset.file)) {
  cat(getopt(spec, usage=TRUE))
  q(status=101)
}

if (is.null(opt$trf.file) || !file.exists(opt$trf.file)) {
  cat(getopt(spec, usage=TRUE))
  q(status=102)
}

if (is.null(opt$row.id)) {
  cat(getopt(spec, usage=TRUE))
  q(status=103)
}

if (is.null(opt$col.id)) {
  cat(getopt(spec, usage=TRUE))
  q(status=104)
}

if (is.null(opt$cor.method)) {
  opt$cor.method <- "pearson"
}

tryCatch({
  dataset <- readRDS(opt$dataset.file)
  trf     <- readRDS(opt$trf.file)
  x       <- as.vector(dataset[opt$row.id,])
  y       <- as.vector(t(trf$RPM[opt$col.id,]))
  color   <- factor(trf$clinical[colnames(trf$RPM),]$tissue)
  df      <- data.frame(x=x, y=y, Tissue=color, row.names = colnames(trf$RPM))
  sp      <- ggscatter(df, x = "x", y = "y", color = "Tissue",
                       add = "reg.line",
                       add.params = list(color = "blue", fill = "lightgray"),
                       xlab = opt$row.id, ylab = opt$col.id,
                       conf.int = TRUE, cor.coef = TRUE, cor.method = opt$cor.method,
                       cor.coeff.args = list(output.type="text"))
  ggsave(opt$output.file, plot = sp, width = 20, height = 20, units = "cm", dpi = 600)
}, error=function (e) {
  cat(e$message);
  q(status = 105)
})
q(status=0)