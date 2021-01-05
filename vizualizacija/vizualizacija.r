# 3. faza: Vizualizacija podatkov

APPL.close <- zdruzena %>% filter(Ime == "AAPL", Tip == "Close")

ggplot(APPL.close, aes(x=Datum, y=Vrednost)) + geom_line()


graf1 <- plot(AMZN$AMZN.Open)
graf2 <- ggplot(zdruzena %>% filter(Tip == "Open",
                           Ime %in% c("AAPL","NVDA","AMZN","MSFT","AMD", "INTC","ADBE", "SNE")),
       aes(x=Datum, y=Vrednost, color=Ime)) + geom_line()
  
graf3 <- ggplot(zdruzena %>% filter(Tip == "Open",
                           Ime %in% c("AAPL","NVDA","AMZN","MSFT","AMD", "INTC","ADBE", "SNE")),
       aes(x=Datum, y=Vrednost, color=Ime)) + geom_line() + 
  xlim(as.Date(c("2020-10-01", "2020-11-01"))) + ylim(c(0,600))

graf4 <- lineChart(AMZN, line.type = 'h', theme = 'black')

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

## Uvozimo zemljevid.
#zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip", "OB",
#                             pot.zemljevida="OB", encoding="Windows-1250")
## Če zemljevid nima nastavljene projekcije, jo ročno določimo
#proj4string(zemljevid) <- CRS("+proj=utm +zone=10+datum=WGS84")
#
#levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
#  { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
#zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels=levels(obcine$obcina))
#
## Izračunamo povprečno velikost družine
#povprecja <- druzine %>% group_by(obcina) %>%
#  summarise(povprecje=sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))
