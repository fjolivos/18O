library(haven)
library(lubridate)
library(tidyverse)
library(rdrobust)

image <- read_sav("base_final_anon.sav")

#--------------Create cut-off point

#Separate Date from time
image <- image %>% 
  mutate(Date = as_datetime(submitdate),
         Time = hms::as_hms(Date))

#Date of the estallido and days from survey 
image <- image %>% 
  mutate(estallido = as_date("2019-10-19"),
         date_diff = as_date(Date) - estallido)

image %>% 
  select(Date, Time, estallido, date_diff) %>% 
  slice(c(1:3, (n()-2):n()))


#--------------Export

image[image == 99] <- NA
image[image == 88] <- NA

pride_coutry <- table(image$P1)
pride_coutry

myvars <- c("id", "comuna", "comuna2", "sexo", "edad", 
            "P1", "P2", "P3_3", "P3_7", "P3_8", "P3_9", 
            "P7_1", "P7_2", "P8_2", "P9_2", "P10", 
            "P11_1", "P11_3", "P11_5", "P11_6", "P12_3", "P12_4", 
            "P13_1", "P13_5", "P13_6", "P14", "P15", "P17", 
            "C2", "C3", "C4", "C5B", "integrantes", "date_diff")

subimage <- image %>% 
  select(all_of(myvars))

write_dta(subimage, 
          "base_analisis.dta")

saveRDS(subimage, 
        "base_analisis.rds")
