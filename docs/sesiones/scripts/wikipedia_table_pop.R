#### WIKIPEDIA 
#### #geo_Utdt
#### Población de Federaciones
#### 27  de julio 2021

# CARGO PAQUETES
library(rvest) # Easily Harvest (Scrape) Web Pages, CRAN v0.3.6
library(XML) # Tools for Parsing and Generating XML Within R and S-Plus, CRAN v3.99-0.5
library(tidyverse) # Easily Install and Load the 'Tidyverse', CRAN v1.3.0

#### Wikipedia Scraping ######
#### Example: Parsing A Table From Wikipedia
####  https://steviep42.github.io/webscraping/book/index.html#example-parsing-a-table-from-wikipedia

## ARGENTINA ####

argentina <- "https://en.wikipedia.org/wiki/List_of_Argentine_provinces_by_population"


argentina2 <- read_html(argentina) %>% 
  html_nodes(xpath = '//*[@id="mw-content-text"]/div[1]/table') %>% # Selector Gadget Copy Xpath
  html_table(fill = T)




argentina2[[1]] 


### FEDERACIONES

canada <- "https://en.wikipedia.org/wiki/List_of_Canadian_provinces_and_territories_by_population"

usa <- "https://en.wikipedia.org/wiki/List_of_states_and_territories_of_the_United_States_by_population"

mexico <- "https://en.wikipedia.org/wiki/List_of_Mexican_states_by_population"

brasil <- "https://en.wikipedia.org/wiki/List_of_Brazilian_states_by_population"

alemania <- "https://en.wikipedia.org/wiki/List_of_German_states_by_population"

rusia <- "https://en.wikipedia.org/wiki/List_of_federal_subjects_of_Russia_by_population"

china <- "https://en.wikipedia.org/wiki/List_of_Chinese_administrative_divisions_by_population"


federaciones <- c(alemania, argentina, brasil, canada, china, mexico, rusia) %>% 
  enframe(name = NULL)

### ITERACION

datos_feds <- federaciones %>% 
  mutate(data_fed = map(.x = value, 
                        .f = ~ read_html(.) %>% 
                          html_nodes(xpath = '//*[@id="mw-content-text"]/div/table' ) %>% 
                          html_table(fill = TRUE)))
library(purrr)



# EXTRAER TABLA "a lo base"
datos_feds$data_fed[[7]][[3]]
