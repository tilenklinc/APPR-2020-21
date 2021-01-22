#install.packages("xml2", type="source")
#data cleanup
library(dplyr)
library(tidyr)
library(magrittr)
library(stringr)
library(lubridate)
library(data.table)

#API and json
library(httr)
library(jsonlite)
library(config)
library(newsanchor)

#Web Scraping
library(rvest)

#Visualization
library(plotly)
library(ggplot2)
library(DT)
library(webshot)

#Data
library(bea.R)
library(devtools)
library(gtrendsR)

#Text Analysis
library(tidytext)
library(wordcloud)
library(RColorBrewer)

#Forecasting
library(quantmod)
library(forecast)
library(tseries)
library(prophet)
library(curl)


suppressWarnings(suppressMessages(library(knitr)))
suppressWarnings(suppressMessages(library(rvest)))
suppressWarnings(suppressMessages(library(gsubfn)))
suppressWarnings(suppressMessages(library(tmap)))
suppressWarnings(suppressMessages(library(shiny)))
suppressWarnings(suppressMessages(library(quantmod)))
suppressWarnings(suppressMessages(library(xml2)))
suppressWarnings(suppressMessages(library(dplyr)))
suppressWarnings(suppressMessages(library(RColorBrewer)))
suppressWarnings(suppressMessages(library(shinythemes)))
library(shinydashboard)
library(shinythemes)
library(forecast)
library(tseries)
library(PerformanceAnalytics)
library(reshape2)
library(newsanchor)
library(textdata)



options(gsubfn.engine="R")

# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/uvozi.zemljevid.r", encoding="UTF-8")
