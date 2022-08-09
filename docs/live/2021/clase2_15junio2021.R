
##### CLASE 2 - CODIGO EN VIVO ################
# Instrumentos de Análisis Urbanos II 
# Universidad Torcauto Di Tella - MEU
# Juan Pablo Ruiz Nicolini
########################################

curso <- data.frame(nombre= c("Juan", "Pedro", "María", "José", 
                              "Enzo", "Ariel", "Eva"),
                    edad= c(25, 32, 21,40, 
                            30, 28, 37),
                    nacim= c(1993, 1986, 1997, 1978,
                             1988, 1990, 1981),
                    software.primario= c("spss", "stata", "stata", 
                                         "excel", "R", "stata",
                                         "spss"),
                    nivel= c(3, 5,7, 6,
                             2, 6, 8) 
)

mean(curso$edad)  

sum(curso$edad)/length(curso$edad)


curso$edad

library(electorAr)

elecciones <- show_available_elections(source = "data")


as.data.frame(elecciones)

gral2015 <-  get_election_data(district = 'arg', 
                               category = 'presi', 
                               round = 'gral', 
                               year = 2015, 
                               level = "departamento")
base <- get_names(gral2015)  
  

unique(base$nombre_lista)

fit <- base[base$nombre_lista == 'ALIANZA FRENTE DE IZQUIERDA Y DE LOS TRABAJADORES', ] # > BASE
fit[fit$votos == max(fit$votos),]

library(tidyverse)

base %>% 
  filter(nombre_lista == 'ALIANZA FRENTE DE IZQUIERDA Y DE LOS TRABAJADORES') %>% 
   ungroup() %>% 
  slice_max(votos)


