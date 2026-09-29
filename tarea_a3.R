#A3 — Limpieza de datos reales del INE
#Autor: María José Salinas Correa
#Fecha: 29-09-2026
#Descripción: Limpiar y preparar datos de la ENE para analizar
# la brecha en las horas semanales efectivamente trabajadas
# en la actividad principal entre trabajadores formales e informales.

#Pregunta: ¿Existe una brecha en las horas semanales efectivamente trabajadas
#en la actividad principal entre trabajadores formales e informales?

#.- Ficha de la fuente
#Ficha de la fuente: Instituto Nacional de estadísticas
#Encuesta: Encuesta Nacional de empleo 
#Trimestre Movil: Mayo - Junio - Julio 2026
#Enlace de descarga: https://www.ine.cl/docs/default-source/ocupacion-y-desocupacion/bbdd/2026/csv/ene-2026-06-mjj.csv
#Fecha de descarga: 22-09-2026
#Unidad de Observación: Personas de 15 años o más con residencia habitual en 
# hogares de viviendas particulares ocupadas dentro del territorio nacional.

#1.- Cargar los datos
library(tidyr)
library(dplyr)

ene <- read.csv2("data/raw/ene-2026-06-mjj.csv")

dim(ene)
glimpse(ene)
## La base contiene 97.946 observaciones y 222 variables
#Con glimpse se usa para comprobar que se hayan cargados bien los datos 

# 2. Variables a ocupar

#Me quedaré con estas variables porque son las que necesito para responder
#la pregunta.

#efectivas: Horas efectivamente trabajadas en la semana de referencia.
#ocup_form: Clasificación de las personas ocupadas según formalidad.
#            1: Ocupado formal
#            2: Ocupado informal
#activ: Condición de actividad.
#       1: Ocupado/a
#      2: Desocupado/a
#       3: Fuera de la fuerza de trabajo
# fact_cal: Factor de expansión trimestral calibrado.

#3 Revisar los nombres de la variable 
names(select(ene, starts_with("efec")))
names(select(ene, starts_with("ocup")))
names(select(ene, starts_with("act")))
names(select(ene, starts_with("fact")))
#Se buscaron las variables por el comienzo de sus nombres para comprobar que 
#estuvieran disponibles en la base.

#Se busca reducir la base de datos
empleo <-
  ene |>
  select(
    starts_with("efec"),
    ocup_form,
    activ,
    fact_cal)

dim(empleo)
#Se creó  empleo con las variables que se utilizarán en el análisis,
#manteniendo las 97.946 observaciones y con 4 variables de la base original.
names(empleo)
# Para comprobar que empleo contenga las 4 variables necesarias.

#Recodifación de variables categoricas 
empleo <- empleo |>
  mutate(
    formalidad = case_when(
      ocup_form == 1 ~ "Formal",
      ocup_form == 2 ~ "Informal",
      TRUE ~ "Sin clasificación" ),
    situacion = case_when(
      activ == 1 ~ "Ocupado",
      activ == 2 ~ "Desocupado",
      activ == 3 ~ "Fuera de la fuerza de trabajo",
      TRUE ~ "Sin clasificación") )
#Se crearon las variables formalidad y situación para facilitar el análisis.
