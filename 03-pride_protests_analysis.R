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

#:::::::::::::::::::::::::Balance

#La idea es comparar las medias y distribuciones de las variables. Pueden ser
#boxplots o la media con el intervalo de confianza. Cualquiera visualizacion
#que permita mostrar el balance va a estar bien. Hay unas ligeras diferencias
#por zonas geograficas, pero con la correcion del ebal quedan bien. 

#Abajo genere unos graficos con la media de cada una de las variables. Ojo con
#que uso la base de datos prideLW. Es un subset que considera solo casos sin 
#missing. La variable "sample" viene de la base de datos en Stata. 

#Las variables son casi todas 0 a 1. Son las variables categoricas transformadas
#en binarias. Reportar la media de eso esta perfect. 

library(tidyverse)

pride <- readRDS("data/02-base_analisis.rds")

pride %>% 
  transmute(across(c(gender, age_4, geozone, edu, household, 
                     pride_CL, pride_esf, energy, pride_sym, pride_dev, pride_pl, treat),
                   as.numeric)) %>% 
  summarise(across(everything(), max))

table(pride$pride_CL, useNA = 'ifany')


# Change inplicit to explicit NA
pride <- pride %>% 
  mutate(across(c(gender, age_4, geozone, edu, household, 
                  pride_CL, pride_esf, energy, pride_sym, pride_dev, pride_pl),
                ~replace(., . %in% c(88, 99), NA)))


# Change variables to factor
pride <- pride %>% 
  mutate(across(c(gender, age_4, geozone, edu, household, 
                  pride_CL, pride_esf, energy, pride_sym, pride_dev, pride_pl),
                as_factor))

table(pride$pride_CL, useNA = 'ifany')

# Keep cases with full response
pride <- pride %>% 
  mutate(sample = rowSums(across(c(gender, age_4, geozone, edu, household, 
                                   pride_CL, pride_esf, energy, pride_sym, pride_dev, pride_pl, treat), 
                                 is.na)))
count(pride, sample)

prideLW <- pride %>% 
  filter(sample == 0)

# Create new dataframe mpg_means_se
df_category <- prideLW %>% 
  select(id, treat, gender, age_4, geozone, edu, household) %>% 
  pivot_longer(cols = c(gender, age_4, geozone, edu, household), 
               names_to = 'variable', 
               values_to = 'category')

df_category_diff_treat <- df_category %>% 
  group_by(variable, category) %>% 
  summarise(mean_se(treat))


df_category_diff_treat %>% 
  ggplot(aes(x = category, y = y)) +
  geom_linerange(aes(ymin = 0, ymax = y, 
                     colour = stage(variable,
                                    after_scale = prismatic::clr_alpha(colour, alpha = .3))), 
                 size = 2) + 
  geom_errorbar(aes(ymin = ymin, ymax = ymax,
                    colour = stage(variable,
                                   after_scale = prismatic::clr_darken(colour, shift = .5))), 
                size = 1) +
  geom_point(size = 2) +
  facet_grid(cols = vars(variable),
             scales = 'free_x', space = 'free_x') +
  scale_y_continuous('Proportion of treated', 
                     limits = c(0,1),
                     labels = scales::percent) +
  scale_colour_brewer(palette = 'Set1', guide = 'none') + 
  coord_cartesian(expand = FALSE) + 
  labs(title = "Sample balance", 
       subtitle = 'Difference between treated and non-treated in five categories',
       x = " ") +
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 90, size = rel(1), 
                                   hjust = 1, vjust = 0.5))
  
ggsave('plots/03-df_category_diff_treat.png',
       scale = 1.25,
       width = 14, height = 8,
       units = 'cm')


#:::::::::::::::::::::::::REGRESIONS

library("arm")

#::::::Effects on moral sentiments toward the country 

#Estime los modelos para cada una de las variables. Trato de replicar los analisis
#que ya incluimos en la propuesta. Solo tengo problemas con los modelos C que no
#me permiten incluir el weight. No se la razon.

#El entropy balance lo hice en Stata. El weight es webal. 

#Pride toward the country

