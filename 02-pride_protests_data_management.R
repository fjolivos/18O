#********************************************************************************
#  Pride & Protest 
#  Francisco Olivos
#  June 11
#  Balance and main models
#********************************************************************************

#Still to do and consider:
#            - Tenemos que preparar varias cosas en el material suplementario. 
#              pero eso lo podemos hacer despues.
#            - Probare algunos analisis por submuestra. Principalmente hay un 
#              perfil de jovenes, hombres y mas educados que se asocia con protesta.
#              quiero ver si hay diferencias significativas entre esos grupos que podamos destacar. 
#            - Incluir el grafico de las encuestas por dia es un poco riesgoso. Porque luego de la segunda tanda
#              de encuesta, se volvio a parar una semana. Y si mostramos eso nos van a cuestionar inmediatamente. 


library(tidyverse)

pride <- readRDS("data/01-base_analisis.rds")

# DATA MANAGEMENT ---------------------------------------------------------

rename_label <- function(df, ..., label){
  vars <- enquos(...)
  
  df <- rename(df, !!!enquos(...))
  attr(df[[names(vars)[1]]], 'label') <- label
  
  return(df)
}


# Estallido social: post treatement.
pride$treat <- if_else(pride$date_diff > 0, TRUE, FALSE)
attr(pride$treat, 'label') <- 'Social crisis'

pride %>% count(treat)

# Country Pride
pride <- pride %>% 
  rename_label(pride_CL = P1, label = "Pride toward the country")

# Energy
pride <- pride %>% 
  rename_label(energy = P3_3, label = "Proud of Chileans: Energy")

# Symbols
pride <- pride %>% 
  rename_label(pride_sym = P3_9, label = "Proud of Chile: Symbols")

# Economic Development
pride <- pride %>% 
  rename_label(pride_dev = P11_1, label = "Proud of Chile: Economic development")

# Place to Live
pride <- pride %>% 
  rename_label(pride_pl = P11_3, label = "Proud of Chile: Place to live")

# Effort
pride <- pride %>% 
  mutate(pride_esf = case_when(P14 == 2 ~ 1L,
                               P14 %in% c(1, 3:6) ~ 0L,
                               TRUE ~ NA_integer_))
attr(pride$pride_esf, 'label') <- 'Proud of Chileans: Effort'

# Gender (sexo)
pride <- pride %>% 
  rename_label(gender = sexo, label = "Gender") %>% 
  mutate(gender = as_factor(gender),
         gender = fct_recode(gender, 'Male' = 'Hombre', 'Female' = 'Mujer'))

count(pride, gender)


# Age (edad)
pride <- pride %>% 
  rename_label(age = edad, label = "Age") %>% 
  mutate(age_4 = case_when(age <= 35 ~ '17-35',
                           age <= 50 ~ '36-50',
                           age <= 65 ~ '51-65',
                           age <= 97 ~ '66-87'),
         age_4 = as_factor(age_4),
         age_4 = fct_relevel(age_4, c("17-35", "36-50", "51-65", "66-87")))

count(pride, age_4)


# Political position (C2)
pride <- pride %>% 
  rename_label(polpos = C2, label = "Political identification") %>% 
  mutate(polpos = case_when(polpos <= 4 ~ 'Left',
                            polpos == 5 ~ 'Center',
                            polpos <= 10  ~ 'Right',
                            polpos == 77 ~ 'None'),
         polpos = as_factor(polpos),
         polpos = fct_relevel(polpos, c("Left", "Center", "Right", "None")))

count(pride, polpos)


# Region
count(pride, geozone)


# Respondent's educational level (C3)
pride <- pride %>% 
  rename_label(edu = C3, label = "Educational Level") %>% 
  mutate(edu = case_when(edu <= 6 ~ 'Less than secondary',
                            edu == 7 ~ 'Secondary completed',
                            edu <= 12  ~ 'More than secondary'),
         edu = as_factor(edu),
         edu = fct_relevel(edu, c("Less than secondary", "Secondary completed",  "More than secondary")))

count(pride, edu)


# Number of people living in the same household (integrantes)
pride <- pride %>% 
  rename_label(household = integrantes, label = "Number of household members") %>% 
  mutate(household = case_when(household == 1 ~ 'One',
                               household == 2 ~ 'Two',
                               household == 3 ~ 'Three',
                               household <= 7  ~ 'Four or more'),
         household = as_factor(household),
         household = fct_relevel(household, c("One", "Two", "Three", "Four or more")))

count(pride, household)

# Write data
saveRDS(pride, "data/02-base_analisis.rds")
