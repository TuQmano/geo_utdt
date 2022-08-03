library(sf)
library(tidyverse)
library(geoAr)
library(units)


radios <- read_sf("https://github.com/PoliticaArgentina/data_warehouse/raw/master/geoAr/data/radios_simplified.geojson")

  meta_data <- geo_metadata %>% 
    select(contains("prov")) %>% 
  #  print(n = 20)
    distinct()

class(radios)

radios_nombres_prov <- radios %>% 
  transmute(codigo = str_sub(link, start = 1, end = 2)) %>% 
  left_join(meta_data, by = c("codigo" = "codprov_censo")) %>% 
  filter(codigo == "02")


mapview::mapview()


geoAr::show_arg_codes(viewer = TRUE)

radios_nombres_prov
get_geo(geo = "ARGENTINA") %>% 
  plot()



chaco <- get_geo(geo = "CHACO") %>% 
  add_geo_codes() %>% 
  select(nomdepto_censo) %>% 
  mutate(area = set_units(x = st_area(geometry), km^2)) %>% 
  arrange(area)




  ggplot(chaco) +
  geom_sf() + 
  geom_sf_text(aes(label = nomdepto_censo))


