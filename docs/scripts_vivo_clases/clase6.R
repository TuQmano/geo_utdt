library(geoAr) 
library(tidyverse)


geoAr::show_arg_codes(viewer = T) # VIEWER TRUE requiere de dependencia de paquete {gt} 



### PARA DESCARGAR DE MANERA SENCILLA GEOMETRIAS DE ARGENTINA
### A DISTINTOS NIVELES (PROVINCIA, DEPARTAMENTO, RADIOS CENSALES) con parametro level
### CORRESPONDIENTES A GEOMETRIAS DEL CENSO 2010 (INDEC)
### CON PARAMETRO simplified (por defeccto TRUE) PARA OBTENER GEOMETRIAS LVIANAS / CRUDAS


tuc <- get_geo(geo = "TUCUMAN") # NIVEL PROVINCIAL SIMLPIFIADO


plot(tuc)  # PREVISUALIZAR GEOMETRIA Y ATRIBUTOS

tuc <- get_geo(geo = "TUCUMAN", simplified = FALSE) # NIVEL PROVINCIAL 'ORIGINAL'


# QUE TIPO DE OBJETO DEVUELVE {geoAr} ? 

## libreria {sf} / SIMPLE FEATURES

class(tuc)

## Transformamos datos originales *eliniamos 'sf' de nuestro dataset

tuc2 <- as.data.frame(tuc)

class(tuc2)




### DIFERNECiA VISUAL DE SIMPLIFICACION (CABA)

get_geo("CABA", simplified = FALSE) %>% 
  plot()

get_geo("CABA", simplified = TRUE) %>% 
  plot()



library(polArverse) # el universo de paquetes de POLitica ARgentina (polAr)

# QUE ELECCIONES PUEDO DESCARGAR????
electorAr::show_available_elections(viewer = T,
                                    source = "data")

# ME QUEDO CON PARAEMTROS PARA DESCARGAR ELECCION DE TUCUMAN A NIVEL DEPARTAMENTAL *para mapear
tucuman_2005 <- get_election_data(district = "tucuman",	
                                  category = "dip",	
                                  round = "gral",	
                                  year = 2005, 
                                  level = "departamento")


tuc3 <- tuc %>%  # GEOMETRIAS TUCUMAN via {geoAr}
  geoAr::add_geo_codes() %>%  # AGREGO CODIGOS / ID ALTERNATIVOS
  select(contains("coddepto")) # ME QUEDO CON VARIABLES NECESARIAS PARA VINCULAR DATOS ELECTORALES CON GEOMETRIAS

# VINCULO DATOS ESPACIALES CON ELECTORALES
tucuman_2005 %>% 
  left_join(tuc3)  ### PERO NO DEVUEVLE UN OBJETO {sf}!!!


# Utilizo st_as_sf() para reconvertir nuestro dataset y poder trabajar GIS
geo_electoral <- tucuman_2005 %>% 
  left_join(tuc3) %>% 
  sf::st_as_sf()

class(geo_electoral)


  
# Ejemplo aplicado de base GEO con otra fuente de datos (elecotral)


datos_basicos <- geo_electoral %>% 
  select(electores, depto) %>% 
  distinct()
ggplot() +
  geom_sf(data = datos_basicos, 
          aes(fill = electores)) +
  scale_fill_viridis_c() +
  geom_sf(data = centroide_tuc)



  ### FUENTES DE DATOS ALTERNATIVAS DE {geoAr}

# Base de Asentamientos Humanos de la Republica Argentina
  get_bahra(geo = "TUCUMAN")
  
# Obtener geometrias de la Encuesta Permanente de Hogares (EPH) del INDEC  
  
  get_eph()

  
  
  ## TRANSFORMACION DE GEOMETRIAS   polygon -> centroide
  
  
 centroide_tuc <-  sf::st_centroid(tuc)
  
 
 