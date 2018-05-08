options(stringsAsFactors=FALSE)

options(max.print=100)

options(scipen=10)

auto.loads = c("stats","readr", "dplyr", "ggplot2", "RcppRoll", "zoo", "gridExtra", "ggthemes")

# This snippet allows you to tab-complete package names for # use in "library()" or "require()" calls
utils::rc.settings(ipck=TRUE)

sshhh <- function(a.package){
  suppressWarnings(suppressPackageStartupMessages(
    library(a.package, character.only=TRUE)))
}

toClipboard <- function(data) {
	write.table(data, "clipboard", sep="\t", row.names=FALSE, col.names=FALSE)
}

fromClipboard <- function() {
	read.delim("clipboard")
}

if(interactive()){
  invisible(sapply(auto.loads, sshhh))
}

# Set ggplot2 format defaults
theme_set(theme_gray(base_size = 14))
theme_update(plot.title = element_text(hjust = 0.5))
theme_update(plot.subtitle = element_text(hjust = 0.5))

message("\n*** Successfully loaded .Rprofile ***\n")

