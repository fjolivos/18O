library(haven)
library(tidyverse)
library(lubridate)
library(rdrobust)
library(foreign)

image <- read_sav("C:/Users/fjoli/Dropbox/Data/Image de Chile/base_final_anon.sav")


#--------------Create cut-off point

#Separate Date from time
image$Date <- as.Date(image$submitdate)
image$Time <- format(image$submitdate,"%H:%M:%S")

#Date of the estallido
image$estallido <- rep("2019-10-19",length(image$id))

image$date_diff <- as.Date(as.character(image$Date), format="%Y-%m-%d")-
  as.Date(as.character(image$estallido), format="%Y-%m-%d")

#--------------Export

image[image == 99] <- NA
image[image == 88] <- NA

pride_coutry <- table(image$P1)
pride_coutry


myvars <- c("id", "comuna", "comuna2", "sexo", "edad", "P1", "P2", "P3_3", "P3_7", "P3_8", "P3_9", "P7_1", "P7_2", "P8_2", "P9_2", "P10", "P11_1", "P11_3", "P11_5", "P11_6", "P12_3", "P12_4", "P13_1", "P13_5", "P13_6", "P14", "P15", "P17", "C2", "C3", "C4", "C5B", "integrantes", "date_diff")
subimage <- image[myvars]

write.dta(subimage, "C:/Users/fjoli/Dropbox/Data/Image de Chile/image.dta")
