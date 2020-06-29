#********************************************************************************
#  Pride & Protest 
#  Francisco Olivos
#  June 11
#  Main models
#********************************************************************************

#:::::::::::::::::::::::::REGRESIONS

library(arm)
library(tidyverse)

prideLW <- readRDS("data/03-prideLW.rds")

#::::::Effects on moral sentiments toward the country 

#Estime los modelos para cada una de las variables. Trato de replicar los analisis
#que ya incluimos en la propuesta. Solo tengo problemas con los modelos C que no
#me permiten incluir el weight. No se la razon.


# Collection of dependen variables
df_LHS <- tibble(type_var = as_factor(c(rep('National', 4), rep('Chileans', 2))),
                 formula_LHS = c('Country Pride'         = 'pride_CL', 
                                 'Economic Developement' = 'pride_dev', 
                                 'Symbols'               = 'pride_sym', 
                                 'Place'                 = 'pride_pl', 
                                 'Energy'                = 'energy', 
                                 'Efford'                = 'pride_esf'))

# Different models to be test
df_RHS <- tibble(type_model = as_factor(c('Binary', 'Covariates', 'Entropy')),
                 formula_RHS = c('treat', 
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

# Coeficients of interest
df_models_estimate <- df_models %>% 
  rowwise() %>% 
  summarise(across(c(type_var, formula_LHS, type_model)),
            broom::tidy(model),
            as_tibble(confint(model)))

# Edit data frame for ploting
df_models_treat <- df_models_estimate %>% 
  filter(term == 'treatTRUE') %>% 
  rename(est_low = `2.5 %`, est_high = `97.5 %`) %>% 
  mutate(name = names(formula_LHS), .before = everything())


# Plot

df_models_treat %>% 
  ggplot(aes(x = type_model, 
             y = estimate, ymin = est_low, ymax = est_high,
             colour = type_var)) +
  geom_pointrange() +
  geom_hline(yintercept = 0) +
  facet_wrap(facets = vars(type_var, name)) +
  coord_flip() +
  scale_colour_brewer(palette = 'Set1', guide = 'none') + 
  scale_y_continuous(labels = function(x) scales::number(x, accuracy = .1)) + 
  theme_minimal() +
  labs(title = 'Effects of the social outburst',
       subtitle = 'Estimates of OLS regression regarding National pride and Chileans',
       x = 'Models',
       y = 'Effects of the social crisis') +
  theme(plot.title.position = 'plot',
        axis.text.x = element_text(size = rel(.75)))

ggsave('plots/04-df_models_treat.png',
       scale = 1.25,
       width = 14, height = 8,
       units = 'cm')



