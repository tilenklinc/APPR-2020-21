#install.packages("xml2", type="source")
suppressWarnings(suppressMessages(library(knitr)))
suppressWarnings(suppressMessages(library(rvest)))
suppressWarnings(suppressMessages(library(gsubfn)))
suppressWarnings(suppressMessages(library(tidyr)))
suppressWarnings(suppressMessages(library(tmap)))
suppressWarnings(suppressMessages(library(shiny)))
suppressWarnings(suppressMessages(library(quantmod)))
suppressWarnings(suppressMessages(library(xml2)))
suppressWarnings(suppressMessages(library(dplyr)))
suppressWarnings(suppressMessages(library(RColorBrewer)))



options(gsubfn.engine="R")

# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/uvozi.zemljevid.r", encoding="UTF-8")
