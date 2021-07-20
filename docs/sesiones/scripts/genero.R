library(tm)
library(stringi)

# http://apuntes-r.blogspot.com/2018/11/identificar-genero-de-un-nombre.html

# FUNCIONES ------------------------------

 # LIMPIEZA DE TEXTO 

clean_txt <- function(txt){
  txt <- stri_trim(gsub('[[:punct:][:digit:] ]+',' ',tolower(txt)))
  return(strsplit(txt, " ")[[1]])
}


# ADIVINA GENERO

get_gender2 <- function(nombre, lista_nombres="") {
  nombre <- clean_txt(nombre)
  nombre <- subset(nombre, nombre %in% lista_nombres)
  mylist <- list()
  mylist[c("f", "m","a")] <- 0
  for (i in 1:length(nombre)){
    g <- as.character(df[which(df$nombre == nombre[i]),"genero"])
    g <- ifelse(identical(g, character(0)), 'a', g)
    if(i==1){
      mylist[[g]] <- mylist[[g]] + 2
    } else{
      mylist[[g]] <- mylist[[g]] + 1
    }
    g2 = sapply(mylist, function(x) x[which.max(abs(x))])
    return(names(g2[g2==max(g2)])[1])
  }
}
# DATOS ---------------------------------
path <- 'https://www.dropbox.com/s/edm5383iffurv4x/nombres.csv?dl=1'
df <- read.csv(path, sep=",",  colClasses = "character")

# EJEMPLO DE APLICACION

get_gender2("enzo maría", df$nombre)



##########
# ITERACION CON PURRR

datos <- readxl::read_xlsx("sesiones/data/20210526224919cd91_reviews.xlsx")


datos

datos %>% 
  select(autor_name, autor_id)


datos %>% 
  select(autor_name, autor_id) %>% 
  group_by(autor_id) %>% 
  nest()



datos %>% 
  select(autor_name, autor_id) %>% 
  group_by(autor_id) %>% 
  nest() %>% 
  mutate(genero = map2(.x = data, 
                       .y = autor_id,
                       .f =  ~ get_gender2(nombre = .x$autor_name,
                                           lista_nombres = df$nombre))) %>% 
  unnest(cols = c(data, genero)) %>% 
  select(genero, autor_name, everything()) %>% 
  print(n = Inf)

