#!/bin/bash
#ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
file_location1=resultados/print_tp2.cvs
file_location2=resultados/print_tp2_exp.cvs
file_location3=resultados/_ciclos.cvs
file_location4=resultados/_sec.cvs
file_location5=resultados/_microsec.cvs

if [ -e  $file_location1 ]; then
	rm $file_location1
	rm $file_location2
fi

if [  ! -d  resultados ]; then
	mkdir resultados
fi

if [ $# -lt 2 ];	then
	echo "Faltan argumentos: tipo de implementación asm o c y una imagen. Opcionalmente ingresar de forma ordenada cantidad de iteraciones, un offsetx y un offsety"
else
	echo "Cantidad de iteraciones 1!"
	if [ $# -eq 2 ];	then
		../build/tp2 ImagenFantasma -i $1 $2 0 0 >> $file_location1
		./tp2_exp ImagenFantasma -i $1 $2 0 0 >> $file_location2
	else
		echo "Cantidad de iteraciones $3!"
		if [ $# -eq 3 ];	then
			for (( i = 0; i < $3; i++ )); do
				../build/tp2 ImagenFantasma -i $1 $2 0 0 >> $file_location1
				./tp2_exp ImagenFantasma -i $1 $2 0 0 >> $file_location2
			done
		fi	

		if [ $# -eq 4 ];	then
			for (( i = 0; i < $3; i++ )); do
				../build/tp2 ImagenFantasma -i $1 $2 $4 0 >> $file_location1
				./tp2_exp ImagenFantasma -i $1 $2 $4 0 >> $file_location2
			done
		fi	

		if [ $# -gt 4 ]; then
			for (( i = 0; i < $3; i++ )); do
				../build/tp2 ImagenFantasma -i $1 $2 $4 $5 >> $file_location1
				./tp2_exp ImagenFantasma -i $1 $2 $4 $5 >> $file_location2
			done
		fi
	fi
	
	echo "Creando archivos de datos"
	grep  -w "totales" $file_location1 | grep  -oP '[0-9.]*' | cat > $file_location3
	grep  -w "segundos" $file_location2 | grep  -oP '[0-9.]*' | cat > $file_location4
	grep  -w "microsegundos" $file_location2 | grep  -oP '[0-9.]*' | cat > $file_location5
		
	echo "Fin del programa"
fi	

