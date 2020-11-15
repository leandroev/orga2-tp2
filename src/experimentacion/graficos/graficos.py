import seaborn as sns
import numpy as np                   
import matplotlib.pyplot as plt      
from matplotlib.dates import DateFormatter
import matplotlib.dates as mdates
from pandas.plotting import register_matplotlib_converters
import pandas as pd
import math
import random
import glob


# Percentile, return an array with the 80-percetile 
def percentile_80(array):
	p = np.percentile(array,80)
	res = []
	for elem in array:
		if elem <= p:
			res.append(elem)
	return res

# Quitar Outliers
def remove_outliers(array):
	mean = np.mean(array)
	standard = np.std(array)
	limit = 1.5
	res = []
	for elem in array:
		z = (elem - mean)/standard
		if z <= limit:
			res.append(elem)
	return res


#Medicion ImagenFantasma
#Cargo los datos csv 
datos_micros_fantasma = pd.read_csv("../resultados/ImagenFantasma_micros.csv",header=None)
datos_ciclos_fantasma = pd.read_csv("../resultados/ImagenFantasma_ciclos.csv",header=None)

arr_micros_fantasma = np.array(datos_micros_fantasma[0])
arr_ciclos_fantasma = np.array(datos_ciclos_fantasma[0])


#Medicion ImagenFantasma_enteros
#Cargo los datos csv 
datos_micros_fantasma_ent = pd.read_csv("../resultados/ImagenFantasma_enteros_micros.csv",header=None)
datos_ciclos_fantasma_ent = pd.read_csv("../resultados/ImagenFantasma_enteros_ciclos.csv",header=None)


arr_micros_fantasma_ent = np.array(datos_micros_fantasma_ent[0])
arr_ciclos_fantasma_ent = np.array(datos_ciclos_fantasma_ent[0])

#Medicion ImagenFantasma_enteros
#Cargo los datos csv 
datos_micros_fantasma_x4 = pd.read_csv("../resultados/ImagenFantasma_x4_micros.csv",header=None)
datos_ciclos_fantasma_x4 = pd.read_csv("../resultados/ImagenFantasma_x4_ciclos.csv",header=None)


arr_micros_fantasma_x4 = np.array(datos_micros_fantasma_x4[0])
arr_ciclos_fantasma_x4 = np.array(datos_ciclos_fantasma_x4[0])


#Percentiles
#saco el los datos que esten por debajo del percentil80
#array_fantasma_micros = percentile_80(arr_micros_fantasma)
#array_fantasma_ciclos = percentile_80(arr_ciclos_fantasma)

#array_fantasma_ent_micros = percentile_80(arr_micros_fantasma_ent)
#array_fantasma_ent_ciclos = percentile_80(arr_ciclos_fantasma_ent)

#Quito outlier
array_fantasma_micros = remove_outliers(arr_micros_fantasma)
array_fantasma_ciclos = remove_outliers(arr_ciclos_fantasma)

array_fantasma_ent_micros = remove_outliers(arr_micros_fantasma_ent)
array_fantasma_ent_ciclos = remove_outliers(arr_ciclos_fantasma_ent)

array_fantasma_x4_micros = remove_outliers(arr_micros_fantasma_x4)
array_fantasma_x4_ciclos = remove_outliers(arr_ciclos_fantasma_x4)

#Calculo la media
micros = [np.mean(array_fantasma_micros),np.mean(array_fantasma_ent_micros)]
ciclos = [np.mean(array_fantasma_ciclos),np.mean(array_fantasma_ent_ciclos)]
micros2 = [np.mean(array_fantasma_micros),np.mean(array_fantasma_x4_micros)]
ciclos2 = [np.mean(array_fantasma_ciclos),np.mean(array_fantasma_x4_ciclos)]


implementaciones_micros = ['ImagenFantasma', 'ImagenFantasma_enteros']
implementaciones_ciclos = ['ImagenFantasma', 'ImagenFantasma_enteros']
implementaciones_micros2 = ['ImagenFantasma', 'ImagenFantasma_x4']
implementaciones_ciclos2 = ['ImagenFantasma', 'ImagenFantasma_x4']


plt.figure(figsize=(3,6))

#######################################################################################################################################

plt.subplot(1,2,1)
#Boxplot 1
plt.boxplot([array_fantasma_micros,array_fantasma_ent_micros], sym="o" ,labels=implementaciones_micros,meanline=True)
plt.ylabel('Microsegundos')
#Barplot 1
plt.subplot(1,2,2)
plt.bar(implementaciones_micros,micros, color = 'lightseagreen')
plt.ylabel('Microsegundos')
#plt.ticklabel_format(style='plain', axis='y')
plt.show()

#######################################################################################################################################

#Boxplot 2
plt.subplot(1,2,1)
plt.boxplot([array_fantasma_ciclos,array_fantasma_ent_ciclos], sym="o" ,labels=implementaciones_ciclos,meanline=True, showmeans=True,showbox=True)
plt.ylabel('Ticks de reloj')
#Barplot 2
plt.subplot(1,2,2)
plt.bar(implementaciones_ciclos,ciclos, color = 'lightseagreen')
plt.ylabel('Ticks de reloj')
#plt.ticklabel_format(style='plain', axis='y')
plt.show()

#######################################################################################################################################

#Boxplot 3
plt.subplot(1,2,1)
plt.boxplot([array_fantasma_micros,array_fantasma_x4_micros], sym="o" ,labels=implementaciones_micros2,meanline=True, showmeans=True,showbox=True)
plt.ylabel('Microsegundos')
#Barplot 3
plt.subplot(1,2,2)
plt.bar(implementaciones_micros2,micros2, color = 'dodgerblue')
plt.ylabel('Microsegundos')
#plt.ticklabel_format(style='plain', axis='y')
plt.show()

#######################################################################################################################################

#Boxplot 4
plt.subplot(1,2,1)
plt.boxplot([array_fantasma_ciclos,array_fantasma_x4_ciclos], sym="o" ,labels=implementaciones_ciclos2,meanline=True, showmeans=True,showbox=True)
plt.ylabel('Ticks de reloj')
#Barplot 4
plt.subplot(1,2,2)
plt.bar(implementaciones_ciclos2,ciclos2, color = 'dodgerblue')
plt.ylabel('Ticks de reloj')
#plt.ticklabel_format(style='plain', axis='y')
plt.show()


#######################################################################################################################################

res = []
data = pd.DataFrame()
for filename in glob.glob('../resultados/multi/*ciclos.csv'):
	print(filename)
	datos = pd.read_csv(filename,header=None)
	arr_ciclos = np.array(datos[0])
	array_ciclos = remove_outliers(arr_ciclos)
	media = np.mean(array_ciclos)
	res.append((filename,media))

pd.DataFrame(res).to_csv("medias_multi.csv")



	

