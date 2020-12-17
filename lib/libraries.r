install.packages("xml2", type="source")
library(knitr)
library(rvest)
library(gsubfn)
library(tidyr)
library(tmap)
library(shiny)
library(quantmod)
library(xml2)
library(dplyr)



options(gsubfn.engine="R")

# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/uvozi.zemljevid.r", encoding="UTF-8")
