library(knitr)
library(rvest)
library(gsubfn)
library(tidyr)
library(tmap)
library(shiny)
library(quantmod)
library(xml2)
library(dplyr)
install_github("jaanos/rvest", ref="table-span-filling-v0.3.6.196")


options(gsubfn.engine="R")

# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/uvozi.zemljevid.r", encoding="UTF-8")
