# CLASE 6
# GEO UTDT
# Juan Pablo Ruiz Nicolini
# 20 julio 2021


s <- livecode::serve_file()


# CARGO LIBRERIA
library(tidyverse) # Easily Install and Load the 'Tidyverse', CRAN v1.3.0
library(geoAr) # get_geo 
library(electorAr) # get_election_results


# CARGO DATOS


elccion <- get_election_results(district = "tucuman", category = "gober", round = "gral", year = 1991)

get_geo(geo = "TUCUMAN")

### 
library(glue)
nombre <- "TuQmano"
ocupacion <- "Cientista de Datos"
aniversario <- as.Date("1983-09-15")



glue("Mi nombre es {nombre}. 
     Trabajo de {ocupacion}.
     Naci el {format(aniversario, '%A, %d de %B de %Y')}")

paste("Mi nombhre es ", nombre, ".\n Trabajo de ", ocupacion)


#### PROGRAMACION
set.seed(1710)

df <- tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)



df$a <- (df$a - min(df$a)) /
  (max(df$a) - min(df$a))

df$b <- (df$b - min(df$b)) /
  (max(df$b) - min(df$a))

df$c <- (df$c - min(df$c)) /
  (max(df$c) - min(df$c))

df$d <- (df$d - min(df$d)) /
  (max(df$d) - min(df$d))



df

x <- df$a

(x - min(x)) / (max(x) - min(x))


rescale01 <- function(x){

  rng <- range(x)


  (x - rng[1]) / (rng[2] - rng[1])


}



rescale01(vector =  c(1005, 238, 154, 29))


# EJEMPLO ELECTORAR

library(electorAr)

tucuman_dip_gral_2017 %>% 
  get_names() %>% 
  arrange(desc(votos)) %>% 
  mutate(pct = round(votos/sum(votos)*100, 2))


calcular_pct <-  function(data){
 
   round(data/sum(data)*100,1)
  
}

tucuman_dip_gral_2017 %>% 
  mutate(pct = calcular_pct(votos))


source("calcular_pct.R")


#### PURRR

library(geoAr)  # para geometrías

geo <- get_geo("ARGENTINA") %>% 
  add_geo_codes()

data <- geo %>% 
  group_by(name_prov) %>% # CHEQUEAR GRUPOS 
  nest() 


dir.create("geo_arg")



data %>% 
  mutate(salida = walk2(.x = data, .y = name_prov,
                        .f = ~ st_write(obj = .x, 
                                   dsn = glue::glue("geo_arg/{.y}.geojson"))))




