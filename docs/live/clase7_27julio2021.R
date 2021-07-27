# CLASE 6
# GEO UTDT
# Juan Pablo Ruiz Nicolini
# 27 julio 2021


s <- livecode::serve_file()


# EJEMPLO MERCEDES 

library(tidyverse)

df <- tibble::tibble(direccion = "ALVEAR, MARCELO T DE 1558")

df %>% separate(col = direccion, sep =  ",", # tidy
                into = c("dir2", "dir")) %>% 
  mutate(numero = str_extract(dir, pattern = "\\d{1,}"), # MAS DE 1 DIGITO,
         dir = str_remove_all(dir, pattern = "\\d"), 
         dir = str_squish(dir)) # ELIMIO ESPACIO EN BLANCO) %>% # ELIMINO NUMERO
  transmute(direccion = glue::glue("{dir} {dir2} {numero}"))
  
### RUMBA
 
 library(RUMBA)

  
library(googlesheets4)
googlesheets4::gs4_deauth()  
  
df <- googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/1GT5x04e_T0voMFL4Ey8uqDIKZEyUulan6Q7F4as7NPQ/edit?usp=sharing", )
    
  RUMBA::mutate_USIG_geocode(data = df, address = "calle")
  
df2 <- df %>%
  dplyr::slice(1:10)
  
georefar::get_ubicacion()  


### SCRAPEO


  

  