m1A <- lm(formula = pride_CL ~ treat, data = prideLW)
m1B <- lm(formula = pride_CL ~ treat + gender + age + zone1 + zone2 + zone4 +
          edu1 + edu3 + household2 + household3 + household4, data = prideLW)
m1C <- lm(formula = pride_CL ~ treat, data = prideLW) #error when adding weight=webal

par(mfrow = c(1, 1))
coefplot(m1A, xlim=c(-.6, 0), main = "Country Pride", intercept=FALSE)
coefplot(m1B, add=TRUE, col.pts="red",  intercept=FALSE)
coefplot(m1C, add=TRUE, col.pts="blue", intercept=FALSE, offset=0.2)

#Pride economic development
m2A <- lm(formula = pride_dev ~ treat, data = prideLW)
m2B <- lm(formula = pride_dev ~ treat + gender + age + zone1 + zone2 + zone4 +
            edu1 + edu3 + household2 + household3 + household4, data = prideLW)
m2C <- lm(formula = pride_dev ~ treat, data = prideLW) #error when adding weight=webal

par(mfrow = c(1, 1))
coefplot(m2A, xlim=c(-.6, 0), main = "Economic Development", intercept=FALSE)
coefplot(m2B, add=TRUE, col.pts="red",  intercept=FALSE)
coefplot(m2C, add=TRUE, col.pts="blue", intercept=FALSE, offset=0.2)

#Pride symbols
m3A <- lm(formula = pride_sym ~ treat, data = prideLW)
m3B <- lm(formula = pride_sym ~ treat + gender + age + zone1 + zone2 + zone4 +
            edu1 + edu3 + household2 + household3 + household4, data = prideLW)
m3C <- lm(formula = pride_sym ~ treat, data = prideLW) #error when adding weight=webal

par(mfrow = c(1, 1))
coefplot(m3A, xlim=c(-.6, 0), main = "Symbols", intercept=FALSE)
coefplot(m3B, add=TRUE, col.pts="red",  intercept=FALSE)
coefplot(m3C, add=TRUE, col.pts="blue", intercept=FALSE, offset=0.2)

#Place to live
m4A <- lm(formula = pride_pl ~ treat, data = prideLW)
m4B <- lm(formula = pride_pl ~ treat + gender + age + zone1 + zone2 + zone4 +
            edu1 + edu3 + household2 + household3 + household4, data = prideLW)
m4C <- lm(formula = pride_pl ~ treat, data = prideLW) #error when adding weight=webal

par(mfrow = c(1, 1))
coefplot(m4A, xlim=c(-.6, 0), main = "Place", intercept=FALSE)
coefplot(m4B, add=TRUE, col.pts="red",  intercept=FALSE)
coefplot(m4C, add=TRUE, col.pts="blue", intercept=FALSE, offset=0.2)

#::::::Effects on moral sentiments toward Chileans

#Energy

m5A <- lm(formula = energy ~ treat, data = prideLW)
m5B <- lm(formula = energy ~ treat + gender + age + zone1 + zone2 + zone4 +
            edu1 + edu3 + household2 + household3 + household4, data = prideLW)
m5C <- lm(formula = energy ~ treat, data = prideLW) #error when adding weight=webal

par(mfrow = c(1, 1))
coefplot(m5A, xlim=c(0, .5), main = "Energy", intercept=FALSE)
coefplot(m5B, add=TRUE, col.pts="red",  intercept=FALSE)
coefplot(m5C, add=TRUE, col.pts="blue", intercept=FALSE, offset=0.2)

#Effort

m6A <- lm(formula = pride_esf ~ treat, data = prideLW)
m6B <- lm(formula = pride_esf ~ treat + gender + age + zone1 + zone2 + zone4 +
            edu1 + edu3 + household2 + household3 + household4, data = prideLW)
m6C <- lm(formula = pride_esf ~ treat, data = prideLW) #error when adding weight=webal

par(mfrow = c(1, 1))
coefplot(m6A, xlim=c(0, .5), main = "Effort", intercept=FALSE)
coefplot(m6B, add=TRUE, col.pts="red",  intercept=FALSE)
coefplot(m6C, add=TRUE, col.pts="blue", intercept=FALSE, offset=0.2)



