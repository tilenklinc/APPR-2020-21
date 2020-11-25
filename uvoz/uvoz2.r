# 2. faza: Uvoz podatkov

#Delnice
#Simboli:
#Apple(AAPL), Nvidia Corporation(NVDA), Amazon.com(AMZN), Microsoft(MSFT),
#AMD(AMD), Intel Corp(INTC), Alphabet Inc(GOOGL), Adobe(ADBE), Zoom(ZM), Facebook(FB)

library(quantmod)
library(xml2)
library(rvest) #! lahko izbrišeš

symbols <- c("GOOGL","AAPL","NVDA","AMZN","MSFT","AMD", "INTC","ADBE")

getSymbols(symbols, src = "yahoo", from = "2010-01-01", to = "2020-11-01", auto.assign = TRUE)

#HTML

uvozi.kapitalizacijo <- function() {
  url <- "https://en.wikipedia.org/wiki/List_of_stock_exchanges"
  stran <- read_html(url)
  tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
    .[[1]] %>% html_table(dec=",", fill = TRUE)
  for (i in 1:ncol(tabela)) {
    if (is.character(tabela[[i]])) {
      Encoding(tabela[[i]]) <- "UTF-8"
    }
  }

  colnames(tabela) <- c("Rang", "Leto", "Borza","Simbol", "Regija", "Kraj",
                        "Tržna kapitalizacija", "Mesečni trading volumen",
                        "Časovni pas", "Sprememba", "DST", "Odprtje", "Zaprtje",
                        "Kosilo", "Odprtje(UTC)", "Zaprtje(UTC)")
#Izbris stolpcev
  tabela$
