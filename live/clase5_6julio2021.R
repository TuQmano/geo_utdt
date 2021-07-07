s <- livecode::serve_file()

# CLASE 5 - geo

library(geoAr)

argentina <- get_geo("ARGENTINA")

library(sf)

argentina %>% 
  st_write("docs/mapasad_arg.geojson")

# vroom::vroom("www.datos_salud/covid.csv")

plot(argentina)

show_arg_codes() %>% 
  print(n = Inf)


argentina2 <- get_geo("ARGENTINA",
                      simplified = FALSE)

argentina2 %>% 
  st_write("docs/mapas_arg2.geojson")



# MISCELANEAS

argentina %>% 
 add_geo_codes() %>% 
  mapview::mapview()


mapedit::editFeatures(argentina)



# SIMPLIFY GEOMETRY


library(tidyverse) # Easily Install and Load the 'Tidyverse', CRAN v1.3.0
library(sf) # Simple Features for R, CRAN v0.9-7
library(ggplot2) # Create Elegant Data Visualisations Using the Grammar of Graphics, CRAN v3.3.3
library(rmapshaper) # Client for 'mapshaper' for 'Geospatial' Operations, CRAN v0.4.4

#### MAP ARGENTINA w/ PROVS ####

#create a couple temp files

temp <- tempfile()

temp2 <- tempfile()

#download the zip folder from the internet save to 'temp' 
download.file("https://www.indec.gob.ar/ftp/cuadros/territorio/codgeo/Codgeo_Pais_x_prov_datos.zip",temp)
#unzip the contents in 'temp' and save unzipped content in 'temp2'
unzip(zipfile = temp, exdir = temp2)
#finds the filepath of the shapefile (.shp) file in the temp2 unzip folder
#the $ at the end of ".shp$" ensures you are not also finding files such as .shp.xml 
your_SHP_file<-list.files(temp2, pattern = ".shp$",full.names=TRUE)

#read the shapefile. Alternatively make an assignment, such as f<-sf::read_sf(your_SHP_file)
mapa_arg <- sf::read_sf(your_SHP_file) %>% 
  select(codprov_censo = link, 
         geometry)

plot(mapa_arg)


mapa_arg %>%
  st_crop(xmin = -78.844299, ymin = -56.918980,
          xmax = -53.531800, ymax = -20.341163) %>% 
  plot()

mapa_arg %>%
  st_crop(xmin = -78.844299, ymin = -56.918980,
          xmax = -53.531800, ymax = -20.341163) %>% 
  st_write("../../mapa1.geojson")



# SIMPLIFY PROVS
mapa_arg %>% 
  rmapshaper::ms_simplify() %>%
  st_crop(xmin = -78.844299, ymin = -56.918980,
          xmax = -53.531800, ymax = -20.341163) %>% 
  st_write("../../mapa2.geojson")




