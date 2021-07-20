library(tidyverse) # Easily Install and Load the 'Tidyverse', CRAN v1.3.0
library(sf) # Simple Features for R, CRAN v1.0-0
library(geoAr) # Argentina's Spatial Data Toolbox, [github::politicaargentina/geoAr] v0.0.1.0
library(leaflet) # Create Interactive Web Maps with the JavaScript 'Leaflet' Library, CRAN v2.0.4.1
library(glue) # Interpreted String Literals, CRAN v1.4.2

# VELOCIDAD DE CARGA DE DATOS

#  library(microbenchmark) # Comparar performance
#  
#  
#  microbenchmark::microbenchmark(
#  
#  datos_read <- readr::read_csv("sesiones/data/hoteles.csv"), 
#  
#  datos_vroom <- vroom::vroom("sesiones/data/hoteles.csv")
#  
#  )
#  
# Unit: milliseconds
#                                                            expr     min        lq     mean   median        uq      max neval
# datos_read <- readr::read_csv("sesiones/data/hoteles.csv") 25.8023  36.71075  40.8425  40.4686  44.39875  71.7842   100
# datos_vroom <- vroom::vroom("sesiones/data/hoteles.csv")   98.9646 113.78025 124.0913 120.1019 128.28895 376.1721   100




datos_vroom


# SF ??? 

datos_vroom %>% 
  st_as_sf()

# CREAR COORDENADAS
#
#
#
#

# WRANGLE DATA 

# QUE PAQUETES USAMOS PARA LIMPIAR DATASET ?

datos <- datos_vroom %>%
  mutate(lat = as.character(LATITUDE), 
         lon = as.character(LONGITUDE)) %>% 
  mutate(lat = glue("{str_sub(lat, 1 ,3)}.{str_sub(lat, 4, str_length(lat))}"), 
         lon = glue("{str_sub(lon, 1 ,3)}.{str_sub(lon, 4, str_length(lon))}")) %>% 
  mutate(across(.cols = c(lat, lon), .fns = ~ as.double(.))) %>% 
  filter(!is.na(lon)) %>% 
  print()



# CONVERTIR A OBJETO SF

 puntos <- datos %>%
  st_as_sf(coords = c('lon', "lat")) %>% 
  print()

# QUE PODEMOS INFERIR DE ESTA INFO?????

 # VISUALMENTE
 leaflet(puntos) %>% 
   addCircles()  %>% 
   addArgTiles()
 
 
 # BB Arg  https://gist.github.com/graydon/11198540
 
 box <- c(xmin = -73.4154357571 , ymin =  -55.25, 
          xmax = -53.628348965, ymax = -21.8323104794)

 
hoteles <- datos %>%
  st_as_sf(coords = c('lon', "lat"), crs = 4326) %>% 
  st_crop(y = box) # BOUNDING BOX ARGENTINA


# INSPECCION VISUAL

leaflet(hoteles) %>% 
  addCircles()  %>% 
  addArgTiles()


