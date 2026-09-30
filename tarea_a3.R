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
# La base contiene 97.946 observaciones y 222 variables
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
##Se revisaron los nombres de las variables para identificar las que
#se utilizarán en el análisis

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

#4 Recodifación de variables categoricas 
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
# En formalidad, el código 1 corresponde a trabajadores formales y 
#el código 2 a trabajadores informales.
#En situacion, el código 1 corresponde a personas ocupadas,
#el 2 a desocupadas y el 3 a personas fuera de la fuerza de trabajo.
#Los valores que no corresponden a estas categorías se dejaron como
#"Sin clasificación".
#Comprobar las categorías recodificadas

table(empleo$formalidad, useNA = "ifany")
table(empleo$situacion, useNA = "ifany")
#Al revisar la variable formalidad, se encontraron 29.328 personas
#clasificadas como formales y 12.522 como informales. También aparecen
#56.096 observaciones como "Sin clasificación", lo que es esperable
#porque ocup_form corresponde a una clasificación de las personas ocupadas
#y no se aplica a quienes no están ocupados.

# 5. Revisar valores faltantes

colSums(is.na(empleo))
#se reviso los valores faltantes de todas las variables utilizadas.

#Revisar los valores faltantes de activ

summary(ene$edad[is.na(ene$activ)])
#Se revisó la edad de las personas que tienen NA en activ.
#Estos casos corresponden a personas menores de 15 años, por lo que
#no les corresponde responder sobre su situación laboral.
#Por esto, estos NA son estructurales.

#Revisar los valores faltantes de efectivas

table(empleo$activ, is.na(empleo$efectivas), useNA = "ifany")
#Se revisó dónde aparecen los valores faltantes de efectivas según
#la situación laboral. Las horas efectivamente trabajadas no corresponden
#a las personas desocupadas o fuera de la fuerza de trabajo.

# Revisar los valores faltantes de ocup_form

table(empleo$activ, is.na(empleo$ocup_form), useNA = "ifany")
#Se revisó la variable ocup_form para comprobar dónde aparecen los
#valores faltantes. Esta variable se utiliza solamente para clasificar
#a las personas ocupadas según su formalidad.

#Comparar la base con y sin los NA

nrow(empleo)
nrow(na.omit(empleo))
#Se comparó la cantidad de observaciones antes y después de utilizar
#na.omit(). Esta comparación muestra que eliminar todos los NA puede
#reducir bastante la cantidad de observaciones, ya que algunos faltantes
#son estructurales y aparecen porque una variable no corresponde.

#6Revisar valores especiales en efectivas

sum(empleo$efectivas == 888, na.rm = TRUE)
sum(empleo$efectivas == 999, na.rm = TRUE)
#Se revisaron los valores especiales de efectivas.
#El código 888 corresponde a "No sabe" y 999 a "No responde".

#Revisar los valores altos de efectivas

sort(
  table(empleo$efectivas[empleo$efectivas > 80]),
  decreasing = TRUE)
#Se revisaron los valores altos de horas para identificar si aparecen
#códigos que no corresponden a horas trabajadas.  

#Convertir los valores especiales en NA

empleo_limpia <-
  empleo |>
  mutate(
    efectivas_ = na_if(efectivas, 888),
    efectivas_ = na_if(efectivas_, 999))
#Se cambiaron los valores 888 y 999 por NA porque no representan
#una cantidad de horas trabajadas.


#Comparar el máximo antes y después de limpiar

max(empleo$efectivas, na.rm = TRUE)
max(empleo_limpia$efectivas_, na.rm = TRUE)
#Se comparó el valor máximo antes y después de eliminar los códigos
#especiales para comprobar el efecto de la limpieza.


#Comparar el promedio antes y después de limpiar

mean(empleo$efectivas, na.rm = TRUE)
mean(empleo_limpia$efectivas_, na.rm = TRUE)
#Se comparó el promedio de horas antes y después de cambiar los códigos
#888 y 999 por NA. Esto permite observar cuánto afectan estos valores
#al promedio de horas trabajadas.


#7 Trabajar solamente con personas ocupadas

ocupados <- empleo_limpia |>
  filter(situacion == "Ocupado")

dim(ocupados)
#Se dejaron solamente las personas ocupadas porque son las que tienen
#una clasificación formal o informal y permiten responder la pregunta.

#Revisar la cantidad de personas formales e informales

table(ocupados$formalidad, useNA = "ifany")
#Se revisó cuántas personas ocupadas pertenecen a cada categoría
#de formalidad.

#8 Promedio de horas sin ponderar

ocupados |>
  filter(!is.na(efectivas_), !is.na(formalidad)) |>
  group_by(formalidad) |>
  summarise(
    promedio_horas = mean(efectivas_, na.rm = TRUE))
#Se calculó el promedio de horas efectivamente trabajadas para
#trabajadores formales e informales sin utilizar el factor de expansión.


# Promedio de horas ponderado con fact_cal

resultado_formalidad <- ocupados |>
  filter(!is.na(efectivas_), !is.na(formalidad)) |>
  group_by(formalidad) |>
  summarise(
    promedio_horas = sum(efectivas_ * fact_cal) / sum(fact_cal))

resultado_formalidad
#Se calculó nuevamente el promedio utilizando fact_cal para considerar
#el peso de cada observación en la población.


#Calcular la brecha

promedio_formal <- resultado_formalidad$promedio_horas[
  resultado_formalidad$formalidad == "Formal"]

promedio_informal <- resultado_formalidad$promedio_horas[
  resultado_formalidad$formalidad == "Informal"]

brecha <- promedio_formal - promedio_informal

brecha
#La brecha se calculó restando el promedio de horas de los trabajadores
#informales al promedio de los trabajadores formales.
#Un resultado positivo significa que el promedio de horas es mayor
#entre los trabajadores formales.


#Comparar resultados ponderados y sin ponderar

resultado_sin_ponderar <- ocupados |>
  filter(!is.na(efectivas_), !is.na(formalidad)) |>
  group_by(formalidad) |>
  summarise(
    promedio_horas = mean(efectivas_, na.rm = TRUE)
  )

resultado_sin_ponderar

resultado_formalidad

#Se compararon los promedios sin ponderar y los promedios ponderados
#con fact_cal. Para el resultado final se utilizarán los promedios
#ponderados.




