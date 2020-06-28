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


# Collection of dependen variables
df_LHS <- tibble(formula_LHS = c('pride_CL', 'pride_dev', 'pride_sym', 'pride_pl', 
                                 'energy', 'pride_esf'))

# Different models to be test
df_RHS <- tibble(formula_RHS = c('treat', 
                                 'treat + gender + age + geozone + edu + household',
                                 'treat'),
                 wt = list(NULL, NULL, 'webal'))

# Create all combination of dependent variables and models
df_models <- expand_grid(df_LHS, df_RHS)

# Build model formula
df_models <- df_models %>% 
  mutate(formula = str_glue("as.integer({formula_LHS}) ~ {formula_RHS}"))

# Function to run regresions for each case
f_lm <- function(.df, formula, weights = NULL){
  if(!is.null(weights)){
    weights <- rlang::sym(weights)  
  }

  rlang::eval_tidy(
    rlang::quo(
      lm(formula = formula, 
         data = .df,
         weights = !!weights)
    )
  )
}

# Calculate all models
df_models <- df_models %>% 
  mutate(model = map2(formula, wt, ~f_lm(.df = prideLW, formula = .x, weights = .y)))


broom::tidy(df_models$model[[1]])

  output$glance

output %>% unnest(glance)


#Pride toward the country
table(prideLW$pride_CL)

m1A <- lm(formula = as.integer(pride_CL) ~ treat, 
          data = prideLW)
m1B <- lm(formula = as.integer(pride_CL) ~ treat + gender + age + geozone + edu + household, 
          data = prideLW)
m1C <- lm(formula = as.integer(pride_CL) ~ treat, weights = prideLW$webal,
          data = prideLW)

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



