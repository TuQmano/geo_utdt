# CLASE 6
# GEO UTDT
# Juan Pablo Ruiz Nicolini
# 3 agosto 2021


s <- livecode::serve_file()


### EJERCICIO

source("sesiones/scripts/obtener_tc_data.R")

datos_tc <- obtener_tc_data()

datos_tc %>% 
  as_tibble()


# DATA VIZ

library(tidyverse)
library(datos)


millas

millas %>% 
  ggplot() +  # DATOS 
  geom_point(mapping = aes(x = cilindrada,      
                             y = autopista, 
             color = clase)) + # ESTETICAS
  facet_wrap(~ clase, nrow = 4, scales = "free")




# DOS GEOMETRIAS

# izquierda
ggplot(data = millas) +
  geom_point(mapping = aes(x = cilindrada, y = autopista))

# derecha
ggplot(data = millas) +
  geom_smooth(mapping = aes(x = cilindrada, y = autopista))


millas %>% 
  ggplot() +  # DATOS 
  geom_point(mapping = aes(x = cilindrada,      
                           y = autopista)) +
  geom_smooth(mapping = aes(x = cilindrada,      
                            y = autopista), method = "lm")

          

ggplot(data = millas, aes(x = cilindrada, y = autopista)) +
  geom_point() +
  geom_smooth()



ggplot(millas, aes(cilindrada, autopista)) +
  geom_point() +
  geom_smooth()



ggplot(millas, aes(cilindrada, autopista)) +
  geom_point(color = "red") +
  geom_point(data = millas %>% 
               filter(fabricante == "audi"), color = "blue", size =3) +
  geom_smooth(se = FALSE) +
  labs(title = "Performance de los AUDI",  subtitle = "Un gráfico del TuQmano", 
       y = "Etiqueta Y",  x = "Etiqueta X", 
       caption = "FUENTE: {datos} 'R Para Ciencia de Datos'") +
  ggthemes::theme_wsj()  




   