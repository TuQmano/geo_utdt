### LEER SHP FILES EN LINEA ? 

# https://stackoverflow.com/questions/59740419/unzipping-and-reading-shape-file-in-r-without-rgdal-installed

library(tidyverse)
library(sf)



#create a couple temp files
temp <- tempfile()
temp2 <- tempfile()
#download the zip folder from the internet save to 'temp' 
download.file("https://cdn.buenosaires.gob.ar/datosabiertos/datasets/ministerio-de-educacion/calles/callejero.zip",temp)
#unzip the contents in 'temp' and save unzipped content in 'temp2'
unzip(zipfile = temp, exdir = temp2)
#finds the filepath of the shapefile (.shp) file in the temp2 unzip folder
#the $ at the end of ".shp$" ensures you are not also finding files such as .shp.xml 
your_SHP_file<-list.files(temp2, pattern = ".shp$",full.names=TRUE)

#read the shapefile. Alternatively make an assignment, such as f<-sf::read_sf(your_SHP_file)
sf::read_sf(your_SHP_file)

