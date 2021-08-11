### mapsf


library(geoAr) # Argentina's Spatial Data Toolbox, [github::politicaargentina/geoAr] v0.0.1.0
library(mapsf) # Thematic Cartography, CRAN v0.2.0
library(electorAr) # Toolbox for Argentina's Electoral Data, [github::PoliticaArgentina/electorAr] v0.0.1.0
library(tidyverse) # Easily Install and Load the 'Tidyverse', CRAN v1.3.0

tuc <- get_geo("TUCUMAN")


electores <- get_election_data(district = "tucuman", 
                               category = "dip", 
                               round = "gral", 
                               year = 2017,
                               level = "departamento") %>% 
  select(electores) %>% 
  distinct()


tuc2 <- tuc %>% 
  add_geo_codes() %>% 
  left_join(electores)

### MAPSF


mf_init(tuc2, theme = "iceberg")

mf_shadow(tuc2, add = T)

mf_map(tuc2, add = T)

mf_map(tuc2, 
       var = "electores", 
       type = "prop", 
       inche = 0.25, 
       col = "red", 
       leg_title = "Electores")

mf_layout(title = "TUCUMAN - Elección 2017", credits = "DATOS: (a) electorales con {electorAr}\n
          (b) geometrías con {geoAr} \n 
          (c) mapa con {mapsf}")


### Inset maps

mf_map(tuc2)
mf_inset_on(x = "worldmap")
mf_worldmap(tuc2)
mf_inset_off()



# https://github.com/rCarto
# https://github.com/riatelab/maptiles

