# 3. faza: Vizualizacija podatkov

APPL.close <- zdruzena %>% filter(Ime == "AAPL", Tip == "Close")

ggplot(APPL.close, aes(x=Datum, y=Vrednost)) + geom_line()


graf1 <- plot(AMZN$AMZN.Open)
graf2 <- ggplot(zdruzena %>% filter(Tip == "Open",
                           Ime %in% c("AAPL","NVDA","AMZN","MSFT","AMD", "INTC","ADBE", "SNE")),
       aes(x=Datum, y=Vrednost, color=Ime)) + geom_line() + ggtitle("Cena delnic skozi čas") + 
  ylab("Cena na delnico") + xlab("Leto")
graf2
graf3 <- ggplot(zdruzena %>% filter(Tip == "Open",
                           Ime %in% c("AAPL","NVDA","AMZN","MSFT","AMD", "INTC","ADBE", "SNE")),
       aes(x=Datum, y=Vrednost, color=Ime)) + geom_line() + 
  xlim(as.Date(c("2018-08-01", "2018-12-30"))) + ylim(c(0,300))



graf3 <- ggplot(zdruzena %>% filter(Tip == "Open",
                                    Ime %in% c("NVDA", "AMD")),
                aes(x=Datum, y=Vrednost, color=Ime)) + geom_line() + 
  xlim(as.Date(c("2020-06-15", "2020-10-15"))) + ylim(c(0,600))
graf3
graf4 <- lineChart(AMZN, line.type = 'h', theme = 'black')

procentAMD <- zdruzena  %>% filter(Tip == "Open", Ime == "AMD")
procentAMD <- distinct(procentAMD)
procentAMD$Vrednost %>% sapply(`/` )

graf5 <- candleChart(NVDA, TA=c(addMACD(),addVo()), subset = '2019', theme='white')
graf6 <- candleChart(NVDA, TA=NULL, subset = '2019', theme='white')

graf7 <- chartSeries(NVDA, 
            type = c("auto", "matchsticks"), 
            subset = '2018-01::',
            show.grid = TRUE,
            major.ticks='auto', minor.ticks=TRUE,
            multi.col = TRUE,
            TA=c(addMACD(),addVo()))

graf8 <- chartSeries(NVDA, 
            type = c("auto", "matchsticks"), 
            subset = '2019-01::',
            show.grid = TRUE,
            major.ticks='auto', minor.ticks=TRUE,
            multi.col = FALSE,
            TA=c(addMACD(),addVo(),addSMA(n=200,col = 'blue'),addSMA(n=50,col = 'red'),addSMA(n=22,col = 'green'),
                 addROC(n=200,col = 'blue'),addROC(n=50,col = 'red'),addROC(n=22,col = 'green')))

urejena <- select(kapitalizacija, -c(4)) 


## Uvozimo zemljevid.
# Zemljevid


world_map <- map_data("world") %>% select(c(1:5))
a <- urejena
colnames(a)[2] <- "region"
a$region <- gsub("European Union", "Denmark", a$region)
a$region <- gsub("Nasdaq Nordic Exchanges", "Norway", a$region)
a$region <- gsub(a$region[4], "UK", a$region)
a$region <- gsub("United States", "USA", a$region)

b <- full_join(a, world_map, by = "region")

cplot <- ggplot(b, aes(x =long,y= lat, group = group, fill=Borza))+
  geom_polygon(color="white") + 
  theme_void() + coord_equal() + labs(fill="Frequency") + 
  theme(legend.position="bottom") + theme(legend.position="none")

cplot