caba <- geoAr::get_geo("CABA")

class(caba)

library(ggplot2)


p <- ggplot(data = caba) +
  geom_sf(color = "yellow", 
#          fill = "red", 
          alpha = .3 )
p



#### READ HTML

library(rvest)

scrapeo <- read_html("https://www.utdt.edu/")

#####


p +
 aes(fill = p$data$coddepto_censo)


library(ggplot2)
library(patchwork) # instrall.packages("patchwork")

p1 <- ggplot(mtcars) + geom_point(aes(mpg, disp))
p2 <- ggplot(mtcars) + geom_boxplot(aes(gear, disp, group = gear))

p1 + p2



p3 <- ggplot(mtcars) + geom_smooth(aes(disp, qsec))
p4 <- ggplot(mtcars) + geom_bar(aes(carb))


(p1 | p2 | p3) /
  p4


caba
library(electorAr)
show_available_elections(source = "results") %>% 
  dplyr::filter(district == "caba")

electores <- electorAr::get_election_data("caba",   
                                          "dip",   
                                          "gral", 2015, level = "departamento")

library(dplyr)

pob <- electores %>%
  select(electores) %>% 
  slice(1)

library(ggrepel)
library(ggsflabel)

nuestro_mapa <- caba %>% 
  geoAr::add_geo_codes() %>% 
  left_join(pob) %>% 
 # select(electores) %>% 
  ggplot() +
  geom_sf(aes(fill = electores/sum(electores)*100)) +
  geom_sf_label(aes(label = depto)) +
  scale_fill_viridis_c() +
  theme_void() +
  labs(title = "Un titulo", 
       fill = "Cantidad de Electores",
       caption = "Un grafico de geo_utdt") +
  theme(legend.position = "bottom")



library(ggplot2)


tabla <- electores %>% 
  slice(1) %>% 
  ungroup() %>% 
  select(depto, electores)



tablaOk <- gridExtra::tableGrob(tabla)


nuestro_mapa + tablaOk


library(hrbrthemes)
# SQUISSE
ggplot(electores) +
  aes(x = listas, weight = votos) +
  geom_bar(fill = "#0c4c8a") +
  theme_minimal() +
  facet_wrap(vars(depto))+
  theme_ipsum() +
  coord_flip()


# FUENTES

library(extrafont)
loadfonts()

tabla <- extrafont::fonttable()
