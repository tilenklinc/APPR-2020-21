
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

#Web Scraping
library(rvest)

#Visualization
library(plotly)
library(ggplot2)
library(DT)

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

accessKey <- "de25b9c5e84d9d201b7d8fa849a34f32"

#config <- config::get()
date_from = today()-dyears(5)

URL <- paste0("http://api.marketstack.com/v1/eod?access_key=de25b9c5e84d9d201b7d8fa849a34f32",symbol,
              "&sort=newest&date_from=",date_from,
              "&api_token=")

results <- GET(url = URL)

content <- content(results, "text")
content %<>%
  fromJSON(flatten = TRUE) %>% #Flatten
  as.data.frame() #Make dataframe

#Number of columns
ncol(content)


#########
names(nvda)[c(2:6)] <- c("open","high","low","close","volume")
nvda <- select(nvda, c(1:6))

stock <- nvda

