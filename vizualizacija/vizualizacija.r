# 3. faza: Vizualizacija podatkov

plot(AMZN$AMZN.Open)
ggplot(zdruzena %>% filter(Tip == "Open",
                           Ime %in% c("AAPL","NVDA","AMZN","MSFT","AMD", "INTC","ADBE", "SNE")),
       aes(x=Datum, y=Vrednost, color=Ime)) + geom_line()
  
ggplot(zdruzena %>% filter(Tip == "Open",
                             Ime %in% c("AAPL","NVDA","AMZN","MSFT","AMD", "INTC","ADBE", "SNE")),
         aes(x=Datum, y=Vrednost, color=Ime)) + geom_line() +
    scale_x_continuous(limits = seq(as.Date("2012-02-12"), as.Date("2014-02-12"), by = "1 year"))
  xx <- zdruzena[zdruzena$Datum >= "2012-01-01" & zdruzena$Datum <= "2013-01-01",1]


#lineChart(AMZN, line.type = 'h', theme = 'white')

#candleChart(AMZN, TA=c(addMACD(),addVo()), subset = '2019')

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
