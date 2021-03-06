#********************************************************************************
#  Pride & Protest 
#  Francisco Olivos
#  June 11
#  Main models
#********************************************************************************

#:::::::::::::::::::::::::REGRESIONS

library(tidyverse)
library(arm)

prideLW <- readRDS("data/03-prideLW.rds")

#::::::Effects on moral sentiments toward the country 

#Estime los modelos para cada una de las variables. Trato de replicar los analisis
#que ya incluimos en la propuesta. Solo tengo problemas con los modelos C que no
#me permiten incluir el weight. No se la razon.

#El entropy balance lo hice en Stata. El weight es webal. 

#Pride toward the country
table(prideLW$pride_CL)

m1A <- lm(formula = as.integer(pride_CL) ~ treat, data = prideLW)
m1B <- lm(formula = as.integer(pride_CL) ~ treat + gender + age + geozone + edu + household, 
          data = prideLW)
m1C <- lm(formula = as.integer(pride_CL) ~ treat, data = prideLW, weights = prideLW$webal)

par(mfrow = c(1, 1))
coefplot(m1A, xlim=c(-.6, 0), main = "Country Pride", intercept=FALSE)
coefplot(m1B, add=TRUE, col.pts="red",  intercept=FALSE)
coefplot(m1C, add=TRUE, col.pts="blue", intercept=FALSE, offset=0.2)

#Pride economic development
m2A <- lm(formula = as.integer(pride_dev) ~ treat, data = prideLW)
m2B <- lm(formula = as.integer(pride_dev) ~ treat + gender + age + geozone + edu + household, 
          data = prideLW)
m2C <- lm(formula = as.integer(pride_dev) ~ treat, data = prideLW, weights = prideLW$webal)

par(mfrow = c(1, 1))
coefplot(m2A, xlim=c(-.6, 0), main = "Economic Development", intercept=FALSE)
coefplot(m2B, add=TRUE, col.pts="red",  intercept=FALSE)
coefplot(m2C, add=TRUE, col.pts="blue", intercept=FALSE, offset=0.2)

#Pride symbols
m3A <- lm(formula = as.integer(pride_sym) ~ treat, data = prideLW)
m3B <- lm(formula = as.integer(pride_sym) ~ treat + gender + age + geozone + edu + household, 
          data = prideLW)
m3C <- lm(formula = as.integer(pride_sym) ~ treat, data = prideLW, weights = prideLW$webal)

par(mfrow = c(1, 1))
coefplot(m3A, xlim=c(-.6, 0), main = "Symbols", intercept=FALSE)
coefplot(m3B, add=TRUE, col.pts="red",  intercept=FALSE)
coefplot(m3C, add=TRUE, col.pts="blue", intercept=FALSE, offset=0.2)

#Place to live
m4A <- lm(formula = as.integer(pride_pl) ~ treat, data = prideLW)
m4B <- lm(formula = as.integer(pride_pl) ~ treat + gender + age + geozone + edu + household, 
          data = prideLW)
m4C <- lm(formula = as.integer(pride_pl) ~ treat, data = prideLW, weights = prideLW$webal)

par(mfrow = c(1, 1))
coefplot(m4A, xlim=c(-.6, 0), main = "Place", intercept=FALSE)
coefplot(m4B, add=TRUE, col.pts="red",  intercept=FALSE)
coefplot(m4C, add=TRUE, col.pts="blue", intercept=FALSE, offset=0.2)

#::::::Effects on moral sentiments toward Chileans

#Energy

m5A <- lm(formula = as.integer(energy) ~ treat, data = prideLW)
m5B <- lm(formula = as.integer(energy) ~ treat + gender + age + geozone + edu + household, 
          data = prideLW)
m5C <- lm(formula = as.integer(energy) ~ treat, data = prideLW, weights = prideLW$webal)

par(mfrow = c(1, 1))
coefplot(m5A, xlim=c(0, .5), main = "Energy", intercept=FALSE)
coefplot(m5B, add=TRUE, col.pts="red",  intercept=FALSE)
coefplot(m5C, add=TRUE, col.pts="blue", intercept=FALSE, offset=0.2)

#Effort

m6A <- lm(formula = as.integer(pride_esf) ~ treat, data = prideLW)
m6B <- lm(formula = as.integer(pride_esf) ~ treat + gender + age + geozone + edu + household, 
          data = prideLW)
m6C <- lm(formula = as.integer(pride_esf) ~ treat, data = prideLW, weights = prideLW$webal)

par(mfrow = c(1, 1))
coefplot(m6A, xlim=c(0, .5), main = "Effort", intercept=FALSE)
coefplot(m6B, add=TRUE, col.pts="red",  intercept=FALSE)
coefplot(m6C, add=TRUE, col.pts="blue", intercept=FALSE, offset=0.2)



