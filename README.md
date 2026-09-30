#tarea_a3-fundamentos

#Tarea A3: Limpieza de datos reales del INE
#Autor: María José Salinas Correa
#Fecha: 29-09-2026
#Pregunta: ¿Existe una brecha en las horas semanales efectivamente trabajadas 
#en la actividad principal entre trabajadores formales e informales?


#En los datos analizados, los promedios de horas efectivamente trabajadas presentan
#diferencias entre trabajadores formales e informales. El promedio ponderado de horas 
#efectivamente trabajadas fue de 38,8 horas para los trabajadores formales y de 29,5 
#horas para los trabajadores informales. La brecha entre ambos grupos fue de 9,31 horas 
#semanales, lo que significa que los trabajadores formales trabajaron en promedio 9,31 
#horas más que los trabajadores informales.
#Para obtener estos resultados se utilizó el factor de expansión fact_cal, 
#considerando el peso de cada observación en la población. Estos resultados 
#muestran que existe una diferencia en las horas efectivamente trabajadas entre 
#trabajadores formales e informales en los datos analizados.

#Fuente: Instituto Nacional de Estadísticas (INE)
#Encuesta: Encuesta Nacional de Empleo (ENE)
#Trimestre móvil: mayo-junio-julio de 2026 (mjj)
#Fecha de descarga: 22-09-2026

#Fuente: https://www.ine.gob.cl/estadisticas-por-tema/mercado-laboral/ocupacion-y-desocupacion

#Variables utilizadas
#efectivas: horas efectivamente trabajadas en la semana de referencia.
#ocup_form: clasificación de las personas ocupadas según formalidad.
#activ: condición de actividad.
#fact_cal: factor de expansión trimestral calibrado.
#También se crearon las variables formalidad y situacion mediante case_when() para facilitar el análisis.

#Limpieza de datos

#La base original contiene 97.946 observaciones y 222 variables. Para realizar 
#el análisis se seleccionaron las variables necesarias para responder la pregunta 
#de investigación.

#Se revisaron los valores faltantes y los valores especiales de la variable efectivas.
#Los códigos 888 y 999, correspondientes a "No sabe" y "No responde", fueron reemplazados 
#por NA, ya que no representan una cantidad de horas trabajadas.

#Luego, se seleccionaron solamente las personas ocupadas para comparar las horas 
#efectivamente trabajadas entre trabajadores formales e informales.

#Finalmente, se calcularon los promedios de horas sin ponderar y ponderados 
#utilizando fact_cal. Para el resultado final se utilizaron los promedios ponderados.

#Cómo correr el script

#Abrir el proyecto en RStudio y ejecutar el archivo correspondiente desde la 
#carpeta principal del repositorio.

#Declaración de autoría y uso de IA
#Herramienta utilizada: ChatGPT.
#Para qué la usé: Para comprender las instrucciones de la actividad, resolver 
#dudas sobre la limpieza de los datos, revisar el tratamiento de los valores 
#faltantes y especiales de la variable efectivas, y comprender cómo utilizar 
#el factor de expansión fact_cal en el cálculo de los promedios ponderados. 
#También la utilicé para revisar el código y la interpretación de los resultados.
#Qué hice yo: Revisé la información de la encuesta y el significado de las variables, 
#planteé la pregunta de investigación, seleccioné las variables, ejecuté y revisé el 
#código en R, y decidí qué datos mantener o transformar. También revisé los 
#resultados obtenidos y redacté la interpretación final.

#Verificación: Confirmo que entiendo y puedo explicar todo lo que entrego.