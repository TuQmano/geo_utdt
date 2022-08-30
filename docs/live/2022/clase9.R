
#  1. cargo librerias ####
library(tidyverse)
library(sf)
library(geoAr)

link <- "https://cdn.buenosaires.gob.ar/datosabiertos/datasets/sbase/subte-viajes-molinetes/molinetes-2022.zip"



#create a couple temp files

temp <- tempfile()

temp2 <- tempfile()

#download the zip folder from the internet save to 'temp' 
download.file(link,temp)
#unzip the contents in 'temp' and save unzipped content in 'temp2'
unzip(zipfile = temp, exdir = temp2)

ruta <- list.files(temp2, full.names = TRUE)

(datos <- read_csv2(ruta))

##### EJEMPLO SIXTO (FAILED) ####
link_sixto <- "https://cdn.buenosaires.gob.ar/datosabiertos/datasets/relevamiento-usos-del-suelo/relevamiento-usos-suelo-2017.geojson"

usos <- st_read(link_sixto,
                query = 'SELECT * FROM "link_sixto" WHERE COMUNA == 1')





### Ejemplo TUQMANO #### 

tuc_properati <- read_csv("sesiones/data/tucuman_properati.csv")

skimr::skim(tuc_properati)

class(tuc_properati)

tuc_geo <- tuc_properati %>% 
  filter(if_any(.cols = c(lat, lon), 
                .fns = ~ !is.na(.))) %>% 
  st_as_sf(coords = c("lon", "lat"), crs = 4326 )

colnames(tuc_properati)
colnames(tuc_geo)

tuc_geo 

#geometria de tucuman
tucu_shape <- geoAr::get_geo("TUCUMAN") %>% 
  add_geo_codes()


tucu_shape$nomdepto_censo

unique(tuc_properati$l3)


library(ggplot2)

ggplot(tucu_shape) +
  geom_sf() +
  geom_sf(data = tuc_geo)


mapview::mapview(tuc_geo)



filtrado <- sf::st_intersection(x = tuc_geo, y = tucu_shape)

publicaciones <- filtrado %>% 
  st_set_geometry(NULL) %>% 
  # as.data.frame() %>% 
  # select(-geometry) %>% 
  # as_tibble() %>% 
  group_by(nomdepto_censo, coddepto_censo) %>% 
  summarise(cantida = n()) %>% 
  arrange(desc(cantida))


area <- tucu_shape %>% 
  mutate(area = units::set_units(st_area(geometry),  km^2)) %>% 
  select(coddepto_censo, area)

datos <- left_join(publicaciones, area, by = "coddepto_censo") %>% 
  mutate(indicador = as.numeric(cantida/area)) %>% 
  st_as_sf() 





mapa1 <- ggplot(datos) +
  geom_sf(data = tucu_shape)+
  geom_sf(aes(fill = indicador)) +
  scale_fill_viridis_c(option = "B") +
  cowplot::theme_map() +
  labs(fill = "Publicaciones x Km2")



grilla <- geoAr::get_grid("TUCUMAN")

geoTUC <- filtrado %>% 
  st_set_geometry(NULL) %>% 
  group_by(nomdepto_censo, coddepto_censo, property_type) %>% 
  summarise(n = n()) %>% 
  ggplot() +
  geom_col(aes(x = n, y = property_type)) +
  geofacet::facet_geo(~ nomdepto_censo, grid = grilla)+ 
  theme_minimal() +
  labs(x = "", y = "")


library(patchwork)


geoTUC + mapa1


