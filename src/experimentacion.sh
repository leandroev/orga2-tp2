#!/bin/bash
#ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
file_location1=experimentacion/_microsec.cvs
file_location2=experimentacion/_sec.cvs
file_location3=experimentacion/_ciclos.cvs

if [ -e resultados.cvs ]; then
	rm resultados.cvs
fi

if [ $# -lt 2 ];	then
	echo "Faltan argumentos: tipo de implementación asm o c y una imagen. Opcionalmente ingresar de forma ordenada cantidad de iteraciones, un offsetx y un offsety"
else
	echo "Cantidad de iteraciones 1!"
	if [ $# -eq 2 ];	then
		./build/tp2 ImagenFantasma -i $1 $2 0 0 >> resultados_tp2.cvs
		./build/tp2_exp ImagenFantasma -i $1 $2 0 0 >> resultados_exp.cvs
	else
		echo "Cantidad de iteraciones $3!"
		if [ $# -eq 3 ];	then
			for (( i = 0; i < $3; i++ )); do
				./build/tp2 ImagenFantasma -i $1 $2 0 0 >> resultados_tp2.cvs
				./build/tp2_exp ImagenFantasma -i $1 $2 0 0 >> resultados_exp.cvs
			done
		fi	
		if [ $# -eq 4 ];	then
			for (( i = 0; i < $3; i++ )); do
				./build/tp2 ImagenFantasma -i $1 $2 $4 0 >> resultados_tp2.cvs
				./build/tp2_exp ImagenFantasma -i $1 $2 $4 0 >> resultados_exp.cvs
			done
		fi	
		if [ $# -gt 4 ]; then
			for (( i = 0; i < $3; i++ )); do
				./build/tp2 ImagenFantasma -i $1 $2 $4 $5 >> resultados_tp2.cvs
				./build/tp2_exp ImagenFantasma -i $1 $2 $4 $5 >> resultados_exp.cvs
			done
		fi
	fi
	echo "Creando archivos de datos"
	grep  -w "totales" resultados_tp2.cvs | grep  -oP '[0-9.]*' | cat > $file_location3
	grep  -w "segundos" resultados_exp.cvs | grep  -oP '[0-9.]*' | cat > $file_location2
	grep  -w "microsegundos" resultados_exp.cvs | grep  -oP '[0-9.]*' | cat > $file_location1
	fi
	
	echo "Fin del programa"
fi	

#if grep  -q -w "ciclos" resultados.cvs ; then 
#		echo "Creando archivo con datos de #ciclos de reloj"
#		grep  -w "totales" resultados_exp.cvs | grep  -oP '[0-9.]*' | cat > $file_location3
#	else
#		echo "Creando archivo con datos de segundos y milisegundos"	
#		grep  -w "segundos" resultados.cvs | grep  -oP '[0-9.]*' | cat > $file_location2
#		grep  -w "microsegundos" resultados.cvs | grep  -oP '[0-9.]*' | cat > $file_location1
#	fi