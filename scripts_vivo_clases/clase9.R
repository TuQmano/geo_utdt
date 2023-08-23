#### CARGAR LIBRERIAS

library(dplyr) # A Grammar of Data Manipulation, CRAN v1.1.2 # Tidy Messy Data, CRAN v1.1.4 # Create Elegant Data Visualisations Using the Grammar of Graphics, CRAN v3.4.2
library(ggplot2) # Create Elegant Data Visualisations Using the Grammar of Graphics, CRAN v3.4.2 # A Grammar of Data Manipulation, CRAN v1.1.2
library(dplyr) # A Grammar of Data Manipulation, CRAN v1.1.2 # Tidy Messy Data, CRAN v1.1.4
library(ggplot2) # Create Elegant Data Visualisations Using the Grammar of Graphics, CRAN v3.4.2


### Uso de annotater para comentar librerias utilizadas https://github.com/luisDVA/annotater

options(scipen = 999)


## geoAr - Facets ----

### Grillas ----
show_arg_codes(viewer = T) # Exploro ID de grillas

argentina <- get_grid(district = "ARGENTINA") # Descargo Grilla ARG


### Datos Electorales ----


show_available_elections(source = "data",
                         viewer = TRUE) # PARA EXPLORAR ELECCIONES DISPONIBLES PARA DESCARGA

# DESCARGI ELECCION DE INTERES: Balotage Presidente 2015
datos_electorales <- get_election_data(district = "arg", # Para toda ARGENTINA	
                                       category = "presi", # Categoria PRESIDENTE
                                       round = 	"balota", # Turno BALOTAGE
                                       year = 	2015, # Ciclo elecotral AÑO 2015
                                       level = "provincia") %>% # A nivel agregado PROVINCIA
  get_names() # Agrego nombre de listas (data.frame original solo incluye el codigo de lista)

### Data Wragnle ----


datos_electorales2 <- datos_electorales %>%  # Me guardo un nuevo objeto con transformaciones
  mutate(votos_pct = votos/sum(votos)) %>% # CALCULO % VOTOS  
  rename(code = codprov) # renombro variable de interes



### ggplot FACET ----
# Visaulizacion de datos electorels con una "apetura" por provincia

ggplot(datos_electorales2) + # inicio a un objeto ggplot2
  geom_col(aes(x = votos_pct, # agrego GEOMETRIA de Columnas (%Votos por partido)
               y = nombre_lista)) +
  facet_wrap(facets = ~ name_prov) # facetamos ("small multiples") por Nombre de Distirto


### Prueba de concpeto geofacet ----

# Al ejercicio anterior podemos cambiarle solamente la sentencia de facetado
# para ordenar las "GRILLAS COMO SI FUERAN MAPAS"


ggplot(datos_electorales2) +
  geom_col(aes(x = votos_pct, 
               y = nombre_lista, fill = nombre_lista)) +
#  facet_wrap(facets = ~ name_prov) 
geofacet::facet_geo(grid = argentina, 
                    facets = ~ code, 
                    label = "name")




## sf - ggplot ----

#### Descargo geometria

arg_geom <- get_geo(geo = "ARGENTINA", level = "provincia")



#### Unir datos

data_completa <-  arg_geom %>% 
  add_geo_codes() %>% 
  left_join(datos_electorales, by = "codprov")

#### Domar datos


x <-  data_completa %>% 
  select(nombre_lista, votos, everything()) %>% 
  filter(nombre_lista %in% c("FRENTE PARA LA VICTORIA", "CAMBIEMOS")) %>%
  select(-listas) %>% 
  pivot_wider(names_from = "nombre_lista", values_from = "votos") %>% 
  janitor::clean_names() %>% 
  mutate(dif =  frente_para_la_victoria - CAMBIEMOS)

#### Viz de mapa estatico


ggplot(x) +
  geom_sf(aes(fill = dif))

#### EJEMPLO MAPA electorAr + polArViz ----
# https://github.com/PoliticaArgentina/polArViz/blob/master/R/map_results.R


library(polArViz)


polArViz::map_results(datos_electorales %>%  
                        select(-nombre_lista))



#### Viz de mapa estatico


mapa_balotage <-   ggplot(x) +
  geom_sf(aes(fill = dif)) 


# Funciones auxiliares para INSETS de mapas en {polArViz}
# https://politicaargentina.github.io/polArViz/



# CABA
polArViz::inset_caba(ggplot_map = mapa_balotage)

# ANTARTIDA
polArViz::inset_antartida(mapa_balotage)


### Theme Map
mapa_balotage +
  # cowplot::theme_map +
  ggthemes::theme_fivethirtyeight()


## mapsf ----

# Caracterizar el peso electoral de los Departamentos de TUCUMAN

library(mapsf) # Thematic Cartography, CRAN v0.2.0

# Con librería geoAr
tuc <- get_geo("TUCUMAN") # Descargo dataframe con geometrias a nivel departamento (por defecto)

# Con librería electorAr. Descargo datos electorales de 2017
electores <- get_election_data(district = "tucuman", # distrito TUCUMAN
                               category = "dip",  # Categoria DIPUTADOS
                               round = "gral",  # Turno electoral GENERAL
                               year = 2017,  # Ciclo electoral AÑO 2017
                               level = "departamento") %>%  # Nivel de los datos agregados DEPARTAMENTO
  select(electores) %>%  # Me quedo con la variable de interes para representar graficamente ELECTORES
  # Dado que hasta el paso previo cada fila esta el nivel de lista/partido asociado a sus votos
  # y la cantidad de electores es una CONSTANTE para cada GRUPO (Depto)
  # nos quedamos con una unica fila (cantidad de electores) por DEPARTAMENTO
  distinct() 


# Aumentamos metadadtos geograficos (con ID de entidades geograficas: DEPTO) para vincular nuestra
# GEOMETRY (geoAr, con codprov_censo) con nuestros datos de electores (electorAr, con codpov)

tuc2 <- tuc %>% # Dataframe GIS original
  add_geo_codes() %>% # Agregamos comlumnas con codigos de distritos utiles para la union
  left_join(electores) # agregamos datos electores correspondientes a cada departamento

### MAPSF

# Layout del mapa a diseñar
mf_init(tuc2, theme = "iceberg") # inicializa un mapa , con un theme pre definido

mf_shadow(tuc2, add = T)  # Genera una "SOMBRA" de la geometría de base 

mf_map(tuc2, add = T)  # Grafica mapa / geometria (Deptos de TUCUMAN descargados con agaeoAr) con poligonos

mf_map(tuc2,  # Sobre el objeto anterior calcula una geometría (en el centroide) y grafica un POINT 
       var = "electores", # en funcion de la variable de interes
       type = "prop", # del tipo PROP con detamindadas eteticasaaaaaaaaaaaaa
       inche = 0.25, 
       col = "red", 
       leg_title = "Electores")

# Agrega referencias
mf_layout(title = "TUCUMAN - Elección 2017", credits = "DATOS: (a) electorales con {electorAr}\n
          (b) geometrías con {geoAr} \n 
          (c) mapa con {mapsf}")


### Inset maps

mf_map(tuc2) # Incio canvas
mf_inset_on(x = "worldmap") # activo funcion para agregar inset de ubicacion geo mundial
mf_worldmap(tuc2) # agrego mapa mundo con referencia de tucuman
mf_inset_off() # apago funcion para insets





