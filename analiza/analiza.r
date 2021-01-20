# 4. faza: Analiza podatkov

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

cplot

