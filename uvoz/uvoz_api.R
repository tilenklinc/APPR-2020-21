## NVDA stock
symbol <- "NVDA"
company <- "Nvidia"

uvozi.api <- function() {
  source("uvoz/apikeys.R")
  
  date_from = today()-dyears(5)
  
  content1 <- sprintf("http://api.marketstack.com/v1/eod?access_key=%s&symbols=%s&sort=DESC&date_from=%s",
                      marketstack_key, symbol, date_from) %>% GET()  %>% content() %>%
    .$data %>% lapply(as.data.frame, stringsAsFactors=FALSE) %>% bind_rows() %>% mutate(date=parse_datetime(date))
  
  
  #----------------urejanje tabele content1-------------------
  stock <- content1[,c(11, 13, 4, 2, 3, 1, 10)]
  
  names(stock)[c(1,7)] <- c("name","volume")
  stock <- as.data.frame(stock)
  
  write.csv2(stock, file = "uvoz/stock.csv")
}
uvozi.api()

#--------------------------uvozi novice----------------------
uvozi.news <- function() {
  source("uvoz/apikeys.R")
  date_from = "2020-12-22"
  url_news = paste0("https://newsapi.org/v2/everything?q=",
                    company,
                    "&from=",date_from,
                    "&sortBy=relevance&pageSize=100&language=en&apiKey=",newsapi_key)
  url_news
  results <- GET(url = url_news)
  news <- content(results, "text")
  news %<>%
    fromJSON(flatten = TRUE) %>% #flatten
    as.data.frame() %>% #make dataframe
    select(c(articles.title, articles.description, articles.content, articles.publishedAt))
  
  write.csv2(news, file = "uvoz/news.csv")
}
uvozi.news()