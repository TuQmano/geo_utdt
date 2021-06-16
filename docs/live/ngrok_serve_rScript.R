# LIVE CODING TEMPLATE
s <- livecode::serve_file()

#  
# 
# (1)  Ejejutar ngrok.exe
# en linea de comandos ngrok http  #####IP
# 
#  
# (2) leugo en ngrok UI copiar la url de redireccion (termina en ngrok.io)
#  
#  detalles https://bitsandbricks.github.io/post/compartiendo-c%C3%B3digo-en-vivo-con-el-mundo-desde-rstudio/
#  



library(polAr)

get_election_data(district = "tucuman", 
                  category = "dip", 
                  round = "paso", 
                  year = 2015)
