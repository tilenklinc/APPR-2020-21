# 4. faza: Analiza podatkov
## NVDA stock
symbol <- "NVDA"
company <- "Nvidia"

#------------------------ZEMLJEVID------------------------#
urejena <- kapitalizacija[-c(4)]
world_map <- map_data("world") %>% select(c(1:5))
a <- urejena
colnames(a)[2] <- "region"
a$region <- gsub("European Union", "Denmark", a$region)
a$region <- gsub("Nasdaq Nordic Exchanges", "Norway", a$region)
a$region <- gsub(a$region[4], "UK", a$region)
a$region <- gsub("United States", "USA", a$region)

b <- full_join(a, world_map, by = "region")

cplot <- ggplot(b, aes(x =long,y= lat, group = group, fill=Market_cap))+
  geom_polygon(color="white") + 
  theme_void() + coord_equal() + labs(fill="Vrednost tržne kapitalizacije[bio$]") + 
  theme(legend.position="right")


#datatable(stock)

#-----------------------TRENDS------------------------------
#trends
trends <- gtrends(keyword = symbol, geo = "US", onlyInterest = TRUE)
trends <- trends$interest_over_time %>%
  as_tibble() %>%
  select(c(date, hits, keyword))

trends$date <- as_date(ceiling_date(trends$date, unit = "weeks", change_on_boundary = NULL,
                                    week_start = getOption("lubridate.week.start", 1)))

#Pogostost google zadetkov
graf5 <- trends %>%  
  plot_ly(x=~date, y=~hits, mode = 'lines', name = "Trend Google iskanja") %>%
  layout(title = paste0(symbol,": Zanimanje skozi čas"),
         yaxis = list(title = "iskanja"),
         xaxis = list(title = "datum"))

#povezava med zadetki in ceno delnice
graf6 <- trends %>%
  left_join(stock, by = "date") %>%
  select(one_of(c("date", "hits", "close"))) %>%
  drop_na() %>%
  ggplot(aes(hits, close)) + geom_point(color="orange") + geom_smooth(color = "blue") +
  labs(title =paste0(symbol,": Zveza med Google iskanji in ceno")) + ylab("cena ob zaprtju [$]") + xlab("zadetki")

#----------------------------ČLANKI-------------------------------
news_words <- news %>%
  select(c("articles.title","articles.description", "articles.content", "articles.publishedAt")) %>%
  unnest_tokens(word, articles.description) %>%
  filter(!word %in% append(stop_words$word, values = "chars"), str_detect(word, "^[a-z']+$"))
news_words$date = as_date(news_words$articles.publishedAt)

words_only <- news_words %>% count(word, sort =TRUE)

set.seed(1)

#graf 
#wordcloud(words = words_only$word, freq = words_only$n,scale=c(5,.5), max.words=50, colors=brewer.pal(8, "Dark2"))

#----------------------VTIS članka--------------------------
afinn <- get_sentiments("afinn")

sentiment_summary <- news_words %>%
  left_join(afinn) %>% 
  filter(!is.na(value)) %>%
  group_by(articles.title, date) %>%
  summarise(value = mean(value)) %>%
  mutate(sentiment = ifelse(value>0, "pozitiven","negativen")) 

#vse novice
#datatable(sentiment_summary)
graf8 <- ggplot(sentiment_summary, aes(date, value)) +
  geom_bar(stat = "identity", aes(fill=sentiment)) +
  ggtitle(paste0(symbol, ": Vtis novic skozi čas")) 
