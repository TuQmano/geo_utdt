### geo_utdt
### Juan Pablo Ruiz Nicolini
### 2 de agostro de 2021

# LIBRERIAS

library(vroom) # Read and Write Rectangular Text Data Quickly, CRAN v1.5.1
library(tidyverse) # Easily Install and Load the 'Tidyverse', CRAN v1.3.0
library(skimr) # Compact and Flexible Summaries of Data, CRAN v2.1.3

# CARGO DATOS 

properati_tuc <- vroom::vroom("sesiones/data/tucuman_properati.csv")


# EXPLORAMOS DATOS (Alternativas)

head(properati_tuc) # tail(properati_tuc)

str(properati_tuc)

summary(properati_tuc)

skimr::skim(properati_tuc)



# EDA Visual

# COMO SE DISTRIBUYEN LAS PUBLICACIONES ?



# LIMPIEZA DE DATOS
(datos_seleccion <- properati_tuc %>% 
  select(l1, l2, l3, operation_type, created_on) %>% 
  rename(localidad = l3, 
           tipo_operacion = operation_type, 
           fecha = created_on) %>% 
  filter(!is.na(localidad)
         )
  )


# TRANSFORMACION / CUENTAS: CANTIDAD DE PUBLICACIONES POR LOCALIDAD - FECHA
(datos_plot <- datos_seleccion  %>%
  group_by(localidad, fecha) %>% 
  summarise(n = n()))  
 
 ggplot(data = datos_plot) + 
  geom_point(mapping = aes(x = fecha, 
                           y = localidad, 
                           size = n))
 
 
 ### SEGUNDO INTENTO
 
 
 datos_plot %>% 
   ungroup() %>% 
   mutate(localidad2 = fct_lump(f = localidad,  n = 3)) %>%  # GENERAMOS NUEVA VARIABLES LOCALIDAD COLAPSANDO MENOS FRECUENTES EN ' OTROS' 
   ggplot() + 
   geom_point(mapping = aes(x = fecha, y = localidad2, 
                            size = n))
  
 
 
 ### TERCER INTENTO
 
 
 datos_plot %>% 
   ungroup() %>% 
   mutate( localidad2 = fct_lump(f = localidad,  n = 3)) %>%  
   ggplot() + 
   geom_jitter(mapping = aes(x = fecha, y = localidad2, size = n, # CAMBIAMOS EL TIPO DE GEOMETRIA POR _jitter (noise) 
                             color = n)) # AGREGAMOS OTRA DIMENSION - escala de color en función de n
 
 
 ### CUARTO INTENTO
 

 
(plot <-  datos_plot %>% 
   ungroup() %>% 
   mutate( localidad2 = fct_lump(f = localidad,  n = 3)) %>%  
   ggplot() + 
   geom_jitter(mapping = aes(x = fecha, y = localidad2, size = n,   color = n)) +
   scale_color_continuous(guide = "legend"))  # COMBINAMOS DOS LEYENDAS (scale parameter)

 
 
 
 
 
(plot2 <-  plot + 
    labs(title = "Publicaciones x día", 
         subtitle = "TUCUMAN", 
         x = "", 
         y = "Localidades (top)") )
 
 
 # THEME 
 
 
 
(plot3 <-  plot2  +
    theme_void() ) # ESQUEMA CON VALORES PREDETERMINADOS

 
 plot3 + # CUSTOMIZACION DE CAPAS: muevo leyenda
    theme(legend.position = "bottom")
 

 
 plot3 + # CUSTOMIZACION DE CAPAS: recupero texto de x y le doy color
    theme(legend.position = "bottom", 
          axis.text.x = element_text(color = "red", angle = 45))
 
 
(plot4 <-  plot3 + # CUSTOMIZACION DE CAPAS: recupero texto de x y le doy color
    theme(legend.position = "top", 
          axis.text.x = element_text(color = "red"))  +
    scale_color_viridis_c(option = "magma", 
                          guide = "legend"))
 
 
 # Y LAS LOCALIDADES????
 
fecha_media <-  mean(datos_plot$fecha)


summary(plot4)

 plot4 +
    geom_text(aes(x = fecha_media, y = localidad2,
                  label = localidad2 ), color = "red", size = 10, alpha = .1)
 
 
 
  