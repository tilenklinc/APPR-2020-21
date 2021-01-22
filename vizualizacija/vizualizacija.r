# 3. faza: Vizualizacija podatkov

#------------------------VSE DELNICE------------------------#
zacetne <- zdruzena %>% group_by(Ime, Tip) %>%
  slice_min(Datum, n=1, with_ties=FALSE) %>%
  transmute(Ime, Tip, ZacetnaVrednost=Vrednost)

normirana <- inner_join(zdruzena, zacetne) %>%
  mutate(NormiranaVrednost=Vrednost/ZacetnaVrednost) %>%
  select(-ZacetnaVrednost)

graf1 <- ggplot(normirana %>% filter(Tip == "Open",
                                    Ime %in% c("AAPL","NVDA","AMZN", "MSFT","AMD", "INTC","ADBE" ,"SNE")),
                aes(x=Datum, y=NormiranaVrednost, color=Ime)) + geom_line() + ggtitle("Cena delnic skozi čas") + 
  ylab("Cena na delnico [$]") + xlab("Leto") + scale_y_continuous(trans = 'log10')

graf1
#---------------Primerjava ob izdaji graficnih kartic (AMD, NVDIA)------------------#

dates_vline <- as.Date(c("2020-12-08", "2020-09-17"))
dates_vline <- which(zdruzena$Datum %in% dates_vline)

graf2 <- ggplot(zdruzena %>% filter(Tip == "Open",
                                    Ime %in% c("NVDA", "AMD")),
                aes(x=Datum, y=Vrednost, color=Ime)) + geom_line(size=0.7) + 
  xlim(as.Date(c("2020-08-15", "2020-12-31"))) + ylim(c(0,600)) + ylab("Cena delnice [$]") +
  geom_vline(xintercept = as.numeric(zdruzena$Datum[dates_vline]),col = "blue", lwd = 0.5) +
  ggtitle("Pregled cen ob izdaji novih grafičnih kartic")


#--------------------------RETURNS--------------------------#
delnice <- getSymbols.yahoo("GOOGL", src="google", From="2005-01-01", auto.assign=FALSE)[,4]

donosi <- na.omit(periodReturn(delnice,
                                  period = "monthly",
                                  type="arithmetic"))

cal_donosi <- table.CalendarReturns(donosi, digits = 1, as.perc=TRUE)
cal_donosi$monthly.returns = NULL
df= data.frame(cal_donosi)


cal_donosi$group <- row.names(cal_donosi)
cal_donosi.m <- melt(cal_donosi, id.vars="group")

graf4 <- ggplot(cal_donosi.m, aes(group, value, fill=group)) + 
  geom_boxplot(alpha=0.5, varwidth = TRUE) +
  theme(legend.position = "right") +
  ggtitle("Letni donosi delnice GOOGL") + 
  theme(plot.title = element_text(hjust=0.5)) + 
  stat_summary(fun.y = mean, geom = "point", shape=20, size=5, color="blue", fill="blue") +
  labs(x=NULL,y=NULL) + 
  scale_y_continuous(labels=function(x) paste0(x,".00%"))



