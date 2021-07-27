library(rvest) # Easily Harvest (Scrape) Web Pages, CRAN v1.0.0
library(tidyverse) # Easily Install and Load the 'Tidyverse', CRAN v1.3.0

url <- "https://tuqmano.ar"

tuq <- read_html(url)


titulos <- tuq %>% 
  html_elements(".archive-item") %>%
  html_text2()


fechas <- tuq %>% 
  html_elements(".archive-item-date") %>%
  html_text2()



#
links <- tuq %>% 
  html_elements("a") %>%
  html_attr("href")



links # necesita limpieza

links <- links %>% 
  as_tibble() %>% 
  mutate(fecha = str_sub(value, start = 2, end = 11), 
         es_fecha = lubridate::ymd(fecha)) %>% 
  filter(!is.na(es_fecha)) %>% 
  transmute(link_compelto = glue::glue("{url}{value}")) 



# JUNTO TODO
dplyr::bind_cols(titulos, fechas, links)  %>% 
  rename(titulo = 1, 
         fecha = 2)

