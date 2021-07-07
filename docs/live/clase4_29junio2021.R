s <- livecode::serve_file()

getwd()

setwd("../../")
  
### EJRCICIO CLASE 4 

library(googlesheets4) # Access Google Sheets using the Sheets API V4, CRAN v0.3.0
library(janitor) # Simple Tools for Examining and Cleaning Dirty Data, CRAN v2.1.0
library(tidyverse) # Easily Install and Load the 'Tidyverse', CRAN v1.3.0

googlesheets4::gs4_deauth() # Elimina autorizacion interactiva con Google

tp1 <- read_sheet("https://docs.google.com/spreadsheets/d/1lOmFtE291lVjy8w8UwramgnIEgcvwz0iIq0VqvjMp5A/edit?usp=sharing") %>% 
  clean_names()


tp1 %>% 
  filter(!is.na(alumne_apellido_nombre))

# + dplyr -> Properati 

datos <- vroom::vroom("https://storage.googleapis.com/properati-data-public/ar_properties.csv.gz")

muestra <- datos %>% 
  slice(1:100000)


skimr::skim(muestra) # Descronor set de datps y variables

muestra %>% 
  rename(provincia = l2) %>% 
  group_by(provincia) %>% 
  summarize(cantidad = n()) %>% 
  arrange(desc(cantidad)) %>% 
  mutate(provincia2 = case_when(
    str_detect(string = provincia, pattern = "Bs.As") ~ "PBA", 
    str_detect(string = provincia, pattern = "Buenos Aires") ~ "PBA", 
    TRUE ~ provincia
  )) %>% 
  print(n = Inf)



#### 

library(geoAr) # Argentina's Spatial Data Toolbox, [github::politicaargentina/geoAr] v0.0.1.0

(codigos <- show_arg_codes(nivel = "departamentos"))


get_geo(geo = "TUCUMAN") %>% 
  dplyr::left_join(codigos, by = c("codprov_censo", "coddepto_censo"))



# STRIGR
library(tidyverse)

codigos %>% 
  transmute(id, 
            codprov,
            codprov2 = str_pad(string = codprov,width = 3, side = "left", pad = 1 ))
  
# LUBRIDATE

library(lubridate) # (a)
dmy("6/10/2020")


today() -7 


# 
