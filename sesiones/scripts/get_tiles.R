library(sf) # Simple Features for R, CRAN v1.0-0
#> Linking to GEOS 3.7.1, GDAL 3.1.2, PROJ 7.1.0


library(maptiles) # Download and Display Map Tiles, CRAN v0.2.0
library(geoAr) # Argentina's Spatial Data Toolbox, [github::politicaargentina/geoAr] v0.0.1.0

# import departamentos de TUCUMAN


tucuman <- get_geo("TUCUMAN")
# Project to crs = 4326


tuc <- st_transform(tucuman)

# dowload tiles and compose raster (SpatRaster)
tuc_osm <- get_tiles(tuc, crop = TRUE)

class(tuc_osm)
# display map
plot_tiles(tuc_osm)
# add Norh Carolina counties

plot(st_geometry(tuc), col = "NA", add = TRUE)
# add credit


mtext(text = get_credit("OpenStreetMap"), 
      side = 1, line = -1, adj = 1, cex = .9, 
      font = 3)



library(leaflet)


leaflet(tucuman) %>% 
  addPolygons() %>% 
  addProviderTiles(providers$OpenStreetMap)
