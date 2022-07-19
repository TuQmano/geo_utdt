
tasa <- function(base, tasa = NULL){
  
  library(eph)
  library(tidyverse)
  
  assertthat::assert_that(is.data.frame(base), msg = "el argumento base tiene que ser un objeto data.frame")
  
  vars <- c("PONDERA", "ESTADO")
  chequeo <- vars %in% colnames(base)
  
  assertthat::assert_that(all(chequeo), msg='No se encuentra alguna de las variables ESTADO o PONDERA')
  
  if(tasa == "empleo"){
    
    base %>% 
      summarise(pob_tot = sum(PONDERA),
                pob_ocupada = sum(PONDERA[ESTADO == 1]),
                tasa_empleo = pob_ocupada / pob_tot * 100) %>% 
      select(tasa_empleo)   
    
  } else {
    
    if(tasa == "desempleo"){
      
      base %>% 
        summarise(pob_tot = sum(PONDERA[ESTADO %in% c(1,2)]),
                  pob_desocupada = sum(PONDERA[ESTADO == 2]),
                  tasa_desempleo = pob_desocupada / pob_tot * 100) %>% 
        select(tasa_desempleo)   
      
    } else {
      
      if(tasa == "inactividad"){
        
        base %>% 
          summarise(pob_tot = sum(PONDERA),
                    pob_inactiva = sum(PONDERA[ESTADO %in% c(3,4)]),
                    tasa_inactividad = pob_inactiva / pob_tot * 100) %>% 
          select(tasa_inactividad)  
        
      } else {
        
        if(tasa == "todas"){
          
          base %>% 
            summarise(pob_tot = sum(PONDERA),
                      pob_activa = sum(PONDERA[ESTADO %in% c(1,2)]),
                      pob_ocupada = sum(PONDERA[ESTADO == 1]),
                      pob_desocupada = sum(PONDERA[ESTADO == 2]),
                      pob_inactiva = sum(PONDERA[ESTADO %in% c(3,4)]),
                      tasa_empleo = pob_ocupada / pob_tot * 100,
                      tasa_desempleo = pob_desocupada / pob_tot * 100,
                      tasa_inactividad = pob_inactiva / pob_tot * 100) %>% 
            select(contains("tasa"))   
        }
      }
    }
  }
}
  
tasa(b_eph, tasa = "todas")
tasa(b_eph, tasa = "empleo")
tasa(b_eph, tasa = "desempleo")


