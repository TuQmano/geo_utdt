obtener_tc_data <- function(){
  
  #librerias necesarias
  library(rvest)
  library(tidyverse)
  
  # descargo html compelto
  cronista <- read_html("https://www.cronista.com/MercadosOnline/dolar.html")
  
  # "raspo info en formato txt"
  cronista %>% 
    html_elements(xpath = "//*[(@id = 'market-scrll-2')]//li") %>%
    html_text2()
  
}


