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
  ggtitle("Letni donosi delnice ZM") + 
  theme(plot.title = element_text(hjust=0.5)) + 
  stat_summary(fun.y = mean, geom = "point", shape=20, size=5, color="blue", fill="blue") +
  labs(x=NULL,y=NULL) + 
  scale_y_continuous(labels=function(x) paste0(x,".00%"))


#------------------------TRENDS------------------------#

trends <- gtrends(keyword = symbol, geo = "US", onlyInterest = TRUE)
trends <- trends$interest_over_time %>%
  as_data_frame() %>%
  select(c(date, hits, keyword))
trends$date <- as_date(ceiling_date(trends$date, unit = "weeks", change_on_boundary = NULL,
                                    week_start = getOption("lubridate.week.start", 1)))
trends %>%  
  plot_ly(x=~date, y=~hits, mode = 'lines', name = "Google Search Trends") %>%
  layout(title = paste0("Interest over Time: ",symbol), yaxis = list(title = "hits"))

trends %>%
  left_join(stock, by = "date") %>%
  select(one_of(c("date", "hits", "close"))) %>%
  drop_na() %>%
  ggplot(aes(hits, close)) + geom_point(color="blue") + geom_smooth(model=lm, color = "black") +
  labs(title =paste0(symbol,": Relationship between Hits and Close Stock Price"))


#------------------------ZEMLJEVID------------------------#

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

cplot

